//
//  User.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 6/25/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import CoreData
import UIKit
import SWXMLHash

class User: NSManagedObject {

    @NSManaged var userId: String
    @NSManaged var userName: String

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?

    @NSManaged var games: [Game]

    init(userId: String, userName: String, firstName: String? = nil, lastName: String? = nil, in context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else {
            fatalError("User Entity should always be in core data")
        }
        super.init(entity: entity, insertInto: context)

        self.userId = userId
        self.userName = userName
        self.firstName = firstName
        self.lastName = lastName
    }

    convenience init(data: UserXMLData, in context: NSManagedObjectContext) {
        self.init(userId: data.userId, userName: data.userName, firstName: data.firstName, lastName: data.lastName, in: context)
    }
}

struct UserXMLData: XMLIndexerDeserializable {
    let userId: String
    let userName: String

    let firstName: String?
    let lastName: String?

    static func deserialize(_ node: XMLIndexer) throws -> UserXMLData {
        guard let userId: String = node.value(ofAttribute: "id"),
            let userName: String = node.value(ofAttribute: "name")
            else { throw XMLDeserializationError.nodeIsInvalid(node: node) }
        return UserXMLData(
            userId: userId,
            userName: userName,
            firstName: node["firstname"].value(ofAttribute: "value"),
            lastName: node["lastname"].value(ofAttribute: "value")
        )
    }
}
