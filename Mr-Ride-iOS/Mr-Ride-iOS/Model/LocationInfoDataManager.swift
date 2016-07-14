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

struct YBStation {
    var addressCn: String
    var addressEn: String
    var emptySpace: Int
    var latitude: Double
    var longitude: Double
    var districtCn: String
    var districtEn: String
    var availableBikes: Int
    var placeNameCn: String
    var placeNameEn: String
    var id: Int
}

struct Toilet {
    var id: Int
    var district: String
    var placeType: String
    var numberOfToilets: Int
    var placeName: String
    var address: String
    var latitude: Double
    var longitude: Double
    var toiletSource: String
}

class LocationInfoDataManager {
    static let sharedInstance = LocationInfoDataManager()
    private init() { }
    
    
    struct EntityID {
        static let LocationInfoEntityID = "LocationInfo"
        static let YBStationInfoEntityID = "YBStationInfo"
        static let ToiletInfoEntityID = "ToiletInfo"
    }
    
    enum LocationInfoKeys: String {
        case Name = "name"
        case ID = "id"
        case Latitude = "latitude"
        case Longitude = "longitude"
    }
    
    struct ToiletInfoKeys {
        static let ID = "id"
        static let District = "district"
        static let PlaceType = "placeType"
        static let NumberOfToilets = "numberOfToilets"
        static let PlaceName = "placeName"
        static let Address = "address"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let ToiletSource = "toiletSource"
    }
//    enum ToiletInfoKeys: String {
//        case ID = "id"
//        case District = "district"
//        case PlaceType = "placeType"
//        case NumberOfToilets = "numberOfToilets"
//        case PlaceName = "placeName"
//        case Address = "address"
//        case Latitude = "latitude"
//        case Longitude = "longitude"
//        case ToiletSource = "toiletSource"
//    }
    
    private let locationInfoDataMOC = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    enum DataSourceURL: String {
        case PublicToiletsURL = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=008ed7cf-2340-4bc4-89b0-e258a5573be2"
        case RiverSideToiletsURL = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=fe49c753-9358-49dd-8235-1fcadf5bfd3f"
        case YouBikeStationsURL = "http://data.taipei/youbike"
    }
    
    enum ToiletType: String {
        case PublicToilet
        case RiverSideToilet
    }
    
    var locationInfos = [LocationInformation]()
    
//    private let prefetchedList = [DataSourceURL.PublicToiletsURL, .RiverSideToiletsURL, .YouBikeStationsURL]
    private let prefetchedList = [DataSourceURL.YouBikeStationsURL, .PublicToiletsURL]
    
    func getLocationInfoFromDataTaipei(completion: ()->Void) {
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
        
        switch dataSourceURL {
        case .PublicToiletsURL:
            guard let toilets = jsonObjects["result"]?["results"] as? [[String:AnyObject]] else {
                return
            }

            for toilet in toilets {
                if let idString = toilet["_id"] as? String,
                    let district = toilet["行政區"] as? String,
                    let placeType = toilet["類別"] as? String,
                    let numberOfToiletsString = toilet["座數"] as? String,
                    let placeName = toilet["單位名稱"] as? String,
                    let address = toilet["地址"] as? String,
                    let latitudeString = toilet["緯度"] as? String,
                    let longitudeString = toilet["經度"] as? String
                     {
                    
                    if let id = Int(idString), numberOfToilets = Int(numberOfToiletsString), latitude = Double(latitudeString), longitude = Double(longitudeString) {

                        let toiletInfo = Toilet(id: id, district: district, placeType: placeType, numberOfToilets: numberOfToilets, placeName: placeName, address: address, latitude: latitude, longitude: longitude, toiletSource: ToiletType.PublicToilet.rawValue)
                        
                        updateToiletData(toiletInfo)

                    }
                    
                }
            }
        case .RiverSideToiletsURL:
            guard let toilets = jsonObjects["result"]?["results"] as? [[String:AnyObject]] else {
                return
            }

            for toilet in toilets {
                
                if let latitudeString = toilet["latitude"] as? String,
                    let longitudeString = toilet["longitude"] as? String,
                    let idString = toilet["_id"] as? String {
                    
                    if let id = Int(idString), latitude = Double(latitudeString), longitude = Double(longitudeString) {
                        
                        let locationInfo = LocationInformation(name: ToiletType.RiverSideToilet.rawValue,
                                                               id: id,
                                                               latitude: latitude,
                                                               longitude: longitude)
                        updateLocationInfoData(locationInfo)
                    }
                    
                }
            }
        case .YouBikeStationsURL:
            guard let ybStationsJSON = jsonObjects["retVal"] as? [String:AnyObject] else {
                return
            }
            
            for (_, value) in ybStationsJSON {
                
                guard let ybStation = value as? [String:AnyObject] else {
                    print("Returned")
                    return
                }
                
                if let addressCn = ybStation["ar"] as? String,
                    let addressEn = ybStation["aren"] as? String,
                    let emptySpace = ybStation["bemp"] as? String,
                    let latitude = ybStation["lat"] as? String,
                    let longitude = ybStation["lng"] as? String,
                    let districtCn = ybStation["sarea"] as? String,
                    let districtEn = ybStation["sareaen"] as? String,
                    let availableBikes = ybStation["sbi"] as? String,
                    let placeNameCn = ybStation["sna"] as? String,
                    let placeNameEn = ybStation["snaen"] as? String,
                    let id = ybStation["sno"] as? String {
                    
                    let newYBStation = YBStation(addressCn: addressCn, addressEn: addressEn, emptySpace: Int(emptySpace)!, latitude: Double(latitude)!, longitude: Double(longitude)!, districtCn: districtCn, districtEn: districtEn, availableBikes: Int(availableBikes)!, placeNameCn: placeNameCn, placeNameEn: placeNameEn, id: Int(id)!)
                    
                    updateYBStationData(newYBStation)
                    
                }
            }
    
        }
        

    
    }
    
    
    private func updateToiletData(newToilet: Toilet) {
        let fetchReqeust = NSFetchRequest(entityName: EntityID.ToiletInfoEntityID)
        fetchReqeust.predicate = NSPredicate(format: "toiletSource = %@ and id = %i", newToilet.toiletSource, newToilet.id)
        
        do {
            let results = try self.locationInfoDataMOC.executeFetchRequest(fetchReqeust)
            if results.isEmpty {
                
                let parameters: [String:AnyObject] = [
                    ToiletInfoKeys.ID: newToilet.id,
                    ToiletInfoKeys.District: newToilet.district,
                    ToiletInfoKeys.PlaceType: newToilet.placeType,
                    ToiletInfoKeys.NumberOfToilets: newToilet.numberOfToilets,
                    ToiletInfoKeys.PlaceName: newToilet.placeName,
                    ToiletInfoKeys.Address: newToilet.address,
                    ToiletInfoKeys.Latitude: newToilet.latitude,
                    ToiletInfoKeys.Longitude: newToilet.longitude,
                    ToiletInfoKeys.ToiletSource: newToilet.toiletSource
                ]
                
                createEntityWithName(EntityID.ToiletInfoEntityID, parameters: parameters)
//                createToiletData(newToilet)
            } else {
//                if let oldToilet = results.first as? ToiletInfo {
//                    
//                    do {
//                        try oldToilet.managedObjectContext?.save()
//                    } catch let error {
//                        print(error)
//                    }
//                }
            }
        } catch let error {
            print(error)
        }

    }
    
//    private func createToiletData() {
//        
//    }
    
    func readToiletData(completion: ([Toilet])->Void) {
        
        var toiletInfos = [Toilet]()
        let fetchRequest = NSFetchRequest(entityName: EntityID.ToiletInfoEntityID)
        //        fetchRequest.predicate = NSPredicate(format: "%K < %i", LocationInfoKeys.Latitude.rawValue, )
        
        do {
            let results = try locationInfoDataMOC.executeFetchRequest(fetchRequest)
            if !results.isEmpty {
                for result in results {
                    if let toilet = result as? ToiletInfo {
                        if let id = toilet.id?.intValue,
                            let district = toilet.district,
                            let placeType = toilet.placeType,
                            let numberOfToilets = toilet.numberOfToilets?.intValue,
                            let placeName = toilet.placeName,
                            let address = toilet.address,
                            let latitude = toilet.latitude?.doubleValue,
                            let longitude = toilet.longitude?.doubleValue,
                            let toiletSource = toilet.toiletSource {
                            
                            let toiletInfo = Toilet(id: Int(id), district: district, placeType: placeType, numberOfToilets: Int(numberOfToilets), placeName: placeName, address: address, latitude: Double(latitude), longitude: Double(longitude), toiletSource: toiletSource)
                            toiletInfos.append(toiletInfo)
                        }
                    }
                }
                
                
                completion(toiletInfos)
                
                //                return locationInfos
            }
            
        } catch let error {
            print(error)
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
        
    }
    
    private func updateLocationInfoData(locationInfo: LocationInformation) {
        let fetchRequest = NSFetchRequest(entityName: EntityID.LocationInfoEntityID)

        fetchRequest.predicate = NSPredicate(format: "name = %@ and id = %i", locationInfo.name, locationInfo.id)
        do {
            let results = try locationInfoDataMOC.executeFetchRequest(fetchRequest)
            
            if !results.isEmpty {
//                print("Data Exist")
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
//                print("Data Not Exist")
                createLocationInfoData(locationInfo)
            }
        } catch let error {
            print(error)
        }
    }
    
    func readLocationInfoDataFromCoordinate(latitude currentLatitude: Double, currentLongitude: Double, completion: ([LocationInformation])->Void){
        
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
                
                
                completion(locationInfos)
                
//                return locationInfos
            }
            
        } catch let error {
            print(error)
        }
        
        
//        return nil
    }
    
    
    private func updateYBStationData(newYBStation: YBStation) {
        
        let ybStationFetchReqeust = NSFetchRequest(entityName: EntityID.YBStationInfoEntityID)
        ybStationFetchReqeust.predicate = NSPredicate(format: "id = %i", newYBStation.id)
        
        do {
            let results = try self.locationInfoDataMOC.executeFetchRequest(ybStationFetchReqeust)
            if results.isEmpty {
                createYBStationData(newYBStation)
            } else {
                if let oldYBStation = results.first as? YBStationInfo {
                    oldYBStation.emptySpace = newYBStation.emptySpace
                    oldYBStation.availableBikes = newYBStation.availableBikes
                    
                    do {
                        try oldYBStation.managedObjectContext?.save()
                    } catch let error {
                        print(error)
                    }
                }
            }
        } catch let error {
            print(error)
        }
        
        
    }
    
    
    private func createEntityWithName(entityName: String, parameters: [String:AnyObject]? = nil) {
        
        if let parameters = parameters {
            let newEntity = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: self.locationInfoDataMOC)
            for (key, value) in parameters {
                newEntity.setValue(value, forKey: key)
            }
            
            do {
                try newEntity.managedObjectContext?.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    private func createYBStationData(ybStation: YBStation) {
        if let newYBStationInfo = NSEntityDescription.insertNewObjectForEntityForName(EntityID.YBStationInfoEntityID, inManagedObjectContext: self.locationInfoDataMOC) as? YBStationInfo {
            newYBStationInfo.addressCn = ybStation.addressCn
            newYBStationInfo.addressEn = ybStation.addressEn
            newYBStationInfo.availableBikes = ybStation.availableBikes
            newYBStationInfo.districtCn = ybStation.districtCn
            newYBStationInfo.districtEn = ybStation.districtEn
            newYBStationInfo.emptySpace = ybStation.emptySpace
            newYBStationInfo.id = ybStation.id
            newYBStationInfo.latitude = ybStation.latitude
            newYBStationInfo.longitude = ybStation.longitude
            newYBStationInfo.placeNameCn = ybStation.placeNameCn
            newYBStationInfo.placeNameEn = ybStation.placeNameEn
            
            do {
                try newYBStationInfo.managedObjectContext?.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func readYBStationData(completion: ([YBStation])->Void) {
        
        var ybStationInfos = [YBStation]()
        let fetchRequest = NSFetchRequest(entityName: EntityID.YBStationInfoEntityID)
        //        fetchRequest.predicate = NSPredicate(format: "%K < %i", LocationInfoKeys.Latitude.rawValue, )
        
        do {
            let results = try locationInfoDataMOC.executeFetchRequest(fetchRequest)
            if !results.isEmpty {
                for result in results {
                    if let ybStation = result as? YBStationInfo {
                        if let addressCn = ybStation.addressCn,
                            let addressEn = ybStation.addressEn,
                            let emptySpace = ybStation.emptySpace?.intValue,
                            let latitude = ybStation.latitude?.doubleValue,
                            let longitude = ybStation.longitude?.doubleValue,
                            let districtCn = ybStation.districtCn,
                            let districtEn = ybStation.districtEn,
                            let availableBikes = ybStation.availableBikes?.intValue,
                            let placeNameCn = ybStation.placeNameCn,
                            let placeNameEn = ybStation.placeNameEn,
                            let id = ybStation.id?.intValue {
                            
                            let ybStationInfo = YBStation(addressCn: addressCn, addressEn: addressEn, emptySpace: Int(emptySpace), latitude: latitude, longitude: longitude, districtCn: districtCn, districtEn: districtEn, availableBikes: Int(availableBikes), placeNameCn: placeNameCn, placeNameEn: placeNameEn, id: Int(id))
                            ybStationInfos.append(ybStationInfo)
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    completion(ybStationInfos)
                }
                
                //                return locationInfos
            }
            
        } catch let error {
            print(error)
        }
    }
}