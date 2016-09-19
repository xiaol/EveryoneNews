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
    var focusResults = Focus.SearchArray()
    
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
        
        tableView.panGestureRecognizer.require(toFail: pan)
        
        pan.delegate = self
        
        self.tableView.estimatedRowHeight = 68
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.showWaitLoadView()
        
        New.deleSearch()
        
        NewsUtil.searchNewArrayByKey(self.searchKey, finish: { (key, nomore, fin) in
            
            self.srresultMethod(key, nomore: nomore, fin: fin)
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
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: FONTMODALSTYLEIDENTIFITER), object: nil, queue: OperationQueue.main) { (_) in
            
            self.tableView.reloadData()
        }
    }
    
    
    /**
     完成请求处理的方法
     
     - parameter key:    返回的结果是根据什么关键字搜索的
     - parameter nomore: 没有更多新闻
     - parameter fin:    是不是成功的返回
     */
    fileprivate func srresultMethod(_ key:String,nomore:Bool,fin:Bool){
        
        self.hiddenWaitLoadView()
        
        if !fin {
        
            self.currentPage -= 1
        }
        
        self.tableView.mj_footer.endRefreshing()
        
        if nomore {
        
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        }
        
        if self.searchKey == key {
        
            self.tableView.reloadData()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let key = textField.text else{ return false }
        
        textField.resignFirstResponder()
        
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
        
        self.searchKey = key
        
        self.showWaitLoadView()
        
        NewsUtil.searchNewArrayByKey(self.searchKey,finish: { (key, nomore, fin) in
            
            self.srresultMethod(key, nomore: nomore, fin: fin)
        })
        
        return true
    }
    
    @IBAction func dismissAction(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
