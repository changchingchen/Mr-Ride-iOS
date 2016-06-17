//
//  UserInfo+CoreDataProperties.swift
//  Mr-Ride-iOS
//
//  Created by Chang-Ching CHEN on 6/17/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserInfo {

    @NSManaged var height: NSNumber?
    @NSManaged var weight: NSNumber?
    @NSManaged var totalDistance: NSNumber?
    @NSManaged var totalRidingTimes: NSNumber?
    @NSManaged var userEmail: String?
    @NSManaged var totalDuration: NSNumber?

}
