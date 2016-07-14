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

struct OverallResult {
    var totalDistance = 0.0
    var totalDuration = 0.0
    var totalRidingTimes = 0
    var weight = 0.0
}


// Data Recorder is a singleton
class DataRecorder {
    static let sharedManager = DataRecorder()
    private init() { }
    private let dataRecorderMOC = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    struct Constant {
        static let RideRecordEntityID = "RideRecord"
        static let PathLocationEntityID = "PathLocation"
    }
    
    enum RideRecordKeys: String {
        case Calories = "calories"
        case Date = "date"
        case Distance = "distance"
        case Duration = "duration"
        case Paths = "paths"
    }
    
    var records = [Record]()
    var distances = [Double]()
    
}


// MARK: - Core Data
extension DataRecorder {
    
    // This function is for temporary used
    func createUserInfo() {
        
        let userEmail = "snakeking0103@gmail.com"
        
        let userInfoFetchRequest = NSFetchRequest(entityName: "UserInfo")
        userInfoFetchRequest.predicate = NSPredicate(format: "userEmail = %@", userEmail)
        
        do {
            let results = try self.dataRecorderMOC.executeFetchRequest(userInfoFetchRequest)
            
            if results.isEmpty {
                print("Entered")
                if let newUserInfo = NSEntityDescription.insertNewObjectForEntityForName("UserInfo", inManagedObjectContext: self.dataRecorderMOC) as? UserInfo {
                    newUserInfo.height = 175.0
                    newUserInfo.weight = 65.0
                    newUserInfo.totalDistance = 0.0
                    newUserInfo.totalRidingTimes = 0
                    newUserInfo.totalDuration = 0.0
                    newUserInfo.userEmail = "snakeking0103@gmail.com"
                    
                    do {
                        try newUserInfo.managedObjectContext?.save()
                    } catch let error {
                        print(error)
                    }
                    
                }
                
            }
        } catch let error {
            print(error)
        }
        
        
       
        
    }
    
    func updateUserInfo(distance: Double, duration: Double) {
        let userEmail = "snakeking0103@gmail.com"
        
        let userInfoFetchRequest = NSFetchRequest(entityName: "UserInfo")
        userInfoFetchRequest.predicate = NSPredicate(format: "userEmail = %@", userEmail)
        
        do {
            let results = try self.dataRecorderMOC.executeFetchRequest(userInfoFetchRequest)
            
            if !results.isEmpty {
                
                
                guard let userInfo = results.first as? UserInfo else {
                    print("Fail to get data in updateUserInfo")
                    return
                }
                
                guard let currentDistance = userInfo.totalDistance as? Double,
                    let currentDuration = userInfo.totalDistance as? Double,
                    let currentRidingTimes = userInfo.totalRidingTimes as? Int
                    else {
                        return
                }
                userInfo.totalDistance = currentDistance + distance
                userInfo.totalRidingTimes = currentRidingTimes + 1
                userInfo.totalDuration = currentDuration + duration
                
                do {
                    try userInfo.managedObjectContext?.save()
                } catch let error {
                    print(error)
                }
                
            } 
        } catch let error {
            print(error)
        }
    }
    
    func readUserInfo() -> OverallResult? {
        let userEmail = "snakeking0103@gmail.com"
        
        let userInfoFetchRequest = NSFetchRequest(entityName: "UserInfo")
        userInfoFetchRequest.predicate = NSPredicate(format: "userEmail == %@", userEmail)
        
        do {
            let results = try self.dataRecorderMOC.executeFetchRequest(userInfoFetchRequest)
            
            if !results.isEmpty {
                
                
                guard let userInfo = results.first as? UserInfo else {
                    print("Fail to get data in updateUserInfo")
                    return nil
                }
        
                var overallResult = OverallResult()
                
                overallResult.totalDistance = userInfo.totalDistance!.doubleValue
                overallResult.totalDuration = userInfo.totalDuration!.doubleValue
                overallResult.weight = userInfo.weight!.doubleValue
                if let totalRidingTimes = userInfo.totalRidingTimes as? Int {
                    overallResult.totalRidingTimes = totalRidingTimes
                }
                
                return overallResult
                
            }
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    func createRecord(record: Record) {
        
        let newRecord = NSEntityDescription.insertNewObjectForEntityForName("RideRecord", inManagedObjectContext: self.dataRecorderMOC)
        
        newRecord.setValue(record.calories, forKey: "calories")
        newRecord.setValue(record.distance, forKey: "distance")
        newRecord.setValue(record.duration, forKey: "duration")
        newRecord.setValue(record.date,forKey: "date")
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate:record.date)
        let dateForSections = components.year * 100 + components.month
        
//        let dateForSections = components.hour * 10000 + components.minute * 100 + components.second
        newRecord.setValue(dateForSections, forKey: "dateForSections")
        
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
    
    func createRecord2(record: Record) {
        
        if let newRecord = NSEntityDescription.insertNewObjectForEntityForName("RideRecord", inManagedObjectContext: self.dataRecorderMOC) as? RideRecord {
        
            newRecord.calories = record.calories
            newRecord.distance = record.distance
            newRecord.duration = record.duration
            newRecord.date = record.date
            
            do {
                try newRecord.managedObjectContext?.save()
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
            
            let newRecordID = String(newRecord.objectID.URIRepresentation()) // The Object ID will be changed after saved
            
            for (index, path) in record.paths.enumerate() {
                for location in path {
                    if let newLocation = NSEntityDescription.insertNewObjectForEntityForName("PathLocation", inManagedObjectContext: self.dataRecorderMOC) as? PathLocation {
                        newLocation.pathNumber = index
                        newLocation.createdTimestamp = location.timestamp
                        newLocation.latitude = location.latitude
                        newLocation.longitude = location.longitude
                        newLocation.belongsToRideRecordObjectID = newRecordID
                        newRecord.mutableSetValueForKey("locations").addObject(newLocation)
                    }
                }
            }
            
            do {
                try newRecord.managedObjectContext?.save()
            } catch let error {
                print("CoreData Error: \(error)")
            }
        }
        
        
    }
    
    
    func readRecord(date: NSDate) -> Record? {
    
        let rideRecordFetchRequest = NSFetchRequest(entityName: "RideRecord")
        rideRecordFetchRequest.predicate = NSPredicate(format: "date == %@", date)
        
        do {

            
            let results = try dataRecorderMOC.executeFetchRequest(rideRecordFetchRequest)
            
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
    
    func readAllRecords() {
        records.removeAll()
        
        let rideRecordFetchReqeust = NSFetchRequest(entityName: Constant.RideRecordEntityID)
//        rideRecordFetchReqeust.predicate = NSPredicate(format: "date ", date)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        rideRecordFetchReqeust.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try self.dataRecorderMOC.executeFetchRequest(rideRecordFetchReqeust)
            
            for result in results {
                let rideRecord = result as! NSManagedObject
                var record = Record()
                if let date = rideRecord.valueForKey(RideRecordKeys.Date.rawValue) as? NSDate,
                    let distatnce = rideRecord.valueForKey(RideRecordKeys.Distance.rawValue) as? Double,
                    let duration = rideRecord.valueForKey(RideRecordKeys.Duration.rawValue) as? Double {
                    record.date = date
                    record.distance = distatnce
                    record.duration = duration
                    records.append(record)
                }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
    }
    
    func fetchLastestNumberOfDistanceDataWithNumber(number: Int) {
        
        distances.removeAll()
        
        let rideRecordFetchRequest = NSFetchRequest(entityName: Constant.RideRecordEntityID)
        let rideRecordSortDesciptor = NSSortDescriptor(key: "date", ascending: false)
        rideRecordFetchRequest.sortDescriptors = [rideRecordSortDesciptor]
        rideRecordFetchRequest.fetchLimit = number
        
        do {
            let results = try self.dataRecorderMOC.executeFetchRequest(rideRecordFetchRequest)
            for result in results {
                if let rideRecord = result as? RideRecord {
                    if let distance = rideRecord.distance as? Double {
                        distances.append(distance)
                    }
                }
            }
            
        } catch let error {
            print(error)
        }
        
    }
    
}
