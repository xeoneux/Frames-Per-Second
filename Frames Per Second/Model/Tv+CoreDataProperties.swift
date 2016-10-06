//
//  Tv+CoreDataProperties.swift
//  Frames Per Second
//
//  Created by Aayush Kapoor on 06/10/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import Foundation
import CoreData


extension Tv {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tv> {
        return NSFetchRequest<Tv>(entityName: "Tv");
    }

    @NSManaged public var rating: Double
    @NSManaged public var releaseDate: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var category: String?

}
