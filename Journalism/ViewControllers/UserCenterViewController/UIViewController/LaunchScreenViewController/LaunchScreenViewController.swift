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
    
    override var prefersStatusBarHidden : Bool {
        
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.toHidden()
        
        if Channel.isScloerty() {
        
            ChannelUtil.RefreshChannleObjects()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        (UIApplication.shared.delegate as! AppDelegate).startReachabilityNotifier()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            
            DispatchQueue.main.async {
                
                self.showAn()
            }
        })
        
        
        
    }
    
    
    @IBAction func click(_ sender: AnyObject) {
        
        
        self.toHidden()
        self.showAn()
    }
    
    fileprivate func toHidden(){
        
        self.wordDuImageView.toHidden()
        self.wordQiImageView.toHidden()
        self.wordDianImageView.toHidden()
        self.wordYueImageView.toHidden()
        self.wordTianImageView.toHidden()
        self.wordXiaImageView.toHidden()
        self.punctuationImageView.toHidden()
        
        self.OcclusionView.transform = CGAffineTransform.identity
    }
    
    fileprivate func showAn(){
        
        UIView.animate(withDuration: 1.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            
            self.OcclusionView.transform = self.OcclusionView.transform.translatedBy(x: self.OcclusionView.frame.width, y: 0)
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
        
        UIView.animate(withDuration: 0.7, delay: 1.3, usingSpringWithDamping: 0.45, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            self.punctuationImageView.transform = CGAffineTransform.identity
        }) { (_) in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                
                if let vcx = self.storyboard?.instantiateViewController(withIdentifier: "VisitorViewController") {
                    
                    vcx.modalTransitionStyle = .crossDissolve
                    
                    self.present(vcx, animated: true, completion: nil)
                    
                    //                        (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController = vcx
                }
            })
        }
    }
}

private extension UIImageView{
    
    func toHidden(){
        
        self.transform = self.transform.scaledBy(x: 0, y: 0)
    }
    
    func toShow(_ delay:TimeInterval=0,finish:(()->Void)?=nil){
        
        UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.67, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            
            self.transform = CGAffineTransform.identity
            
        }) { (_) in
            
            finish?()
        }
    }
}

