//
//  UIStoryBoard.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift

extension UIStoryboard{
    
    /// 获取单例模式下的UIStoryBoard对象
    class var shareStoryBoard:UIStoryboard!{
        
        get{
            
            struct backTaskLeton{
                
                static var predicate:dispatch_once_t = 0
                
                static var bgTask:UIStoryboard? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                
                backTaskLeton.bgTask = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            })
            
            return backTaskLeton.bgTask
        }
    }
}

extension UIStoryboard{
    
    // 获取新闻列表视图
    func get_NewslistViewController(channel:Channel?=nil)-> NewslistViewController{
        
        let viewController = self.instantiateViewControllerWithIdentifier("NewslistViewController") as! NewslistViewController
        viewController.channel = channel
        return viewController
    }
    
    // 获得子母视图
    func get_UISplitViewController() -> UISplitViewController {
        
        let viewController = self.instantiateViewControllerWithIdentifier("UISplitViewController") as! UISplitViewController
        return viewController
    }
    
    // 获得详情视图
    func get_DetailViewController (new:New)-> UIViewController{
        
        let viewController = self.instantiateViewControllerWithIdentifier("DetailViewController") as! UINavigationController
        
        let detail = viewController.topViewController as! DetailViewController
        
        detail.title = new.title
        
        return viewController
    }
}