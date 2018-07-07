//
//  BoardGameGeekAPI.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 6/25/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash
import PMKAlamofire
import PromiseKit

enum APIError: Error {
    case tryAgain
    case noGames
}

class BoardGameGeekAPI {

    static let useMockData = false

    static let baseURL = "https://www.boardgamegeek.com/xmlapi2"

    static let gamesSessionManager: SessionManager = {
        let sessionConfiguration = URLSessionConfiguration.default

        let gamesSession = Alamofire.SessionManager(configuration: sessionConfiguration)
        gamesSession.adapter = GamesAdapter()
        gamesSession.retrier = BGGRetrier()
        return gamesSession
    }()

    static let bggSessionManager: SessionManager = {
        let sessionConfiguration = URLSessionConfiguration.default

        let session = Alamofire.SessionManager(configuration: sessionConfiguration)
        session.retrier = BGGRetrier()
        return session
    }()

    class func attempt<T>(maximumRetryCount: Int = 3, delayBeforeRetry: DispatchTimeInterval = .seconds(2), _ body: @escaping () -> Promise<T>) -> Promise<T> {
        var attempts = 0
        func attempt() -> Promise<T> {
            attempts += 1
            return body().recover { error -> Promise<T> in
                guard attempts < maximumRetryCount else { throw error }
                return after(delayBeforeRetry).then(on: nil, attempt)
            }
        }
        return attempt()
    }

    class func getUser(userName: String) -> Promise<User> {
        return attempt {
            bggSessionManager.request("\(baseURL)/user?name=\(userName)&top=1")
            .responseString()
            .map { xmlString, dataResponse -> String in
                guard dataResponse.response?.statusCode != 202 else {
                    print("[API]: Retrying fetching user")
                    throw APIError.tryAgain
                }
                return xmlString
            }
        }.map { xmlString in
            let xml = SWXMLHash.lazy(xmlString)
            return try xml["user"].value() as User
        }
    }

    class func getCollection(userName: String) -> Promise<[Game]> {
//        if useMockData, let mockCollectionData = mockCollectionData {
//            print("[Collection] Using Mock Collection")
//            handleResponse(xmlString: mockCollectionData)
//        }
        return attempt { () -> Promise<String> in
            bggSessionManager.request("\(baseURL)/collection?username=\(userName)")
            .responseString()
            .tap { _ in print("[API]: Fetched Collection") }
            .map { xmlString, dataResponse in
                guard dataResponse.response?.statusCode != 202 else {
                    print("[API]: Retrying fetching Collection")
                    throw APIError.tryAgain
                }
                return xmlString
            }
        }.map { xmlString -> [String] in
            let xml = SWXMLHash.parse(xmlString)
            let nodes = xml["items"].children
            let gameIds = nodes.flatMap { node -> String? in
                guard let objectType: String = node.value(ofAttribute: "objecttype".lowercased()), objectType == "thing".lowercased(),
                    let subType: String = node.value(ofAttribute: "subtype".lowercased()), subType == "boardgame".lowercased() else { return nil }
                let gameId: String? = node.value(ofAttribute: "objectid".lowercased())
                return gameId
            }
            return gameIds
        }.tap {
            print("Game Ids to fetch: \($0)")
        }.then { gameIds -> Promise<[Game]> in
            getBoardGames(gameIds: gameIds)
        }
    }

    class func getBoardGame(gameId: String) -> Promise<Game> {
        return getBoardGames(gameIds: [gameId]).firstValue
    }

    class func getBoardGames(gameIds: [String]) -> Promise<[Game]> {
//        if useMockData, let mockData = mockGameData {
//            print("[Games] Using mock games")
//            handleResponse(xmlString: mockData)
//        }
        return attempt { () -> Promise<String> in
            let url = "\(baseURL)/thing?id=\(gameIds.joined(separator: ","))&type=boardgame&stats=1"
            return gamesSessionManager.request(url)
            .responseString()
            .tap { _ in print("[API]: Got Board Games") }
            .map { xmlString, dataResponse -> String in
                guard dataResponse.response?.statusCode != 202 else {
                    print("[API]: Retrying Fetching Board Games")
                    throw APIError.tryAgain
                }
                return xmlString
            }
        }.map { xmlString -> [Game] in
            let xml = SWXMLHash.parse(xmlString)
            let games: [Game] = try xml["items"]["item"].all.map { try $0.value() }
            guard !games.isEmpty else {
                throw APIError.noGames
            }
            return games
        }
    }

    private class GamesAdapter: RequestAdapter {
        func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            var urlRequest = urlRequest
            urlRequest.cachePolicy = .returnCacheDataElseLoad
            return urlRequest
        }
    }

    private class BGGRetrier: RequestRetrier {
        func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
            guard let response = request.response else {
                completion(false, 0)
                return
            }
            if response.statusCode == 202 {
                completion(true, 0.2)
            }
            completion(false, 0)
        }


    }
}
