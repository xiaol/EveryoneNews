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
    @IBInspectable var topBorderColor:UIColor = UIColor.clear
    @IBInspectable var topBorderInsets:UIEdgeInsets = UIEdgeInsets.zero
    
    
    @IBInspectable var bottomBorder:Bool = false
    @IBInspectable var bottomBorderWidth:CGFloat = 0
    @IBInspectable var bottomBorderColor:UIColor = UIColor.clear
    @IBInspectable var bottomBorderInsets:UIEdgeInsets = UIEdgeInsets.zero
    
    
    @IBInspectable var LeftBorder:Bool = false
    @IBInspectable var LeftBorderWidth:CGFloat = 0
    @IBInspectable var LeftBorderColor:UIColor = UIColor.clear
    @IBInspectable var LeftBorderInsets:UIEdgeInsets = UIEdgeInsets.zero
    
    
    @IBInspectable var RightBorder:Bool = false
    @IBInspectable var RightBorderWidth:CGFloat = 0
    @IBInspectable var RightBorderColor:UIColor = UIColor.clear
    @IBInspectable var RightBorderInsets:UIEdgeInsets = UIEdgeInsets.zero
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if topBorder {
        
            let layout = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: topBorderInsets.left, y: topBorderInsets.top))
            path.addLine(to: CGPoint(x: self.frame.size.width-topBorderInsets.right, y: topBorderInsets.top))
            
            path.lineWidth = topBorderWidth
            topBorderColor.setStroke()
            path.stroke()
            
            layout.path = path.cgPath
        }
        
        if bottomBorder {
            
            let layout = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: bottomBorderInsets.left, y: self.frame.size.width-bottomBorderInsets.bottom))
            path.addLine(to: CGPoint(x: self.frame.size.width-topBorderInsets.right, y: self.frame.size.width-bottomBorderInsets.bottom))
            
            path.lineWidth = bottomBorderWidth
            bottomBorderColor.setStroke()
            path.stroke()
            
            layout.path = path.cgPath
        }
    }
}


///按钮扩展类
class BottomBoderView:UIView{
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let layout = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path.lineWidth = 0.5
        UIColor(red: 53/255, green:166/255, blue: 251/255, alpha: 0.8).setStroke()
        path.stroke()
        
        layout.path = path.cgPath
    }
}


///按钮扩展类
class LoginBoderView:UIView{
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let layout = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 0.8).setStroke()
        path.stroke()
        
        layout.path = path.cgPath
    }
}


///圆形图片
class CircularView:UIView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        self.layer.borderWidth = 1
        
        self.clipsToBounds = true
    }
}

///圆形图片
class CircularView1:UIView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        self.layer.borderWidth = 0
        
        self.clipsToBounds = true
    }
}


class TopBorderView:UIView{

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let layout = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        
        path.lineWidth = 0.5
        UIColor(red: 200/255, green:200/255, blue: 200/255, alpha: 0.8).setStroke()
        path.stroke()
        
        layout.path = path.cgPath
    }
}

///按钮扩展类
class CircularTextField:UIView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderColor = UIColor.lightText.cgColor
        self.layer.borderWidth = 0.1
    }
    
}

///  原因按钮
class ReasonButton:UIButton {
    
    var clickSelected = false{
    
        didSet{
        
            self.layer.borderColor = clickSelected ? UIColor.red.withAlphaComponent(0.7).cgColor : UIColor.lightGray.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.clickSelected = !clickSelected
    }
}

class CircularEditButton:UIButton {
 
    internal var CollectionViewDragIng = false{
    
        didSet{
        
            self.setTitleStatus()
        }
    }
    
    fileprivate var dragIngtitle = "  排序删除  "
    fileprivate var dragEdtitle = "  完成  "
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.cornerRadius = 11
        
        self.clipsToBounds = true
        
        self.setTitleStatus()
    }
    
    fileprivate func setTitleStatus(){
        
        self.setTitle(CollectionViewDragIng ? dragEdtitle : dragIngtitle, for: UIControlState())
        
        self.setTitleColor(UIColor.red, for: UIControlState())
        self.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        self.setTitleColor(UIColor.white, for: UIControlState.selected)
        self.setTitleColor(UIColor.red, for: UIControlState.disabled)
        
        self.setBackgroundColor(UIColor.white, forState: UIControlState())
        self.setBackgroundColor(UIColor.red, forState: UIControlState.highlighted)
        self.setBackgroundColor(UIColor.red, forState: UIControlState.selected)
        self.setBackgroundColor(UIColor.white, forState: UIControlState.disabled)
        
        self.layoutIfNeeded()
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor?, forState state: UIControlState) {
        guard let color = color else { return setBackgroundImage(nil, for: state) }
        setBackgroundImage(UIImage.imageColored(color), for: state)
    }
}

extension UIImage {
    class func imageColored(_ color: UIColor) -> UIImage! {
        let onePixel = 1 / UIScreen.main.scale
        let rect = CGRect(x: 0, y: 0, width: onePixel, height: onePixel)
        UIGraphicsBeginImageContextWithOptions(rect.size, color.cgColor.alpha == 1, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
