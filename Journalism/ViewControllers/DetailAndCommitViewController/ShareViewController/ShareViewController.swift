//
//  ShareViewController.swift
//  Journalism
//
//  Created by Mister on 16/6/1.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class ShareViewControllerDismissedAnimation:NSObject,UIViewControllerAnimatedTransitioning {
    
    var isInteraction = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        let containerView = transitionContext.containerView()
        containerView!.addSubview(toViewController.view)
        containerView!.addSubview(fromViewController.view)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            
            toViewController.view.transform = CGAffineTransformIdentity
            fromViewController.view.transform = CGAffineTransformTranslate(fromViewController.view.transform, fromViewController.view.bounds.width, 0)
        }) { (_) in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}


class ShareViewControllerPresentdAnimation:NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ShareViewController
        
//        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        
        let containerView = transitionContext.containerView()
        containerView!.addSubview(toViewController.view)
        
        toViewController.view.alpha = 0
        
        toViewController.shareView.transform = CGAffineTransformTranslate(toViewController.shareView.transform, 0, toViewController.shareView.frame.height)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            
            toViewController.view.alpha = 1
            
            toViewController.shareView.transform = CGAffineTransformIdentity
        }) { (_) in
            
            transitionContext.completeTransition(true)
        }
    }
}


class ShareViewController: UIViewController,UIViewControllerTransitioningDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var shareView: UIView!
        
    let DismissedAnimation = ShareViewControllerDismissedAnimation()
    let PresentdAnimation = ShareViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        self.transitioningDelegate = self
        
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = UIModalPresentationStyle.Custom
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
    
        if operation == UINavigationControllerOperation.Push{
        
            print("???")
            
            return PresentdAnimation
        }
        
        return nil
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
    
        print("????")
        
        return PresentdAnimation
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
    
        return DismissedAnimation
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?{
    
        return nil
    }
}
