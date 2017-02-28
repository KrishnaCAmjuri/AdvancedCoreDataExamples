//
//  BowTie+CoreDataProperties.swift
//  CoreDataSwiftReview
//
//  Created by KrishnaChaitanya Amjuri on 27/02/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//

import Foundation
import CoreData


extension BowTie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BowTie> {
        return NSFetchRequest<BowTie>(entityName: "BowTie");
    }

    @NSManaged public var isFavourite: Bool
    @NSManaged public var lastWorn: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var searchKey: String?
    @NSManaged public var timesWorn: Int64
    @NSManaged public var photoData: NSData?
    @NSManaged public var tintColor: NSObject?

}
