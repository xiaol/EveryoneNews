//
//  CopyLabel.swift
//  Journalism
//
//  Created by Mister on 16/6/12.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class CopyLabel: UILabel {
    
    override func canBecomeFirstResponder() -> Bool {
        
        return true
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        
        return action == #selector(NSObject.copy(_:))
    }

    override func copy(sender: AnyObject?) {
        
        let pboard = UIPasteboard.generalPasteboard()
        pboard.string = self.text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.attachTapHandler()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.attachTapHandler()
    }
    
    private func attachTapHandler(){
    
        let tap = UILongPressGestureRecognizer { (recongnizer) in
            
            if recongnizer.state != .Began {return}
            
            self.becomeFirstResponder()
            
            let menu = UIMenuController.sharedMenuController()
            menu.setTargetRect(self.frame, inView: self.superview!)
            menu.setMenuVisible(true, animated: true)
        }
        
        self.addGestureRecognizer(tap)
    }
}
