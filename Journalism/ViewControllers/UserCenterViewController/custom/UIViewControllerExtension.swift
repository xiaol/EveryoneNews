//
//  UIViewControllerExtension.swift
//  Journalism
//
//  Created by Mister on 16/5/27.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension UIStoryboard{
    
    /// 获取单例模式下的UIStoryBoard对象
    class var shareUserStoryBoard:UIStoryboard!{
        
        get{
            
            struct backTaskLeton{
                
                static var predicate:dispatch_once_t = 0
                
                static var bgTask:UIStoryboard? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                
                backTaskLeton.bgTask = UIStoryboard(name: "User", bundle: NSBundle.mainBundle())
            })
            
            return backTaskLeton.bgTask
        }
    }
}

extension UIStoryboard{
    
    // 获取用户信息视图
    func get_UserCenterViewController()-> UIViewController{
        
        let viewController = self.instantiateViewControllerWithIdentifier("UserCenterViewController")
        
        return viewController
    }
    
    
    // 获取用户信息视图
    func get_LoginViewController()-> UIViewController{
        
        let viewController = self.instantiateViewControllerWithIdentifier("LoginViewController")
        
        return viewController
    }
}