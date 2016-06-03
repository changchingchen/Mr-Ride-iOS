//
//  DataRecorder.swift
//  Mr-Ride-iOS
//
//  Created by Chang-Ching CHEN on 6/1/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import Foundation
import CoreData
import UIKit



struct LocationRecord {
    var latitude = 0.0
    var longitude = 0.0
    var timestamp = NSDate()
}

struct Record {
    var calories = 0.0
    var distance = 0.0
    var date = NSDate()
    var duration = 0.0
    var paths = [[LocationRecord]]()
}



// Data Recorder is a singleton
class DataRecorder {
    static let sharedManager = DataRecorder()
    private init() { }
    private let dataRecorderMOC = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
}


// MARK: - Core Data
extension DataRecorder {
    
    func createRecord(record: Record) {
        
        let newRecord = NSEntityDescription.insertNewObjectForEntityForName("RideRecord", inManagedObjectContext: self.dataRecorderMOC)
        
        newRecord.setValue(record.calories, forKey: "calories")
        newRecord.setValue(record.distance, forKey: "distance")
        newRecord.setValue(record.duration, forKey: "duration")
        newRecord.setValue(record.date,forKey: "date")
       
        do {
            try newRecord.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        
        let newRecordID = String(newRecord.objectID.URIRepresentation()) // The Object ID will be changed after saved
        
        for (index, path) in record.paths.enumerate() {
            for location in path {
                let newLocation = NSEntityDescription.insertNewObjectForEntityForName("PathLocation", inManagedObjectContext: self.dataRecorderMOC)
                newLocation.setValue(index, forKey: "pathNumber")
                newLocation.setValue(location.timestamp, forKey: "createdTimestamp")
                newLocation.setValue(location.latitude, forKey: "latitude")
                newLocation.setValue(location.longitude, forKey: "longitude")
                newLocation.setValue(newRecordID, forKey: "belongsToRideRecordObjectID")
                newRecord.mutableSetValueForKey("locations").addObject(newLocation)
            }
        }
        
        do {
            try newRecord.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    
        

    }
    
    
    func readRecord(date: NSDate) -> Record? {
    
        let rideRecordFetchRequest = NSFetchRequest(entityName: "RideRecord")
        rideRecordFetchRequest.predicate = NSPredicate(format: "date == %@", date)
        
        do {

            
            let results = try dataRecorderMOC.executeFetchRequest(rideRecordFetchRequest)
            print(results.count)
            
            if !results.isEmpty {
                let result = results[0] as! NSManagedObject
                
                var record = Record()
                
                guard let calories = result.valueForKey("calories") as? Double,
                    let distance = result.valueForKey("distance") as? Double,
                    let duration = result.valueForKey("duration") as? Double
                else {return nil}
            
                record.calories = calories
                record.distance = distance
                record.duration = duration
                record.date = date
                
                let objectID = String(result.objectID.URIRepresentation())
                
                record.paths = fetchPathLocation(objectID)

                return record
                
            } else {
                return nil
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return nil

    }
    
    func fetchPathLocation(objectID: String) -> [[LocationRecord]] {
        var paths = [[LocationRecord]]()
        
        let pathLocationFetchRequest = NSFetchRequest(entityName: "PathLocation")
        pathLocationFetchRequest.predicate = NSPredicate(format: "belongsToRideRecordObjectID == %@", objectID)
        
        let sortDescriptor1 = NSSortDescriptor(key: "pathNumber", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "createdTimestamp", ascending: true)
        
        pathLocationFetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        do {
            let results = try self.dataRecorderMOC.executeFetchRequest(pathLocationFetchRequest)
            
            if !results.isEmpty {
                for result in results {
                    guard let path = result as? NSManagedObject else {
                        
                        print("returned")
                        return paths
                    }
                    
                    if let pathNumber = path.valueForKey("pathNumber") as? Int,
                        let createdTimestamp = path.valueForKey("createdTimestamp") as? NSDate,
                        let latitude = path.valueForKey("latitude") as? Double,
                        let longitude = path.valueForKey("longitude") as? Double {

                        
                        if paths.count < (pathNumber + 1) {
                            paths.append([LocationRecord(latitude: latitude, longitude: longitude, timestamp: createdTimestamp)])
                        } else {
                            paths[pathNumber].append(LocationRecord(latitude: latitude, longitude: longitude, timestamp: createdTimestamp))
                        }
                        
                    }
                    
                }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
        return paths
    }
    
    func updateRecord() {
        
    }
    
    
    func deleteData() {
    
    }
    
}
