//
//  LandingViewController.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/23/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class LandingContainerViewController: UIViewController {

    struct Storyboard {
        static let Identifier = "LandingContainerViewController"
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var mainPageContainerView: UIView!
    @IBOutlet weak var leftSideMenuContainerView: UIView!
    
    private var leftSideMenuWidth: CGFloat {
        return leftSideMenuContainerView.bounds.width
    }
    
    private var mainContainerViewController: MainContainerViewController?
    
    let locationInfoDataManager = LocationInfoDataManager.sharedInstance
    
    var isShowingSideMenu = false
    
    var activeViewController: UIViewController? {
        willSet {
            showLeftSideMenu(show: false, animated: true)
            if let mainContainerVC = mainContainerViewController {
                mainContainerVC.activeViewController = newValue
            }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        print("\(self.dynamicType) + \(#function)")
        locationInfoDataManager.getLocationInfoFromDataTaipei{}
        
        scrollView.showsHorizontalScrollIndicator = false
        // Initially close menu programmatically.  This needs to be done on the main thread initially in order to work.
        dispatch_async(GlobalMainQueue) {
            self.showLeftSideMenu(show: self.isShowingSideMenu, animated: false)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showLeftSideMenu(show show: Bool, animated: Bool) {
        scrollView.setContentOffset(show ? CGPointZero : CGPoint(x: leftSideMenuWidth, y: 0), animated: animated)
        isShowingSideMenu = show
    }


    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case "MainContainerViewSegue":
                let navigationController = segue.destinationViewController as! UINavigationController
                mainContainerViewController = navigationController.topViewController as? MainContainerViewController
            default:
                return
            }
        }

    }
    
    

}

// MARK: - UIScrollVIewDelegate

extension LandingContainerViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        isShowingSideMenu = CGPointEqualToPoint(CGPointZero, scrollView.contentOffset)
    }
    
}