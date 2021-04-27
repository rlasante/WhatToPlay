//
//  CategoryFilterView.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/22/20.
//  Copyright © 2020 rlasante. All rights reserved.
//

import SwiftUI

struct CategoryFilterView: View {
    @ObservedObject var viewModel: CategoryFilterViewModel

    var body: some View {
        NavigationLink(
            viewModel.params == nil ? viewModel.shortDescription : viewModel.description,
            destination: CategorySelectionList(viewModel: viewModel)
        )
    }
}

struct CategorySelectionList: View {
    @ObservedObject var viewModel: CategoryFilterViewModel

    var body: some View {
        List {
            ForEach(self.viewModel.options.filter { !viewModel.filteredGames(with: $0).isEmpty }, id: \.self.rawValue) { category in
                MultipleSelectionRow(
                    title: "\(category.rawValue) [\(viewModel.filteredGames(with: category).count)]",
                    isSelected: self.viewModel.params?.contains(category) ?? false
                ) {
                    var params: [GameCategory]? = self.viewModel.params ?? []
                    if params?.contains(category) ?? false {
                        params?.removeAll { $0 == category }
                        if params?.isEmpty ?? false {
                            params = nil
                        }
                    }
                    else {
                        params?.append(category)
                    }
                    self.viewModel.params = params
                }
            }
        }
        .navigationTitle("Category (\(self.viewModel.filteredGames.value.count))")
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
