//
//  DurationFilterView.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 1/11/22.
//  Copyright © 2022 rlasante. All rights reserved.
//

import SwiftUI

struct DurationFilterView: View {
    @ObservedObject var viewModel: DurationFilterViewModel

    @State private var durationRange: Range<TimeInterval> = (0.0 ..< TimeInterval.greatestFiniteMagnitude)
    private let allOptions: [TimeInterval] = {
        let intervals = stride(from: TimeInterval(0), to: 10*60*60, by: 15*60)
        return Array(intervals)
    }()

    func update(option: Range<TimeInterval>) {
        viewModel.params = option
    }

    var body: some View {
        let binder = $durationRange.onUpdate {
            update(option: durationRange)
        }
        return NavigationLink(
            viewModel.params == nil ? viewModel.shortDescription : viewModel.description,
            destination: DurationPicker(viewModel: viewModel)
        )
    }
}

struct DurationPicker: View {
    @ObservedObject var viewModel: DurationFilterViewModel
    @ObservedObject var slider = CustomSlider(start: 0, end: 10*60*60)

    var body: some View {
        return VStack {
            Text("High Value: \(slider.highHandle.currentValue / 60 / 60)")
            Text("Low Value: \(slider.lowHandle.currentValue / 60 / 60)")
            SliderView(slider: slider)
        }
        .navigationTitle("Duration (\(self.viewModel.filteredGames.value.count))")
    }
}

//struct DurationFilterView_Previews: PreviewProvider {
//    static var previews: some View {
//        DurationFilterView()
//    }
//}
