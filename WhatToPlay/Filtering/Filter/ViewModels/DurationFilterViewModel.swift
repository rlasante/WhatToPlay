//
//  DurationFilterViewModel.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 5/10/21.
//  Copyright © 2021 rlasante. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

// TODO: Change this from duration picker, to instead historgram picker where the games are sorted
// from shortest to longest duration

class DurationFilterViewModel: FilterViewModel<ClosedRange<TimeInterval>> {
    @Published var slider: CustomSlider
    @Published var lowDuration: String
    @Published var highDuration: String
    @Published var histogram: [TimeInterval: [Game]] = [:]
    @Published var barChartData: [BarChart.ChartData] = []
    @Published var selectedBarChartData: [BarChart.ChartData] = []

    init(_ unfilteredGames: AnyPublisher<[Game], Never>) {
        slider = CustomSlider(start: 0, end: 0)
        lowDuration = "0"
        highDuration = "0"
        super.init()

        unfilteredGames
            .map { games in
                let startTimes = Set(games.map {
                    $0.minPlayingTime
                })
                let endTimes = Set(games.map {
                    $0.maxPlayingTime
                })
                let allTimes = startTimes.union(endTimes)
                let sortedAllTimes = allTimes.sorted()
                var gamesHistorgram: [TimeInterval: [Game]] = [:]
                sortedAllTimes.forEach { timestamp in
                    let histoGames = games.filter { game in
                        (game.minPlayingTime ... game.maxPlayingTime).contains(timestamp)
                    }
                    gamesHistorgram[timestamp] = histoGames
                }
                return gamesHistorgram
            }
            .assign(to: &$histogram)

        $histogram
            .combineLatest($params)
            .sink { [weak self] histogram, selectedRange in
                guard let self = self else {
                    return
                }
                if histogram.isEmpty || self.slider.valueEnd == Double(histogram.count - 1) {
                    return
                }
                let endRange = Double(histogram.count - 1)
                let slider = CustomSlider(start: 0, end: endRange)
                let lowPercent = selectedRange?.lowerBound ?? 0 / endRange
                let upperPercent = selectedRange?.upperBound ?? endRange / endRange
                slider.lowHandleStartPercentage = lowPercent
                slider.highHandleStartPercentage = upperPercent

                self.slider = slider
            }
            .store(in: &disposeBag)

        // Bar Chart info
        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .short
        formatter.zeroFormattingBehavior = .dropLeading
        formatter.allowedUnits = [.hour, .minute]

        $histogram
            .map { histogram -> [BarChart.ChartData] in
                histogram
                    .sorted { lhs, rhs in
                        lhs.key < rhs.key
                    }
                    .map { key, value in
                        return BarChart.ChartData(label: formatter.string(from: key) ?? "0", value: Double(value.count))
                    }

            }
            .assign(to: &$barChartData)

        $histogram
            .combineLatest($params)
            .map { histogram, params -> [BarChart.ChartData] in
                // Get selected ChartData
                histogram
                    .sorted { lhs, rhs in
                        lhs.key < rhs.key
                    }
                    .filter { key, value in
                        guard let params = params else {
                            // No Params means all selected
                            return true
                        }
                        return params.contains(key)
                    }
                    .map { key, value in
                        return BarChart.ChartData(label: formatter.string(from: key) ?? "0", value: Double(value.count))
                    }
            }
            .assign(to: &$selectedBarChartData)

        // Labels
        $params
            .sink { [weak self] params in
                guard let self = self else {
                    return
                }
                let sortedTimes = self.histogram.keys.sorted()
                guard let params = params else {
                    self.lowDuration = formatter.string(from: 0) ?? "0"
                    self.highDuration = formatter.string(from: sortedTimes.last ?? 0) ?? "0"
                    return
                }

                self.lowDuration = formatter.string(from: params.lowerBound) ?? "0"
                self.highDuration = formatter.string(from: params.upperBound) ?? "0"
            }
            .store(in: &disposeBag)

        $slider
            .flatMap {
                $0.objectWillChange
            }
            .sink { [weak self] in
                self?.objectWillChange.send()
            }
            .store(in: &disposeBag)

        $slider
            .flatMap {
                $0.lowHandle.$currentPercentage
                    .combineLatest($0.highHandle.$currentPercentage)
            }
            .map { [weak self] lowPercentage, highPercentage -> ClosedRange<TimeInterval> in
                guard let self = self else {
                    return (0.0 ... 0.0)
                }
                guard lowPercentage.value <= highPercentage.value else {
                    return (lowPercentage.value * self.slider.valueEnd ... lowPercentage.value * self.slider.valueEnd)
                }
                return (lowPercentage.value * self.slider.valueEnd ... highPercentage.value * self.slider.valueEnd)
            }
            .map { [weak self] range in
                guard let self = self else {
                    return (0.0 ... 0.0)
                }
                let lowIndex = Int(floor(range.lowerBound))
                let highIndex = Int(ceil(range.upperBound))
                guard lowIndex >= 0, highIndex < self.histogram.count else {
                    return (0.0 ... 0.0)
                }
                let sortedTimes = self.histogram.keys.sorted()
                let lowTime = sortedTimes[lowIndex]
                let highTime = sortedTimes[highIndex]
                return (lowTime ... highTime)
            }
//            .map { [weak self] lowValue in
//                guard let self = self else {
//                    return (0.0 ... 0.0)
//                }
//                return (lowValue ... self.slider.highHandle.currentValue)
//            }
            .assign(to: &$params)

//        $slider
//            .flatMap { slider -> AnyPublisher<(TimeInterval, TimeInterval), Never> in
//                let lowHandleValue = slider.$lowHandle.map { handle -> TimeInterval in
//                    handle.currentValue
//                }
//                let highHandleValue = slider.$highHandle.map { handle -> TimeInterval in
//                    handle.currentValue
//                }
//                return lowHandleValue
//                    .combineLatest(highHandleValue)
//                    .eraseToAnyPublisher()
//            }
//            .map { combined -> ClosedRange<TimeInterval>? in
//                (combined.0 ... combined.1)
//            }
//            .assign(to: &$params)

        $params
            .combineLatest(game)
            .map { selectedValue, game -> Bool? in
                guard let game = game else {
                    // If there's no game then no result
                    return nil
                }
                guard let value = selectedValue else {
                    // No params means auto pass on this game
                    return true
                }
                guard value != (0 ... 0) else {
                    // Empty range is true too
                    return true
                }
                let playTimes = [
                    game.minPlayingTime,
                    game.playingTime,
                    game.maxPlayingTime
                ].compactMap { $0 }
                if playTimes.isEmpty {
                    print("Unknown PlayTime")
                    return true
                }

                return playTimes.contains { value.contains($0) || value.upperBound == $0 }
            }
            .subscribe(filtersGame)
            .store(in: &disposeBag)

        $params
            .map { selectedRange -> String in
                guard let selectedRange = selectedRange else {
                    return "Duration: Any"
                }
                let minTime = formatter.string(from: selectedRange.lowerBound) ?? "0"
                let maxTime = formatter.string(from: selectedRange.upperBound) ?? "0"
                return "Duration: \(minTime) - \(maxTime)"
            }
            .assign(to: &$description)
        shortDescription = "Duration"
    }

    func filteredGames(with duration: Range<TimeInterval>?) -> [Game] {
        guard let duration = duration else {
            return filteredGames.value
        }

        return filteredGames.value.filter { game in
            let playTimes = [
                game.minPlayingTime,
                game.playingTime,
                game.maxPlayingTime
            ].compactMap { $0 }
            if playTimes.isEmpty {
                return false
            }
            return playTimes.contains { duration.contains($0) || duration.upperBound == $0 }
        }
    }
}
