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

class CollectionViewModel: NSObject {
    let collectionID: CurrentValueSubject<String?, Error> = CurrentValueSubject(nil)
    let filters: CurrentValueSubject<[FilterModel], Error> = CurrentValueSubject([])

    let games: AnyPublisher<[Game], Error>

    let didSelectGame: CurrentValueSubject<Game?, Error> = CurrentValueSubject(nil)

    /// Emits back events
    let back: PassthroughSubject<Void, Never> = PassthroughSubject()

    init(collectionAPI: CollectionAPI) {
        let collection = collectionID.flatMap { collectionID -> AnyPublisher<CollectionModel, Error> in
            guard let collectionID = collectionID else {
                return Empty(completeImmediately: false).eraseToAnyPublisher()
            }
            return collectionAPI.collection(collectionID: collectionID)
        }
        games = Publishers.CombineLatest(collection, filters)
            .map { ($0.0.games, $0.1) }
            .map {
                let (games, filters) = $0
                return games.filter { game in
                    // Find first filter that would cause a game to get excluded
                    let shouldFilterGame = filters.contains { !$0.filter(game) }
                    return shouldFilterGame
                }
            }.eraseToAnyPublisher()
            // .replay(1)
    }

}
