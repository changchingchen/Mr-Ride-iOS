//
//  LandingViewController.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/24/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    struct Constant {
        static let identifier = "HomeViewController"
    }
    
    @IBOutlet weak var startRidingButton: UIButton!
    
    
//    @IBAction func tapStartRidingButton(sender: UIButton) {
//        let trackingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TrackingViewController") as! TrackingViewController
//        self.navigationController?.pushViewController(trackingViewController, animated: true)
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mrLightblueColor()

        startRidingButton.setTitle("Let's Ride".localized, forState: UIControlState.Normal)
        
        navigationController?.navigationBar.clipsToBounds = true

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true

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

}

extension HomeViewController {
    class func controller() -> HomeViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(Constant.identifier) as! HomeViewController
    }
}
