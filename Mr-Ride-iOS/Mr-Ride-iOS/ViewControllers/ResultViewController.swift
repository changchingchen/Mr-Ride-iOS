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
        static let identifier = "ResultViewController"
    }
    
    var isPushedFromRecordViewController = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = isPushedFromRecordViewController
        if isPushedFromRecordViewController {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "close:")
        }
        self.title = "Result"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    deinit {
        print("ResultViewController destroy!")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
