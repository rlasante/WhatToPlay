//
//  PlayerCountFilterViewModel.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/7/22.
//  Copyright © 2022 rlasante. All rights reserved.
//

import Combine
import Foundation

enum PlayerCountFilter: Codable {
    case any(PlayerCount)
    case recommended(PlayerCount)
    case best(PlayerCount)
}

final class PlayerCountFilterViewModel: FilterViewModel<PlayerCountFilter> {

    // Output
    @Published var count: Int = 0
    @Published var maxPlayerCount: Int = 0
    @Published var bestOnly: Bool = false
    @Published var recommendedOnly: Bool = false
    @Published var histogram: [[Game]] = []
    @Published var chartWindow: ClosedRange<Int> = (0 ... 0)
    @Published var chartData: [BarChart.ChartData] = []
    @Published var selectedChartData: [BarChart.ChartData] = []
    @Published var yAxisLabels: [BarChart.ChartData] = []
    
    @Published var currentHighlight: [BarChart.ChartData] = []
    @Published var currentLabel: String = ""

    init(_ unfilteredGames: AnyPublisher<[Game], Never>) {
        super.init()

        // Get the max possible player count
        unfilteredGames
            .combineLatest($params)
            .map { games, params -> Int in
                let max = games.flatMap { game -> [PlayerCount] in
                    switch params {
                    case .best:
                        if let best = game.bestPlayerCount {
                            return [best]
                        }
                        else {
                            return []
                        }
                    case .recommended:
                        return game.suggestedPlayerCount
                    case .any, .none:
                        return game.playerCount
                    }
                }
                .map { playerCount in
                    switch playerCount {
                    case let .range(_, max):
                        return max
                    case let .count(count):
                        return count
                    }
                }
                .max() ?? 0
                let clampedMax = min(max, 99)
                print("Max player count \(clampedMax)")
                return clampedMax
            }
            .assign(to: &$maxPlayerCount)

        $chartData
            .map { chartData -> [BarChart.ChartData] in
                guard !chartData.isEmpty else {
                    return []
                }
                let maxLevel = chartData.max { $0.value < $1.value }?.value ?? 0
                let numberOfTicks = 10
                let stepCount = maxLevel / Double(numberOfTicks)
                return (0 ... numberOfTicks).map {
                    BarChart.ChartData(label: "\(Int(Double($0) * stepCount))", value: Double($0) * stepCount)
                }
            }
            .assign(to: &$yAxisLabels)

        $maxPlayerCount
            .combineLatest(unfilteredGames, $params)
            .map { maxPlayers, games, params -> [[Game]] in
                // Group the games
                return (0 ... maxPlayers)
                    .map { playerNum -> [Game] in
                        let playerCount = PlayerCount.count(value: playerNum)
                        return games
                            .filter { game in
                                switch params {
                                case .best:
                                    return game.bestPlayerCount?.entirelyContains(playerCount) ?? false
                                case .recommended:
                                    return game.suggestedPlayerCount.contains { $0.entirelyContains(playerCount) }
                                case .any, .none:
                                    return game.playerCount.contains { $0.entirelyContains(playerCount) }
                                }
                            }
                    }
            }
            .assign(to: &$histogram)
        $maxPlayerCount
            .map {
                (0 ... min($0, 20))
            }
            .assign(to: &$chartWindow)
        $histogram
            .combineLatest($chartWindow)
            .map { histogram, chartWindow -> [BarChart.ChartData] in
                return histogram
                    .enumerated()
                    .map { index, games in
                        return BarChart.ChartData(label: "\(index)", value: Double(games.count))
                    }
                    .slice(start: chartWindow.lowerBound, end: chartWindow.upperBound)
            }
            .assign(to: &$chartData)

        $chartData
            .combineLatest($params)
            .map { chartData, params -> [BarChart.ChartData] in
                guard let params = params else {
                    return chartData
                }
                switch params {
                case .any(.count(value: 0)):
                    // Counts as none
                    return chartData
                case let .best(.count(playerCount)), let .recommended(.count(playerCount)), let .any(.count(playerCount)):
                    guard playerCount < chartData.count else {
                        return chartData
                    }
                    return [chartData[playerCount]]
                default:
                    return chartData
                }
            }
            .assign(to: &$selectedChartData)

        $currentHighlight
            .compactMap { [weak self] in
                if let highlighted = $0.first, $0.count == 1, let index = self?.chartData.firstIndex(of: highlighted) {
                    return index
                }
                else {
                    return nil
                }
            }
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .assign(to: &$count)
        $currentHighlight
            .map {
                if let highlighted = $0.first, $0.count == 1 {
                    return highlighted.label
                }
                else {
                    return ""
                }
            }
            .assign(to: &$currentLabel)

        $params
            .sink { [weak self] selectedPlayerCount in
                guard let selectedPlayerCount = selectedPlayerCount else {
                    self?.bestOnly = false
                    self?.recommendedOnly = false
                    return
                }
                switch selectedPlayerCount {
                case .any(_):
                    self?.bestOnly = false
                    self?.recommendedOnly = false
                case .recommended(_):
                    self?.bestOnly = false
                    self?.recommendedOnly = true
                case .best(_):
                    self?.bestOnly = true
                    self?.recommendedOnly = false
                }
            }
            .store(in: &disposeBag)

        $bestOnly
            .filter {
                $0
            }
            .map {
                !$0
            }
            .assign(to: &$recommendedOnly)
        $recommendedOnly
            .filter {
                $0
            }
            .map {
                !$0
            }
            .assign(to: &$bestOnly)

        $bestOnly
            .combineLatest($recommendedOnly, $count)
            .map { bestOnly, recommendedOnly, count -> PlayerCountFilter in
                switch (bestOnly, recommendedOnly) {
                case (true, _):
                    return .best(.count(value: count))
                case (false, true):
                    return .recommended(.count(value: count))
                case (false, false):
                    return .any(.count(value: count))
                }
            }
            .assign(to: &$params)

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

                if case PlayerCountFilter.any(.count(value: 0)) = value {
                    // Empty count is true
                    return true
                }
                switch value {
                case let .best(count):
                    return game.bestPlayerCount?.entirelyContains(count) ?? false
                case let .recommended(count):
                    return game.suggestedPlayerCount
                        .contains { suggestedCount in
                            suggestedCount.entirelyContains(count)
                        }
                case let .any(count):
                    return game.playerCount
                        .contains { availableCount in
                            availableCount.entirelyContains(count)
                        }
                }
            }
            .subscribe(filtersGame)
            .store(in: &disposeBag)

        $params
            .map { selectedPlayerCount -> String in
                guard let selectedPlayerCount = selectedPlayerCount else {
                    return "Player Count: Any"
                }
                return "Player Count: \(selectedPlayerCount)"
            }
            .assign(to: &$description)
        shortDescription = "Player Count"
    }
}
