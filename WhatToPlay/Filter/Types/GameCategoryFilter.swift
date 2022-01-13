//
//  GameCategoryFilter.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 9/11/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit

//struct GameCategoryFilter: FilterTemplate {
//
//    let categories: [GameCategory]
//
//    var description: String {
//        return "Cat: " + categories.map { $0.rawValue }.joined(separator: ", ")
//    }
//    var shortDescription: String { return "Categories" }
//
//    func filter(_ game: Game) -> Bool {
//        return categories.contains { game.categories.contains($0) }
//    }
//
//    init?(categories: [GameCategory]) {
//        guard !categories.isEmpty else { return nil }
//        self.categories = categories
//    }
//
//    init?(categories: GameCategory...) {
//        self.init(categories: categories)
//    }
//
//    init?(filterData: [String: Any]?) {
//        guard let categories = filterData?["categories"] as? [GameCategory] else { return nil }
//        self.init(categories: categories)
//    }
//
//    func serialize() -> [String : Any] {
//        return ["categories": categories]
//    }
//}
