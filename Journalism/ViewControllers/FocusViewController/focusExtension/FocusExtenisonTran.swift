//
//  FocusExtenisonTran.swift
//  Journalism
//
//  Created by Mister on 16/7/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension FocusViewController:UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate{
    
    override func shouldAutorotate() -> Bool {
        
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.Portrait
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let point = pan.translationInView(view)
        
        return fabs(point.x) > fabs(point.y)
    }
    
    internal func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return dismiss ? PresentdAnimation : nil
    }
    
    internal func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return dismiss ? DismissedAnimation : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if self.DismissedAnimation.isInteraction {
            
            return InteractiveTransitioning
        }
        
        return nil
    }
    
    @IBAction func panAction(pan: UIPanGestureRecognizer) {
        
        if !dismiss {return}
        
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