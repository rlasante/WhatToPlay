//
//  GameComplexity.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 9/17/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit
import SWXMLHash

enum GameComplexity: XMLIndexerDeserializable, Comparable, PickerData {

    case light(actualWeight: Double)
    case mediumLight(actualWeight: Double)
    case medium(actualWeight: Double)
    case mediumHeavy(actualWeight: Double)
    case heavy(actualWeight: Double)

    static let all: [GameComplexity] = [
        .light(actualWeight: 1),
        .mediumLight(actualWeight: 2),
        .medium(actualWeight: 3),
        .mediumHeavy(actualWeight: 4),
        .heavy(actualWeight: 5)
    ]

    init?(serverValue: Double) {
        switch serverValue {
        case 0..<1.5: self = .light(actualWeight: serverValue)
        case 1.5..<2.5: self = .mediumLight(actualWeight: serverValue)
        case 2.5..<3.5: self = .medium(actualWeight: serverValue)
        case 3.5..<4.5: self = .mediumHeavy(actualWeight: serverValue)
        case 4.5...5: self = .heavy(actualWeight: serverValue)
        default:
            return nil
        }
    }

    var isValid: Bool {
        switch self {
        case .light(0..<1.5): return true
        case .mediumLight(1.5..<2.5): return true
        case .medium(2.5..<3.5): return true
        case .mediumHeavy(3.5..<4.5): return true
        case .heavy(4.5...5): return true

        default: return false
        }
    }

    var weight: Double {
        switch self {
        case .light: return 1
        case .mediumLight: return 2
        case .medium: return 3
        case .mediumHeavy: return 4
        case .heavy: return 5
        }
    }

    var actualWeight: Double {
        switch self {
        case .light(let actualWeight): return actualWeight
        case .mediumLight(let actualWeight): return actualWeight
        case .medium(let actualWeight): return actualWeight
        case .mediumHeavy(let actualWeight): return actualWeight
        case .heavy(let actualWeight): return actualWeight
        }
    }

    static let serverNodeType = "averageweight"

    static func deserialize(_ node: XMLIndexer) throws -> GameComplexity {
        guard let weight: Double = node.value(ofAttribute: "value"),
            let complexity = GameComplexity(serverValue: weight) else {
                throw XMLDeserializationError.nodeIsInvalid(node: node)
        }
        return complexity
    }

    static func == (lhs: GameComplexity, rhs: GameComplexity) -> Bool {
        return lhs.actualWeight == rhs.actualWeight
    }

    static func < (lhs: GameComplexity, rhs: GameComplexity) -> Bool {
        return lhs.actualWeight < rhs.actualWeight
    }

    var label: String {
        let title: String
        switch self {
        case .light: title = "Light"
        case .mediumLight: title = "Medium Light"
        case .medium: title = "Medium"
        case .mediumHeavy: title = "Medium Heavy"
        case .heavy: title = "Heavy"
        }
        guard actualWeight != weight else { return title }
        let formatter = NumberFormatter()
        formatter.formatterBehavior = NumberFormatter.defaultFormatterBehavior()
        formatter.maximumSignificantDigits = 2
        return "\(title) \(formatter.string(for: self.weight) ?? "--")"
    }
}

class GameComplexityValueTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let complexity = value as? GameComplexity else { return nil }
        return complexity.actualWeight
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let actualWeight = value as? Double else { return nil }
        return GameComplexity(serverValue: actualWeight)
    }
}
