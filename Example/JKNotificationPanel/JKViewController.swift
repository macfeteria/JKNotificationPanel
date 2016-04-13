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
        demoList.append("Success with Custom color")
        demoList.append("Warning")
        demoList.append("Failed")
        demoList.append("Long text")
        demoList.append("Custom View")
        demoList.append("Wait until tap")
        demoList.append("On TableView")
        demoList.append("On Navigation")
        demoList.append("Delegate")
        demoList.append("Completion and Alert")
        demoList.append("Success with custom Image and Text")
        
        let header = self.tableView.dequeueReusableCellWithIdentifier("header")
        header?.textLabel?.text = "JKNotificationPanel"
        self.tableView.tableHeaderView = header
        
    }
    
    // Support oritation
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.panel.transitionToSize(size)
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
        panel.enableTapDismiss = false
        panel.delegate = nil
        
        switch indexPath.row {
            
        // Success
        case 0:
            panel.showNotify(withStatus: .SUCCESS, belowNavigation: self.navigationController!)
        
        // Custom color
        case 1:
            let view = panel.defaultView(.SUCCESS, message: nil)
            view.setColor(UIColor(red: 67.0/255.0, green: 69.0/255.0, blue: 80.0/255.0, alpha: 1))
            panel.showNotify(withView: view, belowNavigation: self.navigationController!)
           
        // Warning
        case 2:
            panel.showNotify(withStatus: .WARNING, belowNavigation: self.navigationController!)
        
        // Failed
        case 3:
            panel.showNotify(withStatus: .FAILED, belowNavigation: self.navigationController!)
        
        // Long Text
        case 4:
            let longtext = "Guus Hiddink meeting the Chelsea players after the game."
            panel.showNotify(withStatus: .SUCCESS, belowNavigation: self.navigationController!, message: longtext)
        
        // Custom View
        case 5:
            let nib = UINib(nibName: "CustomNotificationView", bundle: NSBundle(forClass: self.dynamicType))
            let customView  = nib.instantiateWithOwner(nil, options: nil).first as! UIView
            let width:CGFloat = UIScreen.mainScreen().bounds.size.width
            customView.frame = CGRectMake(0, 0, width, 42)
            panel.showNotify(withView: customView, belowNavigation: self.navigationController!)
        
        // Wait until tap
        case 6:
            panel.timeUntilDismiss = 0 // zero for wait forever
            panel.enableTapDismiss = true
            panel.showNotify(withStatus: .SUCCESS, belowNavigation: self.navigationController!, message: "Tap me to dissmiss")
        
        // On the top of table view
        case 7:
            let text = "The Panel display on the top of the table, pull the table to see the result and tap the panel to dismiss"
            panel.timeUntilDismiss = 0
            panel.enableTapDismiss = true
            panel.showNotify(withStatus: .WARNING, inView:self.tableView, message: text)
        
        // On navigation
        case 8:
            let navView = self.navigationController?.view
            panel.showNotify(withStatus: .SUCCESS, inView: navView!)
        
        // Delegate
        case 9:
            panel.delegate = self
            panel.showNotify(withStatus: .SUCCESS, belowNavigation: self.navigationController!, message: "Alert after notifying done (Delegate style)")
        
        // Completion block
        case 10:
            
            panel.timeUntilDismiss = 0
            panel.enableTapDismiss = false
            panel.addPanelDidTapAction() {
                self.notificationPanelDidTap()
            }
            panel.showNotify(withStatus: .SUCCESS, belowNavigation: self.navigationController!, message: "Tab me to show alert")

        // Custom Image
        case 11:
            let view = panel.defaultView(.SUCCESS, message: "Success panel with custom Image and text")
            view.setImage(UIImage(named: "airplane-icon")!)
            panel.showNotify(withView: view, belowNavigation: self.navigationController!)
            
        default: break
        }
    }
    
    // Delegate
    
    func notificationPanelDidTap() {
        let alert = UIAlertController(title: "Hello!!", message: "This is an example of how to work with completion block.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
            
            // Since alertview take 0.2 to dismiss, therefor fade animate must
            // longer than 0.2
            
            self.panel.dismissNotify(0.4)
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
