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
        
        self.setTitleColor(UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1), forState: UIControlState.Disabled)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.setBackgroundColor(UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1), forState: UIControlState.Disabled)
        self.setBackgroundColor(UIColor.redColor(), forState: UIControlState.Normal)
        
        self.layer.cornerRadius = 2
        
        self.clipsToBounds = true
        
        self.layer.borderWidth = enabled ? 0 : 1
        self.layer.borderColor = enabled ? UIColor.clearColor().CGColor : UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).CGColor
    }
    
    override var enabled: Bool{
    
        didSet{
        
            self.layer.borderWidth = enabled ? 0 : 1
            self.layer.borderColor = enabled ? UIColor.clearColor().CGColor : UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).CGColor
        }
    }
}
