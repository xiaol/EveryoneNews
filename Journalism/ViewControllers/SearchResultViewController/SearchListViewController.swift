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
        
        NewsUtil.searchNewArrayByKey(self.searchKey, finish: { (key, nomore, fin) in
            
            self.srresultMethod(key, nomore: nomore, fin: fin)
        })
        
        New.deleSearch()
        
        self.tableView.mj_header = NewRefreshHeaderView(refreshingBlock: {
            
            NewsUtil.searchNewArrayByKey(self.searchKey, finish: { (key, nomore, fin) in
                
                self.srresultMethod(key, nomore: nomore, fin: fin)
            })
        })
        
        /**
         *  添加表格的上拉刷新视图
         *
         *  @return <#return value description#>
         */
        self.tableView.mj_footer = NewRefreshFooterView(refreshingBlock: {
            
            self.currentPage += 1
            
            NewsUtil.searchNewArrayByKey(self.searchKey,p: "\(self.currentPage)",delete:false,  finish: { (key, nomore, fin) in
                
                self.srresultMethod(key, nomore: nomore, fin: fin)
            })
        })
        

        
        /**
         *  该方法会检测用户设置字体大小的方法
         *  当用户设置字体后，会发起该通知。
         *
         *  @param FONTMODALSTYLEIDENTIFITER  用户发起的通知的名称
         *  @param nil                        所携带的数据
         *  @param NSOperationQueue.mainQueue 需要执行接下来操作的县城
         *
         *  @return 所需要完成的操作
         */
        NSNotificationCenter.defaultCenter().addObserverForName(FONTMODALSTYLEIDENTIFITER, object: nil, queue: NSOperationQueue.mainQueue()) { (_) in
            
            self.tableView.reloadData()
        }
    }
    
    
    /**
     完成请求处理的方法
     
     - parameter key:    返回的结果是根据什么关键字搜索的
     - parameter nomore: 没有更多新闻
     - parameter fin:    是不是成功的返回
     */
    private func srresultMethod(key:String,nomore:Bool,fin:Bool){
        
        self.hiddenWaitLoadView()
        
        if !fin {
        
            self.currentPage -= 1
        }
        
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
        
        
        if nomore {
        
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        }
        
        if self.searchKey == key {
        
            self.tableView.reloadData()
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        guard let key = textField.text else{ return false }
        
        textField.resignFirstResponder()
        
        self.searchKey = key
        
        self.showWaitLoadView()
        
        NewsUtil.searchNewArrayByKey(self.searchKey,finish: { (key, nomore, fin) in
            
            self.srresultMethod(key, nomore: nomore, fin: fin)
        })
        
        return true
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        New.deleSearch()
    }
    
    
    @IBAction func dismissAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
