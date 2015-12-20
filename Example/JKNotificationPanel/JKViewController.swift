//
//  JKViewController.swift
//  JKNotificationPanel
//
//  Created by Ter on 12/20/2558 BE.
//  http://www.macfeteria.com
//  Copyright © 2558 CocoaPods. All rights reserved.
//

import UIKit
import JKNotificationPanel


class JKViewController: UIViewController {
    
    var panel = JKNotificationPanel()
    var defaultView:JKDefaultView?
    var demoList = [String] ()
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "JK Demo"
        
        demoList.append("Success")
        demoList.append("Warning")
        demoList.append("Failed")
        demoList.append("Long text")
        demoList.append("Custom View")
        demoList.append("Wait until tap")
        demoList.append("On TableView")
        demoList.append("From top of Navigation")
        
        let header = self.tableView.dequeueReusableCellWithIdentifier("header")
        header?.textLabel?.text = "JKNotificationPanel"
        self.tableView.tableHeaderView = header
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = demoList[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // reset to default value
        panel.timeUntilDismiss = 2
        panel.enableTabDismiss = false
        
        switch indexPath.row {
        case 0:
            panel.showNotify(withStatus: .SUCCESS, belowNavigation: self.navigationController!)
        case 1:
            panel.showNotify(withStatus: .WARNING, belowNavigation: self.navigationController!)
        case 2:
            panel.showNotify(withStatus: .FAILED, belowNavigation: self.navigationController!)
        case 3:
            let longtext = "Guus Hiddink meeting the Chelsea players after the game."
            panel.showNotify(withStatus: .SUCCESS, belowNavigation: self.navigationController!, message: longtext)
        case 4:
            let nib = UINib(nibName: "CustomNotificationView", bundle: NSBundle(forClass: self.dynamicType))
            let customView  = nib.instantiateWithOwner(nil, options: nil).first as! UIView
            let width:CGFloat = UIScreen.mainScreen().bounds.size.width
            customView.frame = CGRectMake(0, 0, width, 20)
            panel.showNotify(withView: customView, belowNavigation: self.navigationController!)
        case 5:
            panel.timeUntilDismiss = 0
            panel.enableTabDismiss = true
            panel.showNotify(withStatus: .SUCCESS, belowNavigation: self.navigationController!, message: "Tap me to dissmiss")
        case 6:
            let text = "A Panel alway display on the top of the table, tap to dismiss"
            panel.timeUntilDismiss = 0
            panel.enableTabDismiss = true
            panel.showNotify(withStatus: .WARNING, inView:self.tableView, message: text)
        case 7:
            let navView = self.navigationController?.view
            panel.showNotify(withStatus: .SUCCESS, inView: navView!)
        default: break
        }
    }
    
    
}
