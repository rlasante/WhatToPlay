//
//  PlayDurationFilter.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 9/14/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit

private extension TimeInterval {

    var description: String {
        let minute = 60.0
        let hour = minute * 60
        let inMinutes = self / minute
        switch self {
        case -Double.infinity...2*hour: return String(Int(inMinutes))
        case 2*hour+1...Double.infinity:
            // round to every 15 minutes
            let inQuarterHours = Int(inMinutes / 15)
            let inHours = Double(inQuarterHours) / 4.0
            return String(inHours)
        default:
            return "Any"
        }
    }
}

//struct PlayDurationFilter: FilterTemplate {
//
//    let duration: Range<TimeInterval>
//
//    var description: String {
//        guard duration.lowerBound != duration.upperBound else {
//            return "Playtime: \(duration.lowerBound.description) min"
//        }
//        let min = duration.lowerBound.description
//        let max = duration.upperBound.description
//        return "Playtime: \(min)-\(max) min"
//    }
//    var shortDescription: String { return "Playtime" }
//
//    func filter(_ game: Game) -> Bool {
//        let playTimes = [game.minPlayingTime, game.playingTime, game.maxPlayingTime].compactMap { $0 }
//        if playTimes.isEmpty { return false }
//
//        return playTimes.contains { duration.contains($0) || duration.upperBound == $0 }
//    }
//
//    init(duration: Range<TimeInterval>) {
//        self.duration = duration
//    }
//
//    init?(filterData: [String: Any]?) {
//        guard let duration = filterData?["duration"] as? Range<TimeInterval> else { return nil }
//        self.init(duration: duration)
//    }
//
//    func serialize() -> [String : Any] {
//        return ["duration": duration]
//    }
//}
