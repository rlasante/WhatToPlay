//
//  CollectionPickerCoordinator.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/17/19.
//  Copyright © 2019 rlasante. All rights reserved.
//

import Combine
import UIKit

class CollectionPickerCoordinator: BaseCoordinator<Void, Error> {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> AnyPublisher<Void, Error> {
        let viewModel = CollectionPickerViewModel()
        let viewController = CollectionPickerViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)

        viewController.prepare(with: viewModel)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        viewModel.username.send("Hunter9110")

        return viewModel.showCollection
            .flatMap { collectionModel in
                self.show(collection: collectionModel, in: navigationController)
            }.eraseToAnyPublisher()
    }

    private func show(collection: CollectionModel, in navigationController: UINavigationController) -> AnyPublisher<Void, Error> {
        let collectionCoordinator = CollectionCoordinator(rootViewController: navigationController, collectionModel: collection)
        return coordinate(to: collectionCoordinator)
    }
}
