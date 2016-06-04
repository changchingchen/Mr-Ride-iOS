//
//  Record+CoreDataProperties.swift
//  Mr-Ride-iOS
//
//  Created by Chang-Ching CHEN on 6/3/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RideRecord {

    @NSManaged var calories: NSNumber?
    @NSManaged var date: NSDate?
    @NSManaged var distance: NSNumber?
    @NSManaged var duration: NSNumber?
    @NSManaged var locations: NSOrderedSet?

}
