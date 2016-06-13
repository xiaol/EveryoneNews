//
//  SearchViewController.swift
//  Journalism
//
//  Created by Mister on 16/6/12.
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
        containerView!.addSubview(toViewController.view)
        containerView!.addSubview(fromViewController.view)
        
        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        
        let IS_VERTICAL = UIScreen.mainScreen().bounds.width < UIScreen.mainScreen().bounds.height //是否垂直
        
        if let fr = toViewController as? UISplitViewController,nav = fr.viewControllers.first as? UINavigationController,master = nav.viewControllers.first as? HomeViewController,newlist = master.viewControllers[master.currentIndex] as? NewslistViewController,search = fromViewController as? SearchViewController{
            
            search.backView.alpha = 0
            
            let view = newlist.fuckHeaderCellView // 获得 from 搜索视图
            view.hidden = true // 隐藏
            
            let rect = view.convertRect(view.frame, toView: fr.view)
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                
                search.textFiled.resignFirstResponder()
                
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
        containerView!.addSubview(toViewController.view)
        
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
                search.searchInputViewRightConstraint.constant = 12+30+5 // 将取消按钮露出来
                search.backView.alpha = 1
                search.view.layoutIfNeeded()
                
                }, completion: { (_) in
                    
                    view.hidden = false // 隐藏
                    transitionContext.completeTransition(true)
                    
            })
        }
    }
}

class SearchViewController: UIViewController,UIViewControllerTransitioningDelegate {
    
    @IBOutlet var topView: UIView!
    @IBOutlet var textFiled: UITextField!
    @IBOutlet var backView: UIView!
    @IBOutlet var searchInputViewRightConstraint: NSLayoutConstraint! // 右侧距离
    @IBOutlet var searchViewTopSpaceConstraint: NSLayoutConstraint! // 搜索上方视图
    @IBOutlet var searchViewRightSpaceConstraint: NSLayoutConstraint! // 搜索右方视图
    
    let DismissedAnimation = SearchViewControllerDismissedAnimation()
    let PresentdAnimation = SearchViewControllerPresentdAnimation()
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }
    
    @IBAction func dismissAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PresentdAnimation
    }
    
    internal func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return DismissedAnimation
    }
    
    override func canBecomeFirstResponder() -> Bool {
        
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        textFiled.becomeFirstResponder()
    }
}
