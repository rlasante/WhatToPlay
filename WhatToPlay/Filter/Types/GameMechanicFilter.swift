//
//  GameMechanicFilter.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 9/12/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit

struct GameMechanicFilter: FilterTemplate {

    let mechanics: [GameMechanic]

    var description: String {
        return "Mech: " + mechanics.map { $0.rawValue }.joined(separator: ", ")
    }
    var shortDescription: String { return "Mechanics" }

    func filter(_ game: Game) -> Bool {
        return mechanics.contains { game.mechanics.contains($0) }
    }

    init?(mechanics: [GameMechanic]) {
        guard !mechanics.isEmpty else { return nil }
        self.mechanics = mechanics
    }

    init?(mechanics: GameMechanic...) {
        self.init(mechanics: mechanics)
    }

    init?(filterData: [String: Any]?) {
        guard let mechanics = filterData?["mechanics"] as? [GameMechanic] else { return nil }
        self.init(mechanics: mechanics)
    }

    func serialize() -> [String : Any] {
        return ["mechanics": mechanics]
    }
}
