//
//  GameComplexityTests.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 9/17/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

@testable import WhatToPlay
import XCTest

class GameComplexityTests: XCTestCase {

    // MARK: - Init Tests

    func test_invalidInit_under() {
        let weight = -1.0
        XCTAssertNil(GameComplexity(serverValue: weight))
    }

    func test_invalidInit_over() {
        let weight = 7.0
        XCTAssertNil(GameComplexity(serverValue: weight))
    }
    
    func test_complexityInit_light_under() {
        let weight = 0.5
        let complexity = self.complexity(for: weight)
        guard case .light(let actualWeight) = complexity else {
            XCTFail("Incorrect complexity bucket: \(complexity)")
            return
        }
        XCTAssertEqual(actualWeight, weight)
    }

    func test_complexityInit_light_exact() {
        let weight = 1.0
        let complexity = self.complexity(for: weight)
        guard case .light(let actualWeight) = complexity else {
            XCTFail("Incorrect complexity bucket: \(complexity)")
            return
        }
        XCTAssertEqual(actualWeight, weight)
        XCTAssertEqual(actualWeight, complexity.weight)
    }

    func test_complexityInit_light_over() {
        let weight = 1.49999
        let complexity = self.complexity(for: weight)
        guard case .light(let actualWeight) = complexity else {
            XCTFail("Incorrect complexity bucket: \(complexity)")
            return
        }
        XCTAssertEqual(actualWeight, weight)
    }

    func test_complexityInit_mediumLight_under() {
        let weight = 1.5
        let complexity = self.complexity(for: weight)
        guard case .mediumLight(let actualWeight) = complexity else {
            XCTFail("Incorrect complexity bucket: \(complexity)")
            return
        }
        XCTAssertEqual(actualWeight, weight)
    }

    func test_complexityInit_mediumLight_exact() {
        let weight = 2.0
        let complexity = self.complexity(for: weight)
        guard case .mediumLight(let actualWeight) = complexity else {
            XCTFail("Incorrect complexity bucket: \(complexity)")
            return
        }
        XCTAssertEqual(actualWeight, weight)
        XCTAssertEqual(actualWeight, complexity.weight)
    }

    func test_complexityInit_mediumLight_over() {
        let weight = 2.49999
        let complexity = self.complexity(for: weight)
        guard case .mediumLight(let actualWeight) = complexity else {
            XCTFail("Incorrect complexity bucket: \(complexity)")
            return
        }
        XCTAssertEqual(actualWeight, weight)
    }

    func test_complexityInit_medium_under() {
        let weight = 2.5
        let complexity = self.complexity(for: weight)
        guard case .medium(let actualWeight) = complexity else {
            XCTFail("Incorrect complexity bucket: \(complexity)")
            return
        }
        XCTAssertEqual(actualWeight, weight)
    }

    func test_complexityInit_medium_exact() {
        let weight = 3.0
        let complexity = self.complexity(for: weight)
        guard case .medium(let actualWeight) = complexity else {
            XCTFail("Incorrect complexity bucket: \(complexity)")
            return
        }
        XCTAssertEqual(actualWeight, weight)
        XCTAssertEqual(actualWeight, complexity.weight)
    }

    func test_complexityInit_medium_over() {
        let weight = 3.49999
        let complexity = self.complexity(for: weight)
        guard case .medium(let actualWeight) = complexity else {
            XCTFail("Incorrect complexity bucket: \(complexity)")
            return
        }
        XCTAssertEqual(actualWeight, weight)
    }

    func test_complexityInit_mediumHeavy_under() {
        let weight = 3.5
        let complexity = self.complexity(for: weight)
        guard case .mediumHeavy(let actualWeight) = complexity else {
            XCTFail("Incorrect complexity bucket: \(complexity)")
            return
        }
        XCTAssertEqual(actualWeight, weight)
    }

    func test_complexityInit_mediumHeavy_exact() {
        let weight = 4.0
        let complexity = self.complexity(for: weight)
        guard case .mediumHeavy(let actualWeight) = complexity else {
            XCTFail("Incorrect complexity bucket: \(complexity)")
            return
        }
        XCTAssertEqual(actualWeight, weight)
        XCTAssertEqual(actualWeight, complexity.weight)
    }

    func test_complexityInit_mediumHeavy_over() {
        let weight = 4.49999
        let complexity = self.complexity(for: weight)
        guard case .mediumHeavy(let actualWeight) = complexity else {
            XCTFail("Incorrect complexity bucket: \(complexity)")
            return
        }
        XCTAssertEqual(actualWeight, weight)
    }

    func test_complexityInit_heavy_under() {
        let weight = 4.5
        let complexity = self.complexity(for: weight)
        guard case .heavy(let actualWeight) = complexity else {
            XCTFail("Incorrect complexity bucket: \(complexity)")
            return
        }
        XCTAssertEqual(actualWeight, weight)
    }

    func test_complexityInit_heavy_exact() {
        let weight = 5.0
        let complexity = self.complexity(for: weight)
        guard case .heavy(let actualWeight) = complexity else {
            XCTFail("Incorrect complexity bucket: \(complexity)")
            return
        }
        XCTAssertEqual(actualWeight, weight)
        XCTAssertEqual(actualWeight, complexity.weight)
    }

    // MARK: - Comparing

    func test_compare_lessThan_sameBucket() {
        let less = complexity(for: 0.5)
        let more = complexity(for: 1.0)
        XCTAssertLessThan(less, more)
    }

    func test_compare_lessThan_differentBuckets() {
        let less = complexity(for: 0.5)
        let more = complexity(for: 5.0)
        XCTAssertLessThan(less, more)
    }

    func test_compare_equalTo() {
        let left = complexity(for: 2.5)
        let right = complexity(for: 2.5)
        XCTAssertEqual(left, right)
    }


    // MARK: - Helpers

    func complexity(for weight: Double) -> GameComplexity {
        guard let complexity = GameComplexity(serverValue: weight) else {
            XCTFail("Failed to generate a complexity from \(weight)")
            return .light(actualWeight: -1)
        }
        return complexity
    }
}
