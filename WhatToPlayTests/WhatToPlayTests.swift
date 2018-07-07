//
//  WhatToPlayTests.swift
//  WhatToPlayTests
//
//  Created by Ryan LaSante on 6/25/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import XCTest
@testable import WhatToPlay
import PromiseKit

class WhatToPlayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetUser() {
        let gotUser = expectation(description: "Downloading User")
        firstly {
            BoardGameGeekAPI.getUser(userName: "Hunter9110")
        }.done { user in
            do {
                let user = try XCTGuardAssert(user)
                XCTAssertEqual(user.userName, "Hunter9110")
                XCTAssertEqual(try XCTGuardAssert(user.firstName), "Ryan")
                XCTAssertEqual(try XCTGuardAssert(user.lastName), "LaSante")
                gotUser.fulfill()
            } catch {
                print(error)
            }
        }.catch { error in
            XCTFail("Failed to fetch user: \(error)")
        }
        waitForExpectations(timeout: 9, handler: nil)
    }

    func testGetUserInvalid() {
        let gotUser = expectation(description: "Downloading Invalid User")
        firstly {
            BoardGameGeekAPI.getUser(userName: "This is not a username")
        }.done { user in
            XCTFail("No user should have been downloaded \(user)")
            gotUser.fulfill()
        }.catch { error in
            gotUser.fulfill()
        }
        waitForExpectations(timeout: 9, handler: nil)
    }
}

enum XCTError: Error {
    case nilValue
}

func XCTGuardAssert<Type>(_ object: Type?, message: String? = nil) throws -> Type {
    guard let unwrappedObject = object else {
        XCTFail(message ?? "Failed to unwrap \(String(describing: object))")
        _XCTestCaseInterruptionException().raise()
        throw XCTError.nilValue
    }
    return unwrappedObject
}
