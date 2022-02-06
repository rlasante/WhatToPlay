//
//  FilterPickerCoordinator.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/22/20.
//  Copyright © 2020 rlasante. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class FilterPickerCoordinator: BaseCoordinator<[FilterModel], Error> {

    let rootViewController: UINavigationController
    var filters: [FilterModel]
    var filteredGames: AnyPublisher<[Game], Never>
    var unfilteredGames: AnyPublisher<[Game], Never>

    init(rootViewController: UINavigationController, filters: [FilterModel], filteredGames: AnyPublisher<[Game], Never>, unfilteredGames: AnyPublisher<[Game], Never>) {
        self.rootViewController = rootViewController
        self.filters = filters
        self.filteredGames = filteredGames
        self.unfilteredGames = unfilteredGames
    }

    override func start() -> AnyPublisher<[FilterModel], Error> {
        let viewModel = FilterPickerViewModel(filters: filters, filteredGames: filteredGames, unfilteredGames: unfilteredGames)

        let viewController = UIHostingController(rootView: FilterPickerView(viewModel: viewModel))
        rootViewController.show(viewController, sender: self)

        return viewModel.filters.eraseToAnyPublisher()
    }
}
