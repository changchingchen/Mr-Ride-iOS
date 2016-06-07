//
//  PathLocation+CoreDataProperties.swift
//  Mr-Ride-iOS
//
//  Created by Chang-Ching CHEN on 6/6/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PathLocation {

    @NSManaged var createdTimestamp: NSDate?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var pathNumber: NSNumber?
    @NSManaged var belongsToRideRecordObjectID: String?
    @NSManaged var record: RideRecord?

}
