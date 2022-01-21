//
//  DurationFilterViewModel.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 5/10/21.
//  Copyright © 2021 rlasante. All rights reserved.
//

import Foundation

class DurationFilterViewModel: FilterViewModel<Range<TimeInterval>> {
    override init() {
        super.init()
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
                let playTimes = [
                    game.minPlayingTime,
                    game.playingTime,
                    game.maxPlayingTime
                ].compactMap { $0 }
                if playTimes.isEmpty {
                    print("Unknown PlayTime")
                    return false
                }

                return playTimes.contains { value.contains($0) || value.upperBound == $0 }
            }
            .subscribe(filtersGame)
            .store(in: &disposeBag)

        $params
            .map { duration -> String in
                return "Duration: " + (duration?.description ?? "")
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
