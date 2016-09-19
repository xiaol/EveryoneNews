//
//  FoucsShareExt.swift
//  Journalism
//
//  Created by Mister on 16/7/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit


extension FocusViewController:ShareAlertDelegate{

    @IBAction func ClickMoreAction(_ sender:AnyObject){
        
        self.ShareAlertShow(self)
    }
    
    func ClickFontSize() {
        
        self.ShareAlertHidden()
        self.showFontSizeSlideView()
    }
    
    func ClickCancel() {
        
        self.ShareAlertHidden()
    }
    
    func ClickWeChatMoments() {
        self.ClickAlert()
    }
    
    func ClickWeChatFriends() {
        self.ClickAlert()
    }
    
    
    func ClickQQFriends() {
        self.ClickAlert()
    }
    
    func ClickSina() {
        self.ClickAlert()
    }
    
    func ClickSMS() {
        self.ClickAlert()
    }
    
    func ClickEmail() {
        self.ClickAlert()
    }
    
    func ClickCopyLink() {
        self.ClickAlert()
    }
    
    fileprivate func ClickAlert(){
        let alert = UIAlertController(title: nil, message: "暂不支持", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
