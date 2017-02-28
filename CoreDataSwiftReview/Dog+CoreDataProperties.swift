//
//  Dog+CoreDataProperties.swift
//  CoreDataSwiftReview
//
//  Created by KrishnaChaitanya Amjuri on 27/02/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Dog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog> {
        return NSFetchRequest<Dog>(entityName: "Dog");
    }

    @NSManaged public var name: String?
    @NSManaged public var walk: NSOrderedSet?

}

// MARK: Generated accessors for walk
extension Dog {

    @objc(insertObject:inWalkAtIndex:)
    @NSManaged public func insertIntoWalk(_ value: Walk, at idx: Int)

    @objc(removeObjectFromWalkAtIndex:)
    @NSManaged public func removeFromWalk(at idx: Int)

    @objc(insertWalk:atIndexes:)
    @NSManaged public func insertIntoWalk(_ values: [Walk], at indexes: NSIndexSet)

    @objc(removeWalkAtIndexes:)
    @NSManaged public func removeFromWalk(at indexes: NSIndexSet)

    @objc(replaceObjectInWalkAtIndex:withObject:)
    @NSManaged public func replaceWalk(at idx: Int, with value: Walk)

    @objc(replaceWalkAtIndexes:withWalk:)
    @NSManaged public func replaceWalk(at indexes: NSIndexSet, with values: [Walk])

    @objc(addWalkObject:)
    @NSManaged public func addToWalk(_ value: Walk)

    @objc(removeWalkObject:)
    @NSManaged public func removeFromWalk(_ value: Walk)

    @objc(addWalk:)
    @NSManaged public func addToWalk(_ values: NSOrderedSet)

    @objc(removeWalk:)
    @NSManaged public func removeFromWalk(_ values: NSOrderedSet)

}
