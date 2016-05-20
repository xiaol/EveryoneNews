//
//  HeadPhotoView.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

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
class HeadPhotoView:UIImageView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.height/2
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
        
        print(self.frame.height)
        
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