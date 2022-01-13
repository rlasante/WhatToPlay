//
//  PlayerCountFilter.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 9/11/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit

//struct PlayerCountFilter: FilterTemplate {
//
//    var playerCount: PlayerCount
//    var suggestedPlayerCountOnly: Bool
//    var bestPlayerCountOnly: Bool
//
//    var description: String {
//        let addon: String
//        switch (suggestedPlayerCountOnly, bestPlayerCountOnly) {
//        case (true, false): addon = " Suggested"
//        case (false, true): addon = " Best"
//        case (false, false): addon = ""
//        case (true, true):
//            print("Both suggested and best should never be true")
//            addon = ""
//        }
//        switch playerCount {
//        case .count(let value): return "\(value) Player" + "\(value == 1 ? "" : "s")" + addon
//        case let .range(min, max): return "\(min)-\(max) Players" + addon
//        }
//    }
//    var shortDescription: String { return "Players" }
//    var descriptions: [String] {
//        var descriptions = [String]()
//        switch playerCount {
//        case .count(let value): descriptions.append("\(value) Player" + "\(value == 1 ? "" : "s")")
//        case let .range(min, max):
//            if min == max {
//                descriptions.append("\(min) Player" + "\(min == 1 ? "" : "s")")
//            } else {
//                descriptions.append("\(min)-\(max) Players")
//            }
//        }
//        switch (suggestedPlayerCountOnly, bestPlayerCountOnly) {
//        case (true, false): descriptions.append("Suggested Only")
//        case (false, true): descriptions.append("Best Only")
//        default: break
//        }
//        return descriptions
//    }
//
//    init?(playerCount: PlayerCount, suggestedPlayerCountOnly: Bool, bestPlayerCountOnly: Bool) {
//        guard !(suggestedPlayerCountOnly && bestPlayerCountOnly) else {
//            // Can't have both suggested and best counts
//            return nil
//        }
//        self.playerCount = playerCount
//        self.suggestedPlayerCountOnly = suggestedPlayerCountOnly
//        self.bestPlayerCountOnly = bestPlayerCountOnly
//    }
//
//    func filter(_ game: Game) -> Bool {
//        switch (suggestedPlayerCountOnly, bestPlayerCountOnly) {
//        case (true, false):
//            return game.suggestedPlayerCount.contains {
//                $0.entirelyContains(playerCount)
//            }
//        case (false, true):
//            return game.bestPlayerCount?.entirelyContains(playerCount) ?? false
//        default:
//            return game.playerCount.contains {
//                $0.entirelyContains(playerCount)
//            }
//        }
//    }
//
//    init?(filterData: [String: Any]?) {
//        guard let (playerCount, suggestedPlayerCountOnly, bestPlayerCountOnly) = filterData?[String(describing: PlayerCountFilter.self)] as? (PlayerCount, Bool, Bool) else { return nil }
//        self.init(playerCount: playerCount, suggestedPlayerCountOnly: suggestedPlayerCountOnly, bestPlayerCountOnly: bestPlayerCountOnly)
//    }
//
//    func serialize() -> [String : Any] {
//        return [String(describing: PlayerCountFilter.self): (playerCount, suggestedPlayerCountOnly, bestPlayerCountOnly)]
//    }
//
//}
