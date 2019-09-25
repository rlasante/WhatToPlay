//
//  CollectionCoordinator.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/18/19.
//  Copyright © 2019 rlasante. All rights reserved.
//

import Combine
import UIKit

class CollectionCoordinator: BaseCoordinator<Void, Error> {

    let rootViewController: UINavigationController

    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    override func start() -> AnyPublisher<Void, Error> {
//        let viewModel = CollectionViewModel(collectionService: collectionSource.api)
//        return Observable.
        fatalError()
    }
}
