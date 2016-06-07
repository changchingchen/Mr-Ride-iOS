//
//  HistroyViewController.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/24/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    struct Constant {
        static let Identifier = "HistoryViewController"
    }
    
    
    var parentVC: LandingContainerViewController {
        return self.navigationController?.parentViewController as! LandingContainerViewController
    }
    
    private var isShowingLeftSideMenu: Bool {
        return parentVC.isShowingSideMenu
    }
    
    private var historyTableViewController: HistoryTableViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mrLightblueColor()
        
        self.navigationController?.navigationBar.topItem?.title = "History"
        
        historyTableViewController.isShowingLeftSideMenu = isShowingLeftSideMenu
        historyTableViewController.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\(HistoryViewController.Constant.Identifier) viewDidAppear")
        parentVC.scrollView.scrollEnabled = true
    }
    
    
    deinit {
        print("HistoryViewController destroy!")
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        historyTableViewController = segue.destinationViewController as! HistoryTableViewController
        
    }
 

}



extension HistoryViewController: HistoryTableViewControllerDelegate {
    
}


extension HistoryViewController {
    class func controller() -> HistoryViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(Constant.Identifier) as! HistoryViewController
    }
}
