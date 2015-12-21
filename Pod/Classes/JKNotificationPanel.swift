//
//  JKNotificationPanel.swift
//  Pods
//
//  Created by Ter on 12/20/2558 BE.
//  http://www.macfeteria.com
//

import UIKit

public class JKNotificationPanel: NSObject {
    
    public var enableTabDismiss = true
    public var timeUntilDismiss:NSTimeInterval = 2

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
    
    public func showNotify(withView view: UIView,  belowNavigation navigation: UINavigationController) {
        verticalSpace = navigation.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
        self.showNotify(withView: view, inView: navigation.view)
    }
    
    public func showNotify(withStatus status: JKType, belowNavigation navigation: UINavigationController,message text:String? = nil) {
        
        verticalSpace = navigation.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
        let defaultView = self.defaultView(status,message: text)
        self.showNotify(withView: defaultView, inView: navigation.view)
    }
    
    public func showNotify(withStatus status: JKType, inView view: UIView, message text:String? = nil) {
        
        verticalSpace = 0
        let defaultView = self.defaultView(status,message: text)
        self.showNotify(withView: defaultView, inView: view)
    }
    
    public func showNotify(withView view: UIView,inView: UIView) {
        
        forceDismissNotify()
        
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
        
        
        let animateExpandSize = {
            self.view.alpha = 1
            self.view.frame = CGRectMake(0, self.verticalSpace, width, height + 5)
        }
        
        UIView.animateWithDuration(0.2, animations: animateExpandSize ) { (success) -> Void in
            
            guard (self.view != nil) else { return }
            
            let animateNormalSize = {
                self.view.frame = CGRectMake(0, self.verticalSpace , width, height)
            }
            
            let animateNormalSizeDone = { (animateDone:Bool) -> Void in
                if self.timeUntilDismiss > 0 {
                    
                    let animateFade = {
                        self.view.alpha = 0.8
                    }
                    
                    let animateFadeDone = { (animateDone:Bool) -> Void in
                        if animateDone == true {
                            self.dismissNotify()
                        }
                    }
                    
                    UIView.animateWithDuration(0.1, delay: self.timeUntilDismiss, options: .AllowUserInteraction, animations: animateFade, completion: animateFadeDone)
                }
            }
            
            UIView.animateWithDuration(0.2, animations: animateNormalSize , completion: animateNormalSizeDone )
        }
        
    }
    
    
    public func dismissNotify() {
        guard (self.view != nil) else {return}
        var frame = self.view.frame
        frame.size.height = -10
        
        let fade = {
            self.view.alpha = 0
            self.view.frame = frame
        }
        
        let fadeComplete = { (success:Bool) -> Void in
            self.forceDismissNotify()
        }
        
        UIView.animateWithDuration(0.2, animations: fade, completion: fadeComplete)
    }
    
    public func forceDismissNotify() {
        if let view = self.view {
            if let tab = self.tapGesture  {
                view.removeGestureRecognizer(tab)
            }
            view.removeFromSuperview()
            self.view = nil
        }
    }
    
}
