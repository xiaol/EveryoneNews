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
    
    // 显示等待视图
    func showWaitLoadView(){
    
        self.view.addSubview(WaitView.shareWaitView)
        
        WaitView.shareWaitView.snp_makeConstraints { (make) in
            
            make.topMargin.equalTo(self.view.snp_top).offset(0)
            make.bottomMargin.equalTo(self.view.snp_bottom).offset(0)
            make.leftMargin.equalTo(self.view.snp_left).offset(0)
            make.rightMargin.equalTo(self.view.snp_right).offset(0)
        }
    }
    
    // 隐藏等待视图
    func hiddenWaitLoadView(){
    
        WaitView.shareWaitView.removeFromSuperview()
    }
}