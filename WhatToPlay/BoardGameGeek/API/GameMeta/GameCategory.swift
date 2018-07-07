//
//  GameCategory.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 9/13/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit
import SWXMLHash

enum GameCategory: String, EnumCollection, XMLIndexerDeserializable {
    case abstractStrategy,
    actionDexterity,
    adventure,
    americanWest,
    ancient,
    animals,
    arabian,
    bluffing,
    book,
    cardGame,
    childrensGame,
    cityBuilding,
    civilization,
    collectibleComponents,
    comicBookStrip,
    deduction,
    dice,
    economic,
    environmental,
    exploration,
    fantasy,
    farming,
    fighting,
    horror,
    humor,
    industryManufacturing,
    matureAdult,
    medical,
    medieval,
    memory,
    miniatures,
    modernWarfare,
    moviesTvRadioTheme,
    murdermystery,
    mythology,
    nautical,
    negotiation,
    novelbased,
    number,
    partyGame,
    pirates,
    political,
    postnapoleonic,
    printAndPlay,
    puzzle,
    racing,
    realtime,
    renaissance,
    scienceFiction,
    spaceExploration,
    spiessecretAgents,
    sports,
    territoryBuilding,
    trains,
    transportation,
    travel,
    wargame,
    wordGame,
    worldWarIi,
    zombies

    init?(serverValue: String) {
        self.init(rawValue: serverValue.normalizedCamelCased)
    }

    static let serverNodeType = "link"
    static let attributeKey = "type"
    static let attributeValue = "boardgamecategory"

    static func deserialize(_ node: XMLIndexer) throws -> GameCategory {
        guard let type: String = node.value(ofAttribute: attributeKey),
            type == attributeValue else {
                throw XMLDeserializationError.nodeIsInvalid(node: node)
        }
        guard let serverValue: String = node.value(ofAttribute: "value"),
            let category = GameCategory(serverValue: serverValue) else {
                if let type: String = node.value(ofAttribute: "value") {
                    print("[CATEGORY] Missing type:\n\(type.normalizedCamelCased),")
                }
                throw XMLDeserializationError.nodeIsInvalid(node: node)
        }
        return category
    }
}
