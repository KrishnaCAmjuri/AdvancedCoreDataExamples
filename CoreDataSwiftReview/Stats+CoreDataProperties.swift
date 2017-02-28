//
//  Stats+CoreDataProperties.swift
//  CoreDataSwiftReview
//
//  Created by KrishnaChaitanya Amjuri on 28/02/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Stats {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stats> {
        return NSFetchRequest<Stats>(entityName: "Stats");
    }

    @NSManaged public var checkinsCount: Int32
    @NSManaged public var tipCount: Int32
    @NSManaged public var usersCount: Int32
    @NSManaged public var venue: Venue?

}
