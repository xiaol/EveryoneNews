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
    static var shareUserStoryBoard:UIStoryboard!{
        
        return UIStoryboard(name: "User", bundle: Bundle.main)
    }
}

extension UIStoryboard{
    
    // 获取用户信息视图
    func get_UserCenterViewController()-> UIViewController{
        
        let viewController = self.instantiateViewController(withIdentifier: "UserCenterViewController")
        
        return viewController
    }
    
    
    // 获取用户信息视图
    func get_LoginViewController()-> UIViewController{
        
        let viewController = self.instantiateViewController(withIdentifier: "LoginViewController")
        
        return viewController
    }
}
