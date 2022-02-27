//
//  DurationFilterView.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 1/11/22.
//  Copyright © 2022 rlasante. All rights reserved.
//

import Combine
import SwiftUI

struct DurationFilterView: View {
    @ObservedObject var viewModel: DurationFilterViewModel

    private let allOptions: [TimeInterval] = {
        let intervals = stride(from: TimeInterval(0), to: 10*60*60, by: 15*60)
        return Array(intervals)
    }()

    var body: some View {
        return NavigationLink(
            viewModel.params == nil ? viewModel.shortDescription : viewModel.description,
            destination: DurationPicker(viewModel: viewModel)
        )
    }
}

struct DurationPicker: View {
    @State var maxDuration: TimeInterval = 0.0
//    @ObservedObject var slider: CustomSlider
    @ObservedObject var viewModel: DurationFilterViewModel
    private var cancellable: AnyCancellable?

    init(viewModel: DurationFilterViewModel) {
        self.viewModel = viewModel
//        cancellable = self.viewModel.$maxPlayTime
//            .sink { maxPlayTime in
//                self?.maxDuration = maxPlayTime
//            }
//        slider = viewModel.slider
    }

    var body: some View {
//        Binding
        return VStack {
            BarChart(
                title: "Games Per Duration",
                barColor: .gray,
                selectedBarColor: .blue,
                currentLabel: $viewModel.currentLabel,
                yAxisLabels: $viewModel.yAxisLabels,
                data: $viewModel.barChartData,
                selectedData: $viewModel.selectedBarChartData,
                highlightedData: $viewModel.currentHighlight
            )
            Text("High Value: \(viewModel.highDuration)")
            Text("Low Value: \(viewModel.lowDuration)")
            SliderView(slider: viewModel.slider)
        }
        .navigationTitle("Duration (\(self.viewModel.filteredGames.value.count))")
    }
}

//struct DurationFilterView_Previews: PreviewProvider {
//    static var previews: some View {
//        DurationFilterView()
//    }
//}
