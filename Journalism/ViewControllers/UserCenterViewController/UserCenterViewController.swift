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
    
    override func shouldAutorotate() -> Bool {
        
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.panGestureRecognizer.requireGestureRecognizerToFail(pan)
        
        pan.delegate = self
    }
}



extension UserCenterViewController:UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate{

    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let point = pan.translationInView(view)
        
        return fabs(point.x) > fabs(point.y)
    }
    
    @IBAction func dismissButtonTouch(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return animation ? PresentdAnimation : nil
    }
    
    internal func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return animation ? DismissedAnimation : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if self.DismissedAnimation.isInteraction {
            
            return InteractiveTransitioning
        }
        
        return nil
    }
    
    @IBAction func panAction(pan: UIPanGestureRecognizer) {
        
        if !animation {return}
        
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