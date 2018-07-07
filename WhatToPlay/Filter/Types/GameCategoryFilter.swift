//
//  GameCategoryFilter.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 9/11/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit

struct GameCategoryFilter: FilterTemplate {

    let categories: [GameCategory]

    var description: String {
        return "Cat: " + categories.map { $0.rawValue }.joined(separator: ", ")
    }
    var shortDescription: String { return "Categories" }

    func isValid(_ game: Game) -> Bool {
        return !game.categories.intersection(categories).isEmpty
    }

    init?(categories: [GameCategory]) {
        guard !categories.isEmpty else { return nil }
        self.categories = categories
    }

    init?(categories: GameCategory...) {
        self.init(categories: categories)
    }

    init?(filterData: [String: Any]?) {
        guard let categories = filterData?["categories"] as? [GameCategory] else { return nil }
        self.init(categories: categories)
    }

    func serialize() -> [String : Any] {
        return ["categories": categories]
    }
}
