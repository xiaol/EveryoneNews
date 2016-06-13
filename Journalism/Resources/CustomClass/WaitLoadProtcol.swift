//
//  WaitLoadProtcol.swift
//  Journalism
//
//  Created by Mister on 16/6/13.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SnapKit

class WaitView: UIView {
    
    lazy var label = UILabel()
    lazy var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        let image1 = UIImage(named: "xl_1")!
        let image2 = UIImage(named: "xl_2")!
        let image3 = UIImage(named: "xl_3")!
        let image4 = UIImage(named: "xl_4")!
        
        self.imageView.animationImages = [image1,image2,image3,image4]
        self.imageView.animationDuration = 0.6
        self.imageView.startAnimating()
        
        self.addSubview(imageView)
        
        
        label.text = "正在努力加载..."
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        label.textAlignment = .Center
        
        self.addSubview(label)
        
        imageView.snp_makeConstraints { (make) in
            
            make.center.equalTo(self.snp_center)
        }
        
        label.snp_makeConstraints { (make) in
            
            make.centerX.equalTo(self.snp_centerX)
            make.topMargin.equalTo(self.imageView.snp_bottom).offset(20)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 获取单例模式下的UIStoryBoard对象
    class var shareWaitView:WaitView!{
        
        get{
            
            struct backTaskLeton{
                
                static var predicate:dispatch_once_t = 0
                
                static var bgTask:WaitView? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                
                backTaskLeton.bgTask = WaitView(frame: CGRectZero)
            })
            
            return backTaskLeton.bgTask
        }
    }
}

class NoInterest: UIView {
    
    lazy var label = UILabel()
    lazy var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor.blackColor()

        self.imageView.image = UIImage(named: "About")
        self.addSubview(imageView)
        
        imageView.snp_makeConstraints { (make) in
            
            make.centerY.equalTo(self.snp_centerY)
            make.leftMargin.equalTo(20)
        }
        
        label.text = "将减少此类推荐"
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        
        self.addSubview(label)
        
        label.snp_makeConstraints { (make) in
            
            make.centerY.equalTo(self.snp_centerY)
            make.leftMargin.equalTo(self.imageView.snp_right).offset(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 获取单例模式下的UIStoryBoard对象
    class var shareNoInterest:NoInterest!{
        
        get{
            
            struct backTaskLeton{
                
                static var predicate:dispatch_once_t = 0
                
                static var bgTask:NoInterest? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                
                backTaskLeton.bgTask = NoInterest(frame: CGRectZero)
            })
            
            return backTaskLeton.bgTask
        }
    }
}


protocol WaitLoadProtcol {}
extension WaitLoadProtcol where Self:UIViewController{

    func showNoInterest(){
        
        NoInterest.shareNoInterest.alpha = 1
        
        self.view.addSubview(NoInterest.shareNoInterest)
        
        NoInterest.shareNoInterest.snp_makeConstraints { (make) in
            
            make.height.equalTo(59)
            make.width.equalTo(178)
            make.center.equalTo(self.view.snp_center)
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1 * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), {
            UIView.animateWithDuration(0.5, animations: { 
                NoInterest.shareNoInterest.alpha = 0
                }, completion: { (_) in
                    NoInterest.shareNoInterest.removeFromSuperview()
            })
        })
    }
    
    
    func showWaitLoadView(){
    
        self.view.addSubview(WaitView.shareWaitView)
        
        WaitView.shareWaitView.snp_makeConstraints { (make) in
            
            make.topMargin.equalTo(self.view.snp_top).offset(0)
            make.bottomMargin.equalTo(self.view.snp_bottom).offset(0)
            make.leftMargin.equalTo(self.view.snp_left).offset(0)
            make.rightMargin.equalTo(self.view.snp_right).offset(0)
        }
    }
    
    func hiddenWaitLoadView(){
    
        WaitView.shareWaitView.removeFromSuperview()
    }
}