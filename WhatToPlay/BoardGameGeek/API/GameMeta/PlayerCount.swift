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
