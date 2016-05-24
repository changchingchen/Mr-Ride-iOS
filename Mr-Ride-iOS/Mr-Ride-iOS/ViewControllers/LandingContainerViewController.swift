//
//  LandingViewController.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/23/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class LandingContainerViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    private let leftSideMenuWidth: CGFloat = 260
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.showsHorizontalScrollIndicator = false
        
        // Initially close menu programmatically.  This needs to be done on the main thread initially in order to work.
        dispatch_async(GlobalMainQueue) {
//            self.closeMenu(false)
             self.scrollView.setContentOffset(CGPoint(x: self.leftSideMenuWidth, y: 0), animated: false)
        }

        

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

}
//
//extension LandingViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        print("scrollView.contentOffset.x: \(scrollView.contentOffset.x)")
//    }
//}