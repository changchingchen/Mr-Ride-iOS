//
//  LocationInfoDataManager.swift
//  Mr-Ride-iOS
//
//  Created by Chang-Ching CHEN on 6/21/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

struct LocationInformation {
    var name: String
    var id: Int
    var latitude: Double
    var longitude: Double
}

/*
enum LocationType: String {
    case PublicToilet
    case RiverSideToilet
    case YouBikeStation
}

struct DataSourceURL {
    
    static let DataTaipei: [LocationType:String] = [
        .PublicToilet : "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=008ed7cf-2340-4bc4-89b0-e258a5573be2",
        .RiverSideToilet : "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=fe49c753-9358-49dd-8235-1fcadf5bfd3f",
        .YouBikeStation: ""
    ]
    
    static func DataTaipeiSource(:LocationType) -> NSURL? {
        if let urlString = DataTaipei[] {
            return NSURL(string: urlString)
        } else {
            return nil
        }
    }
}
*/


class LocationInfoDataManager {
    static let sharedInstance = LocationInfoDataManager()
    private init() { }
    
    
    struct EntityID {
        static let LocationInfoEntityID = "LocationInfo"
    }
    
    enum LocationInfoKeys: String {
        case Name = "name"
        case ID = "id"
        case Latitude = "latitude"
        case Longitude = "longitude"
    }
    
    private let locationInfoDataMOC = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    enum DataSourceURL: String {
        case PublicToiletsURL = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=008ed7cf-2340-4bc4-89b0-e258a5573be2"
        case RiverSideToiletsURL = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=fe49c753-9358-49dd-8235-1fcadf5bfd3f"
        case YouBikeStationsURL = ""
    }
    
    enum LocationType: String {
        case PublicToilet
        case RiverSideToilet
        case YouBikeStation
    }
    
    var locationInfos = [LocationInformation]()
    
//    private let prefetchedList = [DataSourceURL.PublicToiletsURL, .RiverSideToiletsURL, .YouBikeStationsURL]
    private let prefetchedList = [DataSourceURL.PublicToiletsURL]
    
    func getToiletInfoFromDataTaipei(completion: ()->Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            for url in self.prefetchedList {
                Alamofire.request(.GET, url.rawValue)
                        .validate()
                        .responseJSON { response in
                            switch response.result {
                            case .Success(let result):
                                print("Validation Successful")
                                self.parseJSONObject(result, dataSourceURL: url)
                            case .Failure(let error):
                                print(error)
                            }
                            
                            
                }
            }
        }
        
    }
    
    private func parseJSONObject(jsonObject: AnyObject, dataSourceURL: DataSourceURL) {
        guard let jsonObjects = jsonObject as? [String:AnyObject] else {
            return
        }
        
        guard let toilets = jsonObjects["result"]?["results"] as? [[String:AnyObject]] else {
            return
        }
        
        switch dataSourceURL {
        case .PublicToiletsURL:
            for toilet in toilets {
                if let latitudeString = toilet["緯度"] as? String,
                    let longitudeString = toilet["經度"] as? String,
                    let idString = toilet["_id"] as? String {
                    
                    if let id = Int(idString), latitude = Double(latitudeString), longitude = Double(longitudeString) {

                        let locationInfo = LocationInformation(name: LocationType.PublicToilet.rawValue,
                                                              id: id,
                                                              latitude: latitude,
                                                              longitude: longitude)
                        updateLocationInfoData(locationInfo)
                    }
                    
                }
            }
        case .RiverSideToiletsURL:
            for toilet in toilets {
                
                if let latitudeString = toilet["latitude"] as? String,
                    let longitudeString = toilet["longitude"] as? String,
                    let idString = toilet["_id"] as? String {
                    
                    if let id = Int(idString), latitude = Double(latitudeString), longitude = Double(longitudeString) {
                        
                        let locationInfo = LocationInformation(name: LocationType.RiverSideToilet.rawValue,
                                                               id: id,
                                                               latitude: latitude,
                                                               longitude: longitude)
                        updateLocationInfoData(locationInfo)
                    }
                    
                }
            }
            break
        case .YouBikeStationsURL:
            break
        }
        

    
    }
    
    private func createLocationInfoData(locationInfo: LocationInformation) {
        if let newLocationInfo = NSEntityDescription.insertNewObjectForEntityForName(EntityID.LocationInfoEntityID, inManagedObjectContext: self.locationInfoDataMOC) as? LocationInfo {
            newLocationInfo.name = locationInfo.name
            newLocationInfo.id = locationInfo.id
            newLocationInfo.latitude = locationInfo.latitude
            newLocationInfo.longitude = locationInfo.longitude
            
            do {
                try newLocationInfo.managedObjectContext?.save()
            } catch let error {
                print(error)
            }
        }
        
//        let fetchRequest = NSFetchRequest(entityName: EntityID.LocationInfoEntityID)
//        do {
//            let results = try locationInfoDataMOC.executeFetchRequest(fetchRequest)
//            if !results.isEmpty {
//                for result in results  {
//                    if let locationInformation = result as? LocationInfo {
//                        print(locationInformation.name)
//                        print(locationInformation.id)
//                        print(locationInformation.latitude)
//                        print(locationInformation.longitude)
//                    }
//                }
//            }
//        } catch let error {
//            print(error)
//        }
        
        
    }
    
    private func updateLocationInfoData(locationInfo: LocationInformation) {
        let fetchRequest = NSFetchRequest(entityName: EntityID.LocationInfoEntityID)

        fetchRequest.predicate = NSPredicate(format: "name == %@ and id == %i", locationInfo.name, locationInfo.id)
        do {
            let results = try locationInfoDataMOC.executeFetchRequest(fetchRequest)
            
            if !results.isEmpty {
                print("Data Exist")
                if let oldLocationInfo = results.last as? LocationInfo where oldLocationInfo.latitude != locationInfo.latitude || oldLocationInfo.longitude != locationInfo.longitude {
                    oldLocationInfo.latitude = locationInfo.latitude
                    oldLocationInfo.longitude = locationInfo.longitude
                    print("Data updated")
                    do {
                        try oldLocationInfo.managedObjectContext?.save()
                    } catch let error {
                        print(error)
                    }
                }
            } else {
                print("Data Not Exist")
                createLocationInfoData(locationInfo)
            }
        } catch let error {
            print(error)
        }
    }
    
    private func readLocationInfoDataFromCoordinate(latitude currentLatitude: Double, currentLongitude: Double) -> [LocationInformation]? {
        
        let fetchRequest = NSFetchRequest(entityName: EntityID.LocationInfoEntityID)
//        fetchRequest.predicate = NSPredicate(format: "%K < %i", LocationInfoKeys.Latitude.rawValue, )
    
        
        do {
            let results = try locationInfoDataMOC.executeFetchRequest(fetchRequest)
            if !results.isEmpty {
                for result in results {
                    if let locationInfo = result as? LocationInfo {
                        if let name = locationInfo.name, let id = locationInfo.id?.intValue, let latitude = locationInfo.latitude?.doubleValue, let longitude = locationInfo.longitude?.doubleValue {
                            let locationInfoTemp = LocationInformation(name: name,
                                                                   id: Int(id),
                                                                   latitude: latitude,
                                                                   longitude: longitude)
                            locationInfos.append(locationInfoTemp)
                        }
                    }
                }
            }
            
        } catch let error {
            print(error)
        }
        
        
        return nil
    }
    
}