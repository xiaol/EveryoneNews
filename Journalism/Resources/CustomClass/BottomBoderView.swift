//
//  BottomBoderView.swift
//  Journalism
//
//  Created by Mister on 16/5/16.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

///按钮扩展类
@IBDesignable
class BottomBoderView:UIView{
    
    @IBInspectable var bottomBorder:Bool = false
    @IBInspectable var bottomBorderColor:UIColor?
    @IBInspectable var bottomBorderWidth:CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        //// Bottom
        if self.bottomBorder {
            let layout = CAShapeLayer()
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: 0, y: self.frame.size.height))
            path.addLineToPoint(CGPoint(x: self.frame.size.width, y: self.frame.size.height))
            
            path.lineWidth = bottomBorderWidth
            (bottomBorderColor ?? UIColor.lightGrayColor()).setStroke()
            path.stroke()
            
            layout.path = path.CGPath
        }
    }
}