//
//  GameFamily.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/10/18.
//  Copyright © 2018 rlasante. All rights reserved.
//

import CoreData
import UIKit

class GameFamily: NSManagedObject {
    static let linkType: String = "boardgamefamily"

    @NSManaged var id: String
    @NSManaged var name: String

    init(id: String, name: String, in context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "GameFamily", in: context) else {
            fatalError("GameFamily Entity should always be in core data")
        }
        super.init(entity: entity, insertInto: context)
        self.id = id
        self.name = name
    }

    class func fetchRequest(names: String...) -> NSFetchRequest<GameFamily> {
        return fetchRequestForCollection(with: NSPredicate(format: "name in %@", names))
    }

    class func fetchRequestForCollection(with predicate: NSPredicate? = nil) -> NSFetchRequest<GameFamily> {
        let fetchRequest = NSFetchRequest<GameFamily>(entityName: "GameFamily")
        fetchRequest.predicate = predicate
        return fetchRequest
    }

    // TODO Make it so that we can easily do a get or create
    class func fetchOrCreate(id: String, name: String, in context: NSManagedObjectContext) -> GameFamily {
        let fetchRequest = fetchRequestForCollection(with: NSPredicate(format: "id == %@", id))
        if let family = (try? context.fetch(fetchRequest))?.first {
            return family
        }
        let family = GameFamily(id: id, name: name, in: context)
        return family
    }
}
