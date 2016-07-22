//
//  WaitLoadProtcol.swift
//  Journalism
//
//  Created by Mister on 16/6/13.
//  Copyright © 2016年 aimobier. All rights reserved.
//


import UIKit
import SnapKit

enum FState{

    case Success,Fail
}

protocol WaitLoadProtcol {}
extension WaitLoadProtcol where Self:UIViewController{

    /**
     显示关注成功页面
     */
    func ShowFouceView(state:FState = .Success){
    
        let fv = FoucsedView(frame: CGRectZero)
        self.view.addSubview(fv)
        
        fv.snp_makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.left.equalTo(0)
        }

        if state == .Fail {
        
            fv.title.text = "关注失败"
            fv.topLabel.text = "很抱歉，没有该来源信息"
            fv.bottom.text = "您的关注点，已经记录。敬请谅解"
        }else{
        
            fv.title.text = "关注成功"
            fv.topLabel.text = "你可以在[关注]频道"
            fv.bottom.text = "查看他更新的相关内容"
        }
        
        fv.mbackView.transform = CGAffineTransformScale(fv.mbackView.transform, 0, 0)
        fv.okImageView.transform = CGAffineTransformScale(fv.okImageView.transform, 0, 0)
        
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { 
            
            fv.mbackView.transform = CGAffineTransformIdentity
            
            }) { (_) in
                
                UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    
                    fv.okImageView.transform = CGAffineTransformIdentity
                    
                }) { (_) in
                    
                }
        }
        
        
//        let anim = CASpringAnimation(keyPath: "transform")
//        
//        anim.damping = 9
//        
//        anim.fromValue = NSValue(CATransform3D: CATransform3DMakeScale(0, 0, 0))
//        anim.toValue = NSValue(CATransform3D: CATransform3DMakeScale(1, 1, 1))
//        anim.duration = anim.settlingDuration
//        anim.fillMode = kCAFillModeForwards
//        
//        anim.delegate = fv
//        
//        fv.mbackView.layer.addAnimation(anim, forKey: "fuck")
    }
    
    
    /**
     显示字体大小
     */
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

extension WaitLoadProtcol where Self:SearchListViewController{
    
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