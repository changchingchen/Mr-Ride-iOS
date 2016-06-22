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

struct LocationInfo {
    var name: String
    var id: Int
    var latitude: Double
    var longitude: Double
}

class LocationInfoDataManager {
    static let sharedInstance = LocationInfoDataManager()
    private init() { }
    
    private let locationInfoDataMOC = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//    private let dataTaipeiToiletURLSource = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid="
//    private let dataTaipeiToiletURLSource = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=fe49c753-9358-49dd-8235-1fcadf5bfd3f"

//    private let dataTaipeiToiletURLSource = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=008ed7cf-2340-4bc4-89b0-e258a5573be2"
    
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
    
    var locationInfos = [LocationInfo]()
    
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
//                print(toilet)
//                print(toilet["緯度"])
//                if let latitude = toilet["緯度"] { print(latitude)}
                if let latitudeString = toilet["緯度"] as? String,
                    let longitudeString = toilet["經度"] as? String,
                    let idString = toilet["_id"] as? String {
                    
                    if let id = Int(idString), latitude = Double(latitudeString), longitude = Double(longitudeString) {
                        let locationInfo = LocationInfo(name: LocationType.PublicToilet.rawValue,
                                                        id: id,
                                                        latitude: latitude,
                                                        longitude: longitude)
                        createLocationInfoData(locationInfo)
                    }
                    
                }
            }
        case .RiverSideToiletsURL:
//            for toilet in toilets {
////                print(toilet)
//                if let latitude = toilet["Latitude"] as? Double, let longitude = toilet["Longitude"], let id = toilet["_id"] {
//                    print(latitude)
//                    print(longitude)
//                    print(id)
//                }
//            }
            break
        case .YouBikeStationsURL:
            break
        }
        

    
    }
    
    private func createLocationInfoData(locationInfo: LocationInfo) {
//        if let newLocationInfo = NSEntityDescription.insertNewObjectForEntityForName(LocatioinInfo, inManagedObjectContext: self.locationInfoDataMOC) as? LocationInfo {
//            
//        }
    }
    
}