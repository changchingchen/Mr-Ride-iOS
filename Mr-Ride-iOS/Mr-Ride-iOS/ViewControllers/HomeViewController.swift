//
//  LandingViewController.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/24/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit
import CoreData
//import QuartzCore

class HomeViewController: UIViewController {

    struct Constant {
        static let Identifier = "HomeViewController"
    }
    
    var parentVC: LandingContainerViewController {
        return self.navigationController?.parentViewController as! LandingContainerViewController
    }
    
    var isShowingLeftSideMenu: Bool {
        return parentVC.isShowingSideMenu
    }
    
    @IBOutlet weak var chartContainerView: UIView!
    
    @IBOutlet weak var totalDistanceStaticLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    
    @IBOutlet weak var totalCountStaticLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    
    @IBOutlet weak var averageSpeedStaticLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    
    @IBOutlet weak var startRidingButtonContainerView: UIView!
    @IBOutlet weak var startRidingButton: UIButton!
    
    @IBAction func tapStartRidingButton(sender: UIButton) {
        
        if !isShowingLeftSideMenu {
            let recordNVC = self.storyboard?.instantiateViewControllerWithIdentifier("RecordViewNavigationController") as! UINavigationController
            recordNVC.delegate = self
            recordNVC.modalPresentationStyle = .OverCurrentContext
            
            for subview in view.subviews where subview is UILabel {
                subview.hidden = true
            }
            self.navigationController?.presentViewController(recordNVC, animated: true, completion: nil)
        }

    }
    
    
    let dataRecorder = DataRecorder.sharedManager
    
    private var isFirstLaunched = true
    private let numberOfDataForChart = 5
    private var distances = [Double]()
    private var chartView: ChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(self.dynamicType): \(#function)")

        
        view.backgroundColor = UIColor.mrLightblueColor()
        
        initTotalDistanceLabels()
        initTotalCountLabels()
        initAverageSpeedLabels()
        initStartRidingButton()
        
        updateDistanceData()
       
        dataRecorder.createUserInfo() // Temporary, Need to modify later
        updateLabels()


//        navigationController?.navigationBar.clipsToBounds = true
        self.navigationController?.navigationBar.topItem?.title = "Mr. Ride"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self.dynamicType): \(#function)")

    }
    
    func updateLabels() {
        if let overallResult = dataRecorder.readUserInfo() {

            let distance = overallResult.totalDistance
            let duration = overallResult.totalDuration
            
            let averageSpeed = (duration == 0.0) ? 0.0 : (distance / duration * (3600 / 1000)) //unit: km/hr
            
            totalDistanceLabel.text = String(format: "%.1f km", distance / 1000)
            totalCountLabel.text = "\(overallResult.totalRidingTimes) Times"
            averageSpeedLabel.text = String(format: "%.2f km/hr", averageSpeed)
            
        }
    }
    
    
    private func initTotalDistanceLabels() {
        totalDistanceStaticLabel.layer.shadowColor = UIColor.mrBlack15Color().CGColor
        totalDistanceStaticLabel.layer.shadowRadius = 2.0
        totalDistanceStaticLabel.layer.shadowOpacity = 1.0
        
        totalDistanceLabel.layer.shadowColor = UIColor.mrBlack25Color().CGColor
        totalDistanceLabel.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        totalDistanceLabel.layer.shadowRadius = 2.0
        totalDistanceLabel.layer.shadowOpacity = 1.0
        totalDistanceLabel.font = UIFont.mrTextStyleFontSFUITextBold(80.0)
    }
    
    private func initTotalCountLabels() {
        totalCountStaticLabel.textColor = .whiteColor()
        totalCountStaticLabel.font = UIFont.mrTextStyleFontSFUITextRegular(12.0)
        totalCountStaticLabel.layer.shadowColor = UIColor.mrBlack15Color().CGColor
        totalCountStaticLabel.layer.shadowRadius = 2.0
        totalCountStaticLabel.layer.shadowOpacity = 1.0
        
        totalCountLabel.textColor = .whiteColor()
        totalCountLabel.font = UIFont.mrTextStyleFontSFUITextRegular(30.0)
        totalCountLabel.layer.shadowColor = UIColor.mrBlack15Color().CGColor
        totalCountLabel.layer.shadowRadius = 2.0
        totalCountLabel.layer.shadowOpacity = 1.0
    }
    
    private func initAverageSpeedLabels() {
        averageSpeedStaticLabel.textColor = .whiteColor()
        averageSpeedStaticLabel.font = UIFont.mrTextStyleFontSFUITextRegular(12.0)
        averageSpeedStaticLabel.layer.shadowColor = UIColor.mrBlack15Color().CGColor
        averageSpeedStaticLabel.layer.shadowRadius = 2.0
        averageSpeedStaticLabel.layer.shadowOpacity = 1.0
        
        averageSpeedLabel.textColor = .whiteColor()
        averageSpeedLabel.font = UIFont.mrTextStyleFontSFUITextRegular(30.0)
        averageSpeedLabel.layer.shadowColor = UIColor.mrBlack15Color().CGColor
        averageSpeedLabel.layer.shadowRadius = 2.0
        averageSpeedLabel.layer.shadowOpacity = 1.0
    }

    private func initStartRidingButton() {
        startRidingButton.titleLabel?.font = UIFont.mrTextStyleFontSFUITextMedium(30.0)
        startRidingButton.setTitleColor(UIColor.mrLightblueColor(), forState: UIControlState.Normal)
        
        startRidingButton.setTitle("Let's Ride".localized, forState: UIControlState.Normal)
        startRidingButton.titleLabel?.shadowOffset = CGSizeMake(0.0, 3.0)
        startRidingButton.titleLabel?.shadowColor = UIColor.blackColor()
        
        
        startRidingButtonContainerView.layer.cornerRadius = 30.0
        startRidingButtonContainerView.layer.shadowColor = UIColor.mrBlack25Color().CGColor
        startRidingButtonContainerView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        startRidingButtonContainerView.layer.shadowRadius = 2.0
        startRidingButtonContainerView.layer.shadowOpacity = 1.0
    }
    
    func resumeLabels() {
        for subview in view.subviews where subview is UILabel {
            subview.hidden = false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("\(self.dynamicType): \(#function)")

        if isFirstLaunched {
            chartView = ChartView(frame: CGRect(x: 0.0, y: 0.0, width: chartContainerView.bounds.size.width, height: chartContainerView.bounds.size.height))
            chartView.backgroundColor = UIColor.clearColor()
            chartView.graphPoints = distances.reverse()
            chartView.needsToMarkToday = true
            chartContainerView.addSubview(chartView)
            chartContainerView.backgroundColor = .clearColor()

            isFirstLaunched = !isFirstLaunched
        }
        
    }
    
    private func averageOfDoubles (numbers: [Double]) -> Double? {
        if !numbers.isEmpty {
            return numbers.reduce(0.0, combine: {$0+$1}) / Double(numbers.count)
        } else {
            return nil
        }
        
    }
    
    func updateDistanceData() {
        dataRecorder.fetchLastestNumberOfDistanceDataWithNumber(numberOfDataForChart)
        distances = dataRecorder.distances
        if let average = averageOfDoubles(distances) {
            distances.insert(average, atIndex: 0)
        }
        if chartView != nil {
            chartView.graphPoints = distances.reverse()
        }
    }
    
    deinit {
        print("HomeViewController destroy!")
    }

}

extension HomeViewController: UINavigationControllerDelegate {
    
}

extension HomeViewController {
    class func controller() -> HomeViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(Constant.Identifier) as! HomeViewController
    }
}
