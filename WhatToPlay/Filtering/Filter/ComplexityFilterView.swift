//
//  ComplexityFilterView.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 4/26/21.
//  Copyright © 2021 rlasante. All rights reserved.
//

import SwiftUI

struct ComplexityFilterView: View {
    @ObservedObject var viewModel: ComplexityFilterViewModel

    @State private var complexity: String = "None"
    private let allOptions: [String] = {
        var complexities = GameComplexity.all

        var names = complexities.map { $0.label }
        names.insert("None", at: 0)
        return names
    }()

    func complexity(for option: String) -> GameComplexity? {
        return GameComplexity.all.first(where: { $0.label == option })
    }

    func update(option: String) {
        guard let complexity = GameComplexity.all.first(where: { $0.label == option }) else {
            viewModel.params = nil
            return
        }
        viewModel.params = [complexity]
    }

    var body: some View {
//        NavigationLink(
//            viewModel.params == nil ? viewModel.shortDescription : viewModel.description,
//            destination: ComplexitySelectionList(viewModel: viewModel)
//        )
//        if let passedComplexity = viewModel.params?.first, passedComplexity != complexity {
//            complexity = passedComplexity
//        }

        let binder = $complexity.onUpdate {
            update(option: complexity)
        }

        return VStack {
            Picker(
                viewModel.params == nil ? viewModel.shortDescription : viewModel.description,
                selection: binder
            ) {
                ForEach(allOptions, id: \.self) { complexity in
                    Text("\(complexity) (\(viewModel.filteredGames(with: self.complexity(for: complexity)).count))")
                }
            }
        }
    }
}

extension Binding {

    /// When the `Binding`'s `wrappedValue` changes, the given closure is executed.
    /// - Parameter closure: Chunk of code to execute whenever the value changes.
    /// - Returns: New `Binding`.
    func onUpdate(_ closure: @escaping () -> Void) -> Binding<Value> {
        Binding(get: {
            wrappedValue
        }, set: { newValue in
            wrappedValue = newValue
            closure()
        })
    }
}

struct ComplexitySelectionList: View {
    @ObservedObject var viewModel: ComplexityFilterViewModel

    var body: some View {
        List {
            ForEach(self.viewModel.options, id: \.self.weight) { complexity in
                MultipleSelectionRow(
                    title: "\(complexity.label) [\(viewModel.filteredGames(with: complexity).count)]",
                    isSelected: self.viewModel.params?.contains(complexity) ?? false
                ) {
                    var params: [GameComplexity]? = self.viewModel.params ?? []
                    if params?.contains(complexity) ?? false {
                        params?.removeAll { $0 == complexity }
                        if params?.isEmpty ?? false {
                            params = nil
                        }
                    }
                    else {
                        params?.append(complexity)
                    }
                    self.viewModel.params = params
                }
            }
        }
        .navigationTitle("Complexity (\(self.viewModel.filteredGames.value.count))")
    }
}
