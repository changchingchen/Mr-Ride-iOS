//
//  MainContainerViewController.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/24/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class MainContainerViewController: UIViewController {

    struct Storyboard {
        static let Identifier = "MainContainerViewController"
    }
    
    var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController(activeViewController)
        }
    }
    
    @IBAction func tapLeftSideMenuBarButton(sender: UIBarButtonItem) {
        let landingContainerViewController = self.navigationController?.parentViewController as! LandingContainerViewController
        
        landingContainerViewController.showLeftSideMenu(show: !landingContainerViewController.isShowingSideMenu, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barStyle = .Black
        

        activeViewController = HomeViewController.controller()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inactiveVC = inactiveViewController {
            inactiveVC.willMoveToParentViewController(nil)
            inactiveVC.view.removeFromSuperview()
            inactiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController(activeViewController: UIViewController?) {
        if let activeVC = activeViewController {
            self.addChildViewController(activeVC)
            activeVC.view.frame = view.bounds
            view.addSubview(activeVC.view)
            activeVC.didMoveToParentViewController(self)
        }
    }

}
