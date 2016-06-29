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
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.showsUserLocation = true
            mapView.delegate = self
        }
    }
    
    
    // Picker
    enum Place: String {
        case UbikeStation = "Ubike Station"
        case Toilet
    }
    
    private var places = [Place.Toilet, .UbikeStation]
    
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
            switch place {
            case .Toilet:
                break
            case .UbikeStation:
                break
            }
        }
        

    }
    
    
    let locationManager = CLLocationManager()
    var locationInfos: [LocationInformation]?
    
    let locationInfoDataManager = LocationInfoDataManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.mrLightblueColor()
        navigationController?.navigationBar.topItem?.title = "Map"
        bottomContainerView.layer.cornerRadius = 4.0
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        
        locationInfoDataManager.readLocationInfoDataFromCoordinate(latitude: 0.0, currentLongitude: 0.0) { locationInfos in
            if locationInfos.count > 0 {
                var annotations = [CustomizedAnnotation]()
//                var annotations = [MKPointAnnotation]()
                
                for locationInfo in locationInfos {
                    let location = CLLocationCoordinate2D(latitude: locationInfo.latitude, longitude: locationInfo.longitude)
                    let annotation = CustomizedAnnotation(coordinate: location, imageNamed: "icon-toilet", title: "Toilet", subtitle: nil)
//                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotations.append(annotation)
                }

                self.mapView.addAnnotations(annotations)

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
            let region = MKCoordinateRegionMakeWithDistance(center, 500, 500)
            self.mapView.setRegion(region, animated: true)
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
}


extension MapInfoViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? CustomizedAnnotation {
            let identifier = CustomizedAnnotation.Identifier
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? CircleAnnotationView
            
            if annotationView == nil {
                annotationView = CircleAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.setup()
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
        if let newCenter = view.annotation?.coordinate {
            let newRegion = MKCoordinateRegionMakeWithDistance(newCenter, 1000, 1000)
            mapView.setRegion(newRegion, animated: true)
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
    
    static let Identifier = "CustomizedAnnotation"
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var imageNamed: String
    
    init(coordinate: CLLocationCoordinate2D, imageNamed: String, title: String? = nil, subtitle: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.imageNamed = imageNamed
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
    func setup() {
        let radius = 20.0
        let imageNamed = "icon-toilet"
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
        
        if let image = UIImage(named: imageNamed) {
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

