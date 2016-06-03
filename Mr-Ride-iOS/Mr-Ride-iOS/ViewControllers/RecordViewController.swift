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
    let calendar = NSCalendar.currentCalendar()

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
        
    }
    
    @IBAction func tapTimerButton(sender: UIButton) {

        if !hasTappedTimerButton {
            date = NSDate() // Record the start date and time
            hasTappedTimerButton = true
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
    
    @IBAction func finish(sender: UIBarButtonItem) {
        
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
        
        self.navigationController?.navigationBar.topItem?.title = "Record"
        
        
        // Finish Button should appear only when hasTappedTimerButton == true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("RecordViewController destroy!")
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        mapViewController = segue.destinationViewController as? MapViewController
        
        
    }


}

