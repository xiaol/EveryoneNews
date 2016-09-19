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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let layout1 = CAShapeLayer()
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 0, y: 0))
        path1.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        
        path1.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path1.stroke()
        layout1.path = path1.cgPath
        
        
        let layout2 = CAShapeLayer()
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 23, y: self.frame.size.height))
        path2.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path2.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path2.stroke()
        
        layout2.path = path2.cgPath
    }
}

class UserBottomtoTopBoderView:UIView{
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let layout1 = CAShapeLayer()
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 23, y: 0))
        path1.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        
        path1.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path1.stroke()
        layout1.path = path1.cgPath
        
        
        let layout2 = CAShapeLayer()
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 0, y: self.frame.size.height))
        path2.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path2.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path2.stroke()
        
        layout2.path = path2.cgPath
    }
}



// - ---- - - - -  设置 UIView

class touchView:UIView{

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
     
        self.backgroundColor = UIColor.lightGray
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        self.backgroundColor = UIColor.white
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesCancelled(touches, with: event)
        
        self.backgroundColor = UIColor.white
    }
}


///按钮扩展类
class SetttingToptoBottomBoderView:touchView{
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let layout1 = CAShapeLayer()
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 0, y: 0))
        path1.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        
        path1.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path1.stroke()
        layout1.path = path1.cgPath
        
        
        let layout2 = CAShapeLayer()
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 59, y: self.frame.size.height))
        path2.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path2.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path2.stroke()
        
        layout2.path = path2.cgPath
    }
}

class SetttingBottomtoTopBoderView:touchView{
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let layout1 = CAShapeLayer()
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 59, y: 0))
        path1.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        
        path1.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path1.stroke()
        layout1.path = path1.cgPath
        
        
        let layout2 = CAShapeLayer()
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 0, y: self.frame.size.height))
        path2.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path2.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path2.stroke()
        
        layout2.path = path2.cgPath
    }
}

///按钮扩展类
class SetttingTopAndBottomBoderView:touchView{

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let layout1 = CAShapeLayer()
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 0, y: 0))
        path1.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        
        path1.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path1.stroke()
        layout1.path = path1.cgPath
        
        
        let layout2 = CAShapeLayer()
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 0, y: self.frame.size.height))
        path2.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path2.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path2.stroke()
        
        layout2.path = path2.cgPath
    }
}


///按钮扩展类
class SetttingBottomBoderView:touchView{
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let layout2 = CAShapeLayer()
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 0, y: self.frame.size.height))
        path2.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        path2.lineWidth = 0.5
        UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
        path2.stroke()
        
        layout2.path = path2.cgPath
    }
}
