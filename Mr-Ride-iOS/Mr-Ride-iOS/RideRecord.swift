//
//  RideRecord.swift
//  Mr-Ride-iOS
//
//  Created by Chang-Ching CHEN on 6/6/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import Foundation
import CoreData


class RideRecord: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    var headerForSection: String {
        if let date = self.date {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM, yyyy"
            return dateFormatter.stringFromDate(date)
        } else {
            return "NA"
        }
    }

}
