//
//  NotLikeExtension.swift
//  Journalism
//
//  Created by Mister on 16/5/24.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit


extension HomeViewController:NewslistViewControllerNoLikeDelegate{

    struct WTFFFFF {
        
        static var finish: ((cancel: Bool) -> Void)!
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        if !self.noLikeChosseView.hidden{
        
            self.HideNoLikeHandleViewButton(finish:WTFFFFF.finish)
        }
    }
    
    func ClickNoLikeButtonOfUITableViewCell(cell: NewBaseTableViewCell, finish: ((cancel: Bool) -> Void)) {
        
        if !self.noLikeChosseView.hidden {
            
            self.HideNoLikeHandleViewButton(finish:finish)
        }else{
            
            WTFFFFF.finish = finish
            
            self.ShowNoLikeHandleViewButton(cell,finish:finish)
        }
    }
    
    private func HideNoLikeHandleViewButton(cancel:Bool=true,finish: ((cancel: Bool) -> Void)){
  
        UIView.animateWithDuration(0.2) { 
            
            self.noLikeChosseView.alpha = 0
        }
        
        
        UIView.animateWithDuration(0.3, animations: { 
            
            self.noLikeChosseView.transform = CGAffineTransformTranslate(self.noLikeChosseView.transform, 0, -self.noLikeChosseView.frame.height)
            
            }) { (_) in
                
            self.noLikeChosseView.hidden = true
                
                UIView.animateWithDuration(0.3, animations: { 
                    
                    self.shareBackView.alpha = 0
                    
                    }, completion: { (_) in
                        
                        finish(cancel: cancel)
                })
        }
        

    }
    
    private func ShowNoLikeHandleViewButton(cell: NewBaseTableViewCell,finish: ((cancel: Bool) -> Void)){
        
        
        let tapCell = UITapGestureRecognizer { (tap) in
            
            cell.removeGestureRecognizer(tap)
            
            self.HideNoLikeHandleViewButton(finish:finish)
        }
  
        cell.addGestureRecognizer(tapCell)
        
        self.shareBackView.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            
            self.HideNoLikeHandleViewButton(finish:finish)
        }))
        
        
        self.button1.clickSelected = false
        self.button2.clickSelected = false
        self.button3.clickSelected = false
        self.button4.clickSelected = false
        
        self.shareBackView.alpha = 0
        self.shareBackView.hidden = false
        self.view.insertSubview(self.shareBackView, belowSubview: self.noLikeChosseView) // 初始化背景视图
        
        cell.frame = cell.convertRect(cell.bounds, toView: self.view)
        self.view.addSubview(cell) // 添加Cell
        
        self.noLikeChosseViewTopCOnstraint.constant = cell.frame.origin.y+cell.frame.height // 设置显示的约束大笑
        self.view.layoutIfNeeded()
        
        self.button4.setTitle("  来源:\(cell.pubLabel.text!)  ", forState: UIControlState.Normal)
        self.noLikeChosseView.transform = CGAffineTransformTranslate(cell.transform, 0, -self.noLikeChosseView.frame.height)
        
        self.noLikeChosseView.alpha = 0
        self.noLikeChosseView.hidden = false
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.shareBackView.alpha = 1
            
        }) { (_) in
            
            UIView.animateWithDuration(0.3) {
                
                self.noLikeChosseView.transform = CGAffineTransformIdentity
            }
            
            UIView.animateWithDuration(0.5, animations: {
                
                self.noLikeChosseView.alpha = 1
            })
        }
    }
    
    
    @IBAction func ClickNoLikeButton(sender: AnyObject) {
        
        self.HideNoLikeHandleViewButton(false,finish:WTFFFFF.finish)
    }
    
    private var shareBackView:UIView!{
        
        get{
            
            struct backTaskLeton{
                
                static var predicate:dispatch_once_t = 0
                
                static var bgTask:UIView? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                
                backTaskLeton.bgTask = UIView(frame: UIScreen.mainScreen().bounds)
                backTaskLeton.bgTask!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            })
            
            return backTaskLeton.bgTask
        }
    }
}