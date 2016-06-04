//
//  TrackingViewController.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/24/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit
//import MapKit

class RecordViewController: UIViewController {

    struct Constant {
        static let identifier = "RecordViewController"
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    private var record = Record()
    private var calories = 0.0
    let dataRecorder = DataRecorder.sharedManager
    
    // Properties for timer => Try to move timer to Model
    private enum TimerState {
        case Pause
        case Run
    }
    
    private var startTime = NSTimeInterval()
    private var timer = NSTimer()
    private var totalElapsedTime = NSTimeInterval()
    private var elapsedTimeOneRound = NSTimeInterval()
    private var timerState = TimerState.Pause
    private var hasTappedTimerButton = false
    private var date = NSDate()
    
    func startTimer() {
        timerState = .Run
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        mapViewController.startUpdatingLocation()

    }
    
    func stopTimer() {
        
        timerState = .Pause
        timer.invalidate()
        totalElapsedTime += elapsedTimeOneRound // Calculate the total elapsed time from the beginning
        mapViewController.stopUpdatingLocation()
    }
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime = currentTime - startTime
        
        elapsedTimeOneRound = elapsedTime // Record the elapsed time for current round (run->pause)
        
        elapsedTime += totalElapsedTime
        
        let hour = UInt8(elapsedTime / 3600.0)
        elapsedTime %= 3600
        let minute = UInt8(elapsedTime / 60.0)
        elapsedTime %= 60
        let second = UInt8(elapsedTime)
        let tenMillisecond = UInt16(elapsedTime * 100) % 100
        
        timerLabel.text
            = String(format: "%02d:%02d:%02d.%02d", hour, minute, second, tenMillisecond)
        
        distanceLabel.text = "\(Int(mapViewController.distance)) m"
//        speedLabel.text = "\(mapViewController.speed)"
        
    }
    
    @IBAction func tapTimerButton(sender: UIButton) {

        if !hasTappedTimerButton {
            date = NSDate() // Record the start date and time
            hasTappedTimerButton = true

            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(finish(_:)))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()

        }
        
        switch timerState {
        case .Pause:
            startTimer()
            mapViewController.isTimerRunning = true
        case .Run:
            stopTimer()
            mapViewController.isTimerRunning = false
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        stopTimer()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func finish(sender: UIBarButtonItem) {
        
        stopTimer()
       
        let resultViewContoller = self.storyboard?.instantiateViewControllerWithIdentifier(ResultViewController.Constant.identifier) as! ResultViewController
        resultViewContoller.isPushedFromRecordViewController = true
        resultViewContoller.date = date
        updateCurrentRecord()
        
        self.dataRecorder.createRecord(record)
        
        self.navigationController?.pushViewController(resultViewContoller, animated: true)
    }

    
    
    private func updateCurrentRecord() {
        self.record.distance = mapViewController.distance
        self.record.duration = self.totalElapsedTime
        self.record.calories = self.calories
        self.record.date = self.date
        for (index, path) in mapViewController.paths.enumerate() {
            self.record.paths.append([])
            
            for location in path {
                self.record.paths[index].append(location)
            }
        }

    }
    
    
    // MARK: - Properties for MapView

    
    private var mapViewController: MapViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("RecordViewController destroy!")
    }

    
    func initView() {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: date)
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        // Set Navigation Bar
        self.navigationController?.navigationBar.topItem?.title = String(format: "%4d / %02d / %02d", components.year, components.month, components.day)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
//, NSFontAttributeName: UIFont.mrTextStyleFontSFUITextSemibold(17.0)?
        // Set View Background
        view.backgroundColor = UIColor.mrLightblueColor()
        let gradientBackgroundLayer = CAGradientLayer()
        let gradientTopColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6).CGColor
        let gradientBottomColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4).CGColor
        gradientBackgroundLayer.colors = [gradientTopColor, gradientBottomColor]
        gradientBackgroundLayer.locations = [0.0, 1.0]
        gradientBackgroundLayer.frame = view.frame
        view.layer.insertSublayer(gradientBackgroundLayer, atIndex: 0)
        
        
        // Set Label Colors and Font
        distanceLabel.textColor = UIColor.whiteColor()
        distanceLabel.font = UIFont.mrTextStyleFontSFUITextRegular(30.0)

        speedLabel.textColor = UIColor.whiteColor()
        speedLabel.font = UIFont.mrTextStyleFontSFUITextRegular(30.0)
        
        caloriesLabel.textColor = UIColor.whiteColor()
        caloriesLabel.font = UIFont.mrTextStyleFontSFUITextRegular(30.0)

        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        mapViewController = segue.destinationViewController as? MapViewController
        
        
    }


}

