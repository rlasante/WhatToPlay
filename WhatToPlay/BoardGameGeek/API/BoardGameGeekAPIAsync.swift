//
//  BoardGameGeekAPIAsync.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 1/20/22.
//  Copyright © 2022 rlasante. All rights reserved.
//

import CoreData
import Foundation
import SWXMLHash
import SwiftUI

enum APIError: Error {
    case fetchFailed
    case invalidURL
    case invalidData
    case noGames
    case tryAgain
}

struct CollectionListAPIProvider: CollectionListAPI, CollectionListAPIAsync {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func collections(username: String) async throws -> [CollectionModel] {
        let bggGames = try await BoardGameGeekAPIAsync.shared.getCollection(username: username, context: context)
        return [CollectionModel(games: bggGames)]
    }
}

struct CollectionAPIProvider: CollectionAPI, CollectionAPIAsync {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func collection(collectionID: String) async throws -> CollectionModel {
        let bggGames = try await BoardGameGeekAPIAsync.shared.collection(username: collectionID, context: context)
        return CollectionModel(games: bggGames)
    }
}

class BoardGameGeekAPIAsync {
    static let shared = BoardGameGeekAPIAsync()

    private let baseURL = "https://www.boardgamegeek.com/xmlapi2"

//    static let bggSession: Session = {
//        let sessionConfiguration = URLSessionConfiguration.default
//
//        let interceptor = BGGInterceptor(retrier: BGGRetrier())
//        let session = Alamofire.Session(configuration: sessionConfiguration, interceptor: interceptor)
//        return session
//    }()

//    let session: URLSession
//
//    init() {
//        session = URLSession(configuration: .default)
//    }

    func collection(username: String, context: NSManagedObjectContext, retries: Int = 3) async throws -> [Game] {
        do {
            return try await getCollection(username: username, context: context)
        }
        catch APIError.tryAgain {
            if retries <= 0 {
                print("Retries failed")
                throw APIError.fetchFailed
            }
            return try await collection(username: username, context: context, retries: retries - 1)
        }
        catch {
            throw error
        }
    }

    func getCollection(username: String, context: NSManagedObjectContext) async throws -> [Game] {
        guard let url = URL(string:"\(baseURL)/collection?username=\(username)&own=1") else {
            throw APIError.invalidURL
        }
        print("\(#function) Performing Request: \(url)")
        let (data, response) = try await URLSession.shared.data(from: url)
        // todo check if the response is 202
        if let httpResponse = response as? HTTPURLResponse, httpResponse.shouldRetryRequest {
            print("\(#function) Try again")
            throw APIError.tryAgain
        }
        guard let xmlString = String(data: data, encoding: .utf8) else {
            throw APIError.invalidData
        }
        let gameIds = try self.gameIds(xmlString: xmlString)
        return try await boardGames(gameIds: gameIds, context: context)
    }

    private func gameIds(xmlString: String) throws -> [String] {
        let xml = SWXMLHash.parse(xmlString)
        let nodes = xml["items"].children
        let gameIds = nodes.compactMap { node -> String? in
            guard
                let objectType: String = node.value(ofAttribute: "objecttype".lowercased()),
                objectType == "thing".lowercased(),
                let subType: String = node.value(ofAttribute: "subtype".lowercased()),
                subType == "boardgame".lowercased()
            else { return nil }
            let gameId: String? = node.value(ofAttribute: "objectid".lowercased())
            return gameId
        }
        return gameIds
    }

    func boardGames(
        gameIds: [String],
        context: NSManagedObjectContext,
        retryCount: Int = 3
    ) async throws -> [Game] {
        let localGames: [Game] = (try? context.fetch(Game.fetchRequest(forIds: gameIds))) ?? []
        let gameIds = gameIds.filter { id in
            !localGames.contains { $0.gameId == id }
        }
        if gameIds.isEmpty {
            return localGames
        }

        guard let url = URL(string: "\(baseURL)/thing?id=\(gameIds.joined(separator: ","))&type=boardgame&stats=1") else {
            throw APIError.invalidURL
        }
        print("\(#function) Performing Request: \(url)")
        let (data, response) = try await URLSession.shared.data(from: url)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.shouldRetryRequest {
            if retryCount > 0 {
                return try await boardGames(gameIds: gameIds, context: context, retryCount: retryCount - 1)
            }
            else {
                throw APIError.fetchFailed
            }
        }
        // Throw try again if 202
        guard let xmlString = String(data: data, encoding: .utf8) else {
            throw APIError.invalidData
        }

        let xml = SWXMLHash.parse(xmlString)
        // TODO figure out a way to store the data so that way we will have it when I add new properties
        let gamesData: [GameXMLData] = try xml["items"]["item"].all.map { try $0.value() }

        let games = gamesData.map { Game(data: $0, in: context)}
        try context.save()
        let allSortedGames = [games, localGames]
            .flatMap { $0 }
            .sorted { $0.name ?? "" < $1.name ?? "" }
        guard !allSortedGames.isEmpty else {
            throw APIError.noGames
        }
        if !gameIds.isEmpty {
            print("Missing the following ids: \(gameIds)")
        }
        return allSortedGames
    }
}
