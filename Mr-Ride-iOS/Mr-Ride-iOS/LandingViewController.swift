//
//  LandingViewController.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/23/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    private let leftMenuWidth: CGFloat = 260
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.showsHorizontalScrollIndicator = false
        dispatch_async(dispatch_get_main_queue()) {
//            self.closeMenu(false)
             self.scrollView.setContentOffset(CGPoint(x: self.leftMenuWidth, y: 0), animated: false)
        }

        
       
        print("scrollView.contentOffset.x: \(scrollView.contentOffset.x)")

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

extension LandingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scrollView.contentOffset.x: \(scrollView.contentOffset.x)")
    }
}