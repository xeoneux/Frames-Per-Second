//
//  Movie+CoreDataProperties.swift
//  Frames Per Second
//
//  Created by Aayush Kapoor on 06/10/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie");
    }

    @NSManaged public var imageUrl: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var rating: Double
    @NSManaged public var overview: String?
    @NSManaged public var title: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var category: String?

}
