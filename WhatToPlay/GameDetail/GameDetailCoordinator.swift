//
//  GameDetailCoordinator.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/21/20.
//  Copyright © 2020 rlasante. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

class GameDetailCoordinator: BaseCoordinator<Void, Error> {

    let rootViewController: UINavigationController
    let game: Game

    init(rootViewController: UINavigationController, game: Game) {
        self.rootViewController = rootViewController
        self.game = game
    }

    override func start() -> AnyPublisher<Void, Error> {
        let viewModel = GameDetailViewModel(game: game)

        let viewController = UIHostingController(rootView: GameDetailView(viewModel: viewModel))
        rootViewController.show(viewController, sender: self)

        return viewModel.dismiss.eraseToAnyPublisher()
    }
}
