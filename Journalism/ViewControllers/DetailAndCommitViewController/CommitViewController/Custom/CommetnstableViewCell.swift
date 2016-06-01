//
//  CommetnstableViewCell.swift
//  Journalism
//
//  Created by Mister on 16/6/1.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class CommentsTableViewHeader: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        self.layer.borderColor = UIColor.clearColor().CGColor
        
        if true {
            
            let layout = CAShapeLayer()
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: 18, y: self.frame.size.height))
            path.addLineToPoint(CGPoint(x: self.frame.size.width-18, y: self.frame.size.height))
            
            path.lineWidth = 1
            UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).setStroke()
            path.stroke()
            
            layout.path = path.CGPath
        }
        
        if true {
            
            let size = CGSize(width: 600, height: 600)
            
            let titleWidth = NSString(string:titleLabel.text!).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil).width
            
            let layout = CAShapeLayer()
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: 18, y: self.frame.size.height))
            path.addLineToPoint(CGPoint(x: titleWidth+18+3, y: self.frame.size.height))
            
            path.lineWidth = 1
            UIColor(red: 0/255, green:145/255, blue: 250/255, alpha: 1).setStroke()
            path.stroke()
            
            layout.path = path.CGPath
        }
    }
}
