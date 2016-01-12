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


class JKViewController: UIViewController,JKNotificationPanelDelegate {
    
    var panel = JKNotificationPanel()
    var defaultView:JKDefaultView?
    var demoList = [String] ()
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "JK Demo"
        
        demoList.append("Success")
        demoList.append("Custom color")
        demoList.append("Warning")
        demoList.append("Failed")
        demoList.append("Long text")
        demoList.append("Custom View")
        demoList.append("Wait until tap")
        demoList.append("On TableView")
        demoList.append("On Navigation")
        demoList.append("Delegate")
        demoList.append("Completion and Alert")
        
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
        panel.delegate = nil
        
        switch indexPath.row {
        case 0:
            panel.showNotify(withStatus: .SUCCESS, belowNavigation: self.navigationController!)
        case 1:
            let view = panel.defaultView(.SUCCESS, message: "Success with custom color")
            view.setColor(UIColor(red: 67.0/255.0, green: 69.0/255.0, blue: 80.0/255.0, alpha: 1))
            panel.showNotify(withView: view, belowNavigation: self.navigationController!)
        case 2:
            panel.showNotify(withStatus: .WARNING, belowNavigation: self.navigationController!)
        case 3:
            panel.showNotify(withStatus: .FAILED, belowNavigation: self.navigationController!)
        case 4:
            let longtext = "Guus Hiddink meeting the Chelsea players after the game."
            panel.showNotify(withStatus: .SUCCESS, belowNavigation: self.navigationController!, message: longtext)
        case 5:
            let nib = UINib(nibName: "CustomNotificationView", bundle: NSBundle(forClass: self.dynamicType))
            let customView  = nib.instantiateWithOwner(nil, options: nil).first as! UIView
            let width:CGFloat = UIScreen.mainScreen().bounds.size.width
            customView.frame = CGRectMake(0, 0, width, 20)
            panel.showNotify(withView: customView, belowNavigation: self.navigationController!)
        case 6:
            panel.timeUntilDismiss = 0 // zero for wait forever
            panel.enableTabDismiss = true
            panel.showNotify(withStatus: .SUCCESS, belowNavigation: self.navigationController!, message: "Tap me to dissmiss")
        case 7:
            let text = "The Panel display on the top of the table, pull the table to see the result and tap the panel to dismiss"
            panel.timeUntilDismiss = 0
            panel.enableTabDismiss = true
            panel.showNotify(withStatus: .WARNING, inView:self.tableView, message: text)
        case 8:
            let navView = self.navigationController?.view
            panel.showNotify(withStatus: .SUCCESS, inView: navView!)
        case 9:
            panel.delegate = self
            panel.showNotify(withStatus: .SUCCESS, belowNavigation: self.navigationController!, message: "Alert after notifying done (Delegate style)")
        case 10:
            
            panel.timeUntilDismiss = 0
            panel.enableTabDismiss = false
            panel.addPanelDidTabAction() {
                self.notificationPanelDidTab()
            }
            panel.showNotify(withStatus: .SUCCESS, belowNavigation: self.navigationController!, message: "Tab me to show alert")
            
        default: break
        }
    }
    
    // Delegate
    
    func notificationPanelDidTab() {
        let alert = UIAlertController(title: "Hello!!", message: "This is an example of how to work with completion block.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
            self.panel.dismissNotify()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func notificationPanelDidDismiss() {
        
        let alert = UIAlertController(title: "Nofity Completed", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func notifyCompleted() {
        let alert = UIAlertView()
        alert.title = "Nofity Completed"
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
}
