//
//  CollectionCoordinator.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/18/19.
//  Copyright © 2019 rlasante. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

class CollectionCoordinator: BaseCoordinator<Void, Error> {

    let rootViewController: UINavigationController
    let collectionModel: CollectionModel

    init(rootViewController: UINavigationController, collectionModel: CollectionModel) {
        self.rootViewController = rootViewController
        self.collectionModel = collectionModel
    }

    override func start() -> AnyPublisher<Void, Error> {
        let viewModel = CollectionViewModel(collectionAPI: collectionModel.api(), collectionModel: collectionModel)

        let viewController = UIHostingController(rootView: CollectionView(viewModel: viewModel)) // , selectedGame: viewModel.selectedGame))
        rootViewController.show(viewController, sender: self)
        
//        let viewController = GameCollectionViewController.initFromStoryboard(name: "Main")
//        let navigationController = UINavigationController(rootViewController: viewController)

//        viewController.prepare(with: viewModel)

//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()
        let showGame = viewModel.showGame
            .flatMap { game in
                self.show(game: game, in: self.rootViewController)
            }
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
        disposeBag.insert(showGame)

        let showFilters = viewModel.pickFilters
            .flatMap { game in
                self.showFilters(in: self.rootViewController, filters: viewModel.filters.value, viewModel: viewModel)
            }
            .sink(receiveCompletion: { _ in }, receiveValue: { filters in
                viewModel.filters.send(filters)
            })
        disposeBag.insert(showFilters)

        return viewModel.back.eraseToAnyPublisher()
    }

    func show(game: Game, in navController: UINavigationController) -> AnyPublisher<Void, Error> {
        let gameDetailCoordinator = GameDetailCoordinator(rootViewController: navController, game: game)
        return coordinate(to: gameDetailCoordinator)
    }

    func showFilters(in navController: UINavigationController, filters: [FilterModel], viewModel: CollectionViewModel) -> AnyPublisher<[FilterModel], Error> {
        let filteredGames: AnyPublisher<[Game], Never> = viewModel.$games
            .eraseToAnyPublisher()
        let filterPickerCoordinator = FilterPickerCoordinator(
            rootViewController: navController,
            filters: filters,
            filteredGames: filteredGames,
            unfilteredGames: viewModel.allGamesPublisher
        )
        return coordinate(to: filterPickerCoordinator)
    }
}
