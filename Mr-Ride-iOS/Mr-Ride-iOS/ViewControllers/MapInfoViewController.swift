//
//  MapInfoViewController.swift
//  Mr-Ride-iOS
//
//  Created by Chang-Ching CHEN on 6/16/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class MapInfoViewController: UIViewController {

    struct Constant {
        static let Identifier = "MapInfoViewController"
    }

    var parentVC: LandingContainerViewController {
        return self.navigationController?.parentViewController as! LandingContainerViewController
    }
    
    var isShowingLeftSideMenu: Bool {
        return parentVC.isShowingSideMenu
    }
    
    @IBOutlet weak var bottomContainerView: UIView! {
        didSet {
            bottomContainerView.layer.cornerRadius = 4.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.mrLightblueColor()
        navigationController?.navigationBar.topItem?.title = "Map"
        bottomContainerView.layer.cornerRadius = 4.0
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

extension MapInfoViewController {
    class func controller() -> MapInfoViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(Constant.Identifier) as! MapInfoViewController
    }
}
