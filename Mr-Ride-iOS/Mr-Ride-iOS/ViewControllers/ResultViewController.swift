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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        self.navigationItem.hidesBackButton = isPushedFromRecordViewController
        if isPushedFromRecordViewController {

            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(close(_:)))
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
            
            view.backgroundColor = UIColor.clearColor()
        }
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: date)
        self.title = String(format: "%4d / %02d / %02d", components.year, components.month, components.day)
        
        print(totalElapsedTime)
        
        print(date)
        
        if let record = dataRecorder.readRecord(date) {
            
            print("read data success!!")
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
