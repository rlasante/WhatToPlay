//
//  CollectionTests.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/22/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import XCTest
@testable import WhatToPlay
import PromiseKit

class CollectionTests: XCTestCase {
    
    func testGetCollection() {
//        let expectedGame = Inis.self

        let gotCollection = expectation(description: "Downloading Collection")
        firstly {
            BoardGameGeekAPI.getCollection(userName: "Hunter9110")
        }.done { games in
            XCTAssertNotEqual(games.count, 0)
            gotCollection.fulfill()
        }.catch { error in
            XCTFail("Failed to fetch collection: \(error)")
            gotCollection.fulfill()
        }
        waitForExpectations(timeout: 60, handler: nil)
    }
    
}
