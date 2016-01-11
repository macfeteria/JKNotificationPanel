//
//  JKNotificationPanel.swift
//  Pods
//
//  Created by Ter on 12/20/2558 BE.
//  http://www.macfeteria.com
//

import UIKit

public protocol JKNotificationPanelDelegate {
    func notifyCompleted ()
}

public class JKNotificationPanel: NSObject {
    
    public var enableTabDismiss = true
    public var timeUntilDismiss:NSTimeInterval = 2
    public var delegate:JKNotificationPanelDelegate!
    
    var completionHandler:()->Void = { }
    var view:UIView!
    var tapGesture:UITapGestureRecognizer!
    var verticalSpace:CGFloat = 0
    var inview:UIView!
    
    
    public func defaultView(status:JKType, message:String?) -> JKDefaultView {
        let height:CGFloat = 42
        let width:CGFloat = UIScreen.mainScreen().bounds.size.width
        
        let view = JKDefaultView(frame: CGRectMake(0, 0, width, height))
        view.setPanelStatus(status)
        view.setMessage(message)
        
        return view
    }

    
    public func showNotify(withStatus status: JKType,
        belowNavigation navigation: UINavigationController, message text:String? = nil , completion handler:(()->Void)? = nil) {
        
        verticalSpace = navigation.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
        let defaultView = self.defaultView(status,message: text)
        self.showNotify(withView: defaultView, inView: navigation.view,completion:  handler)
    }
    
    public func showNotify(withStatus status: JKType, inView view: UIView, message text:String? = nil , completion handler:(()->Void)? = nil) {
        
        verticalSpace = 0
        let defaultView = self.defaultView(status,message: text)
        self.showNotify(withView: defaultView, inView: view,completion:  handler)
    }
    
    
    
    public func showNotify(withView view: UIView,  belowNavigation navigation: UINavigationController , completion handler:(()->Void)? = nil) {
        verticalSpace = navigation.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
        self.showNotify(withView: view, inView: navigation.view ,completion:  handler)
    }
    
    public func showNotify(withView view: UIView,inView: UIView, completion handler:(()->Void)? = nil ) {
        
        reset()
        
        if handler != nil {
            completionHandler = handler!
        }
        
        let width = inView.frame.width
        let height = view.frame.height
        let top = (-height/2.0) + verticalSpace
        
        self.view = UIView()
        
        if self.enableTabDismiss == true {
            self.tapGesture = UITapGestureRecognizer(target: self, action: "dismissNotify")
            self.view.addGestureRecognizer(tapGesture)
        }
        
        self.view.alpha = 0
        self.view.frame = CGRectMake(0, top , width, height)
        self.view.backgroundColor = UIColor.clearColor()
        self.view.addSubview(view)
        self.view.bringSubviewToFront(view)
        
        inView.addSubview(self.view)
        
        
        let expandView = {
            self.view.alpha = 1
            self.view.frame = CGRectMake(0, self.verticalSpace, width, height + 5)
        }
        
        UIView.animateWithDuration(0.2, animations: expandView ) { (success) -> Void in
            
            guard (self.view != nil) else { return }
            
            let resizeViewToDefault = {
                self.view.frame = CGRectMake(0, self.verticalSpace , width, height)
            }
            
            let resizeViewToDefaultComplete = { (animateDone:Bool) -> Void in
                if self.timeUntilDismiss > 0 {
                    
                    let prepareFade = {
                        self.view.alpha = 0.8
                    }
                    
                    let prepareFadeComplete = { (animateDone:Bool) -> Void in
                        if animateDone == true {
                            self.animateFade()
                        }
                    }
                    
                    UIView.animateWithDuration(0.1, delay: self.timeUntilDismiss, options: .AllowUserInteraction, animations: prepareFade, completion: prepareFadeComplete)
                }
            }
            
            UIView.animateWithDuration(0.2, animations: resizeViewToDefault , completion: resizeViewToDefaultComplete )
        }
        
    }
    
    
    func reset() {
        if let view = self.view {
            if let tab = self.tapGesture  {
                view.removeGestureRecognizer(tab)
            }
            view.removeFromSuperview()
            self.view = nil
        }
        
    }
    
    
    func animateFade() {
        guard (self.view != nil) else {return}
        var frame = self.view.frame
        frame.size.height = -10
        
        let fade = {
            self.view.alpha = 0
            self.view.frame = frame
        }
        
        let fadeComplete = { (success:Bool) -> Void in
            self.dismissNotify()
        }
        
        UIView.animateWithDuration(0.2, animations: fade, completion: fadeComplete)
    }
    
    public func dismissNotify() {
        if let view = self.view {
            if let tab = self.tapGesture  {
                view.removeGestureRecognizer(tab)
            }
            view.removeFromSuperview()
            self.view = nil
            
            
            if let delegate = self.delegate {
                delegate.notifyCompleted()
            } else {
                completionHandler()
            }

        }

    }
    
}
