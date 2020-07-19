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
    let collectionModel: CollectionModel

    init(rootViewController: UINavigationController, collectionModel: CollectionModel) {
        self.rootViewController = rootViewController
        self.collectionModel = collectionModel
    }

    override func start() -> AnyPublisher<Void, Error> {
        let viewModel = CollectionViewModel(collectionAPI: collectionModel.api, collectionModel: collectionModel)

        let viewController = GameCollectionViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)

        viewController.prepare(with: viewModel)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return viewModel.showCollection
            .flatMap { collectionModel in
                self.show(collection: collectionModel, in: navigationController)
            }.eraseToAnyPublisher()
//        return Observable.
        fatalError()
    }
}
