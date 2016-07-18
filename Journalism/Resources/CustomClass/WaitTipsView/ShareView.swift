//
//  ShareView.swift
//  Journalism
//
//  Created by Mister on 16/7/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit


@objc protocol ShareAlertDelegate {
    
    optional func ClickWeChatMoments()
    optional func ClickWeChatFriends()
    optional func ClickQQFriends()
    optional func ClickSina()
    optional func ClickSMS()
    optional func ClickEmail()
    optional func ClickCopyLink()
    optional func ClickFontSize()
    optional func ClickCancel()
}


extension ShareAlertDelegate where Self:UIViewController{

    func ShareAlertShow(delegate:ShareAlertDelegate){
    
        let sview = ShareAlertView.shareShareAlertView
        
        sview.del = delegate
        
        self.view.addSubview(sview)
        
        sview.snp_makeConstraints { (make) in
            
            make.edges.equalTo(UIEdgeInsetsZero)
        }
        
        sview.ShowAnimMethod()
        
    }
    
    func ShareAlertHidden(){
        
        ShareAlertView.shareShareAlertView.HiddenAnimMethod()
    }
}


class ShareAlertView: UIView {
    
    //分享背景视图
    var backView:UIView!
    var clickView:UIView!
    //分享背景视图
    var shareBackView:UIView!
    
    var del:ShareAlertDelegate?
    
    var contentBackView:UIView!
    
    var cancelButton:UIButton!
    
    var topView:ShareBottomBorderView!
    var bottomView:UIView!
    
    var sTopView:UIView!
    var sBottomView:UIView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 获取单例模式下的UIStoryBoard对象
    class var shareShareAlertView:ShareAlertView!{
        
        get{
            
            struct backTaskLeton{
                
                static var predicate:dispatch_once_t = 0
                
                static var bgTask:ShareAlertView? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                
                backTaskLeton.bgTask = ShareAlertView(frame: CGRectZero)
            })
            
            return backTaskLeton.bgTask
        }
    }
    
    private var view1:ShareCotentView!
    private var view2:ShareCotentView!
    private var view3:ShareCotentView!
    private var view4:ShareCotentView!
    private var view5:ShareCotentView!
    private var view6:ShareCotentView!
    private var view7:ShareCotentView!
    private var view8:ShareCotentView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        BBB()
        CB()
        TB()
        STV()
        SBV()
    }
    
    
    func ShowAnimMethod(){
    
        self.backView.alpha = 0
        UIView.animateWithDuration(0.5) {
            self.backView.alpha = 1
        }
        
        let views = [view1,view2,view3,view4,view5,view6,view7,view8]
        
        for view in views {
            
            view.transform = CGAffineTransformScale(view.transform, 0, 0)
            view.transform = CGAffineTransformTranslate(view.transform, 0, 30)
        }
        
        self.shareBackView.transform = CGAffineTransformTranslate(self.shareBackView.transform, 0, 374)
        
        UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.shareBackView.transform = CGAffineTransformIdentity
            
        }) { (_) in
            
        }

        for (index,view) in views.enumerate() {
            
            UIView.animateWithDuration(0.3, delay: 0.25+Double(index)*0.02, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                view.transform = CGAffineTransformIdentity
                
                }, completion: nil)
        }
        
    }
    
    
    func HiddenAnimMethod(){

        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            self.shareBackView.transform = CGAffineTransformTranslate(self.shareBackView.transform, 0, self.shareBackView.frame.height)
            
        }) { (_) in
            
        }
        
        UIView.animateWithDuration(0.3, delay: 0.15, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            
            self.backView.alpha = 0
            
        }) { (_) in
            
            self.removeFromSuperview()
        }
    }
    
    
    /**
     设置三个北京视图的约束
     */
    func BBB(){
        
        self.clickView = UIView()
        self.backView = UIView()
        self.shareBackView = UIView()
        self.cancelButton = UIButton()
        self.contentBackView = UIView()
        
        self.cancelButton.removeActions(.TouchUpInside)
        self.cancelButton.addAction(.TouchUpInside) { (_) in
            
            self.del?.ClickCancel?()
        }
        

        
        self.clickView.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            
            self.del?.ClickCancel?()
        }))
        
        self.addSubview(self.backView)
        self.backView.addSubview(self.shareBackView)
        self.backView.addSubview(self.clickView)
        self.shareBackView.addSubview(self.contentBackView)
        
        
        self.backView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        self.shareBackView.backgroundColor = UIColor.a_color9
        
        self.backView.snp_makeConstraints { (make) in
            
            make.edges.equalTo(UIEdgeInsetsZero)
        }
        
        self.shareBackView.snp_makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(334)
        }
        
        self.clickView.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(self.shareBackView.snp_top)
        }

    }
    
    /**
     设置取消按钮
     */
    private func CB(){
        
        self.shareBackView.addSubview(cancelButton)
        
        self.cancelButton.setTitle("取消", forState: UIControlState.Normal)
        self.cancelButton.setTitleColor(UIColor.a_color3, forState: UIControlState.Normal)
        self.cancelButton.titleLabel?.font = UIFont.a_font4
        self.cancelButton.setBackgroundColor(UIColor.hexStringToColor("#f0f0f0"), forState: UIControlState.Normal)
        
        cancelButton.snp_makeConstraints { (make) in
            
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(47)
        }
        
        self.contentBackView.snp_makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(self.cancelButton.snp_top)
        }
    }
    
    /**
     设置上下两个视图
     */
    func TB(){
    
        self.topView = ShareBottomBorderView()
        self.bottomView = UIView()
        self.sTopView = UIView()
        self.sBottomView = UIView()

        self.contentBackView.addSubview(self.topView)
        self.contentBackView.addSubview(self.bottomView)
        self.topView.addSubview(sTopView)
        self.bottomView.addSubview(sBottomView)
        
        self.topView.backgroundColor = UIColor.clearColor()
        self.bottomView.backgroundColor = UIColor.clearColor()
        self.sTopView.backgroundColor = UIColor.clearColor()
        self.sBottomView.backgroundColor = UIColor.clearColor()
        
        self.topView.snp_makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(self.contentBackView.snp_height).dividedBy(2)
        }
        
        
        self.bottomView.snp_makeConstraints { (make) in
            
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(self.contentBackView.snp_height).dividedBy(2)
        }
        

        
        sTopView.snp_makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.right.equalTo(0)
            
            make.top.equalTo(32)
            make.bottom.equalTo(-32)
        }
        
        
        sBottomView.snp_makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.right.equalTo(0)
            
            make.top.equalTo(32)
            make.bottom.equalTo(-32)
        }
    }
    
    /**
     上下视图
     */
    func STV(){
    
        view1 = ShareCotentView(image: UIImage(named: "详情页微信朋友圈")!, title: "微信朋友圈") { (control) in
            self.del?.ClickWeChatMoments?()
        }
        view2 = ShareCotentView(image: UIImage(named: "详情页微信好友")!, title: "微信好友") { (control) in
            self.del?.ClickWeChatFriends?()
        }
        view3 = ShareCotentView(image: UIImage(named: "详情页QQ好友")!, title: "QQ好友") { (control) in
            self.del?.ClickQQFriends?()
        }
        view4 = ShareCotentView(image: UIImage(named: "详情页新浪微博")!, title: "新浪微博") { (control) in
            self.del?.ClickSina?()
        }
        
        self.sTopView.addSubview(view1)
        self.sTopView.addSubview(view2)
        self.sTopView.addSubview(view3)
        self.sTopView.addSubview(view4)
        
        view1.snp_makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sTopView.snp_width).dividedBy(4)
        }
        
        
        view2.snp_makeConstraints { (make) in
            
            make.left.equalTo(view1.snp_right)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sTopView.snp_width).dividedBy(4)
        }
        
        
        view3.snp_makeConstraints { (make) in
            
            make.left.equalTo(view2.snp_right)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sTopView.snp_width).dividedBy(4)
        }
        
        view4.snp_makeConstraints { (make) in
            
            make.left.equalTo(view3.snp_right)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sTopView.snp_width).dividedBy(4)
        }
    }
    
    /**
     上下视图
     */
    func SBV(){
        
        view5 = ShareCotentView(image: UIImage(named: "详情页短信")!, title: "短信") { (control) in
            self.del?.ClickSMS?()
        }
        view6 = ShareCotentView(image: UIImage(named: "详情页邮件")!, title: "邮件") { (control) in
            self.del?.ClickEmail?()
        }
        view7 = ShareCotentView(image: UIImage(named: "详情页转发链接")!, title: "转发链接") { (control) in
            self.del?.ClickCopyLink?()
        }
        view8 = ShareCotentView(image: UIImage(named: "详情页字体大小")!, title: "字体大小") { (control) in
            self.del?.ClickFontSize?()
        }
        
        self.sBottomView.addSubview(view5)
        self.sBottomView.addSubview(view6)
        self.sBottomView.addSubview(view7)
        self.sBottomView.addSubview(view8)
        
        view5.snp_makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sBottomView.snp_width).dividedBy(4)
        }
        
        
        view6.snp_makeConstraints { (make) in
            
            make.left.equalTo(view5.snp_right)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sBottomView.snp_width).dividedBy(4)
        }
        
        
        view7.snp_makeConstraints { (make) in
            
            make.left.equalTo(view6.snp_right)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sBottomView.snp_width).dividedBy(4)
        }
        
        view8.snp_makeConstraints { (make) in
            
            make.left.equalTo(view7.snp_right)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sBottomView.snp_width).dividedBy(4)
        }
    }
}


class ShareCotentView:UIView{
    
    var titleLabel:UILabel!
    var shareButton:UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(image: UIImage,title:String,finish:((control:UIControl)->Void)) {
        super.init(frame: CGRectZero)
        
        self.titleLabel = UILabel()
        self.shareButton = UIButton()
        
        self.shareButton.setImage(image, forState: UIControlState.Normal)
        self.titleLabel.text = title
        
        self.titleLabel.font = UIFont.a_font6
        self.titleLabel.textColor = UIColor.a_color3
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.shareButton)
        
        self.shareButton.snp_makeConstraints { (make) in
            
            make.centerX.equalTo(self)
            make.top.equalTo(0)
        }
        
        self.titleLabel.snp_makeConstraints { (make) in
            
            make.centerX.equalTo(self.shareButton)
            make.top.equalTo(self.shareButton.snp_bottom).offset(10)
        }
        
        self.shareButton.removeActions(.TouchUpInside)
        self.shareButton.addAction(.TouchUpInside, block: finish)
    }
}