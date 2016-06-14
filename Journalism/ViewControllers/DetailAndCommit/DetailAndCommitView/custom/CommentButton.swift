//
//  CommentButton.swift
//  Journalism
//
//  Created by Mister on 16/6/2.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class CommentButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.setTitleColor(UIColor.a_color4, forState: UIControlState.Disabled)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.setBackgroundColor(UIColor.a_color11, forState: UIControlState.Disabled)
        self.setBackgroundColor(UIColor.redColor(), forState: UIControlState.Normal)
        
        self.layer.cornerRadius = 2
        
        self.clipsToBounds = true
        
        self.layer.borderWidth = enabled ? 0 : 1
        self.layer.borderColor = enabled ? UIColor.clearColor().CGColor : UIColor.a_color4.CGColor
    }
    
    override var enabled: Bool{
    
        didSet{
        
            self.layer.borderWidth = enabled ? 0 : 1
            self.layer.borderColor = enabled ? UIColor.clearColor().CGColor : UIColor.a_color4.CGColor
        }
    }
}
