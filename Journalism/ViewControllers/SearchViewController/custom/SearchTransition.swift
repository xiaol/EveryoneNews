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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        containerView.addSubview(fromViewController.view)
        
        toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        
        let IS_VERTICAL = UIScreen.main.bounds.width < UIScreen.main.bounds.height //是否垂直
        
        if let fr = toViewController as? UISplitViewController,let nav = fr.viewControllers.first as? UINavigationController,let master = nav.viewControllers.first as? HomeViewController,let newlist = master.viewControllers[master.currentIndex] as? NewslistViewController,let search = fromViewController as? SearchViewController{
            
            search.backView.alpha = 0
            
            let view = newlist.fuckHeaderCellView! // 获得 from 搜索视图
            view.isHidden = true // 隐藏
            
            let rect = view.convert(view.frame, to: fr.view)
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions(), animations: {
                
                search.searchInputViewRightConstraint.constant = 12
                
                search.searchViewTopSpaceConstraint.constant = IS_VERTICAL ? rect.origin.y-20 : rect.origin.y
                search.searchViewRightSpaceConstraint.constant = UIScreen.main.bounds.width-rect.width
                search.topView.alpha = 0
                search.backView.alpha = 0
                
                search.view.layer.layoutIfNeeded() // 完成替换工作
                
                }, completion: { (_) in
                    
                    view.isHidden = false // 隐藏
                    transitionContext.completeTransition(true)
            })
        }
    }
}

class SearchViewControllerPresentdAnimation:NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        
        let IS_VERTICAL = UIScreen.main.bounds.width < UIScreen.main.bounds.height //是否垂直
        
        if let fr = fromViewController as? UISplitViewController,let nav = fr.viewControllers.first as? UINavigationController,let master = nav.viewControllers.first as? HomeViewController,let newlist = master.viewControllers[master.currentIndex] as? NewslistViewController,let search = toViewController as? SearchViewController{
            
            search.backView.alpha = 0
            
            let view = newlist.fuckHeaderCellView! // 获得 from 搜索视图
            view.isHidden = true // 隐藏
            
            let rect = view.convert(view.frame, to: fr.view)
            
            search.searchViewTopSpaceConstraint.constant = IS_VERTICAL ? rect.origin.y-20 : rect.origin.y
            
            search.searchViewRightSpaceConstraint.constant = UIScreen.main.bounds.width-rect.width
            search.view.layer.layoutIfNeeded() // 完成替换工作
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                
                search.searchViewTopSpaceConstraint.constant = 0
                search.searchViewRightSpaceConstraint.constant = 0
                search.searchInputViewRightConstraint.constant = 12+30 // 将取消按钮露出来
                search.backView.alpha = 1
                search.view.layoutIfNeeded()
                
                }, completion: { (_) in
                    
                    view.isHidden = false // 隐藏
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
    override func viewDidDisappear(_ animated: Bool) {
        
        self.textFiled.text = ""
        super.viewDidDisappear(animated)
        self.textFiled.resignFirstResponder()
    }
    
    /**
     点击返回按钮的时候。将键盘收起，并且将文字设置为空
     
     - parameter sender: <#sender description#>
     */
    @IBAction func dismissAction(_ sender: AnyObject) {
        
        self.textFiled.resignFirstResponder()
        self.textFiled.text = ""
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    /**
     当时图准备 presented 的时候
     
     - parameter presented:  <#presented description#>
     - parameter presenting: <#presenting description#>
     - parameter source:     <#source description#>
     
     - returns: <#return value description#>
     */
    @objc(animationControllerForPresentedController:presentingController:sourceController:) internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PresentdAnimation
    }
    
    /**
     当视图准备
     
     - parameter dismissed: <#dismissed description#>
     
     - returns: <#return value description#>
     */
    @objc(animationControllerForDismissedController:) internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return DismissedAnimation
    }
}
