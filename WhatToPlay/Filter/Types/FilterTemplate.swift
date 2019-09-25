//
//  FilterTemplate.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 9/11/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit

protocol FilterTemplate: FilterModel {
    init?(filterData: [String: Any]?)
    func serialize() -> [String: Any]
    var description: String { get }
    var shortDescription: String { get }
    var descriptions: [String] { get }
    func filter(_ game: Game) -> Bool
}
extension FilterTemplate {
    var descriptions: [String] {
        return [description]
    }
}
