//
//  ShareView.swift
//  Journalism
//
//  Created by Mister on 16/7/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit


@objc protocol ShareAlertDelegate {
    
    @objc optional func ClickWeChatMoments()
    @objc optional func ClickWeChatFriends()
    @objc optional func ClickQQFriends()
    @objc optional func ClickSina()
    @objc optional func ClickSMS()
    @objc optional func ClickEmail()
    @objc optional func ClickCopyLink()
    @objc optional func ClickFontSize()
    @objc optional func ClickCancel()
}


extension ShareAlertDelegate where Self:UIViewController{

    func ShareAlertShow(_ delegate:ShareAlertDelegate){
    
        let sview = ShareAlertView.shareShareAlertView
        
        sview?.del = delegate
        
        sview?.addGestureRecognizer(UIPanGestureRecognizer())
        
        self.view.addSubview(sview!)
        
        sview?.snp.makeConstraints { (make) in
            
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        sview?.ShowAnimMethod()
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
    static var shareShareAlertView:ShareAlertView!{
        
       return ShareAlertView()
    }
    
    fileprivate var view1:ShareCotentView!
    fileprivate var view2:ShareCotentView!
    fileprivate var view3:ShareCotentView!
    fileprivate var view4:ShareCotentView!
    fileprivate var view5:ShareCotentView!
    fileprivate var view6:ShareCotentView!
    fileprivate var view7:ShareCotentView!
    fileprivate var view8:ShareCotentView!
    
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
        UIView.animate(withDuration: 0.5, animations: {
            self.backView.alpha = 1
        }) 
        
        let views = [view1,view2,view3,view4,view5,view6,view7,view8]
        
        for view in views {
            
            view?.transform = (view?.transform.scaledBy(x: 0, y: 0))!
            view?.transform = (view?.transform.translatedBy(x: 0, y: 30))!
            
            view?.titleLabel.font = UIFont.a_font6
        }
        
        self.shareBackView.transform = self.shareBackView.transform.translatedBy(x: 0, y: 374)
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions(), animations: {
            
            self.shareBackView.transform = CGAffineTransform.identity
            
        }) { (_) in
            
        }

        for (index,view) in views.enumerated() {
            
            UIView.animate(withDuration: 0.3, delay: 0.25+Double(index)*0.02, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
                
                view?.transform = CGAffineTransform.identity
                
                }, completion: nil)
        }
        
    }
    
    
    func HiddenAnimMethod(){

        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            self.shareBackView.transform = self.shareBackView.transform.translatedBy(x: 0, y: self.shareBackView.frame.height)
            
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.15, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            
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
        
        self.cancelButton.removeActions(events: .touchUpInside)
        self.cancelButton.addAction(events: .touchUpInside) { (_) in
            
            self.del?.ClickCancel?()
        }
        

        
        self.clickView.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            
            self.del?.ClickCancel?()
        }))
        
        self.addSubview(self.backView)
        self.backView.addSubview(self.shareBackView)
        self.backView.addSubview(self.clickView)
        self.shareBackView.addSubview(self.contentBackView)
        
        
        self.backView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        self.shareBackView.backgroundColor = UIColor.a_color9
        
        self.backView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        self.shareBackView.snp.makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(334)
        }
        
        self.clickView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(self.shareBackView.snp.top)
        }

    }
    
    /**
     设置取消按钮
     */
    fileprivate func CB(){
        
        self.shareBackView.addSubview(cancelButton)
        
        self.cancelButton.setTitle("取消", for: UIControlState())
        self.cancelButton.setTitleColor(UIColor.a_color3, for: UIControlState())
        self.cancelButton.titleLabel?.font = UIFont.a_font4
        self.cancelButton.setBackgroundColor(UIColor.hexStringToColor("#f0f0f0"), forState: UIControlState())
        
        cancelButton.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(47)
        }
        
        self.contentBackView.snp.makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(self.cancelButton.snp.top)
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
        
        self.topView.backgroundColor = UIColor.clear
        self.bottomView.backgroundColor = UIColor.clear
        self.sTopView.backgroundColor = UIColor.clear
        self.sBottomView.backgroundColor = UIColor.clear
        
        self.topView.snp.makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(self.contentBackView.snp.height).dividedBy(2)
        }
        
        
        self.bottomView.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(self.contentBackView.snp.height).dividedBy(2)
        }
        

        
        sTopView.snp.makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.right.equalTo(0)
            
            make.top.equalTo(32)
            make.bottom.equalTo(-32)
        }
        
        
        sBottomView.snp.makeConstraints { (make) in
            
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
        
        view1.snp.makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sTopView.snp.width).dividedBy(4)
        }
        
        
        view2.snp.makeConstraints { (make) in
            
            make.left.equalTo(view1.snp.right)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sTopView.snp.width).dividedBy(4)
        }
        
        
        view3.snp.makeConstraints { (make) in
            
            make.left.equalTo(view2.snp.right)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sTopView.snp.width).dividedBy(4)
        }
        
        view4.snp.makeConstraints { (make) in
            
            make.left.equalTo(view3.snp.right)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sTopView.snp.width).dividedBy(4)
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
        
        view5.snp.makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sBottomView.snp.width).dividedBy(4)
        }
        
        
        view6.snp.makeConstraints { (make) in
            
            make.left.equalTo(view5.snp.right)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sBottomView.snp.width).dividedBy(4)
        }
        
        
        view7.snp.makeConstraints { (make) in
            
            make.left.equalTo(view6.snp.right)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sBottomView.snp.width).dividedBy(4)
        }
        
        view8.snp.makeConstraints { (make) in
            
            make.left.equalTo(view7.snp.right)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.sBottomView.snp.width).dividedBy(4)
        }
    }
}


class ShareCotentView:UIView{
    
    var titleLabel:UILabel!
    var shareButton:UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(image: UIImage,title:String,finish:@escaping  (( _ control:UIControl)->Void)) {
        super.init(frame: CGRect.zero)
        
        self.titleLabel = UILabel()
        self.shareButton = UIButton()
        
        self.shareButton.setImage(image, for: UIControlState())
        self.titleLabel.text = title
        
        self.titleLabel.font = UIFont.a_font6
        self.titleLabel.textColor = UIColor.a_color3
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.shareButton)
        
        self.shareButton.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self)
            make.top.equalTo(0)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self.shareButton)
            make.top.equalTo(self.shareButton.snp.bottom).offset(10)
        }
        
        self.shareButton.removeActions(events: .touchUpInside)
        self.shareButton.addAction(events: .touchUpInside, closure: finish)
    }
}
