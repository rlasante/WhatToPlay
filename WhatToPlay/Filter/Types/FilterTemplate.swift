//
//  FilterTemplate.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 9/11/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit

protocol FilterTemplate {
    init?(filterData: [String: Any]?)
    func serialize() -> [String: Any]
    func isValid(_ game: Game) -> Bool
    var description: String { get }
    var shortDescription: String { get }
    var descriptions: [String] { get }
}
extension FilterTemplate {
    var descriptions: [String] {
        return [description]
    }
}
