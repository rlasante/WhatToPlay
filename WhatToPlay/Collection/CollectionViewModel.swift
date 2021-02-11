//
//  CollectionViewModel.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/18/19.
//  Copyright © 2019 rlasante. All rights reserved.
//

import Combine
import UIKit

protocol CollectionAPI {
    func collection(collectionID: String) -> AnyPublisher<CollectionModel, Error>
}

protocol GameAPI {
    associatedtype GameInput
    func game(_ input: GameInput) -> AnyPublisher<Game, Error>
}

class CollectionViewModel: NSObject, ObservableObject {
    var disposeBag: Set<AnyCancellable> = []
    // Input
    let collectionID: CurrentValueSubject<String?, Error> = CurrentValueSubject(nil)
    let filters: CurrentValueSubject<[FilterModel], Error> = CurrentValueSubject([])
    @Published var selectedGame: Game? {
        didSet {
            guard let selectedGame = selectedGame else {
                return
            }
            selectGame.send(selectedGame)
        }
    }
    let selectGame = PassthroughSubject<Game, Error>()
    let selectFilters = PassthroughSubject<Void, Error>()

    // Output
    let gamesPublisher: AnyPublisher<[Game], Error>
    @Published var games: [Game] = []

    let showGame: AnyPublisher<Game, Error>
    let pickFilters: AnyPublisher<Void, Error>

    /// Emits back events
    let back: PassthroughSubject<Void, Error> = PassthroughSubject()

    init(collectionAPI: CollectionAPI, collectionModel: CollectionModel) {

        let collection = CurrentValueSubject<CollectionModel, Error>(collectionModel)
        games = collectionModel.games

        showGame = selectGame.eraseToAnyPublisher()
        pickFilters = selectFilters.eraseToAnyPublisher()

//        let collection = collectionID.flatMap { collectionID -> AnyPublisher<CollectionModel, Error> in
//            guard let collectionID = collectionID else {
//                return Empty(completeImmediately: false).eraseToAnyPublisher()
//            }
//            return collectionAPI.collection(collectionID: collectionID)
//        }
        let _gamesPublisher = Publishers.CombineLatest(collection, filters)
            .map { collectionFilter -> ([Game], [FilterModel]) in
                (collectionFilter.0.games, collectionFilter.1)
            }
            .map { gamesFilters -> [Game] in
                let (games, filters) = gamesFilters
                return games.filter { game in
                    // Find first filter that would cause a game to get excluded
                    let shouldFilterGame = filters.contains { !$0.filter(game) }
                    return shouldFilterGame
                }
        }.share()
        gamesPublisher = _gamesPublisher.eraseToAnyPublisher()

        super.init()

//        Publishers.CombineLatest(collection, filters)
//            .map { ($0.0.games, $0.1) }
//            .map {
//                let (games, filters) = $0
//                return games.filter { game in
//                    // Find first filter that would cause a game to get excluded
//                    let shouldFilterGame = filters.contains { !$0.filter(game) }
//                    return shouldFilterGame
//                }
//        }.catch { _ in
//            return CurrentValueSubject([])
//        }.assign(to: \.games, on: self)
//        .store(in: &disposeBag)

            // .replay(1)
    }
}
