//
//  CollectionModel.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/17/19.
//  Copyright © 2019 rlasante. All rights reserved.
//

import Foundation

class CollectionModel {
    /// ID for the collection
    var collectionId: String = UUID().uuidString

    /// List of games in the collection
    var games: [Game] = []
}
