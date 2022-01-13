//
//  Game+CoreDataProperties.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/10/18.
//  Copyright © 2018 rlasante. All rights reserved.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    var id: String { gameId ?? "unknown" }

    @NSManaged public var gameId: String?
    @NSManaged public var yearPublished: String?
    @NSManaged public var name: String?
    @NSManaged public var gameDescription: String?
    @NSManaged public var thumbnailURL: URL?
    @NSManaged public var imageURL: URL?
    @NSManaged public var publisher: String?
    @NSManaged public var rawPlayerCount: [AnyObject]
    @NSManaged public var rawBestPlayerCount: AnyObject?
    @NSManaged public var rawSuggestedPlayerCount: [AnyObject]
    @NSManaged public var playingTime: TimeInterval
    @NSManaged public var minPlayingTime: TimeInterval
    @NSManaged public var maxPlayingTime: TimeInterval
    @NSManaged public var playerAge: Int16
    @NSManaged public var suggestedPlayerAge: Int16
    @NSManaged public var rawMechanics: [String]
    @NSManaged public var rawCategories: [String]
    @NSManaged public var rawComplexity: Double

}
