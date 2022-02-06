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
    var disposeBag: Set<AnyCancellable> = []
    
    // Inputs
    var selectedFilters: CurrentValueSubject<[FilterModel], Error>

    // Outputs
    var filters: PassthroughSubject<[FilterModel], Error>

    init(filters: [FilterModel], filteredGames: AnyPublisher<[Game], Never>, unfilteredGames: AnyPublisher<[Game], Never>) {
        let filters = filters.isEmpty ? [CategoryFilterViewModel(), MechanicFilterViewModel(), ComplexityFilterViewModel(), DurationFilterViewModel(unfilteredGames)] : filters
        selectedFilters = CurrentValueSubject(filters)
        self.filters = PassthroughSubject()



        selectedFilters
            .flatMap { filters -> CombineLatestCollection<[AnyPublisher<FilterModel, Error>]> in
                let objectChangedFilters = filters
                    .compactMap { currentFilter in
                        return currentFilter
                            .objectDidChange
                            .tryMap {
                                $0
                            }
                            .eraseToAnyPublisher()
                    }
                return CombineLatestCollection(objectChangedFilters)
            }
            .subscribe(self.filters)
            .store(in: &disposeBag)
        let _filteredGames = filteredGames.share()
        filters.forEach {
            _filteredGames
                .subscribe($0.filteredGames)
                .store(in: &disposeBag)

            $0.refresh()
        }
    }

    deinit {
        print("Releasing FilterPickerViewModel")
    }
}
