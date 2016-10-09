//
//  Person+CoreDataClass.swift
//  Frames Per Second
//
//  Created by Aayush Kapoor on 06/10/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import Foundation
import CoreData


public class Person: NSManagedObject {

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    init(data: [String: Any], category: String, insertInto context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)!
        super.init(entity: entity, insertInto: context)

        name = (data["name"] as! String)
        imageUrl = (data["profile_path"] as? String)
        popularity = (data["popularity"] as! Double)

        self.category = category
    }

}
