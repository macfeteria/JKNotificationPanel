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

open class JKNotificationPanel: NSObject {
    
    let defaultViewHeight:CGFloat = 42.0

    open var enableTapDismiss = true
    open var timeUntilDismiss:TimeInterval = 2
    open var delegate:JKNotificationPanelDelegate!
    
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
    
    
    fileprivate func frameRect(_ size:CGSize? = nil) -> CGRect {
        var height:CGFloat = defaultViewHeight
        var width:CGFloat = UIScreen.main.bounds.size.width
        
        if let size = size {
            height = size.height
            width = size.width
        }
        
        return CGRect(x: 0, y: 0, width: width,  height: height)
        
    }
    
    open func transitionTo(size:CGSize) {
        
        if let jkview = self.withView as? JKDefaultView {
            jkview.transitionTo(size: size)
        }
        
        if let jkSubview = self.withView as? JKSubtitleView {
            jkSubview.transitionTo(size: size)
        }
        
        if let navBar  = self.navigationBar , let view = self.view {
            let navHeight = navBar.frame.height + UIApplication.shared.statusBarFrame.size.height
            verticalSpace = navHeight
            view.frame = CGRect(x: 0, y: self.verticalSpace, width: view.frame.width, height: view.frame.height)
        }
    }
    
    
    open func createDefaultView(withStatus:JKStatus, title:String?, size:CGSize? = nil) -> JKDefaultView {
        let view = JKDefaultView(frame: frameRect(size))
        view.setPanelStatus(withStatus)
        view.setTitle(title)
        return view
    }


    open func createSubtitleView(withStatus:JKStatus, title:String?, message:String?, size:CGSize? = nil) -> JKSubtitleView {
        let view = JKSubtitleView(frame: frameRect(size))
        view.setPanelStatus(withStatus)
        view.setTitle(title)
        view.setMessage(message)
        return view
    }
    
    open func setPanelDidTapAction(_ action:@escaping ()->Void ) {
        tapAction = action
    }
    
    open func setPanelDidDissmissAction(_ action:@escaping ()->Void ) {
        dismissAction  = action
    }
    
    open func showNotify(withStatus status: JKStatus, belowNavigation navigation: UINavigationController, title:String? = nil , message:String? = nil) {
        navigationBar = navigation.navigationBar
        verticalSpace = navigation.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.size.height
        let panelSize = CGSize(width: navigation.navigationBar.frame.size.width, height: defaultViewHeight)

        if let message = message {
            let subtitleView = self.createSubtitleView(withStatus: status, title: title, message: message)
            self.showNotify(withView: subtitleView, inView: navigation.view)
        } else {
            let defaultView = self.createDefaultView(withStatus: status, title: title, size: panelSize)
            self.showNotify(withView: defaultView, inView: navigation.view)
        }
    }
    

    
    open func showNotify(withStatus status: JKStatus, inView view: UIView, title:String? = nil , message:String? = nil) {
        
        verticalSpace = 0
        let panelSize = CGSize(width: view.frame.size.width, height: defaultViewHeight)
        
        if let message = message {
            let subtitleView = self.createSubtitleView(withStatus: status, title: title, message: message)
            self.showNotify(withView: subtitleView, inView: view)
        }
        else {
            let defaultView = self.createDefaultView(withStatus: status,title: title,size: panelSize)
            self.showNotify(withView: defaultView, inView: view)
        }
    }
    
    open func showNotify(withView view: UIView,  belowNavigation navigation: UINavigationController , completion handler:(()->Void)? = nil) {
        navigationBar = navigation.navigationBar
        verticalSpace = navigation.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.size.height
        self.showNotify(withView: view, inView: navigation.view )
    }
    
    open func showNotify(withView view: UIView, inView: UIView) {
 
        reset()
 
        self.withView = view
        
        let width = inView.frame.width
        let height = view.frame.height
        let top = (-height/2.0) + verticalSpace
        
        self.view = UIView()
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(JKNotificationPanel.tapHandler))
        self.view.addGestureRecognizer(tapGesture)
        
        self.view.alpha = 1
        self.view.frame = CGRect(x: 0, y: top , width: width, height: height)
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(view)
        self.view.bringSubview(toFront: view)
        view.autoresizingMask = [.flexibleWidth]
        self.view.autoresizingMask = [.flexibleWidth]
        inView.addSubview(self.view)
        
        // Start Animate
        let expandView = {
            self.view.alpha = 1
            self.view.frame = CGRect(x: 0, y: self.verticalSpace, width: width, height: height + 5)
        }
        
        UIView.animate(withDuration: 0.2, animations: expandView, completion: { (success) -> Void in
            guard (self.view != nil) else { return }
            
            let resizeViewToDefault = {
                self.view.frame = CGRect(x: 0, y: self.verticalSpace , width: width, height: height)
            }
            
            let resizeViewToDefaultComplete = { (animateDone:Bool) -> Void in
                if self.timeUntilDismiss > 0 {
                    let prepareFade = {
                        self.view.alpha = 0.8
                    }
                    let prepareFadeComplete = { (animateDone:Bool) -> Void in
                        if animateDone == true {
                            self.animate(withFadeDuration: 0.2)
                        }
                    }
                    UIView.animate(withDuration: 0.1, delay: self.timeUntilDismiss, options: .allowUserInteraction, animations: prepareFade, completion: prepareFadeComplete)
                }
            }
            UIView.animate(withDuration: 0.2, animations: resizeViewToDefault , completion: resizeViewToDefaultComplete )
        })
    }
    
    
    func tapHandler () {
        if  enableTapDismiss ==   true {
            self.dismiss(withFadeDuration: 0.2)
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
    
    
    func animate(withFadeDuration fadeDuration:TimeInterval) {
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
        
        UIView.animate(withDuration: fadeDuration, animations: fade, completion: fadeComplete)
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
    
    open func dismiss(withFadeDuration fadeDuration:TimeInterval) {
        if fadeDuration == 0 {
            removePanelFromSuperView()
        }
        else {
            animate(withFadeDuration: fadeDuration)
        }
    }
    
}
