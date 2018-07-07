//
//  GameTests.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/18/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import XCTest
@testable import WhatToPlay
import PromiseKit

class GameTests: XCTestCase {

    func testGetInvalidGame() {
        let gotGame = expectation(description: "Downloading BoardGame")
        firstly {
            BoardGameGeekAPI.getBoardGame(gameId: "This is not a gameId")
        }.done { game in
            XCTFail("It should have Failed to fetch the game")
        }.catch { error in
            gotGame.fulfill()
        }
        waitForExpectations(timeout: 9, handler: nil)
    }

    func testGetValidGame() {
        let expectedGame = Inis.self

        let gotGame = expectation(description: "Downloading BoardGame")
        firstly {
            BoardGameGeekAPI.getBoardGame(gameId: expectedGame.gameId)
        }.done { game in
            gotGame.fulfill()
        }.catch { error in
            XCTFail("Failed to fetch game: \(error)")
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testParseName() {
        let expectedGame = Inis.self

        let gotGame = expectation(description: "Downloading BoardGame")
        firstly {
            BoardGameGeekAPI.getBoardGame(gameId: expectedGame.gameId)
        }.done { game in
            XCTAssertEqual(game.gameId, expectedGame.gameId)
            XCTAssertEqual(game.name, expectedGame.name)

            XCTAssertEqual(game.playingTime, expectedGame.playTime)
            XCTAssertEqual(game.minPlayingTime, expectedGame.minPlayTime)
            XCTAssertEqual(game.maxPlayingTime, expectedGame.maxPlayTime)

            XCTAssertEqual(game.playerAge!, expectedGame.minAge)

            gotGame.fulfill()
        }.catch { error in
            XCTFail("Failed to fetch game: \(error)")
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testIncorrectGame() {
        let expectedGame = CosmicEncounter.self
        let incorrectGame = Inis.self

        let gotGame = expectation(description: "Downloading BoardGame")
        firstly {
            BoardGameGeekAPI.getBoardGame(gameId: expectedGame.gameId)
        }.done { game in
            XCTAssertNotEqual(game.gameId, incorrectGame.gameId)
            XCTAssertNotEqual(game.name, incorrectGame.name)
            gotGame.fulfill()
        }.catch { error in
            XCTFail("Failed to fetch game: \(error)")
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testBestPlayerCount() {
        let expectedGame = Inis.self

        let gotGame = expectation(description: "Downloading BoardGame")
        firstly {
            BoardGameGeekAPI.getBoardGame(gameId: expectedGame.gameId)
        }.done { game in
            XCTAssertEqual(game.gameId, expectedGame.gameId)
            guard let bestPlayerCount = game.bestPlayerCount else { XCTFail("No Best Player"); return }
            guard case let .count(bestPlayer) = bestPlayerCount else { XCTFail("No Best Player"); return }
            XCTAssertEqual(bestPlayer, expectedGame.bestPlayerCount)
            gotGame.fulfill()
        }.catch { error in
            XCTFail("Failed to fetch game: \(error)")
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testRecommendedNonConsecutivePlayerCount() {
        let expectedGame = RumAndBones.self

        let gotGame = expectation(description: "Downloading BoardGame")
        firstly {
            BoardGameGeekAPI.getBoardGame(gameId: expectedGame.gameId)
        }.done { game in
            for (index, element) in game.suggestedPlayerCount.enumerated() {
                switch element {
                case .count(let actual):
                    guard case let .count(expected) = expectedGame.recommendedPlayerCount[index] else { XCTFail("Wrong type"); return }
                    XCTAssertEqual(actual, expected)
                case .range(let actualMin, let actualMax):
                    guard case let .range(expectedMin, expectedMax) = expectedGame.recommendedPlayerCount[index] else { XCTFail("Wrong type"); return }
                    XCTAssertEqual(actualMin, expectedMin)
                    XCTAssertEqual(actualMax, expectedMax)
                }
            }
            gotGame.fulfill()
        }.catch { error in
            XCTFail("Failed to fetch game: \(error)")
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testRecommendedMaxPlusPlayerCount() {
        let expectedGame = CosmicEncounter.self

        let gotGame = expectation(description: "Downloading BoardGame")
        firstly {
            BoardGameGeekAPI.getBoardGame(gameId: expectedGame.gameId)
        }.done { game in
            for (index, element) in game.suggestedPlayerCount.enumerated() {
                switch element {
                case .count(let actual):
                    guard case let .count(expected) = expectedGame.recommendedPlayerCount[index] else { XCTFail("Wrong type"); return }
                    XCTAssertEqual(actual, expected)
                case .range(let actualMin, let actualMax):
                    guard case let .range(expectedMin, expectedMax) = expectedGame.recommendedPlayerCount[index] else { XCTFail("Wrong type"); return }
                    XCTAssertEqual(actualMin, expectedMin)
                    XCTAssertEqual(actualMax, expectedMax)
                }
            }
            gotGame.fulfill()
        }.catch { error in
            XCTFail("Failed to fetch game: \(error)")
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testGameMechanics() {
        let expectedGame = RumAndBones.self

        let gotGame = expectation(description: "Downloading BoardGame")
        firstly {
            BoardGameGeekAPI.getBoardGame(gameId: expectedGame.gameId)
        }.done { game in
            let difference = game.mechanics.symmetricDifference(expectedGame.mechanics)
            XCTAssertEqual(difference.count, 0, "[MECHANIC] Incorrect Game Mechanics:\nActual: \(game.mechanics)\n\nExpected: \(expectedGame.mechanics)\n\nMissing from local: \(game.mechanics.subtracting(expectedGame.mechanics))\n\nMissing from actual: \(expectedGame.mechanics.subtracting(game.mechanics))")
            gotGame.fulfill()
        }.catch { error in
            XCTFail("Failed to fetch game: \(error)")
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testGameCategories() {
        let expectedGame = RumAndBones.self

        let gotGame = expectation(description: "Downloading BoardGame")
        firstly {
            BoardGameGeekAPI.getBoardGame(gameId: expectedGame.gameId)
        }.done { game in
            let difference = game.categories.symmetricDifference(expectedGame.categories)
            XCTAssertEqual(difference.count, 0, "[CATEGORY] Incorrect Game Categories:\n\nActual: \(game.categories)\n\nExpected: \(expectedGame.categories)\n\nMissing from local: \(game.categories.subtracting(expectedGame.categories))\n\nMissing from actual: \(expectedGame.categories.subtracting(game.categories))")
            gotGame.fulfill()
        }.catch { error in
            XCTFail("Failed to fetch game: \(error)")
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
}
