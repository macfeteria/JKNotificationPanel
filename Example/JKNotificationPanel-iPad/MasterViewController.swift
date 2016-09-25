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
        demoList.append("Subtitle")
        
        let header = self.tableView.dequeueReusableCell(withIdentifier: "header")
        header?.textLabel?.text = "JKNotificationPanel"
        self.tableView.tableHeaderView = header
        
        if let split = self.splitViewController {
            
            split.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
            
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.index = (indexPath as NSIndexPath).row
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = demoList[(indexPath as NSIndexPath).row]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 7 {
            panel.timeUntilDismiss = 2
            let text = "The Panel display on the top of the table (MasterView)"
            panel.showNotify(withStatus: .warning, inView:self.tableView, title: text)

        }
    }
    
    
}
