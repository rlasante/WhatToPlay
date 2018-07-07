//
//  ComplexityFilter.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 9/25/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit

struct ComplexityFilter: FilterTemplate {

    let desiredComplexity: GameComplexity

    var description: String {
        return "Complexity: \(desiredComplexity.label)"
    }
    var shortDescription: String { return "Complexity" }

    func isValid(_ game: Game) -> Bool {
        return game.complexity.weight == desiredComplexity.weight
            || abs(game.complexity.actualWeight - desiredComplexity.actualWeight) < 0.25
    }

    init(complexity: GameComplexity) {
        self.desiredComplexity = complexity
    }

    init?(filterData: [String: Any]?) {
        guard let complexity = filterData?["complexity"] as? GameComplexity else { return nil }
        self.init(complexity: complexity)
    }

    func serialize() -> [String : Any] {
        return ["complexity": desiredComplexity]
    }
}
