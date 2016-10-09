//
//  Movie+CoreDataClass.swift
//  Frames Per Second
//
//  Created by Aayush Kapoor on 06/10/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import Foundation
import CoreData


public class Movie: NSManagedObject {

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    init(data: [String: Any], category: String, insertInto context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context)!
        super.init(entity: entity, insertInto: context)

        title = (data["title"] as! String)
        overview = (data["overview"] as! String)
        rating = (data["vote_average"] as! Double)
        imageUrl = (data["poster_path"] as? String)
        releaseDate = (data["release_date"] as! String)

        self.category = category
    }

}
