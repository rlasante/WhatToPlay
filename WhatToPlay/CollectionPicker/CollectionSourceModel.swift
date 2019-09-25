//
//  CollectionSourceModel.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/18/19.
//  Copyright © 2019 rlasante. All rights reserved.
//

import Foundation

/// Class for the different sources to find collections
class CollectionSourceModel {
    let name: String
    let url: URL
    let baseAPIURL: URL
    let requiresAuthorization: Bool

    /// BoardGameGeek Collection Source
    static let boardGameGeek = CollectionSourceModel(
        name: "BoardGameGeek",
        url: URL(string: "https://www.boardgamegeek.com")!,
        baseAPIURL: URL(string: "https://www.boardgamegeek.com/xmlapi2")!,
        requiresAuthorization: false
    )
    /// Board Game Atlas Collection Source
    static let boardGameAtlas = CollectionSourceModel(
        name: "Board Game Atlas",
        url: URL(string: "https://www.boardgameatlas.com")!,
        baseAPIURL: URL(string: "https://www.boardgameatlas.com/api")!,
        requiresAuthorization: true
    )

    init(name: String, url: URL, baseAPIURL: URL, requiresAuthorization: Bool) {
        self.name = name
        self.url = url
        self.baseAPIURL = baseAPIURL
        self.requiresAuthorization = requiresAuthorization
    }
}

extension CollectionSourceModel: Equatable {
    static func == (lhs: CollectionSourceModel, rhs: CollectionSourceModel) -> Bool {
        return lhs.name == rhs.name
        && lhs.url == rhs.url
        && lhs.baseAPIURL == rhs.baseAPIURL
        && lhs.requiresAuthorization == rhs.requiresAuthorization
    }
}
