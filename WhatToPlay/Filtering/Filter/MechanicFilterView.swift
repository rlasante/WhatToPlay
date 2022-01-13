//
//  MechanicFilterView.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/28/21.
//  Copyright © 2021 rlasante. All rights reserved.
//

import Foundation
import SwiftUI

struct MechanicFilterView: View {
    @ObservedObject var viewModel: MechanicFilterViewModel

    var body: some View {
        NavigationLink(
            viewModel.params == nil ? viewModel.shortDescription : viewModel.description,
            destination: MechanicSelectionList(viewModel: viewModel)
        )
    }
}

struct MechanicSelectionList: View {
    @ObservedObject var viewModel: MechanicFilterViewModel

    var body: some View {
        List {
            ForEach(self.viewModel.options.filter { !viewModel.filteredGames(with: $0).isEmpty }, id: \.self.rawValue) { mechanic in
                MultipleSelectionRow(
                    title: "\(mechanic.rawValue) [\(viewModel.filteredGames(with: mechanic).count)]",
                    isSelected: self.viewModel.params?.contains(mechanic) ?? false
                ) {
                    var params: [GameMechanic]? = self.viewModel.params ?? []
                    if params?.contains(mechanic) ?? false {
                        params?.removeAll { $0 == mechanic }
                        if params?.isEmpty ?? false {
                            params = nil
                        }
                    }
                    else {
                        params?.append(mechanic)
                    }
                    self.viewModel.params = params
                }
            }
        }
        .navigationTitle("Mechanic (\(self.viewModel.filteredGames.value.count))")
    }
}
