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
        static let identifier = "HistoryViewController"
    }
    
    @IBOutlet weak var historyResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.greenColor()
        
        historyResultsTableView.delegate = self
        historyResultsTableView.dataSource = self
        
        let cellReuseIdentifier = "ResultTableViewCell"
        let nib = UINib(nibName: cellReuseIdentifier, bundle: nil)
        historyResultsTableView.registerNib(nib, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.navigationController?.navigationBar.topItem?.title = "History"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\(HistoryViewController.Constant.identifier) viewDidAppear")
        (self.navigationController?.parentViewController as! LandingContainerViewController).scrollView.scrollEnabled = true
    }
    
    
    deinit {
        print("HistoryViewController destroy!")
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

extension HistoryViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let resultViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ResultViewController.Constant.identifier) as! ResultViewController
        self.navigationController?.pushViewController(resultViewController, animated: true)
        (self.navigationController?.parentViewController as! LandingContainerViewController).scrollView.scrollEnabled = false
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultTableViewCell", forIndexPath: indexPath) as! ResultTableViewCell
        
        return cell
    }
    
    
}


extension HistoryViewController {
    class func controller() -> HistoryViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(Constant.identifier) as! HistoryViewController
    }
}
