//
//  DetailAndCommitViewController.swift
//  Journalism
//
//  Created by 荆文征 on 16/5/21.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DetailViewAndCommitViewControllerPopAnimatedTransitioning:NSObject,UIViewControllerAnimatedTransitioning{

    var isInteraction = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),cv = transitionContext.containerView() else{
        
            return transitionContext.completeTransition(true)
        }
        
        cv.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        toVC.view.transform = CGAffineTransformTranslate(toVC.view.transform, -(UIScreen.mainScreen().bounds.width)/2, 0)
        
         UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            
            fromVC.view.transform = CGAffineTransformTranslate(fromVC.view.transform, UIScreen.mainScreen().bounds.width, 0)
            
            toVC.view.transform = CGAffineTransformIdentity
            
            }) { (_) in
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}


class DetailAndCommitViewController:ButtonBarPagerTabStripViewController,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate{

    @IBOutlet weak var titleLabel: UILabel!
    
    let detailViewTransitioning = DetailViewAndCommitViewControllerPopAnimatedTransitioning()
    let detailViewInteractiveTransitioning = UIPercentDrivenInteractiveTransition()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.containerView.bounces = false
        self.buttonBarView.hidden = true
        self.titleLabel.text = self.title
        
        self.navigationController?.delegate = self
        
        self.containerView.panGestureRecognizer.addTarget(self, action: #selector(DetailAndCommitViewController.pan(_:)))
    }

    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?{
    
        guard let animation = animationController as? DetailViewAndCommitViewControllerPopAnimatedTransitioning else{return nil}
        
        if !animation.isInteraction {return nil}
        
        return detailViewInteractiveTransitioning
    }

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
    
        if operation == UINavigationControllerOperation.Pop{
        
            return detailViewTransitioning
        }
        
        return nil
    }
    
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        
        
    }
    
    @IBAction func touchViewController(sender: AnyObject) {
        
        let horizontal = UIScreen.mainScreen().bounds.width > UIScreen.mainScreen().bounds.height
        
        if horizontal {
            
            self.splitViewController?.preferredDisplayMode = self.splitViewController?.preferredDisplayMode == .AllVisible ? .PrimaryHidden : .AllVisible
            
        }else{
        
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let detailViewController = UIStoryboard.shareStoryBoard.get_DetailViewController()
        let commitViewController = UIStoryboard.shareStoryBoard.get_CommitViewController()
        
        return [detailViewController,commitViewController]
    }

    func pan(pan:UIPanGestureRecognizer){
    
        let horizontal = UIScreen.mainScreen().bounds.width > UIScreen.mainScreen().bounds.height
        
        if horizontal {return}
        
        guard let view = pan.view as? UIScrollView else{return}
        
        let point = pan.translationInView(view)
        
        if view.contentOffset.x > 0 || point.x < 0 {return}
        
        if pan.state == UIGestureRecognizerState.Began {
            
            self.detailViewTransitioning.isInteraction = true
            
            self.navigationController?.popViewControllerAnimated(true)
            
        }else if pan.state == UIGestureRecognizerState.Changed {
        
            let process = point.x/UIScreen.mainScreen().bounds.width
            
            self.detailViewInteractiveTransitioning.updateInteractiveTransition(process)
            
        }else {
        
            let loctionX = abs(Int(point.x))
            let velocityX = pan.velocityInView(pan.view).x
            
            if velocityX >= 800 || loctionX >= Int(UIScreen.mainScreen().bounds.width/2) {
                
                self.detailViewInteractiveTransitioning.finishInteractiveTransition()
            }else{
                
                self.detailViewInteractiveTransitioning.cancelInteractiveTransition()
            }
        }
    }
}























