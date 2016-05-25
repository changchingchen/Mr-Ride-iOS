//
//  LandingViewController.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/23/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class LandingContainerViewController: UIViewController {

    struct Constant {
        static let identifier = "LandingContainerViewController"
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainPageContainerView: UIView!
    @IBOutlet weak var leftSideMenuContainerView: UIView!
    
    private var leftSideMenuWidth: CGFloat {
        return leftSideMenuContainerView.bounds.width
    }
    
    private var mainContainerViewController: MainContainerViewController?
    
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
        
        self.scrollView.showsHorizontalScrollIndicator = false

        // Initially close menu programmatically.  This needs to be done on the main thread initially in order to work.
        dispatch_async(GlobalMainQueue) {
            self.showLeftSideMenu(show: false, animated: false)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showLeftSideMenu(show show: Bool, animated: Bool) {
        scrollView.setContentOffset(show ? CGPointZero : CGPoint(x: leftSideMenuWidth, y: 0), animated: animated)
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


//
//extension LandingViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        print("scrollView.contentOffset.x: \(scrollView.contentOffset.x)")
//    }
//}