//
//  CollectionModel.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/17/19.
//  Copyright © 2019 rlasante. All rights reserved.
//

import Foundation
import UIKit

class CollectionModel {
    /// ID for the collection
    var collectionId: String = UUID().uuidString

    /// List of games in the collection
    var games: [Game] = []

    init(games: [Game]) {
        self.games = games
    }

    // TODO: Make this actually work with both
    func api() -> CollectionAPI {
        let context = (UIApplication.shared.delegate as! AppDelegate).mainManagedObjectContext
        return CollectionAPIProvider(context: context)
    }
}
