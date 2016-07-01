//
//  YBStationInfo+CoreDataProperties.swift
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

extension YBStationInfo {

    @NSManaged var addressCn: String?
    @NSManaged var addressEn: String?
    @NSManaged var emptySpace: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var districtCn: String?
    @NSManaged var districtEn: String?
    @NSManaged var availableBikes: NSNumber?
    @NSManaged var placeNameCn: String?
    @NSManaged var placeNameEn: String?
    @NSManaged var id: NSNumber?

}
