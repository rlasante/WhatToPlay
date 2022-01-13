//
//  ComplexityFilterViewModel.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 5/10/21.
//  Copyright © 2021 rlasante. All rights reserved.
//

import Foundation

class ComplexityFilterViewModel: MultiSelectFilterViewModel<GameComplexity> {
    override init() {
        super.init()
        options = GameComplexity.all
        $params
            .combineLatest(game)
            .map { selectedValues, game -> Bool? in
                guard let game = game else {
                    // If there's no game then no result
                    return nil
                }
                guard let values = selectedValues else {
                    // No params means auto pass on this game
                    return true
                }
                guard let complexity = game.complexity else {
                    print("Unknown Game Complexity")
                    return false
                }
                return values.contains { $0.weight == complexity.weight }
            }
            .subscribe(filtersGame)
            .store(in: &disposeBag)

        $params
            .map { values -> String in
                return "Complexity: " + (values?.map { $0.label }.joined(separator: ", ") ?? "")
            }
            .assign(to: &$description)
        shortDescription = "Complexity"
    }

    func filteredGames(with complexity: GameComplexity?) -> [Game] {
        guard let complexity = complexity else {
            return filteredGames.value
        }
        return filteredGames.value.filter { game in
            game.complexity?.weight == complexity.weight
        }
    }
}
