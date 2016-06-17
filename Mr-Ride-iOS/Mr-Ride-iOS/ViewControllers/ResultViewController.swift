//
//  ResultViewController.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/24/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    struct Constant {
        static let Identifier = "ResultViewController"
    }
    
    var isPushedFromRecordViewController = false
    var totalElapsedTime = NSTimeInterval()
    var paths = [[LocationRecord]]()
    private var record: Record?
    var date = NSDate()
    
    let dataRecorder = DataRecorder.sharedManager
    
    private var mapViewController: MapViewController!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        self.navigationItem.hidesBackButton = isPushedFromRecordViewController
        if isPushedFromRecordViewController {

            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(close(_:)))
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
            
            view.backgroundColor = UIColor.clearColor()
        } else {
//            self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
//            view.backgroundColor = UIColor.mrLightblueColor()
//            self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
//            self.navigationController?.navigationBar.barStyle = .Black
//            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//            self.navigationController?.navigationBar.shadowImage = UIImage()
//            self.navigationController?.navigationBar.translucent = false
        }
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: date)
        self.title = String(format: "%4d / %02d / %02d", components.year, components.month, components.day)
        
        
        
        if let record = dataRecorder.readRecord(date) {
            
            let distance = record.distance // unit: m
            var duration = record.duration // unit: s
            print(duration)
            let averageSpeed = distance / duration * (3600 / 1000) //unit: km/hr

            let hour = UInt8(duration / 3600.0)
            duration %= 3600
            let minute = UInt8(duration / 60.0)
            duration %= 60
            let second = UInt8(duration)
            let tenMillisecond = UInt16(duration * 100) % 100
            
            distanceLabel.text = String(format: "%.2f m", distance)
            
            averageSpeedLabel.text = String(format: "%.2f km/hr", averageSpeed)
            
            totalTimeLabel.text
                = String(format: "%02d:%02d:%02d.%02d", hour, minute, second, tenMillisecond)
            
            
            mapViewController.paths = record.paths
            mapViewController.drawRoutes()
        }
    
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close(sender: UIBarButtonItem) {
        if let homeVC = self.navigationController?.delegate as? HomeViewController {
            homeVC.resumeLabels()
            homeVC.updateDistanceData()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    deinit {
        print("ResultViewController destroy!")
    }


    func initView() {
        view.backgroundColor = UIColor.mrLightblueColor()
        let gradientBackgroundLayer = CAGradientLayer()
        let gradientTopColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6).CGColor
        let gradientBottomColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4).CGColor
        gradientBackgroundLayer.colors = [gradientTopColor, gradientBottomColor]
        gradientBackgroundLayer.locations = [0.0, 1.0]
        gradientBackgroundLayer.frame = view.frame
        view.layer.insertSublayer(gradientBackgroundLayer, atIndex: 0)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        mapViewController = segue.destinationViewController as? MapViewController

    }


}
