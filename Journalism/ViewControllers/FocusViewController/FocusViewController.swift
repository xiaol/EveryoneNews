//
//  FocusViewController.swift
//  Journalism
//
//  Created by Mister on 16/7/12.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift

class FocusViewController: UIViewController,WaitLoadProtcol {
    
    var waitView:WaitView!
    
    @IBOutlet var tableView:UITableView!
    
    @IBOutlet var headerView:FoucusHeaderView!
    
    @IBOutlet var pan: UIPanGestureRecognizer!
    
    var notificationToken: NotificationToken? = nil
    
    var dismiss = false
    
    let DismissedAnimation = CustomViewControllerDismissedAnimation()
    let PresentdAnimation = CustomViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }
    
    var pname:String = ""
    
    lazy var newsResults:Results<New> = New.foucsArray(self.pname)
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        /**
         *  设置新闻链接地址
         *
         *  @param pname <#pname description#>
         *
         *  @return <#return value description#>
         */
        self.headerView.setNewC(pname)
        
        
        self.notifitionNewChange()
        
        self.tableView.scrollIndicatorInsets.top = 170
        self.tableView.contentInset.top = 170
        
        New.delFocusArray() // 先把数据库关注的新闻置空
        
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(pan)
        
        pan.delegate = self

        self.LoadNewMethod()
        
        self.tableView.mj_footer = NewRefreshFooterView(refreshingBlock: {
            
            self.LoadNewMethod()
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
     加载新闻～～
     */
    private func LoadNewMethod(){
        
        if self.newsResults.count <= 0 {
        
            self.showWaitLoadView(170)
        }
        
        let timer = self.newsResults.last?.ptimes.timeIntervalSince1970 ?? NSDate().dateByAddingHours(-3).timeIntervalSince1970
        
        Focus.LoadNewListByPname(self.pname, times: timer*1000, finish: {(nomore) in
            
            self.hiddenWaitLoadView()
            
            if nomore {
            
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
            
                self.tableView.mj_footer.endRefreshing()
            }
            
            }, fail: {
                
                self.hiddenWaitLoadView()
                
                self.tableView.mj_footer.endRefreshing()
        })
    }
    
    @IBAction func ClickCancel(sender:AnyObject){
    
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func notifitionNewChange(){
        
        /**
         *  监视当前新闻发生变化之后，进行数据的刷新
         */
        self.notificationToken = newsResults.addNotificationBlock { (changes: RealmCollectionChange) in
            
            switch changes {
            case .Initial:
                // Results are now populated and can be accessed without blocking the UI
                self.tableView.reloadData()
                break
            case .Update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths(insertions.map { NSIndexPath(forRow: $0, inSection: 1) },
                    withRowAnimation: .Automatic)
                self.tableView.deleteRowsAtIndexPaths(deletions.map { NSIndexPath(forRow: $0, inSection: 1) },
                    withRowAnimation: .Automatic)
                self.tableView.reloadRowsAtIndexPaths(modifications.map { NSIndexPath(forRow: $0, inSection: 1) },
                    withRowAnimation: .Automatic)
                self.tableView.endUpdates()
                break
            case .Error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
    }
}


