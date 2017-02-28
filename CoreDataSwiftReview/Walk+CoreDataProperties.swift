//
//  Walk+CoreDataProperties.swift
//  CoreDataSwiftReview
//
//  Created by KrishnaChaitanya Amjuri on 27/02/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var dog: Dog?

}
