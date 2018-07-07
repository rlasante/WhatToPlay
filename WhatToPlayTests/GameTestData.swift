//
//  GameTestData.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/22/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import Foundation
@testable import WhatToPlay

struct Inis {
    static let gameId = "155821"
    static let name = "Inis"
    static let yearPublished = "2016"
    static let playerCount = [PlayerCount.range(min: 2, max: 4)]
    static let bestPlayerCount = 4
    static let recommendedPlayerCount = [PlayerCount.range(min: 2, max: 4)]
    static let playTime: TimeInterval = 90 * 60
    static let minPlayTime: TimeInterval = 60 * 60
    static let maxPlayTime: TimeInterval = 90 * 60
    static let minAge = 14
    static let mechanics: Set<GameMechanic> = [.cardDrafting, .modularBoard, .handManagement, .tilePlacement, .memory, .areaMovement, .areaControlAreaInfluence]
    static let categories: Set<GameCategory> = [.cardGame, .mythology, .ancient]
}

struct CosmicEncounter {
    static let gameId = "39463"
    static let name = "Cosmic Encounter"
    static let yearPublished = "2008"
    static let playerCount = [PlayerCount.range(min: 3, max: 5)]
    static let bestPlayerCount = 5
    static let recommendedPlayerCount = [PlayerCount.range(min: 4, max: Int.max)]
    static let playTime: TimeInterval = 120 * 60
    static let minPlayTime: TimeInterval = 60 * 60
    static let maxPlayTime: TimeInterval = 120 * 60
    static let minAge = 12
    static let mechanics: Set<GameMechanic> = [.partnerships, .takeThat, .variablePlayerPowers, .handManagement]
    static let categories: Set<GameCategory> = [.spaceExploration, .negotiation, .bluffing, .scienceFiction]
}

struct RumAndBones {
    static let gameId = "196202"
    static let name = "Rum & Bones: Second Tide"
    static let recommendedPlayerCount = [PlayerCount.count(value: 2), PlayerCount.count(value: 4)]
    static let mechanics: Set<GameMechanic> = [.diceRolling, .actionMovementProgramming, .variablePhaseOrder, .variablePlayerPowers, .modularBoard, .actionPointAllowanceSystem, .gridMovement]
    static let categories: Set<GameCategory> = [.fantasy, .zombies, .humor, .miniatures, .nautical, .dice, .pirates]
}
