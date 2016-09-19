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
        
        self.setTitleColor(UIColor.a_color4, for: UIControlState.disabled)
        self.setTitleColor(UIColor.white, for: UIControlState())
        
        self.setBackgroundColor(UIColor.a_color11, forState: UIControlState.disabled)
        self.setBackgroundColor(UIColor.red, forState: UIControlState())
        
        self.layer.cornerRadius = 2
        
        self.clipsToBounds = true
        
        self.layer.borderWidth = isEnabled ? 0 : 1
        self.layer.borderColor = isEnabled ? UIColor.clear.cgColor : UIColor.a_color4.cgColor
    }
    
    override var isEnabled: Bool{
    
        didSet{
        
            self.layer.borderWidth = isEnabled ? 0 : 1
            self.layer.borderColor = isEnabled ? UIColor.clear.cgColor : UIColor.a_color4.cgColor
        }
    }
}
