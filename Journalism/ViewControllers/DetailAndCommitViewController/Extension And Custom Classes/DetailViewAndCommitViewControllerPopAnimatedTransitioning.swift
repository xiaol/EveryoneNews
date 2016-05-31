//
//  DetailViewAndCommitViewControllerPopAnimatedTransitioning.swift
//  Journalism
//
//  Created by Mister on 16/5/23.
//  Copyright © 2016年 aimobier. All rights reserved.
//
//  用于dismiss动画的实施

import UIKit

class DetailViewAndCommitViewControllerPopAnimatedTransitioning:NSObject,UIViewControllerAnimatedTransitioning{
    
    var isInteraction = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),cv = transitionContext.containerView() else{
            
            return transitionContext.completeTransition(true)
        }
        
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        
        cv.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        fromVC.view.clipsToBounds = false
        fromVC.view.layer.shadowOpacity = 0.9
        fromVC.view.layer.shadowRadius = 5
        fromVC.view.layer.shadowColor = UIColor.lightGrayColor().CGColor
        fromVC.view.layer.shadowOffset = CGSize(width: -1.5, height: 0)
        
        toVC.view.transform = CGAffineTransformIdentity
        
        toVC.view.transform = CGAffineTransformMakeTranslation(-(UIScreen.mainScreen().bounds.width)/2, 0)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            
            toVC.view.transform = CGAffineTransformIdentity
            fromVC.view.transform = CGAffineTransformTranslate(fromVC.view.transform, UIScreen.mainScreen().bounds.width, 0)
            
        }) { (_) in
            
            toVC.view.transform = CGAffineTransformIdentity
            
            fromVC.view.clipsToBounds = true
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}
