//
//  MasterViewController.swift
//  JKNotificationPanel-iPad
//
//  Created by Ter on 4/13/2559 BE.
//  Copyright © 2559 CocoaPods. All rights reserved.
//

import UIKit
import JKNotificationPanel


class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var demoList = [String] ()
    
    var panel = JKNotificationPanel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "JK Demo"
        
        demoList.append("Success")
        demoList.append("Success with Custom color")
        demoList.append("Warning")
        demoList.append("Failed")
        demoList.append("Long text")
        demoList.append("Custom View")
        demoList.append("Wait until tap")
        demoList.append("On TableView (Master)")
        demoList.append("On Navigation")
        demoList.append("Delegate")
        demoList.append("Completion and Alert")
        demoList.append("Success with custom Image and Text")
        
        let header = self.tableView.dequeueReusableCellWithIdentifier("header")
        header?.textLabel?.text = "JKNotificationPanel"
        self.tableView.tableHeaderView = header
        
        if let split = self.splitViewController {
            
            split.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.index = indexPath.row
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = demoList[indexPath.row]
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 7 {
            panel.timeUntilDismiss = 2
            let text = "The Panel display on the top of the table (MasterView)"
            panel.showNotify(withStatus: .WARNING, inView:self.tableView, message: text)

        }
    }
    
    
}
