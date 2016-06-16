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
import FileKit

private extension Path{
    
    static var cachePath:Path{ return (Path.UserHome+"Library"+"Caches")}
    
     func getFileSize() ->String{
        var size:UInt64 = 0
        for path in self.children(recursive: true) {
            size += path.fileSize ?? 0
        }
        return  size.FileSizeFormat()
    }
    
    func deleteFilesMethod() ->String{
        
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        PINCache.sharedCache().removeAllObjects()
        
        PINRemoteImageManager.sharedImageManager().cache.removeAllObjects()
        
        return self.getFileSize()
    }
    
}


private extension UInt64 {

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
    
   
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }
    
    let DismissedAnimation = CustomViewControllerDismissedAnimation()
    let PresentdAnimation = CustomViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画
}



extension UserSettingViewController:UIViewControllerTransitioningDelegate{

    
    override func shouldAutorotate() -> Bool {
        
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.panGestureRecognizer.requireGestureRecognizerToFail(pan)
        pan.delegate = self
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.cacheSizeLable.text = Path.cachePath.getFileSize()
        
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
        
        self.cacheSizeLable.text = Path.cachePath.deleteFilesMethod()
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