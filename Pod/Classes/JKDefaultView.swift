//
//  JKDefaultView.swift
//  Pods
//
//  Created by Ter on 12/20/2558 BE.
//  http://www.macfeteria.com
//


private let VERTICAL_SPACE:CGFloat = 8
private let HORIZONTAL_SPACE:CGFloat = 8
private let ICON_HEIGHT:CGFloat = 26
private let ICON_WIDTH:CGFloat = 26


public enum JKType:Int {
    case SUCCESS
    case WARNING
    case FAILED
}


public class JKDefaultView: UIView {
    

    var imageIcon:UIImageView!
    var textLabel:UILabel!
    var baseView:UIView!
    
    
    override init (frame : CGRect) {
        
        super.init(frame : frame)

        imageIcon = UIImageView(frame: CGRectMake(VERTICAL_SPACE, HORIZONTAL_SPACE, ICON_WIDTH, ICON_HEIGHT))
        imageIcon.backgroundColor = UIColor.clearColor()
        
        let textLabelX = VERTICAL_SPACE + ICON_WIDTH + VERTICAL_SPACE
        textLabel = UILabel(frame: CGRectMake(textLabelX, HORIZONTAL_SPACE, frame.width - textLabelX - HORIZONTAL_SPACE, 26))
        textLabel.userInteractionEnabled = true
        textLabel.textColor = UIColor.whiteColor()
        baseView = UIView(frame: frame)
        baseView.backgroundColor = UIColor(red: 35.0/255.0, green: 160.0/255.0, blue: 73.0/255.0, alpha: 1)
        baseView.addSubview(imageIcon)
        baseView.addSubview(textLabel)
        self.addSubview(baseView)

    }
    
    public func transitionTosize(size:CGSize) {
        let xPosition = VERTICAL_SPACE + ICON_WIDTH + VERTICAL_SPACE
        self.frame.size = CGSize(width: size.width, height: self.frame.height)
        textLabel.frame.size = CGSize(width: size.width - xPosition - HORIZONTAL_SPACE, height: 26)
        baseView.frame.size = CGSize(width: size.width, height: baseView.frame.height)
        
        // adjust text label
        self.setMessage(textLabel.text)
    }
    
    public func setImage(icon:UIImage) {
        imageIcon.image = icon
    }
    
    
    public func setColor(color:UIColor) {
        self.baseView.backgroundColor = color
    }
    
    public func setMessage(text:String?) {
        
        guard (text != nil) else { return }
        
        textLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        textLabel.text = text
        textLabel.numberOfLines = 0
        textLabel.sizeToFit()
        
        textLabel.frame.origin.y = HORIZONTAL_SPACE + 2
        
        let height = textLabel.frame.height
        var frameHeight = (VERTICAL_SPACE * 2) + height
        if frameHeight < 44 { frameHeight = 44 }
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, frameHeight)
        baseView.frame = self.frame
        
    }
    
    
    func loadImageBundle(named imageName:String) ->UIImage? {
        let podBundle = NSBundle(forClass: self.classForCoder)
        if let bundleURL = podBundle.URLForResource("JKNotificationPanel", withExtension: "bundle")
        {
            let imageBundel = NSBundle(URL:bundleURL )
            let image = UIImage(named: imageName, inBundle: imageBundel, compatibleWithTraitCollection: nil)
            return image
        }
        return nil
    }
    
    public func setPanelStatus(status:JKType) {
        switch (status) {
        case .SUCCESS:
            imageIcon.image = loadImageBundle(named: "success-icon")
            textLabel.text = "Success"
            baseView.backgroundColor = UIColor(red: 35.0/255.0, green: 160.0/255.0, blue: 73.0/255.0, alpha: 1)
        case .WARNING:
            imageIcon.image = loadImageBundle(named: "warning-icon")
            textLabel.text = "Warning"
            baseView.backgroundColor = UIColor(red: 249.0/255.0, green: 169.0/255.0, blue: 69.0/255.0, alpha: 1)
        case .FAILED:
            imageIcon.image = loadImageBundle(named: "fail-icon")
            textLabel.text = "Failed"
            baseView.backgroundColor = UIColor(red: 67.0/255.0, green: 69.0/255.0, blue: 80.0/255.0, alpha: 1)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
