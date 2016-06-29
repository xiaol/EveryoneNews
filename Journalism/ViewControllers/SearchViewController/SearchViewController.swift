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
    
    private var notificationToken:NotificationToken!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }
    
    override func canBecomeFirstResponder() -> Bool {
        
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        textFiled.becomeFirstResponder()
        
        self.notificationToken = results.addNotificationBlock { (_) in
            
            self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.textFiled.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        guard let key = textField.text else{ return false }
        
        SearchHistory.create(key)
        
        let search = UIStoryboard.shareStoryBoard.get_SearchListViewController(key)
        
        self.presentViewController(search, animated: true, completion: nil)
        
        return true
    }
}
