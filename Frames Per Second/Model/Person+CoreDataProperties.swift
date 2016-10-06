//
//  Person+CoreDataProperties.swift
//  Frames Per Second
//
//  Created by Aayush Kapoor on 06/10/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person");
    }

    @NSManaged public var id: Int16
    @NSManaged public var imageUrl: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var name: String?
    @NSManaged public var popularity: Double

}
