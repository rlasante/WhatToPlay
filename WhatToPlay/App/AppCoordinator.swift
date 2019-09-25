//
//  AppCoordinator.swift
//  RepoSearcher
//
//  Created by Arthur Myronenko on 6/29/17.
//  Copyright © 2017 UPTech Team. All rights reserved.
//

import Combine
import UIKit

class AppCoordinator: BaseCoordinator<Void, Error> {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> AnyPublisher<Void, Error> {
        let collectionPickerCoordinator = CollectionPickerCoordinator(window: window)
        return coordinate(to: collectionPickerCoordinator)
    }
}
