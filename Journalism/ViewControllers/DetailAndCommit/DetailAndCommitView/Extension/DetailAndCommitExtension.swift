//
//  DetailAndCommitViewControllerExtension.swift
//  Journalism
//
//  Created by Mister on 16/5/23.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension DetailAndCommitViewController {

    internal func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PresentdAnimation
    }
    
    internal func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return DismissedAnimation
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if self.DismissedAnimation.isInteraction {
            
            return InteractiveTransitioning
        }
        
        return nil
    }
}



extension DetailAndCommitViewController{

    // 切换全屏活着完成反悔上一个界面
    @IBAction func touchViewController(sender: AnyObject) {

        if isDismiss {
        
            if currentIndex == 1 { return self.moveToViewControllerAtIndex(0)}
            
            return self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let horizontal = UIScreen.mainScreen().bounds.width > UIScreen.mainScreen().bounds.height
        
        if horizontal && IS_PLUS{
            
            self.splitViewController?.preferredDisplayMode = self.splitViewController?.preferredDisplayMode == .AllVisible ? .PrimaryHidden : .AllVisible
            
        }else{
            
            if currentIndex == 1 { return self.moveToViewControllerAtIndex(0)}
            
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        self.view.layoutIfNeeded()
    }
    
    // 如果pop动画的渐进动画的开关是真的
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?{
        
        guard let animation = animationController as? DetailViewAndCommitViewControllerPopAnimatedTransitioning else{return nil}
        
        if !animation.isInteraction {return nil}
        
        return detailViewInteractiveTransitioning
    }
    
    // 如果动画切换效果位 pop 的状态的时候
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        
        if operation == UINavigationControllerOperation.Pop{
            
            return detailViewTransitioning
        }
        
        return nil
    }
    
    // 进行滑动返回上一界面的代码操作
    func pan(pan:UIPanGestureRecognizer){

        
        
        
        if isDismiss {
            guard let view = pan.view as? UIScrollView else{return}
            let point = pan.translationInView(view)
            if pan.state == UIGestureRecognizerState.Began {
                if view.contentOffset.x > 0 || point.x < 0 {return}
                
                self.DismissedAnimation.isInteraction = true
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }else if pan.state == UIGestureRecognizerState.Changed {
                
                let process = point.x/UIScreen.mainScreen().bounds.width
                
                self.InteractiveTransitioning.updateInteractiveTransition(process)
                
            }else {
                
                self.DismissedAnimation.isInteraction = false
                
                let loctionX = abs(Int(point.x))
                
                let velocityX = pan.velocityInView(pan.view).x
                
                if velocityX >= 500 || loctionX >= Int(UIScreen.mainScreen().bounds.width/2) {
                    
                    self.InteractiveTransitioning.finishInteractiveTransition()
                    
                }else{
                    
                    self.InteractiveTransitioning.cancelInteractiveTransition()
                }
            }
            
            return
        }
        
        
        
        
        
        guard let view = pan.view as? UIScrollView else{return} // 如果滑动的视图不是UISCrollView也不进行操作
        
        let point = pan.translationInView(view) // 获取移动的位置变化值
        
        if pan.state == UIGestureRecognizerState.Began { // 刚开始的时候，进行以下操作
            
            if view.contentOffset.x > 0 || point.x < 0 {return} // 如果滑动视图的 offset 小于0 或者 移动的位置不是向 右滑的话，也不进行操作
            let horizontal = UIScreen.mainScreen().bounds.width > UIScreen.mainScreen().bounds.height // 判断屏幕是不是横屏
            if horizontal && IS_PLUS{return} // 如果横屏，就不再进行接下来的操作
            
            self.detailViewTransitioning.isInteraction = true
            self.navigationController?.popViewControllerAnimated(true)
        }else if pan.state == UIGestureRecognizerState.Changed { // 改变中的时候
            let process = point.x/UIScreen.mainScreen().bounds.width
            self.detailViewInteractiveTransitioning.updateInteractiveTransition(process)
        }else {// 发生任何终止滑动的事件的时候
            self.detailViewTransitioning.isInteraction = false
            let loctionX = abs(Int(point.x))
            let velocityX = pan.velocityInView(pan.view).x
            if velocityX >= 500 || loctionX >= Int(UIScreen.mainScreen().bounds.width/2) {
                self.detailViewInteractiveTransitioning.finishInteractiveTransition()
            }else{
                self.detailViewInteractiveTransitioning.cancelInteractiveTransition()
            }
        }
    }
}





extension DetailAndCommitViewController {
    
    @available(iOS 9.0, *)
    override func previewActionItems() -> [UIPreviewActionItem] {
        let cancel = UIPreviewAction(title: "取消收藏", style: .Default) { (_, _) in
            guard let n = self.new else{return}
            self.predelegate?.NoCollectionAction?(n)
        }
        
        return [cancel]
    }
}