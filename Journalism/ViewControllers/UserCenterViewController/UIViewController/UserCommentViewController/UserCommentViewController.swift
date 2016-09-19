//
//  UserCommentViewController.swift
//  Journalism
//
//  Created by Mister on 16/6/22.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class UserCommentViewController:UIViewController,UITableViewDelegate{
    
    override var shouldAutorotate : Bool {
        
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        return .lightContent
    }
    
    @IBOutlet var pan: UIPanGestureRecognizer!
    
    let DismissedAnimation = CustomViewControllerDismissedAnimation()
    let PresentdAnimation = CustomViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画
    
    @IBOutlet var navView: UIView!
    @IBOutlet var headPhotoView: HeadPhotoView1!
    @IBOutlet var headerView: UIView!
    @IBOutlet var tableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navView.alpha = 0
        self.tableView.tableHeaderView = headerView
        
        tableView.panGestureRecognizer.require(toFail: pan)
        pan.delegate = self
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let rect = headPhotoView.convert(headPhotoView.frame, to: self.view)
        
        if rect.origin.y <= 0 && rect.origin.y >= -100 {
        
            self.navView.alpha = fabs(rect.origin.y/100)
        }
        
        if rect.origin.y > 0 {
        
            self.navView.alpha = 0
        }
        
        if rect.origin.y < -100 {
            
            self.navView.alpha = 1
        }
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
}



extension UserCommentViewController:UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate{

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let point = pan.translation(in: view)
        
        return fabs(point.x) > fabs(point.y)
    }
    
    internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PresentdAnimation
    }
    
    internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return DismissedAnimation
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if self.DismissedAnimation.isInteraction {
            
            return InteractiveTransitioning
        }
        
        return nil
    }
    
    @IBAction func panAction(_ pan: UIPanGestureRecognizer) {
        
        guard let view = pan.view else{return}
        
        let point = pan.translation(in: view)
        
        if pan.state == UIGestureRecognizerState.began {
            
            if point.x < 0 {return}
            
            self.DismissedAnimation.isInteraction = true
            
            self.dismiss(animated: true, completion: nil)
            
        }else if pan.state == UIGestureRecognizerState.changed {
            
            let process = point.x/UIScreen.main.bounds.width
            
            self.InteractiveTransitioning.update(process)
            
        }else {
            
            self.DismissedAnimation.isInteraction = false
            
            let loctionX = abs(Int(point.x))
            
            let velocityX = pan.velocity(in: pan.view).x
            
            if velocityX >= 800 || loctionX >= Int(UIScreen.main.bounds.width/2) {
                
                self.InteractiveTransitioning.finish()
                
            }else{
                
                self.InteractiveTransitioning.cancel()
            }
        }
    }
}
