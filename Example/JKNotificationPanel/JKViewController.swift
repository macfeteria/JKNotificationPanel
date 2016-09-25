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
        demoList.append("Subtitle")
        demoList.append("Failed")
        demoList.append("Long text")
        demoList.append("Custom View")
        demoList.append("Wait until tap")
        demoList.append("On TableView")
        demoList.append("On Navigation")
        demoList.append("Delegate")
        demoList.append("Completion and Alert")
        demoList.append("Success with custom Image and Text")
        
        let header = self.tableView.dequeueReusableCell(withIdentifier: "header")
        header?.textLabel?.text = "JKNotificationPanel"
        self.tableView.tableHeaderView = header
        
    }
    
    // Support oritation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.panel.transitionTo(size: self.view.frame.size)
            }, completion: nil)
    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = demoList[(indexPath as NSIndexPath).row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        // reset to default value
        
        panel.timeUntilDismiss = 2
        panel.enableTapDismiss = false
        panel.delegate = nil
        
        switch (indexPath as NSIndexPath).row {
            
        // Success
        case 0:
            panel.showNotify(withStatus: .success, belowNavigation: self.navigationController!)
        
        // Custom color
        case 1:
            let view = panel.createDefaultView(withStatus: .success, title: nil)
            view.setColor(UIColor(red: 67.0/255.0, green: 69.0/255.0, blue: 80.0/255.0, alpha: 1))
            panel.showNotify(withView: view, belowNavigation: self.navigationController!)
           
        // Warning
        case 2:
            panel.showNotify(withStatus: .warning, belowNavigation: self.navigationController!)

            
        // Subtitle
        case 3:
            panel.showNotify(withStatus: .warning, belowNavigation: self.navigationController!, title: "Chelsea Football Club", message: "I have to solve the situation because every game we concede two goals minimum.' - Antonio Conte speaking after the game.")
            
        // Failed
        case 4:
            panel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!)
        
        // Long Text
        case 5:
            let longtext = "Guus Hiddink meeting the Chelsea players after the game."
            panel.showNotify(withStatus: .success, belowNavigation: self.navigationController!, title: longtext)
        
        // Custom View
        case 6:
            let nib = UINib(nibName: "CustomNotificationView", bundle: Bundle(for: type(of: self)))
            let customView  = nib.instantiate(withOwner: nil, options: nil).first as! UIView
            let width:CGFloat = UIScreen.main.bounds.size.width
            customView.frame = CGRect(x: 0, y: 0, width: width, height: 42)
            panel.showNotify(withView: customView, belowNavigation: self.navigationController!)
        
        // Wait until tap
        case 7:
            let text = "Tap me to dissmiss"
            panel.timeUntilDismiss = 0 // zero for wait forever
            panel.enableTapDismiss = true
            panel.showNotify(withStatus: .success, belowNavigation: self.navigationController!, title: text)
        
        // On the top of table view
        case 8:
            let text = "The Panel display on the top of the table, pull the table to see the result and tap the panel to dismiss"
            panel.timeUntilDismiss = 0
            panel.enableTapDismiss = true
            panel.showNotify(withStatus: .warning, inView:self.tableView, title: text)
        
        // On navigation
        case 9:
            let navView = self.navigationController?.view
            panel.showNotify(withStatus: .success, inView: navView!)
        
        // Delegate
        case 10:
            let text = "Alert after notifying done (Delegate style)"
            panel.delegate = self
            panel.showNotify(withStatus: .success, belowNavigation: self.navigationController!, title: text)
        
        // Completion block
        case 11:
            let text = "Tab me to show alert"
            panel.timeUntilDismiss = 0
            panel.enableTapDismiss = false
            panel.setPanelDidTapAction() {
                self.notificationPanelDidTap()
            }
            panel.showNotify(withStatus: .success, belowNavigation: self.navigationController!, title: text)

        // Custom Image
        case 12:
            let view = panel.createDefaultView(withStatus: .success, title: "Success panel with custom Image and text")
            view.setImage(UIImage(named: "airplane-icon")!)
            panel.showNotify(withView: view, belowNavigation: self.navigationController!)
            
        default: break
        }
    }
    
    // Delegate
    
    func notificationPanelDidTap() {
        let alert = UIAlertController(title: "Hello!!", message: "This is an example of how to work with completion block.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert) -> Void in
            
            // Since alertview take 0.2 to dismiss, therefor fade animate must
            // longer than 0.2
            
            self.panel.dismiss(withFadeDuration: 0.4)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func notificationPanelDidDismiss() {
        
        let alert = UIAlertController(title: "Nofity Completed", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func notifyCompleted() {
        let alert = UIAlertView()
        alert.title = "Nofity Completed"
        alert.addButton(withTitle: "Ok")
        alert.show()
    }
    
}
