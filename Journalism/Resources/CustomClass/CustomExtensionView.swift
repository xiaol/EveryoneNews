//
//  HeadPhotoView.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

@IBDesignable
class AllTypeBoderView:UIView{
    
    @IBInspectable var topBorder:Bool = false
    @IBInspectable var topBorderWidth:CGFloat = 0
    @IBInspectable var topBorderColor:UIColor = UIColor.clearColor()
    @IBInspectable var topBorderInsets:UIEdgeInsets = UIEdgeInsetsZero
    
    
    @IBInspectable var bottomBorder:Bool = false
    @IBInspectable var bottomBorderWidth:CGFloat = 0
    @IBInspectable var bottomBorderColor:UIColor = UIColor.clearColor()
    @IBInspectable var bottomBorderInsets:UIEdgeInsets = UIEdgeInsetsZero
    
    
    @IBInspectable var LeftBorder:Bool = false
    @IBInspectable var LeftBorderWidth:CGFloat = 0
    @IBInspectable var LeftBorderColor:UIColor = UIColor.clearColor()
    @IBInspectable var LeftBorderInsets:UIEdgeInsets = UIEdgeInsetsZero
    
    
    @IBInspectable var RightBorder:Bool = false
    @IBInspectable var RightBorderWidth:CGFloat = 0
    @IBInspectable var RightBorderColor:UIColor = UIColor.clearColor()
    @IBInspectable var RightBorderInsets:UIEdgeInsets = UIEdgeInsetsZero
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if topBorder {
        
            let layout = CAShapeLayer()
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: topBorderInsets.left, y: topBorderInsets.top))
            path.addLineToPoint(CGPoint(x: self.frame.size.width-topBorderInsets.right, y: topBorderInsets.top))
            
            path.lineWidth = topBorderWidth
            topBorderColor.setStroke()
            path.stroke()
            
            layout.path = path.CGPath
        }
        
        if bottomBorder {
            
            let layout = CAShapeLayer()
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: bottomBorderInsets.left, y: self.frame.size.width-bottomBorderInsets.bottom))
            path.addLineToPoint(CGPoint(x: self.frame.size.width-topBorderInsets.right, y: self.frame.size.width-bottomBorderInsets.bottom))
            
            path.lineWidth = bottomBorderWidth
            bottomBorderColor.setStroke()
            path.stroke()
            
            layout.path = path.CGPath
        }
    }
}


///按钮扩展类
class BottomBoderView:UIView{
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let layout = CAShapeLayer()
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: self.frame.size.height))
        path.addLineToPoint(CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path.lineWidth = 0.5
        UIColor(red: 53/255, green:166/255, blue: 251/255, alpha: 0.8).setStroke()
        path.stroke()
        
        layout.path = path.CGPath
    }
}


///按钮扩展类
class LoginBoderView:UIView{
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let layout = CAShapeLayer()
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: self.frame.size.height))
        path.addLineToPoint(CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 0.8).setStroke()
        path.stroke()
        
        layout.path = path.CGPath
    }
}

class TopBorderView:UIView{

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let layout = CAShapeLayer()
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: self.frame.size.width, y: 0))
        
        path.lineWidth = 0.5
        UIColor(red: 200/255, green:200/255, blue: 200/255, alpha: 0.8).setStroke()
        path.stroke()
        
        layout.path = path.CGPath
    }
}

///按钮扩展类
class CircularTextField:UIView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderColor = UIColor.lightTextColor().CGColor
        self.layer.borderWidth = 0.1
    }
    
}

///圆形图片
class HeadPhotoView:UIImageView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).CGColor
        self.layer.borderWidth = 1
    }
}

///  原因按钮
class ReasonButton:UIButton {
    
    var clickSelected = false{
    
        didSet{
        
            self.layer.borderColor = clickSelected ? UIColor.redColor().colorWithAlphaComponent(0.7).CGColor : UIColor.lightGrayColor().CGColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        self.clickSelected = !clickSelected
    }
}

class CircularEditButton:UIButton {
 
    internal var CollectionViewDragIng = false{
    
        didSet{
        
            self.setTitleStatus()
        }
    }
    
    private var dragIngtitle = "  排序删除  "
    private var dragEdtitle = "  完成  "
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.redColor().CGColor
        self.layer.cornerRadius = 11
        
        self.clipsToBounds = true
        
        self.setTitleStatus()
    }
    
    private func setTitleStatus(){
        
        self.setTitle(CollectionViewDragIng ? dragEdtitle : dragIngtitle, forState: UIControlState.Normal)
        
        self.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        self.setTitleColor(UIColor.redColor(), forState: UIControlState.Disabled)
        
        self.setBackgroundColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.setBackgroundColor(UIColor.redColor(), forState: UIControlState.Highlighted)
        self.setBackgroundColor(UIColor.redColor(), forState: UIControlState.Selected)
        self.setBackgroundColor(UIColor.whiteColor(), forState: UIControlState.Disabled)
        
        self.layoutIfNeeded()
    }
}

private extension UIButton {
    func setBackgroundColor(color: UIColor?, forState state: UIControlState) {
        guard let color = color else { return setBackgroundImage(nil, forState: state) }
        setBackgroundImage(UIImage.imageColored(color), forState: state)
    }
}

private extension UIImage {
    class func imageColored(color: UIColor) -> UIImage! {
        let onePixel = 1 / UIScreen.mainScreen().scale
        let rect = CGRect(x: 0, y: 0, width: onePixel, height: onePixel)
        UIGraphicsBeginImageContextWithOptions(rect.size, CGColorGetAlpha(color.CGColor) == 1, 0)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}