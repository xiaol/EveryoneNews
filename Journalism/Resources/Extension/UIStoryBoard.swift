//
//  UIStoryBoard.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

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

    func get_DisplayViewController(channel:Channel?=nil)->DisplayViewController{
    
        let viewController = self.instantiateViewControllerWithIdentifier("DisplayViewController") as! DisplayViewController
        viewController.channel = channel
        return viewController
    }
}