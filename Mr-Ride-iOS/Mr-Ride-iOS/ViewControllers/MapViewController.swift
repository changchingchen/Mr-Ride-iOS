//
//  MapViewController.swift
//  Mr-Ride-iOS
//
//  Created by admin on 5/31/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    struct Constant {
        static let identifier = "MapViewController"
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    var paths = [[CLLocation]]()
    var path = [CLLocation]()
    var isTimerRunning = false
    var distance = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("MapViewController destroyed!!")
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        path = []
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        paths.append(path)
    }

    func drawRoutes() {

        var allPolylines = MKPolyline()
        var allCoordinates = [CLLocationCoordinate2D]()
        
        mapView.showsUserLocation = false
        
        for path in paths {
            var coordinates = path.map{$0.coordinate}
            allCoordinates += coordinates
            let polyline = MKPolyline(coordinates: &coordinates , count: coordinates.count)
            mapView.addOverlay(polyline)
        }
        
        allPolylines = MKPolyline(coordinates: &allCoordinates, count: allCoordinates.count)
        mapView.setVisibleMapRect(allPolylines.boundingMapRect, edgePadding: UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0), animated: true)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController {
    class func controller() -> MapViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(Constant.identifier) as! MapViewController
    }
}


extension MapViewController: CLLocationManagerDelegate {
//    
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .AuthorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//        }
//    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegionMakeWithDistance(center, 500, 500)
            self.mapView.setRegion(region, animated: true)
            path.append(location)
            
            if previousLocation != nil {
                distance += location.distanceFromLocation(previousLocation!)
                print("Distance: \(distance)")
            }
            previousLocation = location
            print(location)
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: \(error.localizedDescription)")
    }
}

extension MapViewController: MKMapViewDelegate {
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.mrBubblegumColor()
        renderer.lineWidth = 10.0
        return renderer
    }
    
    
}