//
//  FilterPickerViewModel.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/22/20.
//  Copyright © 2020 rlasante. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class FilterPickerViewModel: ObservableObject {
    // Inputs
    var selectedFilters = PassthroughSubject<[FilterTemplate], Error>()

    // Outputs

    @Published var filters: [FilterTemplate] = []
}
