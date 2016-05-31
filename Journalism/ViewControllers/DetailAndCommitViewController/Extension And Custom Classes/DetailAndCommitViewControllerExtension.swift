//
//  DetailAndCommitViewControllerExtension.swift
//  Journalism
//
//  Created by Mister on 16/5/23.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit


extension DetailAndCommitViewController{

    
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
    
    @IBAction func panOcclusionView(pan:UIPanGestureRecognizer) {
    
        guard let view = pan.view else{return} // 如果滑动的视图不是UISCrollView也不进行操作
        
        let point = pan.translationInView(view) // 获取移动的位置变化值
        
        if pan.state == UIGestureRecognizerState.Began { // 刚开始的时候，进行以下操作
            
            if  point.x < 0 {return} // 如果滑动视图的 offset 小于0 或者 移动的位置不是向 右滑的话，也不进行操作
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
            if velocityX >= 800 || loctionX >= Int(UIScreen.mainScreen().bounds.width/2) {
                self.detailViewInteractiveTransitioning.finishInteractiveTransition()
            }else{
                self.detailViewInteractiveTransitioning.cancelInteractiveTransition()
            }
        }
    }
    
    
    // 进行滑动返回上一界面的代码操作
    func pan(pan:UIPanGestureRecognizer){

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
            if velocityX >= 800 || loctionX >= Int(UIScreen.mainScreen().bounds.width/2) {
                self.detailViewInteractiveTransitioning.finishInteractiveTransition()
            }else{
                self.detailViewInteractiveTransitioning.cancelInteractiveTransition()
            }
        }
    }
}