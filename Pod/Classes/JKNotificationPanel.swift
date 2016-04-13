//
//  JKNotificationPanel.swift
//  Pods
//
//  Created by Ter on 12/20/2558 BE.
//  http://www.macfeteria.com
//

import UIKit


public protocol JKNotificationPanelDelegate {
    func notificationPanelDidDismiss ()
    func notificationPanelDidTap()
}

public class JKNotificationPanel: NSObject {
    
    let defaultViewHeight:CGFloat = 42.0

    public var enableTapDismiss = true
    public var timeUntilDismiss:NSTimeInterval = 2
    public var delegate:JKNotificationPanelDelegate!
    
    var tapAction:(()->Void)? = nil
    var dismissAction:(()->Void)? = nil
    
    var completionHandler:()->Void = { }    
    var view:UIView!
    var tapGesture:UITapGestureRecognizer!
    var verticalSpace:CGFloat = 0
    
    var withView:UIView!
    var navigationBar:UINavigationBar?
    
    public override init() {
        super.init()
   }
    
    public func transitionToSize(size:CGSize) {
        
        if let jkview = self.withView as? JKDefaultView {
            jkview.transitionTosize(size)
        }
        
        if let navBar  = self.navigationBar , let view = self.view {
            let navHeight = navBar.frame.height + UIApplication.sharedApplication().statusBarFrame.size.height
            verticalSpace = navHeight
            view.frame = CGRectMake(0, self.verticalSpace, view.frame.width, view.frame.height)
        }
    }
    
    
    public func defaultView(status:JKType, message:String?, size:CGSize? = nil) -> JKDefaultView {
        
        var height:CGFloat = defaultViewHeight
        var width:CGFloat = UIScreen.mainScreen().bounds.size.width
        
        if let size = size {
            height = size.height
            width = size.width
        }
        
        let view = JKDefaultView(frame: CGRectMake(0, 0, width,  height))
        view.setPanelStatus(status)
        view.setMessage(message)
        
        return view
    }

    
    public func addPanelDidTapAction(action:()->Void ) {
        tapAction = action
    }
    
    public func addPanelDidDissmissAction(action:()->Void ) {
        dismissAction  = action
    }
    
    
    public func showNotify(withStatus status: JKType, belowNavigation navigation: UINavigationController, message text:String? = nil) {
        navigationBar = navigation.navigationBar
        verticalSpace = navigation.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
        let panelSize = CGSize(width: navigation.navigationBar.frame.size.width, height: defaultViewHeight)
        let defaultView = self.defaultView(status,message: text,size: panelSize)
        self.showNotify(withView: defaultView, inView: navigation.view)
    }
    
    public func showNotify(withStatus status: JKType, inView view: UIView, message text:String? = nil) {
        
        verticalSpace = 0
        let panelSize = CGSize(width: view.frame.size.width, height: defaultViewHeight)
        let defaultView = self.defaultView(status,message: text,size: panelSize)
        self.showNotify(withView: defaultView, inView: view)
    }
    
    
    
    public func showNotify(withView view: UIView,  belowNavigation navigation: UINavigationController , completion handler:(()->Void)? = nil) {
        navigationBar = navigation.navigationBar
        verticalSpace = navigation.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
        self.showNotify(withView: view, inView: navigation.view )
    }
    
    public func showNotify(withView view: UIView,inView: UIView) {
        
 
        reset()
 
        self.withView = view
        
        let width = inView.frame.width
        let height = view.frame.height
        let top = (-height/2.0) + verticalSpace
        
        self.view = UIView()
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(JKNotificationPanel.tapHandler))
        self.view.addGestureRecognizer(tapGesture)
        
        self.view.alpha = 1
        self.view.frame = CGRectMake(0, top , width, height)
        self.view.backgroundColor = UIColor.clearColor()
        self.view.addSubview(view)
        self.view.bringSubviewToFront(view)
        view.autoresizingMask = [.FlexibleWidth]
        self.view.autoresizingMask = [.FlexibleWidth]
        inView.addSubview(self.view)
        
        
        // Start Animate
        
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
                            self.animateFade(0.2)
                        }
                    }
                    
                    UIView.animateWithDuration(0.1, delay: self.timeUntilDismiss, options: .AllowUserInteraction, animations: prepareFade, completion: prepareFadeComplete)
                }
            }
            
            UIView.animateWithDuration(0.2, animations: resizeViewToDefault , completion: resizeViewToDefaultComplete )
        }
        
    }
    
    
    func tapHandler () {
        if  enableTapDismiss ==   true {
            self.dismissNotify()
        }
        
        if let delegate = self.delegate {
            delegate.notificationPanelDidTap()
        } else if let userTapAction = tapAction {
            userTapAction()
        }
        
    }
    
    func reset() {
        if let view = self.view {
            view.removeGestureRecognizer(self.tapGesture )
            view.removeFromSuperview()
            self.view = nil
            self.withView = nil
        }
    }
    
    
    func animateFade(duration:NSTimeInterval) {
        guard (self.view != nil) else {return}
        var frame = self.view.frame
        frame.size.height = -10
        
        let fade = {
            self.view.alpha = 0
            self.view.frame = frame
        }
        
        let fadeComplete = { (success:Bool) -> Void in
            self.removePanelFromSuperView()
        }
        
        UIView.animateWithDuration(duration, animations: fade, completion: fadeComplete)
    }
    
    func removePanelFromSuperView() {
        if let view = self.view {
            view.removeGestureRecognizer(self.tapGesture )
            view.removeFromSuperview()
            self.view = nil
            self.withView = nil
            
            if let delegate = self.delegate {
                delegate.notificationPanelDidDismiss()
            } else if let userDismissAction = dismissAction {
                userDismissAction()
            }
        }
    }
    
    public func dismissNotify(fadeDuration:NSTimeInterval = 0.2) {
        if fadeDuration == 0 {
            removePanelFromSuperView()
        }
        else {
            animateFade(fadeDuration)
        }
    }
    
}
