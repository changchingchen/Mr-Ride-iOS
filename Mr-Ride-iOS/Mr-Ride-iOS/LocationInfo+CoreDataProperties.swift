//
//  LocationInfo+CoreDataProperties.swift
//  Mr-Ride-iOS
//
//  Created by Chang-Ching CHEN on 6/22/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension LocationInfo {

    @NSManaged var name: String?
    @NSManaged var id: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?

}
