//
//  Record+CoreDataProperties.swift
//  Mr-Ride-iOS
//
//  Created by admin on 5/30/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Record {

    @NSManaged var latitude: NSNumber?
    @NSManaged var logitude: NSNumber?
    @NSManaged var calorie: NSNumber?
    @NSManaged var distance: NSNumber?
    @NSManaged var date: NSDate?
    @NSManaged var time: NSDate?

}
