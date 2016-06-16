//
//  HistroyViewController.swift
//  Mr-Ride-iOS
//
//  Created by SK on 5/24/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit
import CoreData


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
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chartContainerView: UIView!
    private var chartView: ChartView!
    private var isFirstLaunched = true
    private var distances = [Double]()
    private let maxDataPointsOnChart = 14 // this should be multiple of 7
    
//    private var historyTableViewController: HistoryTableViewController!

    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    lazy var fetchedResultsController: NSFetchedResultsController? = {
        let fetchRequest = NSFetchRequest(entityName: "RideRecord")
        let dateForSectionsSortDescriptor = NSSortDescriptor(key: "dateForSections", ascending: false)
        let dateSortDescriptor = NSSortDescriptor(key: "date",  ascending: false)
        fetchRequest.sortDescriptors = [dateForSectionsSortDescriptor, dateSortDescriptor]
        
        // Need to be further consider whether ! is good or not
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "headerForSection", cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mrLightblueColor()
        
        self.navigationController?.navigationBar.topItem?.title = "History"
        
//        historyTableViewController.isShowingLeftSideMenu = isShowingLeftSideMenu
//        historyTableViewController.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        
        let cellReuseIdentifier = "ResultTableViewCell"
        let nib = UINib(nibName: cellReuseIdentifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellReuseIdentifier)
        
        let headerViewIdentifier = HeaderView.Constant.Identifier
        let headerViewNib = UINib(nibName: headerViewIdentifier, bundle: nil)
//        tableView.registerNib(headerViewNib, forCellReuseIdentifier: headerViewIdentifier)
        tableView.registerNib(headerViewNib, forHeaderFooterViewReuseIdentifier: headerViewIdentifier)
        //        self.navigationController?.navigationBarHidden = true


        tableView.backgroundColor = UIColor.clearColor()
        
        
        
        
        do {
            if let frc = fetchedResultsController {
                try frc.performFetch()
            }
        } catch let error {
            print("NSFetchedResultsController.performFetch() failed: \(error)")
        }
        
        if let fetchedResults = fetchedResultsController?.fetchedObjects as? [RideRecord] {
            distances = fetchedResults.map {$0.distance!.doubleValue}
        }
        
        
        
        
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
    
    override func viewDidLayoutSubviews() {
        if isFirstLaunched {
            chartView = ChartView(frame: CGRect(x: 0.0, y: 0.0, width: chartContainerView.bounds.size.width, height: chartContainerView.bounds.size.height))
            chartView.backgroundColor = UIColor.clearColor()
            
            let endIndex = min(distances.count, maxDataPointsOnChart)
            let distancesSlice = distances[0..<endIndex]
            let distancesOnChart = (endIndex < maxDataPointsOnChart) ? Array(distancesSlice) + [Double](count: maxDataPointsOnChart-endIndex, repeatedValue: 0.0) : Array(distancesSlice)
            chartView.graphPoints = distancesOnChart.reverse()
            chartView.needsToMarkToday = false
            chartContainerView.addSubview(chartView)
            chartContainerView.backgroundColor = .clearColor()
            
            isFirstLaunched = !isFirstLaunched
        }
    }
    
    
    deinit {
        print("HistoryViewController destroy!")
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
//        historyTableViewController = segue.destinationViewController as! HistoryTableViewController
        
//    }
 

}



//extension HistoryViewController: HistoryTableViewControllerDelegate {
//    
//}


extension HistoryViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}

// MARK: - Table view data source
extension HistoryViewController: UITableViewDataSource {
    
    private func getFetchObjectsIndexFromIndexPath(indexPath: NSIndexPath) -> Int {
        
        var index = 0
        
        for section in 0..<indexPath.section {
            index += tableView.numberOfRowsInSection(section)
        }
        
        index += indexPath.row
        
        return index
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
        
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderView.Constant.Identifier) as! HeaderView
        headerView.headerTitleLabel.text = fetchedResultsController?.sections?[section].name
        
        return headerView
    }
    
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 34.0
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 10))
        footerView.backgroundColor = .clearColor()
        return footerView
    }
    
    //    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    //        return fetchedResultsController?.sectionIndexTitles
    //    }
    //
    //    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
    //        return fetchedResultsController?.sectionForSectionIndexTitle(title, atIndex: index) ?? 0
    //    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultTableViewCell", forIndexPath: indexPath)
        
        if let rideRecord = fetchedResultsController?.objectAtIndexPath(indexPath) as? RideRecord {
            var record = Record()
            rideRecord.managedObjectContext?.performBlockAndWait {
                if let calories = rideRecord.calories as? Double,
                    let distance = rideRecord.distance as? Double,
                    let duration = rideRecord.duration as? Double,
                    let date = rideRecord.date {
                    record = Record(calories: calories, distance: distance, date: date, duration: duration, paths: [])
                }
                
            }
            
            if let resultTableViewCell = cell as? ResultTableViewCell {
                resultTableViewCell.record = record
            }
            
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
}

// MARK: - Table view delegate
extension HistoryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !isShowingLeftSideMenu {
            let resultVC = self.storyboard?.instantiateViewControllerWithIdentifier(ResultViewController.Constant.Identifier) as! ResultViewController
            if let rideRecord = fetchedResultsController?.objectAtIndexPath(indexPath) as? RideRecord {
                resultVC.date = rideRecord.date!
            }

            self.navigationController?.pushViewController(resultVC, animated: true)
            parentVC.scrollView.scrollEnabled = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView === tableView {
            if let topVisibleIndexPath = tableView.indexPathsForVisibleRows?.first {
                let fetchObjectsIndex = getFetchObjectsIndexFromIndexPath(topVisibleIndexPath)
                
                let startIndex = fetchObjectsIndex
                let endIndex = min(distances.count, startIndex + maxDataPointsOnChart)
                let distancesSlice = distances[startIndex..<endIndex]
                let distancesOnChart = (endIndex-startIndex < maxDataPointsOnChart) ? Array(distancesSlice) + [Double](count: maxDataPointsOnChart-(endIndex-startIndex), repeatedValue: 0.0) : Array(distancesSlice)
                chartView.graphPoints = distancesOnChart.reverse()
                
            }
//            let fetchObjectsIndex = getFetchObjectsIndexFromIndexPath(tableView.indexPathsForVisibleRows?.first?)
//            print(tableView.visibleCells.first)
//            print(tableView.indexPathsForVisibleRows)
//            
//            print(tableView.visibleCells.count)
        }
    }

}


extension HistoryViewController {
    class func controller() -> HistoryViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(Constant.Identifier) as! HistoryViewController
    }
}
