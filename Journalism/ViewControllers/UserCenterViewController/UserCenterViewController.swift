//
//  UserCenterViewController.swift
//  Journalism
//
//  Created by Mister on 16/5/24.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import PINRemoteImage

class UserCenterViewController: UIViewController {
    
    var animation = false
    
    @IBOutlet var userNameLabel: UILabel! // 用户label
    @IBOutlet var userHeadPhotoView: UIImageView! // 用户头像
    
    @IBOutlet var pan: UIPanGestureRecognizer!
    @IBOutlet var scrollView: UIScrollView!
    let DismissedAnimation = CustomViewControllerDismissedAnimation()
    let PresentdAnimation = CustomViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画
    
    override var shouldAutorotate : Bool {
        
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.portrait
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.panGestureRecognizer.require(toFail: pan)
        
        pan.delegate = self
    }
}



extension UserCenterViewController:UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate{

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let point = pan.translation(in: view)
        
        return fabs(point.x) > fabs(point.y)
    }
    
    @IBAction func dismissButtonTouch(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return animation ? PresentdAnimation : nil
    }
    
    internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return animation ? DismissedAnimation : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if self.DismissedAnimation.isInteraction {
            
            return InteractiveTransitioning
        }
        
        return nil
    }
    
    @IBAction func panAction(_ pan: UIPanGestureRecognizer) {
        
        if !animation {return}
        
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
