//
//  PlayerCountFilterView.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/7/22.
//  Copyright © 2022 rlasante. All rights reserved.
//

import SwiftUI

struct PlayerCountFilterView: View {
    @ObservedObject var viewModel: PlayerCountFilterViewModel

    var body: some View {
        return NavigationLink(
            viewModel.params == nil ? viewModel.shortDescription : viewModel.description,
            destination: PlayerCountPicker(viewModel: viewModel)
        )
    }
}

struct PlayerCountPicker: View {
    @ObservedObject var viewModel: PlayerCountFilterViewModel

    var body: some View {
        VStack {
            BarChart(
                title: "Games Per Player Count",
                barColor: .gray,
                selectedBarColor: .blue,
                currentLabel: $viewModel.currentLabel,
                yAxisLabels: $viewModel.yAxisLabels,
                data: $viewModel.chartData,
                selectedData: $viewModel.selectedChartData,
                highlightedData: $viewModel.currentHighlight
            )
            Toggle(isOn: $viewModel.bestOnly) {
                Text("Best Player Count Only")
            }.toggleStyle(.button)
            Toggle("Recommended Player Count", isOn: $viewModel.recommendedOnly)
                .toggleStyle(.button)
            Text("Player Count \(viewModel.count)")
            Picker("Player Count", selection: $viewModel.count) {
                ForEach(0 ..< viewModel.maxPlayerCount + 1, id: \.self) { i in
                    Text("\(i)").tag(i)
                }
            }
        }
        .navigationTitle("Player Count (\(self.viewModel.filteredGames.value.count))")
    }
}

//struct PlayerCountFilterView_Previews: PreviewProvider {
//    static let viewModel = PlayerCountFilterViewModel()
//
//    static var previews: some View {
//        PlayerCountFilterView(viewModel: viewModel)
//        PlayerCountPicker(viewModel: viewModel)
//    }
//}
