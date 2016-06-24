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
    
    /// 获取单例模式下的UIStoryBoard对象
    /// 获取单例模式下的UIStoryBoard对象
    var shareSplistViewController:UISplitViewController!{
        
        get{
            
            struct backTaskLeton{
                
                static var predicate:dispatch_once_t = 0
                
                static var bgTask:UISplitViewController? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                
                backTaskLeton.bgTask = self.instantiateViewControllerWithIdentifier("UISplitViewController") as? UISplitViewController
                backTaskLeton.bgTask!.preferredDisplayMode = .AllVisible
                backTaskLeton.bgTask?.delegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
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
        
        return self.shareSplistViewController
    }
    
    // 获得详情和评论朱世玉视图
    func get_DetailAndCommitViewController (new:New)-> DetailAndCommitViewController{
        
        let viewController = self.instantiateViewControllerWithIdentifier("DetailAndCommitViewController") as! DetailAndCommitViewController
        
        viewController.new = new
        
        return viewController
    }
    
    // 获得详情视图
    func get_DetailViewController (new:New?)-> DetailViewController{
        
        let viewController = self.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController

        viewController.new = new
        
        return viewController
    }
    
    // 获得评论视图
    func get_CommitViewController (new:New?)-> CommitViewController{
        
        let viewController = self.instantiateViewControllerWithIdentifier("CommitViewController") as! CommitViewController
        
        viewController.new = new
        
        return viewController
    }
    
    func get_SearchViewController()-> UIViewController{
    
        let viewController = self.instantiateViewControllerWithIdentifier("SearchViewController")
        
        return viewController
    }
}