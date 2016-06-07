//
//  HistoryTableViewController.swift
//  Mr-Ride-iOS
//
//  Created by Chang-Ching CHEN on 6/4/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit
import CoreData

protocol HistoryTableViewControllerDelegate: class {
    
}

class HistoryTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    struct Constant {
        static let Identifier = "HistoryTableViewContoller"
    }
    
//    private var parentVC: HistoryViewController {
//        return self.navigationController?.parentViewController as! HistoryViewController
//    }

//    var fetchedResultsController: NSFetchedResultsController? {
//        didSet {
//            do {
//                if let frc = fetchedResultsController {
//                    frc.delegate = self
//                    try frc.performFetch()
//                }
//            } catch let error {
//                print("NSFetchedResultsController.performFetch() failed: \(error)")
//            }
//        }
//    }
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    lazy var fetchedResultsController: NSFetchedResultsController? = {
        let fetchRequest = NSFetchRequest(entityName: "RideRecord")
        let dateForSectionsSortDescriptor = NSSortDescriptor(key: "dateForSections", ascending: false)
        let dateSortDescriptor = NSSortDescriptor(key: "date",  ascending: false)
        fetchRequest.sortDescriptors = [dateForSectionsSortDescriptor, dateSortDescriptor]
        
        // Need to be further consider whether ! is good or not
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "dateForSections", cacheName: nil)
        fetchedResultsController.delegate = self
       
        return fetchedResultsController
        
    }()
    
    
    weak var delegate: HistoryTableViewControllerDelegate?
    let dataRecorder = DataRecorder.sharedManager
    
    var isShowingLeftSideMenu = false
    var hasReadAllData = false
    
    enum Month: Int {
        case January = 1
        case February
        case March
        case April
        case May
        case June
        case July
        case August
        case September
        case October
        case November
        case December
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let cellReuseIdentifier = "ResultTableViewCell"
        let nib = UINib(nibName: cellReuseIdentifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellReuseIdentifier)
        
        tableView.backgroundColor = UIColor.clearColor()
        
        
        
        do {
            if let frc = fetchedResultsController {
                try frc.performFetch()
            }
        } catch let error {
            print("NSFetchedResultsController.performFetch() failed: \(error)")
        }
        
//        if !hasReadAllData {
//            dataRecorder.readAllRecords()
//            print(dataRecorder.records.count)
//            hasReadAllData = true
//        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return fetchedResultsController?.sections?.count ?? 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections where sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
//        return dataRecorder.records.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController?.sections where sections.count > 0 {
            var year = 0
            var month = ""
            
            if let yearAndMonth = Int(sections[section].name) {
                year = yearAndMonth / 100
                month = String(Month(rawValue: yearAndMonth % 100)!)
            }
            return "\(month), \(year)"
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
    
//    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
//        return fetchedResultsController?.sectionIndexTitles
//    }
//    
//    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
//        return fetchedResultsController?.sectionForSectionIndexTitle(title, atIndex: index) ?? 0
//    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultTableViewCell", forIndexPath: indexPath)
        
        if let rideRecord = fetchedResultsController?.objectAtIndexPath(indexPath) as? RideRecord {
            var record = Record()
            rideRecord.managedObjectContext?.performBlockAndWait {
                if let calories = rideRecord.calories as? Double,
                    let distance = rideRecord.distance as? Double,
                    let duration = rideRecord.duration as? Double,
                    let date = rideRecord.date
                {
                    record = Record(calories: calories, distance: distance, date: date, duration: duration, paths: [])
                }
                
            }

            if let resultTableViewCell = cell as? ResultTableViewCell {
                resultTableViewCell.record = record
            }
            
        }
        
        
//        let record = dataRecorder.records[indexPath.row]
//        
//        if let resultTableViewCell = cell as? ResultTableViewCell {
//            resultTableViewCell.record = record
//        }
        
        
        return cell
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !isShowingLeftSideMenu {
            let resultVC = self.storyboard?.instantiateViewControllerWithIdentifier(ResultViewController.Constant.Identifier) as! ResultViewController
            if let rideRecord = fetchedResultsController?.objectAtIndexPath(indexPath) as? RideRecord {
                resultVC.date = rideRecord.date!
            }
//            resultVC.date = dataRecorder.records[indexPath.row].date
            self.navigationController?.pushViewController(resultVC, animated: true)
//            parentVC.parentVC.scrollView.scrollEnabled = false
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    
    deinit {
        print("HistoryTableViewController Detroyed!!")
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
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

}

extension HistoryTableViewController {
    class func controller() -> HistoryTableViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(Constant.Identifier) as! HistoryTableViewController
    }
}
