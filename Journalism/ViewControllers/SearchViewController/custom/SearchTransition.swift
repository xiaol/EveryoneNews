//
//  SearchViewControllerTransition.swift
//  Journalism
//
//  Created by Mister on 16/6/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class SearchViewControllerDismissedAnimation:NSObject,UIViewControllerAnimatedTransitioning {
    
    var isInteraction = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        let containerView = transitionContext.containerView()
        containerView.addSubview(toViewController.view)
        containerView.addSubview(fromViewController.view)
        
        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        
        let IS_VERTICAL = UIScreen.mainScreen().bounds.width < UIScreen.mainScreen().bounds.height //是否垂直
        
        if let fr = toViewController as? UISplitViewController,nav = fr.viewControllers.first as? UINavigationController,master = nav.viewControllers.first as? HomeViewController,newlist = master.viewControllers[master.currentIndex] as? NewslistViewController,search = fromViewController as? SearchViewController{
            
            search.backView.alpha = 0
            
            let view = newlist.fuckHeaderCellView // 获得 from 搜索视图
            view.hidden = true // 隐藏
            
            let rect = view.convertRect(view.frame, toView: fr.view)
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                search.searchInputViewRightConstraint.constant = 12
                
                search.searchViewTopSpaceConstraint.constant = IS_VERTICAL ? rect.origin.y-20 : rect.origin.y
                search.searchViewRightSpaceConstraint.constant = UIScreen.mainScreen().bounds.width-rect.width
                search.topView.alpha = 0
                search.backView.alpha = 0
                
                search.view.layer.layoutIfNeeded() // 完成替换工作
                
                }, completion: { (_) in
                    
                    view.hidden = false // 隐藏
                    transitionContext.completeTransition(true)
            })
        }
    }
}

class SearchViewControllerPresentdAnimation:NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        
        let containerView = transitionContext.containerView()
        containerView.addSubview(toViewController.view)
        
        let IS_VERTICAL = UIScreen.mainScreen().bounds.width < UIScreen.mainScreen().bounds.height //是否垂直
        
        if let fr = fromViewController as? UISplitViewController,nav = fr.viewControllers.first as? UINavigationController,master = nav.viewControllers.first as? HomeViewController,newlist = master.viewControllers[master.currentIndex] as? NewslistViewController,search = toViewController as? SearchViewController{
            
            search.backView.alpha = 0
            
            let view = newlist.fuckHeaderCellView // 获得 from 搜索视图
            view.hidden = true // 隐藏
            
            let rect = view.convertRect(view.frame, toView: fr.view)
            
            search.searchViewTopSpaceConstraint.constant = IS_VERTICAL ? rect.origin.y-20 : rect.origin.y
            
            search.searchViewRightSpaceConstraint.constant = UIScreen.mainScreen().bounds.width-rect.width
            search.view.layer.layoutIfNeeded() // 完成替换工作
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
                
                search.searchViewTopSpaceConstraint.constant = 0
                search.searchViewRightSpaceConstraint.constant = 0
                search.searchInputViewRightConstraint.constant = 12+30 // 将取消按钮露出来
                search.backView.alpha = 1
                search.view.layoutIfNeeded()
                
                }, completion: { (_) in
                    
                    view.hidden = false // 隐藏
                    transitionContext.completeTransition(true)
                    
            })
        }
    }
}


extension SearchViewController{
    
    /**
     当时图将要消失的时候 将键盘收起
     
     - parameter animated: <#animated description#>
     */
    override func viewDidDisappear(animated: Bool) {
        
        self.textFiled.text = ""
        super.viewDidDisappear(animated)
        self.textFiled.resignFirstResponder()
    }
    
    /**
     点击返回按钮的时候。将键盘收起，并且将文字设置为空
     
     - parameter sender: <#sender description#>
     */
    @IBAction func dismissAction(sender: AnyObject) {
        
        self.textFiled.resignFirstResponder()
        self.textFiled.text = ""
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     当时图准备 presented 的时候
     
     - parameter presented:  <#presented description#>
     - parameter presenting: <#presenting description#>
     - parameter source:     <#source description#>
     
     - returns: <#return value description#>
     */
    internal func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PresentdAnimation
    }
    
    /**
     当视图准备
     
     - parameter dismissed: <#dismissed description#>
     
     - returns: <#return value description#>
     */
    internal func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return DismissedAnimation
    }
}
