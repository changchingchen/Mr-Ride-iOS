//
//  MainContainerViewController.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/24/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class MainContainerViewController: UIViewController {

    struct Constant {
        static let identifier = "MainContainerViewController"
    }
    
    private lazy var homeViewController = HomeViewController.controller()
    private lazy var historyViewController = HistoryViewController.controller()
    
    var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
        }
        willSet {
            updateActiveViewController(newValue)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activeViewController = HomeViewController.controller()
        // Do any additional setup after loading the view.
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
