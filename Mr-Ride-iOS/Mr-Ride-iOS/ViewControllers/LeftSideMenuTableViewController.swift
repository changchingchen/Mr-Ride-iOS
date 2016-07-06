//
//  LeftSideMenuTableViewController.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/23/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class LeftSideMenuTableViewController: UITableViewController {

    struct Storyboard {
        static let Identifier = "LeftSideMenuTableViewController"
    }
    
    private enum LeftSideMenuItem: String {
        case Home
        case History
        case Map
    }
    
    private let leftSideMenuItems = [LeftSideMenuItem.Home, .History, .Map]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellReuseIdentifier = LeftSideMenuTableViewCell.Constant.Identifier
        let nib = UINib(nibName: cellReuseIdentifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellReuseIdentifier)

        
        // Hide the navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        navigationController!.navigationBar.barStyle = .Black

        
        self.tableView.backgroundColor = UIColor.mrDarkSlateBlueColor()
        
        

        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: .None)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - Table view data source

extension LeftSideMenuTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return leftSideMenuItems.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LeftSideMenuTableViewCell", forIndexPath: indexPath) as! LeftSideMenuTableViewCell

        cell.selectionStyle = .None
        cell.leftSideMenuItemLabel.text = leftSideMenuItems[indexPath.row].rawValue
       
        return cell
    }
    
}

// MARK: - Table view delegate


extension LeftSideMenuTableViewController {
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch leftSideMenuItems[indexPath.row] {
        case .Home:
            (self.navigationController?.parentViewController as! LandingContainerViewController).activeViewController = HomeViewController.controller()
        case .History:
//            let navigationVC = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryViewNavigationController") as! UINavigationController
            (self.navigationController?.parentViewController as! LandingContainerViewController).activeViewController = HistoryViewController.controller()
//            (self.navigationController?.parentViewController as! LandingContainerViewController).activeViewController = navigationVC

        case .Map:
            (self.navigationController?.parentViewController as! LandingContainerViewController).activeViewController = MapInfoViewController.controller()
        }
        
    }
    

}

