//
//  ToiletInfo+CoreDataProperties.swift
//  Mr-Ride-iOS
//
//  Created by Chang-Ching CHEN on 6/29/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ToiletInfo {

    @NSManaged var id: NSNumber?
    @NSManaged var district: String?
    @NSManaged var placeType: String?
    @NSManaged var numberOfToilets: NSNumber?
    @NSManaged var placeName: String?
    @NSManaged var address: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var toiletSource: String?

}
