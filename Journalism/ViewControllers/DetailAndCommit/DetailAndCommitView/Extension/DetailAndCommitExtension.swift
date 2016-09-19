//
//  DetailAndCommitViewControllerExtension.swift
//  Journalism
//
//  Created by Mister on 16/5/23.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension DetailAndCommitViewController {

    @objc(animationControllerForDismissedController:) func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return DismissedAnimation
    }
    
    @objc(animationControllerForPresentedController:presentingController:sourceController:) func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PresentdAnimation
    }

    @objc(interactionControllerForDismissal:) func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if self.DismissedAnimation.isInteraction {
            
            return InteractiveTransitioning
        }
        
        return nil
    }
}



extension DetailAndCommitViewController{

    // 切换全屏活着完成反悔上一个界面
    @IBAction func touchViewController(_ sender: AnyObject) {

        if isDismiss {
        
            if currentIndex == 1 { return self.moveToViewController(at:0)}
            
            return self.dismiss(animated: true, completion: nil)
        }
        
        let horizontal = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        
        if horizontal && IS_PLUS{
            
            self.splitViewController?.preferredDisplayMode = self.splitViewController?.preferredDisplayMode == .allVisible ? .primaryHidden : .allVisible
            
        }else{
            
            if currentIndex == 1 { return self.moveToViewController(at:0)}
            self.navigationController?.popViewController(animated: true)
        }
        
        self.view.layoutIfNeeded()
    }
    
    
    @objc(navigationController:interactionControllerForAnimationController:) func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        guard let animation = animationController as? DetailViewAndCommitViewControllerPopAnimatedTransitioning else{return nil}
        
        if !animation.isInteraction {return nil}
        
        return detailViewInteractiveTransitioning
    }

    @objc(navigationController:animationControllerForOperation:fromViewController:toViewController:) func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.pop{
            
            return detailViewTransitioning
        }
        
        return nil
    }
    
    // 进行滑动返回上一界面的代码操作
    func pan(_ pan:UIPanGestureRecognizer){

        
        
        
        if isDismiss {
            guard let view = pan.view as? UIScrollView else{return}
            let point = pan.translation(in: view)
            if pan.state == UIGestureRecognizerState.began {
                if view.contentOffset.x > 0 || point.x < 0 {return}
                
                self.DismissedAnimation.isInteraction = true
                
                self.dismiss(animated: true, completion: nil)
                
            }else if pan.state == UIGestureRecognizerState.changed {
                
                let process = point.x/UIScreen.main.bounds.width
                
                self.InteractiveTransitioning.update(process)
                
            }else {
                
                self.DismissedAnimation.isInteraction = false
                
                let loctionX = abs(Int(point.x))
                
                let velocityX = pan.velocity(in: pan.view).x
                
                if velocityX >= 500 || loctionX >= Int(UIScreen.main.bounds.width/2) {
                    
                    self.InteractiveTransitioning.finish()
                    
                }else{
                    
                    self.InteractiveTransitioning.cancel()
                }
            }
            
            return
        }
        
        
        
        
        
        guard let view = pan.view as? UIScrollView else{return} // 如果滑动的视图不是UISCrollView也不进行操作
        
        let point = pan.translation(in: view) // 获取移动的位置变化值
        
        if pan.state == UIGestureRecognizerState.began { // 刚开始的时候，进行以下操作
            
            if view.contentOffset.x > 0 || point.x < 0 {return} // 如果滑动视图的 offset 小于0 或者 移动的位置不是向 右滑的话，也不进行操作
            let horizontal = UIScreen.main.bounds.width > UIScreen.main.bounds.height // 判断屏幕是不是横屏
            if horizontal && IS_PLUS{return} // 如果横屏，就不再进行接下来的操作
            
            self.detailViewTransitioning.isInteraction = true
            self.navigationController?.popViewController(animated: true)
        }else if pan.state == UIGestureRecognizerState.changed { // 改变中的时候
            let process = point.x/UIScreen.main.bounds.width
            self.detailViewInteractiveTransitioning.update(process)
        }else {// 发生任何终止滑动的事件的时候
            self.detailViewTransitioning.isInteraction = false
            let loctionX = abs(Int(point.x))
            let velocityX = pan.velocity(in: pan.view).x
            if velocityX >= 500 || loctionX >= Int(UIScreen.main.bounds.width/2) {
                self.detailViewInteractiveTransitioning.finish()
            }else{
                self.detailViewInteractiveTransitioning.cancel()
            }
        }
    }
}





extension DetailAndCommitViewController {
    
    @available(iOS 9.0, *)
    override var previewActionItems : [UIPreviewActionItem] {
        let cancel = UIPreviewAction(title: "取消收藏", style: .default) { (_, _) in
            guard let n = self.new else{return}
            self.predelegate?.NoCollectionAction?(n)
        }
        
        return [cancel]
    }
}
