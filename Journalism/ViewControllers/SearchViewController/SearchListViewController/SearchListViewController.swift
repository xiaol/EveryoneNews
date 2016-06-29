//
//  SearchListViewController.swift
//  Journalism
//
//  Created by Mister on 16/6/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift


class SearchListViewController: UIViewController,WaitLoadProtcol {
    
    var currentPage = 1
    
    // 刷新视图
    var waitView:WaitView!
    
    var searchKey = ""
    
    var newsResults = New.searchArray()
    
    @IBOutlet var textFiled: UITextField!
    
    @IBOutlet var pan: UIPanGestureRecognizer!
    @IBOutlet var tableView: UITableView!
    
    let DismissedAnimation = CustomViewControllerDismissedAnimation()
    let PresentdAnimation = CustomViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动
    
    var notificationToken:NotificationToken!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        textFiled.text = searchKey
        
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(pan)
        pan.delegate = self
        
        
        self.showWaitLoadView()
        
        self.notificationToken = newsResults.addNotificationBlock { (_) in
            
            self.hiddenWaitLoadView()
            
            self.tableView.hidden = self.newsResults.count <= 0
            
            self.tableView.reloadData()
        }
        
        NewsUtil.searchNewArrayByKey(searchKey, finish: { (nomore) in
            
            self.hiddenWaitLoadView()
            }) { 
                
                self.hiddenWaitLoadView()
        }
        
        New.deleSearch()
        
        self.tableView.mj_header = NewRefreshHeaderView(refreshingBlock: {
            
            NewsUtil.searchNewArrayByKey(self.searchKey, finish: { (nomore) in
                
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            })
        })
        
        self.tableView.mj_footer = NewRefreshFooterView(refreshingBlock: {
            
            self.currentPage += 1
            
            NewsUtil.searchNewArrayByKey(self.searchKey, p: "\(self.currentPage)", delete: false, finish: { (nomore) in
                
                if nomore {
                    
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    
                    self.tableView.mj_footer.endRefreshing()
                }
                
                self.tableView.mj_header.endRefreshing()
                
                }, fail: { 

                    self.currentPage -= 1
                    
                    self.tableView.mj_footer.endRefreshing()
                    self.tableView.mj_header.endRefreshing()
            })
        })
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        guard let key = textField.text else{ return false }
        
        textField.resignFirstResponder()
        
        self.searchKey = key
        
        self.showWaitLoadView()
        
        NewsUtil.searchNewArrayByKey(searchKey, finish: { (nomore) in
            
            self.hiddenWaitLoadView()
        }) {
            
            self.hiddenWaitLoadView()
        }
        
        return true
    }
    
    @IBAction func dismissAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
