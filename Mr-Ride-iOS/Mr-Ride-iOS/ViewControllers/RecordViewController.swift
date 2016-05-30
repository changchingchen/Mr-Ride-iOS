//
//  TrackingViewController.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/24/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    struct Constant {
        static let identifier = "RecordViewController"
    }
    
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func finish(sender: UIBarButtonItem) {
        let resultViewContoller = self.storyboard?.instantiateViewControllerWithIdentifier(ResultViewController.Constant.identifier) as! ResultViewController
        resultViewContoller.isPushedFromRecordViewController = true
        self.navigationController?.pushViewController(resultViewContoller, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        self.navigationController?.navigationBar.topItem?.title = "Record"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("RecordViewController destroy!")
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
