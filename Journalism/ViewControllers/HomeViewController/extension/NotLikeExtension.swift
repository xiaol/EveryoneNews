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
        
        static var finish: ((_ cancel: Bool) -> Void)!
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if !self.noLikeChosseView.isHidden{
        
            self.HideNoLikeHandleViewButton(finish:WTFFFFF.finish)
        }
    }
    
    @nonobjc func ClickNoLikeButtonOfUITableViewCell(_ cell: NewBaseTableViewCell, finish: @escaping ((_ cancel: Bool) -> Void)) {
        
        if !self.noLikeChosseView.isHidden {
            
            self.HideNoLikeHandleViewButton(finish:finish)
        }else{
            
            WTFFFFF.finish = finish
            
            self.ShowNoLikeHandleViewButton(cell,finish:finish)
        }
    }
    
    fileprivate func HideNoLikeHandleViewButton(_ cancel:Bool=true,finish: @escaping ((_ cancel: Bool) -> Void)){
  
        UIView.animate(withDuration: 0.2, animations: { 
            
            self.noLikeChosseView.alpha = 0
        }) 
        
        
        UIView.animate(withDuration: 0.3, animations: { 
            
            self.noLikeChosseView.transform = self.noLikeChosseView.transform.translatedBy(x: 0, y: -self.noLikeChosseView.frame.height)
            
            }, completion: { (_) in
                
            self.noLikeChosseView.isHidden = true
                
                UIView.animate(withDuration: 0.3, animations: { 
                    
                    self.shareBackView.alpha = 0
                    
                    }, completion: { (_) in
                        
                        finish(cancel)
                })
        }) 
        

    }
    
    fileprivate func ShowNoLikeHandleViewButton(_ cell: NewBaseTableViewCell,finish: @escaping ((_ cancel: Bool) -> Void)){
        
        
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
        self.shareBackView.isHidden = false
        self.view.insertSubview(self.shareBackView, belowSubview: self.noLikeChosseView) // 初始化背景视图
        
        cell.frame = cell.convert(cell.bounds, to: self.view)
        self.view.addSubview(cell) // 添加Cell
        
        self.noLikeChosseViewTopCOnstraint.constant = cell.frame.origin.y+cell.frame.height // 设置显示的约束大笑
        self.view.layoutIfNeeded()
        
        self.button4.setTitle("  来源:\(cell.pubLabel.text!)  ", for: UIControlState())
        self.noLikeChosseView.transform = cell.transform.translatedBy(x: 0, y: -self.noLikeChosseView.frame.height)
        
        self.noLikeChosseView.alpha = 0
        self.noLikeChosseView.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.shareBackView.alpha = 1
            
        }, completion: { (_) in
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.noLikeChosseView.transform = CGAffineTransform.identity
            }) 
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.noLikeChosseView.alpha = 1
            })
        }) 
    }
    
    
    @IBAction func ClickNoLikeButton(_ sender: AnyObject) {
        
        self.HideNoLikeHandleViewButton(false,finish:WTFFFFF.finish)
    }
    
    fileprivate var shareBackView:UIView!{
        
        let view = UIView(frame: UIScreen.main.bounds)
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        return view
    }
}
