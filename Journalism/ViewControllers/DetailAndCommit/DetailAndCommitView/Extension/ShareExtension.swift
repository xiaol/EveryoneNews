//
//  ShareExtension.swift
//  Journalism
//
//  Created by Mister on 16/6/2.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension DetailAndCommitViewController{

    @IBAction func touchShareButtonAction(sender: AnyObject) {
        
        self.shreContentViewMethod(false, animate: true)
    }
    
    @IBAction func touchMoreButtonAction(sender: AnyObject) {
     
        self.shreContentViewMethod(false, animate: true)
    }
    
    @IBAction func touchCancelButtonAction(sender: AnyObject) {
        
        self.shreContentViewMethod(true, animate: true)
    }
    
    @IBAction func touchCancelViewAction(sender: AnyObject) {
        
        self.shreContentViewMethod(true, animate: true)
    }
    
    func shreContentViewMethod(hidden:Bool = false,animate:Bool = true){
        
        let show = CGAffineTransformIdentity
        let hiddentran = CGAffineTransformTranslate(self.shareContentView.transform, 0, self.shareContentView.frame.height)
        
        UIView.animateWithDuration(animate ? 0.3 : 0) {
            
            self.shareBackView.alpha = hidden ? 0 : 1
            self.shareContentView.transform = hidden ? hiddentran : show
        }
    }
}