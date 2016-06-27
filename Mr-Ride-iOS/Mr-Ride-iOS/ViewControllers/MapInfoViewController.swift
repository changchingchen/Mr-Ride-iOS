//
//  MapInfoViewController.swift
//  Mr-Ride-iOS
//
//  Created by Chang-Ching CHEN on 6/16/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit
import MapKit

class MapInfoViewController: UIViewController {

    struct Storyboard {
        static let Identifier = "MapInfoViewController"
    }

    var parentVC: LandingContainerViewController {
        return self.navigationController?.parentViewController as! LandingContainerViewController
    }
    
    var isShowingLeftSideMenu: Bool {
        return parentVC.isShowingSideMenu
    }
    
    @IBOutlet weak var bottomContainerView: UIView! {
        didSet {
            bottomContainerView.layer.cornerRadius = 4.0
        }
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.showsUserLocation = true
            mapView.delegate = self
        }
    }
    
    let locationManager = CLLocationManager()
    var locationInfos: [LocationInfo]?
    
    let locationInfoDataManager = LocationInfoDataManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.mrLightblueColor()
        navigationController?.navigationBar.topItem?.title = "Map"
        bottomContainerView.layer.cornerRadius = 4.0
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
//        locationInfos = 
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("MapInfoViewController destroyed!")
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

extension MapInfoViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegionMakeWithDistance(center, 500, 500)
            self.mapView.setRegion(region, animated: true)
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
}


extension MapInfoViewController: MKMapViewDelegate {
    
}

extension MapInfoViewController {
    class func controller() -> MapInfoViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(Storyboard.Identifier) as! MapInfoViewController
    }
}
