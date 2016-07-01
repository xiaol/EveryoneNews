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
        
        scrollView.panGestureRecognizer.requireGestureRecognizerToFail(pan)
        pan.delegate = self
        
        self.initChooseFontSize()
        
    }
    
    let DismissedAnimation = CustomViewControllerDismissedAnimation()
    let PresentdAnimation = CustomViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画
}


extension UserSettingViewController{

    @IBAction func small(sender: AnyObject) {
        
        UIFont.a_fontModalStyle = -1
        
        self.setChooseFontSize()
    }
    
    @IBAction func normal(sender: AnyObject) {
        
        UIFont.a_fontModalStyle = 0
        
        self.setChooseFontSize()
    }
    
    @IBAction func big(sender: AnyObject) {
        
        UIFont.a_fontModalStyle = 1
        
        self.setChooseFontSize()
    }
    
    @IBAction func superBig(sender: AnyObject) {
        
        UIFont.a_fontModalStyle = 2
        
        self.setChooseFontSize()
        
    }
    
    private func initChooseFontSize(){
    
        self.chooseFontBackVoew.layer.cornerRadius = 3
        self.chooseFontBackVoew.layer.borderWidth = 1
        self.chooseFontBackVoew.layer.borderColor = UIColor.a_color5.CGColor
        self.chooseFontBackVoew.clipsToBounds = true
        self.chooseFontBackVoew.backgroundColor = UIColor.a_color5
        
        self.setChooseFontSize()
    }
    
    // 设置选择字体大小
    private func setChooseFontSize(){
        
        let back = UIColor.whiteColor()
        let sback = UIColor.a_color5
        
        let text = UIColor.a_color1
        let stext = UIColor.redColor()
        
        
        smallSizeButton.setTitleColor(UIFont.a_fontModalStyle == -1 ? stext : text, forState: .Normal)
        smallSizeButton.setBackgroundColor(UIFont.a_fontModalStyle == -1 ? sback : back, forState: .Normal)
        
        normalSizeButton.setTitleColor(UIFont.a_fontModalStyle == 0 ? stext : text, forState: .Normal)
        normalSizeButton.setBackgroundColor(UIFont.a_fontModalStyle == 0 ? sback : back, forState: .Normal)
        
        bigSizeButton.setTitleColor(UIFont.a_fontModalStyle == 1 ? stext : text, forState: .Normal)
        bigSizeButton.setBackgroundColor(UIFont.a_fontModalStyle == 1 ? sback : back, forState: .Normal)
        
        superBigSizeButton.setTitleColor(UIFont.a_fontModalStyle == 2 ? stext : text, forState: .Normal)
        superBigSizeButton.setBackgroundColor(UIFont.a_fontModalStyle == 2 ? sback : back, forState: .Normal)

    }
}



extension UserSettingViewController:UIViewControllerTransitioningDelegate{

    
    override func shouldAutorotate() -> Bool {
        
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.Portrait
    }
    

    
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.refreshCacheSizeLabel()
    }
    
    private func refreshCacheSizeLabel(){
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            let cacherStr =  XCache.returnCacheSize() + " MB"
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.cacheSizeLable.text = cacherStr
            })
        })
    }
    
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let point = pan.translationInView(view)
        
        return fabs(point.x) > fabs(point.y)
    }
    
    // 用户注销
    @IBAction func LoginOut(sender: AnyObject) {
        
        let alert = UIAlertController(title: "注销", message: "是否注销当前用户", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "注销", style: .Destructive, handler: { (_) in
            
            ShareLUser.LoginOut()
            self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        

    }
    
    // 清理缓存
    @IBAction func ClearCacher(sender: AnyObject) {
        
        SVProgressHUD.showWithStatus("清除缓存中")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            XCache.cleanCache()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                SVProgressHUD.dismiss()
                
                self.refreshCacheSizeLabel()
            })
        })
    }
    
    
    // 清理缓存
    @IBAction func MarkAppStore(sender: AnyObject) {
        
        if let url = NSURL(string: "https://itunes.apple.com/us/app/qi-dian-zi-xunpro/id1130250021?l=zh&ls=1&mt=8") {
        
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func dismissButtonTouch(sender: AnyObject) {
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PresentdAnimation
    }
    
    internal func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return DismissedAnimation
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if self.DismissedAnimation.isInteraction {
            
            return InteractiveTransitioning
        }
        
        return nil
    }
    
    @IBAction func panAction(pan: UIPanGestureRecognizer) {
        
        guard let view = pan.view else{return}
        
        let point = pan.translationInView(view)
        
        if pan.state == UIGestureRecognizerState.Began {
            
            if point.x < 0 {return}
            
            self.DismissedAnimation.isInteraction = true
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }else if pan.state == UIGestureRecognizerState.Changed {
            
            let process = point.x/UIScreen.mainScreen().bounds.width
            
            self.InteractiveTransitioning.updateInteractiveTransition(process)
            
        }else {
            
            self.DismissedAnimation.isInteraction = false
            
            let loctionX = abs(Int(point.x))
            
            let velocityX = pan.velocityInView(pan.view).x
            
            if velocityX >= 800 || loctionX >= Int(UIScreen.mainScreen().bounds.width/2) {
                
                self.InteractiveTransitioning.finishInteractiveTransition()
                
            }else{
                
                self.InteractiveTransitioning.cancelInteractiveTransition()
            }
        }
    }
}