//
//  TrackingViewController.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/24/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    struct Storyboard {
        static let Identifier = "RecordViewController"
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var timerButtonContainerView: UIView!
    @IBOutlet weak var timerButton: UIButton!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    private var record = Record()
    private var calories = 0.0
    private var weight = 0.0
    let dataRecorder = DataRecorder.sharedManager
    let caloriesCalculator = CaloriesCalculator()

    
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
        UIView.animateWithDuration(0.6) { [unowned self] in
            self.timerButton.transform = CGAffineTransformMakeScale(0.5, 0.5)
            self.timerButton.layer.cornerRadius = 8.0
        }

    }
    
    func stopTimer() {
        timerState = .Pause
        timer.invalidate()
        totalElapsedTime += elapsedTimeOneRound // Calculate the total elapsed time from the beginning
        mapViewController.stopUpdatingLocation()
        mapViewController.previousLocation = nil
        UIView.animateWithDuration(0.6) { [unowned self] in
            self.timerButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.timerButton.layer.cornerRadius = self.timerButton.bounds.size.width / 2
        }
        
    }
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime = currentTime - startTime
        
        elapsedTimeOneRound = elapsedTime // Record the elapsed time for current round (run->pause)
        
        elapsedTime += totalElapsedTime
        
        let elapsedTimeInHour = elapsedTime / 3600
        
        
        let hour = UInt8(elapsedTime / 3600.0)
        elapsedTime %= 3600
        let minute = UInt8(elapsedTime / 60.0)
        elapsedTime %= 60
        let second = UInt8(elapsedTime)
        let tenMillisecond = UInt16(elapsedTime * 100) % 100
        
        timerLabel.text
            = String(format: "%02d:%02d:%02d.%02d", hour, minute, second, tenMillisecond)
        
        let distance = mapViewController.distance
        distanceLabel.text = "\(Int(distance)) m"
        let speedInKmPerHour = mapViewController.speed * 3600 / 1000
        speedLabel.text = String(format: "%.2f km/hr", speedInKmPerHour)
        
        let averageSpeedInKmPerHour = (elapsedTimeInHour == 0.0) ? 0.0 : distance / elapsedTimeInHour / 1000

        calories = caloriesCalculator.calculateKCalBurned(.Bike, speed: averageSpeedInKmPerHour, weight: weight, time: elapsedTimeInHour)
        
        caloriesLabel.text = String(format: "%.2f kCal", calories)
        
    }
    
    @IBAction func tapTimerButton(sender: UIButton) {

        if !hasTappedTimerButton {
            date = NSDate() // Record the start date and time
            hasTappedTimerButton = true
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(finish(_:)))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
//            self.navigationItem.rightBarButtonItem?.enabled = true
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

        let cancelAlert = UIAlertController(title: "Notice", message: "Are you sure you want to cancel this ride record?", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .Default) { action in
            
            if let homeViewVC = self.navigationController?.delegate as? HomeViewController {
                homeViewVC.resumeLabels()
                homeViewVC.parentVC.scrollView.scrollEnabled = true
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        cancelAlert.addAction(cancelAction)
        cancelAlert.addAction(okAction)
        self.presentViewController(cancelAlert, animated: true, completion: nil)

    }
    
//    @IBAction func finish(sender: UIBarButtonItem) {
    func finish(sender: UIBarButtonItem) {
    
        stopTimer()
       
        let resultViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ResultViewController.Storyboard.Identifier) as! ResultViewController
        resultViewController.isPushedFromRecordViewController = true
        resultViewController.date = date
//        resultViewController?.date = date
        updateCurrentRecord()
        
        self.dataRecorder.createRecord(record)
        self.dataRecorder.updateUserInfo(record.distance, duration: record.duration)
        self.navigationController?.pushViewController(resultViewController, animated: true)
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

//        self.navigationItem.rightBarButtonItem?.enabled = false

        initView()
        if let overallResult = dataRecorder.readUserInfo() {
            weight = overallResult.weight
        }

        
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
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = false
        

        // Set View Background
        view.backgroundColor = UIColor.clearColor()
        let gradientBackgroundLayer = CAGradientLayer()
        let gradientTopColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6).CGColor
        let gradientBottomColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4).CGColor
        gradientBackgroundLayer.colors = [gradientTopColor, gradientBottomColor]
        gradientBackgroundLayer.locations = [0.0, 1.0]
        gradientBackgroundLayer.frame = view.frame
        view.layer.insertSublayer(gradientBackgroundLayer, atIndex: 0)

        
        timerButtonContainerView.backgroundColor = .clearColor()
        timerButtonContainerView.layer.cornerRadius = timerButtonContainerView.bounds.size.width / 2
        timerButtonContainerView.layer.borderColor = UIColor.whiteColor().CGColor
        timerButtonContainerView.layer.borderWidth = 4.0
        
        timerButton.layer.cornerRadius = timerButton.bounds.size.width / 2
        
        // Set Label Colors and Font
        distanceLabel.textColor = UIColor.whiteColor()
        distanceLabel.font = UIFont.mrTextStyleFontSFUITextRegular(30.0)

        speedLabel.textColor = UIColor.whiteColor()
        speedLabel.font = UIFont.mrTextStyleFontSFUITextRegular(30.0)
        
        caloriesLabel.textColor = UIColor.whiteColor()
        caloriesLabel.font = UIFont.mrTextStyleFontSFUITextRegular(30.0)
        
        timerLabel.textColor = UIColor.whiteColor()
        timerLabel.font = UIFont.mrTextStyleFontRobotoMonoLight(30.0)

        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        mapViewController = segue.destinationViewController as? MapViewController

    }
    


}

