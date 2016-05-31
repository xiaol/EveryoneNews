//
//  BorderView.swift
//  Journalism
//
//  Created by Mister on 16/5/31.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class DetailBorderView:UIView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 4
    }
}



///按钮扩展类
class InfoCommentsBottomBorderView:UIView{
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if true {
        
            let layout = CAShapeLayer()
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: 0, y: self.frame.size.height))
            path.addLineToPoint(CGPoint(x: self.frame.size.width, y: self.frame.size.height))
            
            path.lineWidth = 1
            UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
            path.stroke()
            
            layout.path = path.CGPath
        }
        
        if true {
        
            let size = CGSize(width: 600, height: 600)
            
            
            let titleWidth = NSString(string:"最新评论").boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil).width
            
            let layout = CAShapeLayer()
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: 0, y: self.frame.size.height))
            path.addLineToPoint(CGPoint(x: titleWidth, y: self.frame.size.height))
            
            path.lineWidth = 1
            UIColor(red: 0/255, green:145/255, blue: 250/255, alpha: 1).setStroke()
            path.stroke()
            
            layout.path = path.CGPath
        }
    }
}

