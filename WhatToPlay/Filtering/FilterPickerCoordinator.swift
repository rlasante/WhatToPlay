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

class FilterPickerCoordinator: BaseCoordinator<[FilterTemplate], Error> {

    let rootViewController: UINavigationController

    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    override func start() -> AnyPublisher<[FilterTemplate], Error> {
        let viewModel = FilterPickerViewModel()

        let viewController = UIHostingController(rootView: FilterPickerView(viewModel: viewModel))
        rootViewController.show(viewController, sender: self)

        return viewModel.selectedFilters.eraseToAnyPublisher()
    }
}
