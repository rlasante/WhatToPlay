//
//  FilterPickerView.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/22/20.
//  Copyright © 2020 rlasante. All rights reserved.
//

import SwiftUI

struct FilterPickerView: View {
    @ObservedObject var viewModel: FilterPickerViewModel

    var body: some View {
        List {
            Text("Hello")
            ForEach(self.viewModel.selectedFilters.value.compactMap { $0 as? MechanicFilterViewModel }, id: \.shortDescription) { filter in
                MechanicFilterView(viewModel: filter)
            }
            ForEach(self.viewModel.selectedFilters.value.compactMap { $0 as? CategoryFilterViewModel }, id: \.shortDescription) { filter in
                CategoryFilterView(viewModel: filter)
            }
            ForEach(self.viewModel.selectedFilters.value.compactMap { $0 as? ComplexityFilterViewModel }, id: \.shortDescription) { filter in
                ComplexityFilterView(viewModel: filter)
//                ComplexityFilterView(viewModel: filter, complexity: nil)
            }
            ForEach(self.viewModel.selectedFilters.value.compactMap { $0 as? DurationFilterViewModel }, id: \.shortDescription) { filter in
                DurationFilterView(viewModel: filter)
            }
            ForEach(self.viewModel.selectedFilters.value.compactMap { $0 as? PlayerCountFilterViewModel }, id: \.shortDescription) { filter in
                PlayerCountFilterView(viewModel: filter)
            }
        }
    }
}

//struct FilterPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterPickerView()
//    }
//}
