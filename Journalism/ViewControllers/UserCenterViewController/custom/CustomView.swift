//
//  CustomView.swift
//  Journalism
//
//  Created by Mister on 16/5/25.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

///按钮扩展类
class UserToptoBottomBoderView:UIView{
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let layout1 = CAShapeLayer()
        let path1 = UIBezierPath()
        path1.moveToPoint(CGPoint(x: 0, y: 0))
        path1.addLineToPoint(CGPoint(x: self.frame.size.width, y: 0))
        
        path1.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path1.stroke()
        layout1.path = path1.CGPath
        
        
        let layout2 = CAShapeLayer()
        let path2 = UIBezierPath()
        path2.moveToPoint(CGPoint(x: 23, y: self.frame.size.height))
        path2.addLineToPoint(CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path2.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path2.stroke()
        
        layout2.path = path2.CGPath
    }
}

class UserBottomtoTopBoderView:UIView{
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let layout1 = CAShapeLayer()
        let path1 = UIBezierPath()
        path1.moveToPoint(CGPoint(x: 23, y: 0))
        path1.addLineToPoint(CGPoint(x: self.frame.size.width, y: 0))
        
        path1.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path1.stroke()
        layout1.path = path1.CGPath
        
        
        let layout2 = CAShapeLayer()
        let path2 = UIBezierPath()
        path2.moveToPoint(CGPoint(x: 0, y: self.frame.size.height))
        path2.addLineToPoint(CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path2.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path2.stroke()
        
        layout2.path = path2.CGPath
    }
}



// - ---- - - - -  设置 UIView

///按钮扩展类
class SetttingToptoBottomBoderView:UIView{
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let layout1 = CAShapeLayer()
        let path1 = UIBezierPath()
        path1.moveToPoint(CGPoint(x: 0, y: 0))
        path1.addLineToPoint(CGPoint(x: self.frame.size.width, y: 0))
        
        path1.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path1.stroke()
        layout1.path = path1.CGPath
        
        
        let layout2 = CAShapeLayer()
        let path2 = UIBezierPath()
        path2.moveToPoint(CGPoint(x: 59, y: self.frame.size.height))
        path2.addLineToPoint(CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path2.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path2.stroke()
        
        layout2.path = path2.CGPath
    }
}

class SetttingBottomtoTopBoderView:UIView{
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let layout1 = CAShapeLayer()
        let path1 = UIBezierPath()
        path1.moveToPoint(CGPoint(x: 59, y: 0))
        path1.addLineToPoint(CGPoint(x: self.frame.size.width, y: 0))
        
        path1.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path1.stroke()
        layout1.path = path1.CGPath
        
        
        let layout2 = CAShapeLayer()
        let path2 = UIBezierPath()
        path2.moveToPoint(CGPoint(x: 0, y: self.frame.size.height))
        path2.addLineToPoint(CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path2.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path2.stroke()
        
        layout2.path = path2.CGPath
    }
}

///按钮扩展类
class SetttingTopAndBottomBoderView:UIView{
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let layout1 = CAShapeLayer()
        let path1 = UIBezierPath()
        path1.moveToPoint(CGPoint(x: 0, y: 0))
        path1.addLineToPoint(CGPoint(x: self.frame.size.width, y: 0))
        
        path1.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path1.stroke()
        layout1.path = path1.CGPath
        
        
        let layout2 = CAShapeLayer()
        let path2 = UIBezierPath()
        path2.moveToPoint(CGPoint(x: 0, y: self.frame.size.height))
        path2.addLineToPoint(CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path2.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path2.stroke()
        
        layout2.path = path2.CGPath
    }
}


///按钮扩展类
class SetttingBottomBoderView:UIView{
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let layout2 = CAShapeLayer()
        let path2 = UIBezierPath()
        path2.moveToPoint(CGPoint(x: 0, y: self.frame.size.height))
        path2.addLineToPoint(CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path2.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path2.stroke()
        
        layout2.path = path2.CGPath
    }
}