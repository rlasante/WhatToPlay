//
//  Game.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/6/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import CoreData
import UIKit
import Foundation
import SWXMLHash

extension String {
    var normalizedCamelCased: String {
        var words = self.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .whitespacesAndNewlines).map {
            $0.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "&", with: "And").localizedCapitalized
        }
        if let firstWord = words.first {
            words[0] = firstWord.localizedLowercase
        }
        return words.joined()
    }
}

class Game: NSManagedObject {

//    @NSManaged var rawCategories: [String]
    var categories: [GameCategory] {
        get {
            return ArrayGameCategoryValueTransformer().reverseTransformedValue(rawCategories) as? [GameCategory] ?? []
        }
        set {
            rawCategories = ArrayGameCategoryValueTransformer().transformedValue(newValue) as? [String] ?? []
        }
    }

//    @NSManaged var rawMechanics: [String]
    var mechanics: [GameMechanic] {
        get {
            return ArrayGameMechanicValueTransformer().reverseTransformedValue(rawMechanics) as? [GameMechanic] ?? []
        }
        set {
            rawMechanics = ArrayGameMechanicValueTransformer().transformedValue(newValue) as? [String] ?? []
        }
    }

//    @NSManaged var rawPlayerCount: [AnyObject]
    var playerCount: [PlayerCount] {
        get {
            return ArrayPlayerCountValueTransformer().reverseTransformedValue(rawPlayerCount) as? [PlayerCount] ?? []
        }
        set {
            rawPlayerCount = ArrayPlayerCountValueTransformer().transformedValue(newValue) as? [AnyObject] ?? []
        }
    }

//    @NSManaged var rawBestPlayerCount: AnyObject?
    var bestPlayerCount: PlayerCount? {
        get {
            return PlayerCountValueTransformer().reverseTransformedValue(rawBestPlayerCount) as? PlayerCount
        }
        set {
            rawBestPlayerCount = PlayerCountValueTransformer().transformedValue(newValue) as AnyObject
        }
    }
//    @NSManaged var rawSuggestedPlayerCount: [AnyObject]
    var suggestedPlayerCount: [PlayerCount] {
        get {
            return ArrayPlayerCountValueTransformer().reverseTransformedValue(rawSuggestedPlayerCount) as? [PlayerCount] ?? []
        }
        set {
            rawSuggestedPlayerCount = ArrayPlayerCountValueTransformer().transformedValue(newValue) as? [AnyObject] ?? []
        }
    }

    var complexity: GameComplexity? {
        get {
            return GameComplexityValueTransformer().reverseTransformedValue(rawComplexity) as? GameComplexity
        }
        set {
            rawComplexity = (GameComplexityValueTransformer().transformedValue(newValue)) as! Double
        }
    }

    init(gameId: String, name: String, yearPublished: String? = nil, gameDescription: String? = nil, thumbnailURL: URL? = nil, imageURL: URL? = nil, publisher: String? = nil, categories: [GameCategory] = [], mechanics: [GameMechanic] = [], playerCount: [PlayerCount] = [], bestPlayerCount: PlayerCount? = nil, suggestedPlayerCount: [PlayerCount] = [], playingTime: TimeInterval = 0, minPlayingTime: TimeInterval = 0, maxPlayingTime: TimeInterval = 0, playerAge: Int = 0, suggestedPlayerAge: Int = 0, complexity: GameComplexity? = nil, context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Game", in: context) else {
            fatalError("Game Entity should always be in core data")
        }
        super.init(entity: entity, insertInto: context)
        self.gameId = gameId
        self.name = name
        self.yearPublished = yearPublished
        self.gameDescription = gameDescription
        self.thumbnailURL = thumbnailURL
        self.imageURL = imageURL
        self.publisher = publisher
        self.categories = categories
        self.mechanics = mechanics
        self.playerCount = playerCount
        self.bestPlayerCount = bestPlayerCount
        self.suggestedPlayerCount = suggestedPlayerCount
        self.playingTime = playingTime
        self.minPlayingTime = minPlayingTime
        self.maxPlayingTime = maxPlayingTime
        self.playerAge = Int16(playerAge)
        self.suggestedPlayerAge = Int16(suggestedPlayerAge)
        self.complexity = complexity
    }

    convenience init(data: GameXMLData, in context: NSManagedObjectContext) {
        self.init(gameId: data.gameId, name: data.name, yearPublished: data.yearPublished, gameDescription: data.description, thumbnailURL: data.thumbnailURL, imageURL: data.imageURL, publisher: data.publisher, categories: data.categories, mechanics: data.mechanics, playerCount: data.playerCount, bestPlayerCount: data.bestPlayerCount, suggestedPlayerCount: data.suggestedPlayerCount, playingTime: data.playingTime ?? 0, minPlayingTime: data.minPlayingTime ?? 0, maxPlayingTime: data.maxPlayingTime ?? 0, playerAge: data.playerAge ?? 0, suggestedPlayerAge: data.suggestedPlayerAge ?? 0, complexity: data.complexity, context: context)
    }

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    class func fetchRequest(forIds gameIds: [String]) -> NSFetchRequest<Game> {
        let fetchRequest = NSFetchRequest<Game>(entityName: "Game")
        fetchRequest.predicate = NSPredicate(format: "gameId in %@", gameIds)
        return fetchRequest
    }
}

struct GameXMLData: XMLIndexerDeserializable {
    let gameId: String
    let yearPublished: String?

    let name: String
    let description: String?

    let thumbnailURL: URL?
    let imageURL: URL?

    let publisher: String?

    let categories: [GameCategory]
    let mechanics: [GameMechanic]

    let playerCount: [PlayerCount]
    let bestPlayerCount: PlayerCount?
    let suggestedPlayerCount: [PlayerCount]

    let playingTime: TimeInterval?
    let minPlayingTime: TimeInterval?
    let maxPlayingTime: TimeInterval?

    let playerAge: Int?
    let suggestedPlayerAge: Int?

    let complexity: GameComplexity

    static func deserialize(_ node: XMLIndexer) throws -> GameXMLData {
        guard let gameId: String = node.value(ofAttribute: "id"),
            let name: String = try node["name"].withAttribute("type", "primary").value(ofAttribute: "value")
            else { throw XMLDeserializationError.nodeIsInvalid(node: node) }

        let yearPublished: String? = node["yearpublished"].value(ofAttribute: "value")
        let description: String? = try node["description"].value()
        let thumbnail = URL(string: try node["thumbnail"].value())
        let image = URL(string: try node["image"].value())
        let publisher: String? = node["publisher"].value(ofAttribute: "value")

        let playingTime: TimeInterval = try node["playingtime"].value(ofAttribute: "value")
        let minPlayingTime: TimeInterval = try node["minplaytime"].value(ofAttribute: "value")
        let maxPlayingTime: TimeInterval = try node["maxplaytime"].value(ofAttribute: "value")

        let playerAge: Int = try node["minage"].value(ofAttribute: "value")
        let suggestedAge: Int = 0

        let minPlayers: Int = try node["minplayers"].value(ofAttribute: "value")
        let maxPlayers: Int = try node["maxplayers"].value(ofAttribute: "value")
        let playerCount = [PlayerCount.range(min: minPlayers, max: maxPlayers)]

        let suggestedPlayersPoll = try node["poll"].withAttribute("name", "suggested_numplayers").children

        let bestPlayer = try suggestedPlayersPoll.max { first, second in
            let firstNumberOfVotes: Int = try first["result"].withAttribute("value", "Best").value(ofAttribute: "numvotes")
            let secondNumberOfVotes: Int = try second["result"].withAttribute("value", "Best").value(ofAttribute: "numvotes")
            return firstNumberOfVotes < secondNumberOfVotes
        }

        let bestPlayerCount =  PlayerCount.count(value: bestPlayer?.value(ofAttribute: "numplayers") ?? 0)

        let recommended: [PlayerCount] = try suggestedPlayersPoll.sorted {
            let first: Int? = $0.value(ofAttribute: "numplayers")
            let second: Int? = $1.value(ofAttribute: "numplayers")
            return first ?? Int.max < second ?? Int.max
            }.reduce([PlayerCount]()) { total, value in
                // TODO: Figure out how to get this to work with X+
                let currentCount: Int = (try? value.value(ofAttribute: "numplayers") as Int) ?? Int.max
                let bestVotes: Int = try value["result"].withAttribute("value", "Best").value(ofAttribute: "numvotes")
                let recommendedVotes: Int = try value["result"].withAttribute("value", "Recommended").value(ofAttribute: "numvotes")
                let notRecommendedVotes: Int = try value["result"].withAttribute("value", "Not Recommended").value(ofAttribute: "numvotes")
                let isRecommended = bestVotes + recommendedVotes > notRecommendedVotes
                guard isRecommended else { return total }
                var total = total
                if let lastRecommended = total.last {
                    let lastMinAmount: Int
                    let lastMaxAmount: Int
                    switch lastRecommended {
                    case .count(let val):
                        lastMinAmount = val
                        lastMaxAmount = val
                    case .range(let min, let max):
                        lastMinAmount = min
                        lastMaxAmount = max
                    }
                    // If we've incremented by one then add a range
                    if lastMaxAmount == currentCount - 1 || (lastMaxAmount == maxPlayers && currentCount == Int.max) {
                        total.removeLast()
                        total.append(.range(min: lastMinAmount, max: currentCount))
                    } else { // Otherwise just add it
                        total.append(.count(value: currentCount))
                    }
                } else {
                    total.append(.count(value: currentCount))
                }
                return total
        }

        let suggestedPlayerCount = recommended
        let categories: [GameCategory] = node[GameCategory.serverNodeType].all.compactMap { try? $0.value() }
        let mechanics: [GameMechanic] = node[GameMechanic.serverNodeType].all.compactMap { try? $0.value() }

        let complexity: GameComplexity = (try? node["statistics"]["ratings"][GameComplexity.serverNodeType].value()) ?? .heavy(actualWeight: 5)

        return GameXMLData(gameId: gameId,
                    yearPublished: yearPublished,
                    name: name,
                    description: description,

                    thumbnailURL: thumbnail,
                    imageURL: image,
                    publisher: publisher,

                    categories: categories,
                    mechanics: mechanics,

                    playerCount: playerCount,
                    bestPlayerCount: bestPlayerCount,
                    suggestedPlayerCount: suggestedPlayerCount,

                    playingTime: playingTime * 60,
                    minPlayingTime: minPlayingTime * 60,
                    maxPlayingTime: maxPlayingTime * 60,

                    playerAge: playerAge,
                    suggestedPlayerAge: suggestedAge,
                    complexity: complexity
        )
    }
}
