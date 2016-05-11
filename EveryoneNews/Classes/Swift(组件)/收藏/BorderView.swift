//
//  BorderView.swift
//  EveryoneNews
//
//  Created by Mister on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

///按钮扩展类
@IBDesignable
class BorderView:UIView{
    
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