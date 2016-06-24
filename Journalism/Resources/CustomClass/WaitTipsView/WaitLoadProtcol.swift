//
//  WaitLoadProtcol.swift
//  Journalism
//
//  Created by Mister on 16/6/13.
//  Copyright © 2016年 aimobier. All rights reserved.
//


import UIKit
import SnapKit

protocol WaitLoadProtcol {}
extension WaitLoadProtcol where Self:UIViewController{

    func showFontSizeSlideView(){
    
        let view = FontSizeSlideView(frame: CGRectZero)
        
        view.bbackView.alpha = 0
        
        self.view.addSubview(view)
        view.snp_makeConstraints { (make) in
            
            make.topMargin.equalTo(self.view.snp_top).offset(0)
            make.bottomMargin.equalTo(self.view.snp_bottom).offset(0)
            make.leftMargin.equalTo(self.view.snp_left).offset(0)
            make.rightMargin.equalTo(self.view.snp_right).offset(0)
        }
        
        view.layoutIfNeeded()
        
        view.backView.transform = CGAffineTransformTranslate(view.backView.transform, 0, view.backView.frame.height)
        
        UIView.animateWithDuration(0.2, animations: {
            
            view.bbackView.alpha = 1
            
            }) { (_) in
                
                UIView.animateWithDuration(0.3) {
                    
                    view.backView.transform = CGAffineTransformIdentity
                }
        }
    }
    
    
    // 显示完成删除不感兴趣的新闻
    func showNoInterest(){
        
        NoInterestView.shareNoInterest.alpha = 1
        self.view.addSubview(NoInterestView.shareNoInterest)
        
        NoInterestView.shareNoInterest.snp_makeConstraints { (make) in
            
            make.height.equalTo(59)
            make.width.equalTo(178)
            make.center.equalTo(self.view.snp_center)
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1 * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), {
            UIView.animateWithDuration(0.5, animations: { 
                NoInterestView.shareNoInterest.alpha = 0
                }, completion: { (_) in
                    NoInterestView.shareNoInterest.removeFromSuperview()
            })
        })
    }
    

}

extension WaitLoadProtcol where Self:DetailViewController{
    
    // 显示等待视图
    func showWaitLoadView(){
        
        if self.waitView == nil {
            
            self.waitView = WaitView.shareWaitView
        }
        
        self.view.addSubview(self.waitView )
        
        self.waitView .snp_makeConstraints { (make) in
            
            make.topMargin.equalTo(self.view.snp_top).offset(0)
            make.bottomMargin.equalTo(self.view.snp_bottom).offset(0)
            make.leftMargin.equalTo(self.view.snp_left).offset(0)
            make.rightMargin.equalTo(self.view.snp_right).offset(0)
        }
    }
    
    // 隐藏等待视图
    func hiddenWaitLoadView(){
        
        if self.waitView != nil {
            
            self.waitView.removeFromSuperview()
            self.waitView = nil
        }
    }
}

extension WaitLoadProtcol where Self:NewslistViewController{
    
    // 显示等待视图
    func showWaitLoadView(){
        
        if self.waitView == nil {
            
            self.waitView = WaitView.shareWaitView
        }
        
        self.view.addSubview(self.waitView )
        
        self.waitView .snp_makeConstraints { (make) in
            
            make.topMargin.equalTo(self.view.snp_top).offset(0)
            make.bottomMargin.equalTo(self.view.snp_bottom).offset(0)
            make.leftMargin.equalTo(self.view.snp_left).offset(0)
            make.rightMargin.equalTo(self.view.snp_right).offset(0)
        }
    }
    
    // 隐藏等待视图
    func hiddenWaitLoadView(){
        
        if self.waitView != nil {
            
            self.waitView.removeFromSuperview()
            self.waitView = nil
        }
    }
}