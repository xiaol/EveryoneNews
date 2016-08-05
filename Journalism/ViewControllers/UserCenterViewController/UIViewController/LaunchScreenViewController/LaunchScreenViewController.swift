//
//  LaunchScreenViewController.swift
//  Zijs
//
//  Created by Mister on 16/8/5.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit


class LaunchScreenViewController: UIViewController {
    
    
    /// 读 的图片对象
    @IBOutlet var OcclusionView:UIView!
    
    /// 读 的图片对象
    @IBOutlet var wordLineImageView:UIImageView!
    /// 读 的图片对象
    @IBOutlet var wordDuImageView:UIImageView!
    /// 奇 的图片对象
    @IBOutlet var wordQiImageView:UIImageView!
    /// 点 的图片对象
    @IBOutlet var wordDianImageView:UIImageView!
    /// 阅 的图片对象
    @IBOutlet var wordYueImageView:UIImageView!
    /// 天 的图片对象
    @IBOutlet var wordTianImageView:UIImageView!
    /// 下 的图片对象
    @IBOutlet var wordXiaImageView:UIImageView!
    /// 标点符号 的图片对象
    @IBOutlet var punctuationImageView:UIImageView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.toHidden()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.3 * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), {
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.showAn()
            }
        })
        
        
        
    }
    
    
    @IBAction func click(sender: AnyObject) {
        
        
        self.toHidden()
        self.showAn()
    }
    
    private func toHidden(){
        
        self.wordDuImageView.toHidden()
        self.wordQiImageView.toHidden()
        self.wordDianImageView.toHidden()
        self.wordYueImageView.toHidden()
        self.wordTianImageView.toHidden()
        self.wordXiaImageView.toHidden()
        self.punctuationImageView.toHidden()
        
        self.OcclusionView.transform = CGAffineTransformIdentity
    }
    
    private func showAn(){
        
        UIView.animateWithDuration(1.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.OcclusionView.transform = CGAffineTransformTranslate(self.OcclusionView.transform, self.OcclusionView.frame.width, 0)
        }) { (_) in
            
//            UIView.animateWithDuration(0.85, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
//                
//                self.OcclusionView.transform = CGAffineTransformTranslate(self.OcclusionView.transform, self.OcclusionView.frame.width/2-22, 0)
//                }, completion: nil)
        }
        

        
        self.wordDuImageView.toShow()
        self.wordQiImageView.toShow(0.1)
        self.wordDianImageView.toShow(0.2) {
            
        }
        
        self.wordYueImageView.toShow(0.5)
        self.wordTianImageView.toShow(0.6)
        self.wordXiaImageView.toShow(0.7, finish: {
            
            
        })
        
        UIView.animateWithDuration(0.7, delay: 1.3, usingSpringWithDamping: 0.45, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            self.punctuationImageView.transform = CGAffineTransformIdentity
        }) { (_) in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.5 * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), {
                
                if let vcx = self.storyboard?.instantiateViewControllerWithIdentifier("VisitorViewController") {
                    
                    vcx.modalTransitionStyle = .CrossDissolve
                    
                    self.presentViewController(vcx, animated: true, completion: nil)
                    
                    //                        (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController = vcx
                }
            })
        }
    }
}

private extension UIImageView{
    
    func toHidden(){
        
        self.transform = CGAffineTransformScale(self.transform, 0, 0)
    }
    
    func toShow(delay:NSTimeInterval=0,finish:(()->Void)?=nil){
        
        UIView.animateWithDuration(0.5, delay: delay, usingSpringWithDamping: 0.67, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.transform = CGAffineTransformIdentity
            
        }) { (_) in
            
            finish?()
        }
    }
}

