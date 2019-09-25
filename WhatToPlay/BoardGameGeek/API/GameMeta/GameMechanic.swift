//
//  GameMechanic.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 9/13/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit
import SWXMLHash

enum GameMechanic: String, EnumCollection, XMLIndexerDeserializable {
    case acting,
    areaControlAreaInfluence,
    areaimpulse,
    areaMovement,
    actionMovementProgramming,
    actionPointAllowanceSystem,
    areaEnclosure,
    auctionbidding,
    bettingwagering,
    campaignBattleCardDriven,
    cardDrafting,
    cooperativePlay,
    deckPoolBuilding,
    diceRolling,
    gridMovement,
    handManagement,
    hexandcounter,
    lineDrawing,
    memory,
    modularBoard,
    paperandpencil,
    patternBuilding,
    pickupAndDeliver,
    pointToPointMovement,
    pressYourLuck,
    rolePlaying,
    rollSpinAndMove,
    routenetworkBuilding,
    partnerships,
    patternRecognition,
    playerElimination,
    secretUnitDeployment,
    setCollection,
    simultaneousActionSelection,
    simulation,
    storytelling,
    takeThat,
    tilePlacement,
    timeTrack,
    trading,
    tricktaking,
    variablePlayerPowers,
    variablePhaseOrder,
    voting,
    workerPlacement


    init?(serverValue: String) {
        self.init(rawValue: serverValue.normalizedCamelCased)
    }
    static let serverNodeType = "link"
    static let attributeKey = "type"
    static let attributeValue = "boardgamemechanic"

    static func deserialize(_ node: XMLIndexer) throws -> GameMechanic {
        guard let type: String = node.value(ofAttribute: attributeKey),
            type == attributeValue else {
                throw XMLDeserializationError.nodeIsInvalid(node: node)
        }
        guard let serverValue: String = node.value(ofAttribute: "value"),
            let mechanic = GameMechanic(serverValue: serverValue) else {
                if let type: String = node.value(ofAttribute: "value") {
                    print("[MECHANIC] Missing type:\n\(type.normalizedCamelCased),")
                }
                throw XMLDeserializationError.nodeIsInvalid(node: node)
        }
        return mechanic
    }
}

class GameMechanicValueTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let mechanic = value as? GameMechanic else { return nil }
        return mechanic.rawValue
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let rawValue = value as? String else { return nil }
        return GameMechanic(rawValue: rawValue)
    }
}

class ArrayGameMechanicValueTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let mechanics = value as? [GameMechanic] else { return nil }
        let transformer = GameMechanicValueTransformer()
        return mechanics.map { transformer.transformedValue($0) }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let rawValues = value as? [Any] else { return nil }
        let transformer = GameMechanicValueTransformer()
        return rawValues.map { transformer.reverseTransformedValue($0) }
    }
}
