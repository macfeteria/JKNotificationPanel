//
//  DetailViewController.swift
//  JKNotificationPanel-iPad
//
//  Created by Ter on 4/13/2559 BE.
//  Copyright © 2559 CocoaPods. All rights reserved.
//

import UIKit
import JKNotificationPanel

class DetailViewController: UIViewController,JKNotificationPanelDelegate {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var panel = JKNotificationPanel()
    
    
    var index: Int = 0
    
    func configureView() {
        
        // reset to default value
        
        panel.timeUntilDismiss = 2
        panel.enableTapDismiss = false
        panel.delegate = nil
        
        switch index {
            
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
            
        // Failed
        case 3:
            panel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!)
            
        // Long Text
        case 4:
            let longtext = "This is the very long text \"Offline Mode: Detailed product information, images and datasheets are not available when offline.\""
            panel.showNotify(withStatus: .success, belowNavigation: self.navigationController!, title: longtext)
            
        // Custom View
        case 5:
            let nib = UINib(nibName: "CustomNotificationView", bundle: Bundle(for: type(of: self)))
            let customView  = nib.instantiate(withOwner: nil, options: nil).first as! UIView
            let width:CGFloat = UIScreen.main.bounds.size.width
            customView.frame = CGRect(x: 0, y: 0, width: width, height: 42)
            panel.showNotify(withView: customView, belowNavigation: self.navigationController!)
            
        // Wait until tap
        case 6:
            panel.timeUntilDismiss = 0 // zero for wait forever
            panel.enableTapDismiss = true
            panel.showNotify(withStatus: .success, belowNavigation: self.navigationController!, title: "Tap me to dissmiss")
            
        // On the top of table view
        case 7:
            break
            
        // On navigation
        case 8:
            let navView = self.navigationController?.view
            panel.showNotify(withStatus: .success, inView: navView!)
            
        // Delegate
        case 9:
            panel.delegate = self
            panel.showNotify(withStatus: .success, belowNavigation: self.navigationController!, title: "Alert after notifying done (Delegate style)")
            
        // Completion block
        case 10:
            
            panel.timeUntilDismiss = 0
            panel.enableTapDismiss = false
            panel.setPanelDidTapAction() {
                self.notificationPanelDidTap()
            }
            panel.showNotify(withStatus: .success, belowNavigation: self.navigationController!, title: "Tab me to show alert")
            
        // Custom Image
        case 11:
            let view = panel.createDefaultView(withStatus: .success, title: "Success panel with custom Image and text")
            view.setImage(UIImage(named: "airplane-icon")!)
            panel.showNotify(withView: view, belowNavigation: self.navigationController!)
            
        // Subtitle
        case 12:
            
            panel.timeUntilDismiss = 0
            let message = "This is the very long text \"Offline Mode: Detailed product information, images and datasheets are not available when offline.\""
            let view =  panel.createSubtitleView(withStatus: .warning, title: "Not Enough space", message: message)
            view.setImage(UIImage(named: "airplane-icon")!)
            panel.showNotify(withView: view, belowNavigation: self.navigationController!)
    
            
        default: break
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("frame \(self.view.frame.size)")
    }
    
    
    // Support oritation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: ({ _ in
            self.panel.transitionTo(size: self.view.frame.size)
        }))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        presentAlert ()
    }
    
    func notifyCompleted() {
       presentAlert()
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Nofity Completed", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

