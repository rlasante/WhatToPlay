//
//  GameDetailViewModel.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/21/20.
//  Copyright © 2020 rlasante. All rights reserved.
//

import Combine
import Foundation

class GameDetailViewModel: ObservableObject {
    @Published var game: Game

    // input
    let onBack = PassthroughSubject<Void, Error>()

    // Output
    var dismiss: AnyPublisher<Void, Error>

    init(game: Game) {
        self.game = game
        dismiss = onBack.eraseToAnyPublisher()
    }
}
