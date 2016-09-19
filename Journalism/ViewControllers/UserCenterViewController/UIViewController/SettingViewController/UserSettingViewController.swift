//
//  UserSettingViewController.swift
//  Journalism
//
//  Created by Mister on 16/5/25.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import PINCache
import PINRemoteImage
import SVProgressHUD

extension UInt {

    ///  返回文件的大小
    func FileSizeFormat() -> String{
        
        var fileSizeStr = ""
        let size = Double(self)
        if size > 1024*1024*1024{
            fileSizeStr = "\(String(format: "%.2f", size/1024/1024/1024)) G"
        }else if size > 1024*1024 {
            fileSizeStr = "\(String(format: "%.2f", size/1024/1024)) M"
        }else if size > 1024 {
            fileSizeStr = "\(String(format: "%.2f", size/1024)) KB"
        }else{
            fileSizeStr = "\(size) B"
        }
        return fileSizeStr
    }
}


class UserSettingViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet var logoutButton:UIButton!
    
    @IBOutlet var cacheSizeLable: UILabel!
    @IBOutlet var pan: UIPanGestureRecognizer!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var chooseFontBackVoew: UIView!
    @IBOutlet var smallSizeButton: UIButton!
    @IBOutlet var normalSizeButton: UIButton!
    @IBOutlet var bigSizeButton: UIButton!
    @IBOutlet var superBigSizeButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.panGestureRecognizer.require(toFail: pan)
        pan.delegate = self
        
        self.initChooseFontSize()
        
        self.logoutButton.setTitle(ShareLUser.utype == 2 ? "点击登录" : "退出登录", for: UIControlState())
    }
    
    let DismissedAnimation = CustomViewControllerDismissedAnimation()
    let PresentdAnimation = CustomViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画
}


extension UserSettingViewController{

    @IBAction func small(_ sender: AnyObject) {
        
        UIFont.a_fontModalStyle = -1
        
        self.setChooseFontSize()
    }
    
    @IBAction func normal(_ sender: AnyObject) {
        
        UIFont.a_fontModalStyle = 0
        
        self.setChooseFontSize()
    }
    
    @IBAction func big(_ sender: AnyObject) {
        
        UIFont.a_fontModalStyle = 1
        
        self.setChooseFontSize()
    }
    
    @IBAction func superBig(_ sender: AnyObject) {
        
        UIFont.a_fontModalStyle = 2
        
        self.setChooseFontSize()
        
    }
    
    fileprivate func initChooseFontSize(){
    
        self.chooseFontBackVoew.layer.cornerRadius = 3
        self.chooseFontBackVoew.layer.borderWidth = 1
        self.chooseFontBackVoew.layer.borderColor = UIColor.a_color5.cgColor
        self.chooseFontBackVoew.clipsToBounds = true
        self.chooseFontBackVoew.backgroundColor = UIColor.a_color5
        
        self.setChooseFontSize()
    }
    
    // 设置选择字体大小
    fileprivate func setChooseFontSize(){
        
        let back = UIColor.white
        let sback = UIColor.a_color5
        
        let text = UIColor.a_color1
        let stext = UIColor.red
        
        
        smallSizeButton.setTitleColor(UIFont.a_fontModalStyle == -1 ? stext : text, for: UIControlState())
        smallSizeButton.setBackgroundColor(UIFont.a_fontModalStyle == -1 ? sback : back, forState: UIControlState())
        
        normalSizeButton.setTitleColor(UIFont.a_fontModalStyle == 0 ? stext : text, for: UIControlState())
        normalSizeButton.setBackgroundColor(UIFont.a_fontModalStyle == 0 ? sback : back, forState: UIControlState())
        
        bigSizeButton.setTitleColor(UIFont.a_fontModalStyle == 1 ? stext : text, for: UIControlState())
        bigSizeButton.setBackgroundColor(UIFont.a_fontModalStyle == 1 ? sback : back, forState: UIControlState())
        
        superBigSizeButton.setTitleColor(UIFont.a_fontModalStyle == 2 ? stext : text, for: UIControlState())
        superBigSizeButton.setBackgroundColor(UIFont.a_fontModalStyle == 2 ? sback : back, forState: UIControlState())

    }
}



extension UserSettingViewController:UIViewControllerTransitioningDelegate{

    
    override var shouldAutorotate : Bool {
        
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.portrait
    }
    

    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.refreshCacheSizeLabel()
    }
    
    fileprivate func refreshCacheSizeLabel(){
    
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: { () -> Void in
            
            let cacherStr =  XCache.returnCacheSize() + " MB"
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                self.cacheSizeLable.text = cacherStr
            })
        })
    }
    
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let point = pan.translation(in: view)
        
        return fabs(point.x) > fabs(point.y)
    }
    
    // 用户注销
    @IBAction func LoginOut(_ sender: AnyObject) {
        
        if ShareLUser.utype == 2 {
        
            return self.dismiss(animated: true, completion: nil)
        }
        
        let alert = UIAlertController(title: "注销", message: "是否注销当前用户", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "注销", style: .destructive, handler: { (_) in
            
            ShareLUser.LoginOut()
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // 清理缓存
    @IBAction func ClearCacher(_ sender: AnyObject) {
        
        SVProgressHUD.show(withStatus: "清除缓存中")
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: { () -> Void in
            
            XCache.cleanCache()
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                SVProgressHUD.dismiss()
                
                self.refreshCacheSizeLabel()
            })
        })
    }
    
    
    // 清理缓存
    @IBAction func MarkAppStore(_ sender: AnyObject) {
        
        if let url = URL(string: "https://itunes.apple.com/us/app/qi-dian-zi-xunpro/id1130250021?l=zh&ls=1&mt=8") {
        
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func dismissButtonTouch(_ sender: AnyObject) {
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PresentdAnimation
    }
    
    internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return DismissedAnimation
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if self.DismissedAnimation.isInteraction {
            
            return InteractiveTransitioning
        }
        
        return nil
    }
    
    @IBAction func panAction(_ pan: UIPanGestureRecognizer) {
        
        guard let view = pan.view else{return}
        
        let point = pan.translation(in: view)
        
        if pan.state == UIGestureRecognizerState.began {
            
            if point.x < 0 {return}
            
            self.DismissedAnimation.isInteraction = true
            
            self.dismiss(animated: true, completion: nil)
            
        }else if pan.state == UIGestureRecognizerState.changed {
            
            let process = point.x/UIScreen.main.bounds.width
            
            self.InteractiveTransitioning.update(process)
            
        }else {
            
            self.DismissedAnimation.isInteraction = false
            
            let loctionX = abs(Int(point.x))
            
            let velocityX = pan.velocity(in: pan.view).x
            
            if velocityX >= 800 || loctionX >= Int(UIScreen.main.bounds.width/2) {
                
                self.InteractiveTransitioning.finish()
                
            }else{
                
                self.InteractiveTransitioning.cancel()
            }
        }
    }
}
