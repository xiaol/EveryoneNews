//
//  FoucsShareExt.swift
//  Journalism
//
//  Created by Mister on 16/7/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit


extension FocusViewController:ShareAlertDelegate,WaitLoadProtcol{

    @IBAction func ClickMoreAction(sender:AnyObject){
        
        self.ShareAlertShow(self)
    }
    
    func ClickFontSize() {
        
        self.ShareAlertHidden()
        self.showFontSizeSlideView()
    }
    
    func ClickCancel() {
        
        self.ShareAlertHidden()
    }
}