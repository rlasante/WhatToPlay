//
//  BoardGameGeekAPIV2.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/18/19.
//  Copyright © 2019 rlasante. All rights reserved.
//

import Combine
import CoreData
import Foundation

class BoardGameGeekAPIV2: CollectionListAPI, CollectionAPI {

    struct CollectionInput {
        let collectionID: String
    }

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func collections(username: String) -> AnyPublisher<[CollectionModel], Error> {
        let subject = PassthroughSubject<[CollectionModel], Error>()
        BoardGameGeekAPI.getCollection(userName: username, context: context)
            .pipe { result in
                switch result {
                case let .fulfilled(games):
                    subject.send([CollectionModel(games: games)])
                case let .rejected(error):
                    subject.send(completion: .failure(error))
                }
        }
        return subject.eraseToAnyPublisher()
    }

    func collection(collectionID: String) -> AnyPublisher<CollectionModel, Error> {
        let subject = PassthroughSubject<[CollectionModel], Error>()
        BoardGameGeekAPI.getCollection(userName: collectionID, context: context)
            .pipe { result in
                switch result {
                case let .fulfilled(games):
                    subject.send(CollectionModel(games: games))
                case let .rejected(error):
                    subject.send(completion: .failure(error))
                }
        }
        return subject.eraseToAnyPublisher()
    }


}
