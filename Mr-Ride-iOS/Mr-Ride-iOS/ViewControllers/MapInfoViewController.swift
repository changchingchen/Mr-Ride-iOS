//
//  MapInfoViewController.swift
//  Mr-Ride-iOS
//
//  Created by Chang-Ching CHEN on 6/16/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit
import MapKit

struct DashboardInfo {
    var title: String
    var detail: String
    var address: String
    var distanceInTime: String
}

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
            bottomContainerView.backgroundColor = .clearColor()
            bottomContainerView.layer.cornerRadius = 4.0
            bottomContainerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var mapContainerView: UIView! {
        didSet {
            mapContainerView.layer.cornerRadius = 10.0
            mapContainerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var dashboardView: UIView! {
        didSet {
            dashboardView.backgroundColor = UIColor.mrDarkSlateBlueColor()
            dashboardView.alpha = 0.9
            dashboardView.hidden = true
        }
    }
    
    

    
    @IBOutlet weak var dashboardDetailLabel: UILabel!
    @IBOutlet weak var dashboardTitleLabel: UILabel!
    @IBOutlet weak var dashboardAddressLabel: UILabel!
    @IBOutlet weak var dashboardDistanceLabel: UILabel!
    
    private func setupDashboardLabelStyle() {
        dashboardDetailLabel.textColor = UIColor.whiteColor()
        dashboardDetailLabel.textAlignment = .Center
        dashboardDetailLabel.font = UIFont.mrTextStyleFontSFUITextLight(10.0)
        dashboardDetailLabel.layer.borderColor = UIColor.whiteColor().CGColor
        dashboardDetailLabel.layer.borderWidth = 0.5
        dashboardDetailLabel.layer.cornerRadius = 2.0
        
        dashboardTitleLabel.textColor = UIColor.whiteColor()
        dashboardTitleLabel.textAlignment = .Left
        dashboardTitleLabel.font = UIFont.mrTextStyleFontSFUITextRegular(24.0)
        
        dashboardAddressLabel.textColor = UIColor.whiteColor()
        dashboardAddressLabel.font = UIFont.mrTextStyleFontSFUITextRegular(12.0)
//        dashboardAddressLabel.numberOfLines = 2

        dashboardDistanceLabel.textColor = UIColor.whiteColor()
        dashboardDistanceLabel.font = UIFont.mrTextStyleFontSFUITextRegular(10.0)
        dashboardDistanceLabel.textAlignment = .Right
        
    }
    
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.showsUserLocation = true
            mapView.delegate = self
        }
    }
    
    
    // Picker
    private enum Place: String {
        case UbikeStation = "Ubike Station"
        case Toilet
    }
    
    private var places = [Place.UbikeStation, .Toilet ]
    private var annotationImageNamed: String? {
        if let pickerButtonTitle = pickerButtonTitleLabel.text,
            let place = Place(rawValue: pickerButtonTitle) {
            switch place {
            case .UbikeStation: return "icon-station"
            case .Toilet: return "icon-toilet"
            }
        }
        return nil
    }
    
    
    // Since directly set button title is not fast enough => use this label to set title
    @IBOutlet weak var pickerButtonTitleLabel: UILabel! {
        didSet {
            pickerButtonTitleLabel.text = places[0].rawValue
        }
    }

    @IBAction func tapPickerButton(sender: UIButton) {
        if let pickerButtonTitle = pickerButtonTitleLabel.text,
            let place = Place(rawValue: pickerButtonTitle),
            let index = places.indexOf(place) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
        showPickerView()
    }
    
    @IBOutlet weak var pickerContainerView: UIView! {
        didSet {
            pickerContainerView.hidden = true
        }
    }
    @IBOutlet weak var pickerViewToolBar: UIToolbar! {
        didSet {
            pickerViewToolBar.barStyle = .Default
            pickerViewToolBar.translucent = true

            pickerViewToolBar.userInteractionEnabled = true
//            pickerViewToolBar.hidden = true
        }
    }
    @IBOutlet weak var pickerView: UIPickerView! {
        didSet {
            pickerView.dataSource = self
            pickerView.delegate = self
        }

    }
    @IBOutlet weak var shelterView: UIView! {
        didSet {
            shelterView.backgroundColor = UIColor(white: 0.0, alpha: 0.25)
            shelterView.hidden = true
        }
    }
    
    @IBOutlet weak var pickerContainerViewHeight: NSLayoutConstraint!
//    {
//        didSet {
//            pickerContainerViewHeight.constant = 0.0
//        }
//    }

    
    @IBAction func cancelPicker(sender: UIBarButtonItem) {
        hidePickerView()
    }
    
    @IBAction func donePicker(sender: UIBarButtonItem) {
        
        let pickerButtonTitle = places[pickerView.selectedRowInComponent(0)].rawValue
        pickerButtonTitleLabel.text = pickerButtonTitle
        
        hidePickerView()
        
        if let place = Place(rawValue: pickerButtonTitle) {
            mapView.removeAnnotations(annotations)
            annotations.removeAll()
            switch place {
            case .UbikeStation:
                locationInfoDataManager.readYBStationData {
                    ybStations in
                    if ybStations.count > 0 {
                        
                        for ybStation in ybStations {
                            let location = CLLocationCoordinate2D(latitude: ybStation.latitude, longitude: ybStation.longitude)
                            let dashboardInfo = DashboardInfo(title: ybStation.placeNameCn, detail: ybStation.districtCn, address: ybStation.addressCn, distanceInTime: "0")
                            let annotation = CustomizedAnnotation(identifier: place.rawValue, coordinate: location, imageNamed: self.annotationImageNamed, dashboardInfo: dashboardInfo, title: "\(ybStation.availableBikes) Bike(s) Left", subtitle: nil)
                            annotation.coordinate = location
                            self.annotations.append(annotation)
                        }
                        
                        self.mapView.addAnnotations(self.annotations)
                        
                    }
                }
            case .Toilet:
                locationInfoDataManager.readToiletData {
                    toilets in
                    if toilets.count > 0 {
                        
                        for toilet in toilets {
                            let location = CLLocationCoordinate2D(latitude: toilet.latitude, longitude: toilet.longitude)
                            let dashboardInfo = DashboardInfo(title: toilet.placeName, detail: toilet.placeType, address: toilet.address, distanceInTime: "0")
                            let annotation = CustomizedAnnotation(identifier: place.rawValue, coordinate: location, imageNamed: self.annotationImageNamed, dashboardInfo: dashboardInfo, title: toilet.placeName, subtitle: nil)
                            annotation.coordinate = location
                            self.annotations.append(annotation)
                        }
                        
                        self.mapView.addAnnotations(self.annotations)
                        
                    }
                }
                
                
            }
        }
        

    }
    
    
    let locationManager = CLLocationManager()
    var locationInfos: [LocationInformation]?
    
    private var annotations = [CustomizedAnnotation]()
    
    let locationInfoDataManager = LocationInfoDataManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.mrLightblueColor()
        navigationController?.navigationBar.topItem?.title = "Map"

        
        setupDashboardLabelStyle()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        locationInfoDataManager.readYBStationData {
            ybStations in
            if ybStations.count > 0 {
                
                for ybStation in ybStations {
                    let location = CLLocationCoordinate2D(latitude: ybStation.latitude, longitude: ybStation.longitude)
                    let dashboardInfo = DashboardInfo(title: ybStation.placeNameCn, detail: ybStation.districtCn, address: ybStation.addressCn, distanceInTime: "0")
                    let annotation = CustomizedAnnotation(identifier: Place.UbikeStation.rawValue,coordinate: location, imageNamed: self.annotationImageNamed, dashboardInfo: dashboardInfo, title: "\(ybStation.availableBikes) Bike(s) Left", subtitle: nil)
                    annotation.coordinate = location
                    self.annotations.append(annotation)
                }
                
                self.mapView.addAnnotations(self.annotations)
                
            }
        }

        
        
        
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
            let region = MKCoordinateRegionMakeWithDistance(center, 1000, 1000)
            self.mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()

        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
}


extension MapInfoViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? CustomizedAnnotation {
//            let identifier = CustomizedAnnotation.Identifier
            let identifier = annotation.identifier
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? CircleAnnotationView
            
            if annotationView == nil {
                annotationView = CircleAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.setup(annotation.imageNamed)
                annotationView?.canShowCallout = true
//                if let annotationViewTemp = annotationView as? CircleAnnotationView {
//                    annotationViewTemp.setup(radius: 40.0, imageNamed: annotation.imageNamed)
//                }
//                annotationView?.setup(radius: 40.0, imageNamed: annotation.imageNamed)
//                annotationView = CircleAnnotationView(radius: 20.0, imageNamed: annotation.imageNamed, annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        
        view.backgroundColor = UIColor.mrLightblueColor()
        
        if let annotation = view.annotation as? CustomizedAnnotation {
            let newCenter = annotation.coordinate
            let newRegion = MKCoordinateRegionMakeWithDistance(newCenter, 1000, 1000)
            mapView.setRegion(newRegion, animated: true)
            
            dashboardTitleLabel.text = annotation.dashboardInfo.title
            dashboardDetailLabel.text = " \(annotation.dashboardInfo.detail) "
            dashboardAddressLabel.text = annotation.dashboardInfo.address
            dashboardDistanceLabel.text = "\(annotation.dashboardInfo.distanceInTime) min(s)"

        }
        
        
        dashboardView.hidden = false
        
    }
    
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        view.backgroundColor = UIColor.whiteColor()
        dashboardView.hidden = true
    }
}

extension MapInfoViewController {
    class func controller() -> MapInfoViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(Storyboard.Identifier) as! MapInfoViewController
    }
}

class CustomizedAnnotation: NSObject, MKAnnotation {
    
//    static let Identifier = "CustomizedAnnotation"
    var title: String?
    var subtitle: String?

    var identifier: String
    var coordinate: CLLocationCoordinate2D
    var imageNamed: String?

    var dashboardInfo: DashboardInfo
    
    init(identifier: String, coordinate: CLLocationCoordinate2D, imageNamed: String?, dashboardInfo: DashboardInfo, title: String? = nil, subtitle: String? = nil) {
        self.identifier = identifier
        self.coordinate = coordinate
        self.imageNamed = imageNamed
        self.dashboardInfo = dashboardInfo
        self.title = title
        self.subtitle = subtitle
    }
    
}

class CircleAnnotationView: MKAnnotationView {
    
//    private let radius: CGFloat
//    private let imageNamed: String
    
//    init(radius: CGFloat, imageNamed: String, annotation: MKAnnotation?, reuseIdentifier: String?) {
//        self.radius = radius
//        self.imageNamed = imageNamed
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
////        let diameter = radius * 2
////        self.backgroundColor = .whiteColor()
////        self.frame.size = CGSize(width: diameter, height: diameter)
////        self.layer.cornerRadius = bounds.size.width / 2
////        self.layer.borderWidth = 0.5
////        self.layer.borderColor = UIColor.mrPinkishGreyColor().CGColor
////        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
////        self.layer.shadowRadius = 4.0
////        self.layer.shadowColor = UIColor.blackColor().CGColor
////        self.layer.shadowOpacity = 0.5
////        
////        if let image = UIImage(named: imageNamed) {
////            let imageView = UIImageView(image: image)
////            imageView.center = self.center
////            imageView.frame.size = CGSize(width: radius, height: radius)
////            self.addSubview(imageView)
////        }
//        setup()
//    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    func setup(imageNamed: String?) {
        let radius = 20.0

        let diameter = radius * 2
        self.backgroundColor = .whiteColor()
        self.frame.size = CGSize(width: diameter, height: diameter)
        self.layer.cornerRadius = bounds.size.width / 2
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.mrPinkishGreyColor().CGColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.5
        
        if let iconImageNamed = imageNamed, let image = UIImage(named: iconImageNamed) {
            let imageView = UIImageView(image: image)
            imageView.center = self.center
            imageView.frame.size = CGSize(width: radius, height: radius)
            self.addSubview(imageView)
        }
    }
    
}

// MARK: - Methods for Picker & Picker Delegate
extension MapInfoViewController: UIPickerViewDataSource {
   
    
    private func showPickerView() {
        pickerContainerView.hidden = false
//        pickerContainerViewHeight.constant = 260.0
//        pickerViewToolBar.hidden = false
//        shelterView.hidden = false
    }
    
    private func hidePickerView() {
        pickerContainerView.hidden = true
//        pickerContainerViewHeight.constant = 0.0
//        pickerViewToolBar.hidden = true
//        shelterView.hidden = true
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return places.count
    }
    
}

extension MapInfoViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return places[row].rawValue
    }
    
}

