//
//  SearchViewController.swift
//  Journalism
//
//  Created by Mister on 16/6/12.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController,UIViewControllerTransitioningDelegate,UITextFieldDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var topView: UIView!
    @IBOutlet var textFiled: UITextField!
    @IBOutlet var backView: UIView!
    @IBOutlet var searchInputViewRightConstraint: NSLayoutConstraint! // 右侧距离
    @IBOutlet var searchViewTopSpaceConstraint: NSLayoutConstraint! // 搜索上方视图
    @IBOutlet var searchViewRightSpaceConstraint: NSLayoutConstraint! // 搜索右方视图
    
    let DismissedAnimation = SearchViewControllerDismissedAnimation()
    let PresentdAnimation = SearchViewControllerPresentdAnimation()
    
    var results = SearchHistory.getList()
    var hotResults = HotSearchs.getList()
    
    private var notificationToken:NotificationToken!
    private var hotNotificationToken:NotificationToken!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }
    
    override func canBecomeFirstResponder() -> Bool {
        
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /**
         *  首先将键盘显示出来
         */
        textFiled.becomeFirstResponder()
        
        /**
         *  获取热点搜索结果
         */
        CustomRequest.HotSearch()
        
        /**
         *  监视历史搜索的数据变化，发生变化后
         */
        self.notificationToken = results.addNotificationBlock { (_) in
            
            self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
        }
        
        self.hotNotificationToken = hotResults.addNotificationBlock { (_) in
            
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        }
    }
    
    /**
     当用户点击return 按钮的时候，跳转至搜索结果页面
     
     - parameter textField: <#textField description#>
     
     - returns: <#return value description#>
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        guard let key = textField.text else{ return false }
        let search = UIStoryboard.shareStoryBoard.get_SearchListViewController(key)
        self.presentViewController(search, animated: true, completion: nil)
        return true
    }
    
    /**
     设置当前视图不可以旋转屏幕
     
     - returns: <#return value description#>
     */
    override func shouldAutorotate() -> Bool {
        
        return false
    }
    
    /**
     可旋转的方向只有正反向
     
     - returns: <#return value description#>
     */
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.Portrait
    }
}
