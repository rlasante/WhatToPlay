//
//  User.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 6/25/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit
import SWXMLHash

struct User: XMLIndexerDeserializable {

    let userId: String
    let userName: String

    let firstName: String?
    let lastName: String?


    static func deserialize(_ node: XMLIndexer) throws -> User {
        guard let userId: String = node.value(ofAttribute: "id"),
            let userName: String = node.value(ofAttribute: "name")
            else { throw XMLDeserializationError.nodeIsInvalid(node: node) }
        return User(
            userId: userId,
            userName: userName,
            firstName: node["firstname"].value(ofAttribute: "value"),
            lastName: node["lastname"].value(ofAttribute: "value")
        )
    }

}
