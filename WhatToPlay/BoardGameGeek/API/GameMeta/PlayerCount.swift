//
//  PlayerCount.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 9/13/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit
import SWXMLHash

enum PlayerCount {
    case range(min: Int, max: Int)
    case count(value: Int)

    func entirelyContains(_ playerCount: PlayerCount) -> Bool {
        let minAllowed: Int
        let maxAllowed: Int
        switch self {
        case .range(let min, let max):
            minAllowed = min
            maxAllowed = max
        case .count(let value):
            minAllowed = value
            maxAllowed = value
        }
        switch playerCount {
        case .range(let min, let max):
            return minAllowed <= min && maxAllowed >= max
        case .count(let value):
            return minAllowed <= value && maxAllowed >= value
        }
    }
}

class PlayerCountValueTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let playerCount = value as? PlayerCount else { return nil }
        switch playerCount {
        case let .range(min, max): return [min, max]
        case .count(let value): return value
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        if let countValue = value as? Int {
            return PlayerCount.count(value: countValue)
        } else if let rangeValue = value as? [Int], let min = rangeValue.first, let max = rangeValue.last {
            return PlayerCount.range(min: min, max: max)
        } else {
            return nil
        }
    }
}

class ArrayPlayerCountValueTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let playerCounts = value as? [PlayerCount] else { return nil }
        let transformer = PlayerCountValueTransformer()
        return playerCounts.map { transformer.transformedValue($0) }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let rawValues = value as? [Any] else { return nil }
        let transformer = PlayerCountValueTransformer()
        return rawValues.map { transformer.reverseTransformedValue($0) }
    }
}
