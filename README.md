# JKNotificationPanel


[![Version](https://img.shields.io/cocoapods/v/JKNotificationPanel.svg?style=flat)](http://cocoapods.org/pods/JKNotificationPanel)
[![License](https://img.shields.io/cocoapods/l/JKNotificationPanel.svg?style=flat)](http://cocoapods.org/pods/JKNotificationPanel)
[![Platform](https://img.shields.io/cocoapods/p/JKNotificationPanel.svg?style=flat)](http://cocoapods.org/pods/JKNotificationPanel)

Simple, Customizable notification panel,

![JKNotificationPanel](https://raw.githubusercontent.com/macfeteria/JKNotificationPanel/master/Screenshot/jknotification_screen.gif)

## Requirements

- Swift 3 ( Swift 2.3 use version 0.2 )
- Xcode 6
- iOS 8.0 or above

## Installation

JKNotificationPanel is available through [CocoaPods](http://cocoapods.org) and [Carthage](https://github.com/Carthage/Carthage).
### POD  
To install
it, simply add the following line to your Podfile:

```ruby
use_frameworks!
pod "JKNotificationPanel"
```
JKNotificationPanel written in Swift, you must explicitly include use_frameworks! to your Podfile or target to opt into using frameworks.
### Carthage
Create a Cartfile in your project directory and add the following line.
```ruby
github "macfeteria/JKNotificationPanel"
```
Run carthage update
This will build the framework. The framework will be within Carthage/build/JKNotificationPanel.framework.

# Usage
Using JKNotification panel is very easy.

### Basic Usage

First of all you need to create JKNotifictionPanel
```Swift
let panel = JKNotificationPanel()
```
### Displaying the basic panel
```Swift
panel.showNotify(withStatus: .success, inView: self.view, title: "Success to upload all images.")
```
### Displaying the panel below the navigation
```Swift
panel.showNotify(withStatus: .warning, belowNavigation: self.navigationController!)
```
### Subtitle View
```Swift
panel.showNotify(withStatus: .warning, belowNavigation: self.navigationController!, title: "Chelsea Football Club", message: "Chelsea 4 - 2 Leicester")
```
### Custom View
```Swift
let nib = UINib(nibName: "CustomNotificationView", bundle: Bundle(for: type(of: self)))
let customView  = nib.instantiate(withOwner: nil, options: nil).first as! UIView
let width:CGFloat = UIScreen.main.bounds.size.width
customView.frame = CGRect(x: 0, y: 0, width: width, height: 42)
panel.showNotify(withView: customView, belowNavigation: self.navigationController!)
```

### Tap to dismiss
```Swift
panel.timeUntilDismiss = 0 // zero for wait forever
panel.enableTapDismiss = true
panel.showNotify(withStatus: .success, belowNavigation: self.navigationController!, title: "Tap me to dismiss")

```


### Delegate
```Swift
func notificationPanelDidDismiss ()
func notificationPanelDidTap()
```

### User tap action
If you don't want to use delegate you can also use tap action instead.
```Swift
panel.timeUntilDismiss = 0 // zero for wait forever
panel.enableTapDismiss = false
panel.addPanelDidTapAction() {
self.notificationPanelDidTap()
}
panel.showNotify(withStatus: .success, belowNavigation: self.navigationController!, title: "Tap me to show alert")
```
### Orientation
JKNotificationPanel support orientation. Just call method 'transitionToSize' in ViewController
```Swift
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
super.viewWillTransition(to: size, with: coordinator)

coordinator.animate(alongsideTransition: { (context) in
self.panel.transitionTo(size: self.view.frame.size)
}, completion: nil)
}

```
## Author

Ter,
http://www.macfeteria.com

## License

JKNotificationPanel is available under the MIT license. See the LICENSE file for more info.
