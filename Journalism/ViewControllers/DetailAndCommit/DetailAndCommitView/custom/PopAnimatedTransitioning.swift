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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else{
            
            return transitionContext.completeTransition(true)
        }
        
        let cv = transitionContext.containerView
        
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        
        cv.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        fromVC.view.clipsToBounds = false
        fromVC.view.layer.shadowOpacity = 0.9
        fromVC.view.layer.shadowRadius = 5
        fromVC.view.layer.shadowColor = UIColor.lightGray.cgColor
        fromVC.view.layer.shadowOffset = CGSize(width: -1.5, height: 0)
        
        toVC.view.transform = CGAffineTransform.identity
        
        toVC.view.transform = CGAffineTransform(translationX: -(UIScreen.main.bounds.width)/2, y: 0)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            toVC.view.transform = CGAffineTransform.identity
            fromVC.view.transform = fromVC.view.transform.translatedBy(x: UIScreen.main.bounds.width, y: 0)
            
        }, completion: { (_) in
            
            toVC.view.transform = CGAffineTransform.identity
            
            fromVC.view.clipsToBounds = true
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }) 
    }
}
