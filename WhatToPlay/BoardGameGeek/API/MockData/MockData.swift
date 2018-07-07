//
//  MockCollectionData.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 9/13/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit
import Alamofire


var mockCollectionData: Result<String>? = {
    guard let path = Bundle.main.path(forResource: "MockCollection", ofType: "txt"),
        let content = try? String(contentsOfFile:path, encoding: .utf8) else {
        return nil
    }
    return .success(content)
}()

var mockGameData: Result<String>? = {
    guard let path = Bundle.main.path(forResource: "MockGames", ofType: "txt"),
        let content = try? String(contentsOfFile:path, encoding: .utf8) else {
            return nil
    }
    return .success(content)
}()
