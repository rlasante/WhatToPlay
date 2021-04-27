//
//  FilterViewModel.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/21/21.
//  Copyright © 2021 rlasante. All rights reserved.
//

import Combine
import UIKit

protocol GameFilter {
    var game: CurrentValueSubject<Game?, Never> { get }
    var filtersGame: CurrentValueSubject<Bool?, Never> { get }
}

protocol FilterModel {
    /// Returns true if we should keep the game, false if it should be filtered out
    func filter(_ game: Game) -> Bool
    func refresh()
    var shortDescription: String { get }
    var objectDidChange: PassthroughSubject<FilterModel, Never> { get }
    var filteredGames: CurrentValueSubject<[Game], Never> { get }
}

class FilterViewModel<Params: Codable>: ObservableObject, FilterModel {
    var disposeBag: Set<AnyCancellable> = []

    // Inputs
    @Published var params: Params?
    var filteredGames: CurrentValueSubject<[Game], Never> = CurrentValueSubject([])
    var game: CurrentValueSubject<Game?, Never> = CurrentValueSubject(nil)


    
    // Outputs
    /// Returns true if the current game is included within the filter's specifications
    var filtersGame: CurrentValueSubject<Bool?, Never> = CurrentValueSubject(nil)
    var objectDidChange: PassthroughSubject<FilterModel, Never> = PassthroughSubject()

    @Published var description: String = ""
    @Published var shortDescription: String = ""

    init() {
        $params
            .compactMap { [weak self] params in
                self
            }
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .subscribe(objectDidChange)
            .store(in: &disposeBag)
        params = nil

        filteredGames.sink { [weak self] games in
            self?.objectWillChange.send()
        }.store(in: &disposeBag)

    }

    func filter(_ game: Game) -> Bool {
        self.game.send(game)
        let response = filtersGame.value ?? true
        self.game.send(nil)
        return response
    }

    /// Used to refresh the values
    func refresh() {
        let value = self.params
        params = value
    }
}

class MultiSelectFilterViewModel<Selection: Codable>: FilterViewModel<[Selection]> {
    @Published var options: [Selection] = []
}

// TODO: Figure out how to reuse this without needing to specify the type exactly but that game works with it
class CategoryFilterViewModel: MultiSelectFilterViewModel<GameCategory> {
    override init() {
        super.init()
        self.options = GameCategory.allCases
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
                return Set(game.categories).isSuperset(of: values)
            }
            .subscribe(filtersGame)
            .store(in: &disposeBag)

        $params
            .map { values -> String in
                return "Cat: " + (values?.map { $0.rawValue }.joined(separator: ", ") ?? "")
            }
            .assign(to: &$description)
        shortDescription = "Categories"
    }

    func filteredGames(with category: GameCategory) -> [Game] {
        filteredGames.value.filter { game in
            game.categories.contains(category)
        }
    }
}

class MechanicFilterViewModel: MultiSelectFilterViewModel<GameMechanic> {
    override init() {
        super.init()
        options = GameMechanic.allCases
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
                return Set(game.mechanics).isSuperset(of: values)
            }
            .subscribe(filtersGame)
            .store(in: &disposeBag)

        $params
            .map { values -> String in
                return "Mech: " + (values?.map { $0.rawValue }.joined(separator: ", ") ?? "")
            }
            .assign(to: &$description)
        shortDescription = "Mechanics"
    }

    func filteredGames(with mechanic: GameMechanic) -> [Game] {
        filteredGames.value.filter { game in
            game.mechanics.contains(mechanic)
        }
    }
}

class ComplexityFilterViewModel: FilterViewModel<[GameComplexity]> {
    override init() {
        super.init()
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
}
