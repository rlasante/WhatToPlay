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

    func collections(username _: String) -> AnyPublisher<[CollectionModel], Error> {
        return Empty().eraseToAnyPublisher()
    }

    func collection(collectionID: String) -> AnyPublisher<CollectionModel, Error> {
        return Empty().eraseToAnyPublisher()
    }


}
