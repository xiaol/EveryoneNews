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

    case success,fail
}

protocol WaitLoadProtcol {}
extension WaitLoadProtcol where Self:UIViewController{

    /**
     显示关注成功页面
     */
    func ShowFouceView(_ state:FState = .success){
    
        let fv = FoucsedView(frame: CGRect.zero)
        self.view.addSubview(fv)
        
        fv.snp.makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.left.equalTo(0)
        }

        if state == .fail {
        
            fv.title.text = "关注失败"
            fv.topLabel.text = "很抱歉，没有该来源信息"
            fv.bottom.text = "您的关注点，已经记录。敬请谅解"
        }else{
        
            fv.title.text = "关注成功"
            fv.topLabel.text = "你可以在[关注]频道"
            fv.bottom.text = "查看他更新的相关内容"
        }
        
        fv.mbackView.transform = fv.mbackView.transform.scaledBy(x: 0, y: 0)
        fv.okImageView.transform = fv.okImageView.transform.scaledBy(x: 0, y: 0)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { 
            
            fv.mbackView.transform = CGAffineTransform.identity
            
            }) { (_) in
                
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
                    
                    fv.okImageView.transform = CGAffineTransform.identity
                    
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
    
        let view = FontSizeSlideView(frame: CGRect.zero)
        
        view.bbackView.alpha = 0
        
        self.view.addSubview(view)
        
        view.snp.makeConstraints { (make) in
            
            make.leftMargin.equalTo(self.view.snp.top).offset(0)
            make.bottomMargin.equalTo(self.view.snp.bottom).offset(0)
            make.leftMargin.equalTo(self.view.snp.left).offset(0)
            make.rightMargin.equalTo(self.view.snp.right).offset(0)
        }
        
        view.layoutIfNeeded()
        
        view.backView.transform = view.backView.transform.translatedBy(x: 0, y: view.backView.frame.height)
        
        UIView.animate(withDuration: 0.2, animations: {
            
            view.bbackView.alpha = 1
            
            }, completion: { (_) in
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    view.backView.transform = CGAffineTransform.identity
                }) 
        }) 
    }
    
    
    // 显示完成删除不感兴趣的新闻
    func showNoInterest(_ imgName:String = "About",title:String="将减少此类推荐",height:CGFloat = 59,width:CGFloat = 178){
        
        let shareNoInterest = NoInterestView(frame: CGRect.zero)
        shareNoInterest.alpha = 1
        self.view.addSubview(shareNoInterest)
        
        shareNoInterest.imageView.image = UIImage(named: imgName)
        shareNoInterest.label.text = title

        shareNoInterest.snp.makeConstraints { (make) in
            
            make.height.equalTo(height)
            make.width.equalTo(width)
            make.center.equalTo(self.view.snp.center)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            UIView.animate(withDuration: 0.5, animations: { 
                shareNoInterest.alpha = 0
                }, completion: { (_) in
                    shareNoInterest.removeFromSuperview()
            })
        })
    }
    

}

extension WaitLoadProtcol where Self:FocusViewController{
    
    // 显示等待视图
    func showWaitLoadView(_ top:CGFloat = 0){
        
        if self.waitView == nil {
            
            self.waitView = WaitView.shareWaitView
        }
        
        self.view.addSubview(self.waitView )
        
        self.waitView .snp.makeConstraints { (make) in
            
            make.margins.top.equalTo(self.view.snp.top).offset(top)
            make.bottomMargin.equalTo(self.view.snp.bottom).offset(0)
            make.leftMargin.equalTo(self.view.snp.left).offset(0)
            make.rightMargin.equalTo(self.view.snp.right).offset(0)
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

extension WaitLoadProtcol where Self:DetailViewController{
    
    // 显示等待视图
    func showWaitLoadView(){
        
        self.waitView = WaitView.shareWaitView!
        
        self.view.addSubview(self.waitView)
        
        self.waitView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(UIEdgeInsets.zero)
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
    
    /**
     显示没有关注视图
     
     - parameter hidden: <#hidden description#>
     */
    func ShowNoFocusView(_ hidden:Bool){
    
        NoFocusView.shareNoFocusView.isHidden = !hidden
        
        self.view.addSubview(NoFocusView.shareNoFocusView)
        
        NoFocusView.shareNoFocusView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    
    // 显示等待视图
    func showWaitLoadView(){
        
        self.waitView = WaitView.shareWaitView!
        
        self.view.addSubview(self.waitView)
        
        self.waitView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(UIEdgeInsets.zero)
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
            self.waitView.isUserInteractionEnabled = false
        }
        
        self.view.addSubview(self.waitView )
        
        self.waitView .snp.makeConstraints { (make) in
            
            make.margins.top.equalTo(self.view.snp.top).offset(73)
            make.bottomMargin.equalTo(self.view.snp.bottom).offset(0)
            make.leftMargin.equalTo(self.view.snp.left).offset(0)
            make.rightMargin.equalTo(self.view.snp.right).offset(0)
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
