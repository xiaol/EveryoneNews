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
    static var shareStoryBoard:UIStoryboard!{
        
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    /// 获取单例模式下的UIStoryBoard对象
    /// 获取单例模式下的UIStoryBoard对象
    static var shareSplistViewController:UISplitViewController!{
        
        let viewController = UIStoryboard.shareStoryBoard.instantiateViewController(withIdentifier: "UISplitViewController") as? UISplitViewController
        
        viewController?.preferredDisplayMode = .allVisible
    
    
        viewController?.delegate = (UIApplication.shared.delegate as! AppDelegate)
        
        return viewController
    }
}




extension UIStoryboard{
    
    
    
    
    // 获取新闻列表视图
    func get_NewslistViewController(_ channel:Channel?=nil)-> NewslistViewController{
        
        let viewController = self.instantiateViewController(withIdentifier: "NewslistViewController") as! NewslistViewController
        viewController.channel = channel
        return viewController
    }
    
    // 获得子母视图
    func get_UISplitViewController() -> UISplitViewController {
        
        return UIStoryboard.shareSplistViewController
    }
    
    // 获得详情和评论朱世玉视图
    func get_DetailAndCommitViewController (_ new:New)-> DetailAndCommitViewController{
        
        let viewController = self.instantiateViewController(withIdentifier: "DetailAndCommitViewController") as! DetailAndCommitViewController
        
        viewController.new = new
        
        return viewController
    }
    
    // 获得详情视图
    func get_DetailViewController (_ new:New?)-> DetailViewController{
        
        let viewController = self.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController

        viewController.new = new
        
        return viewController
    }
    
    // 获得评论视图
    func get_CommitViewController (_ new:New?)-> CommitViewController{
        
        let viewController = self.instantiateViewController(withIdentifier: "CommitViewController") as! CommitViewController
        
        viewController.new = new
        
        return viewController
    }
    
    /**
     获取搜索页面
     
     - returns: <#return value description#>
     */
    func get_SearchViewController()-> UIViewController{
    
        let viewController = self.instantiateViewController(withIdentifier: "SearchViewController")
        
        return viewController
    }
    
    /**
      获取搜索展示页面
     
     - returns: 返回搜索视图
     */
    func get_SearchListViewController(_ key:String)-> UIViewController{
        
        let viewController = self.instantiateViewController(withIdentifier: "SearchListViewController") as! SearchListViewController
        
        viewController.searchKey = key
        
        return viewController
    }
    
    
    /**
     获取搜索展示页面
     
     - returns: 返回搜索视图
     */
    func get_FocusViewController(_ pname:String)-> FocusViewController{
        
        let viewController = self.instantiateViewController(withIdentifier: "FocusViewController") as! FocusViewController
        
        viewController.pname = pname
        
        return viewController
    }
    
    /**
     获取搜索展示页面
     
     - returns: 返回搜索视图
     */
    func get_QiDianViewController()-> UIViewController{
        
        let viewController = self.instantiateViewController(withIdentifier: "QiDianViewController") as! QiDianViewController
        
        return viewController
    }
}
