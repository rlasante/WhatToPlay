//
//  ViewModelDependent.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/18/19.
//  Copyright © 2019 rlasante. All rights reserved.
//

protocol ViewModelDependent: class {
    associatedtype ViewModel

    var viewModel: ViewModel! { get set }
    func prepare(with viewModel: ViewModel)
}

extension ViewModelDependent {
    func prepare(with viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}
