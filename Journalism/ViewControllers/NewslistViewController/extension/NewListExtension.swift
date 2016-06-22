//
//  NewslistViewControllerExtension.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift
import MJRefresh
import PINRemoteImage
import XLPagerTabStrip

extension NewslistViewController{

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.sectionFooterHeight = 0
        self.tableView.sectionHeaderHeight = 0
        
        self.messageHandleMethod(hidden:true, anmaiter: false) // 隐藏提示视图
        
        let header = NewRefreshHeaderView(refreshingBlock: {
            
            self.refreshNewsDataMethod()
        })
        
        let footer = NewRefreshFooterView {
            
            self.loadNewsDataMethod()
        }
        
        self.tableView.mj_header = header
        self.tableView.mj_footer = footer
        
        self.refreshNewsDataMethod(false)
        
//        if self.channel?.id ?? 1 != 1 {
//            self.notificationToken = self.newsResults.addNotificationBlock { (changes) in
//                
//                switch changes {
//                case .Initial:
//                    // Results are now populated and can be accessed without blocking the UI
//                    self.tableView.reloadData()
//                    break
//                case .Update(_, let deletions, let insertions, let modifications):
//                    // Query results have changed, so apply them to the UITableView
//                    self.tableView.beginUpdates()
//                    self.tableView.insertRowsAtIndexPaths(insertions.map { NSIndexPath(forRow: $0, inSection: 0) },
//                        withRowAnimation: .Automatic)
//                    self.tableView.deleteRowsAtIndexPaths(deletions.map { NSIndexPath(forRow: $0, inSection: 0) },
//                        withRowAnimation: .Automatic)
//                    self.tableView.reloadRowsAtIndexPaths(modifications.map { NSIndexPath(forRow: $0, inSection: 0) },
//                        withRowAnimation: .Automatic)
//                    self.tableView.endUpdates()
//                    break
//                case .Error(let _):
//                    // An error occurred while opening the Realm file on the background worker thread
//                    break
//                }
//            }
//        }
        
        
        // 获得字体变化通知，完成刷新字体大小方法
        NSNotificationCenter.defaultCenter().addObserverForName(FONTMODALSTYLEIDENTIFITER, object: nil, queue: NSOperationQueue.mainQueue()) { (_) in
            
            self.tableView.reloadData()
        }
    }
    
    /// 刷新新闻内容方法
    private func refreshNewsDataMethod(show:Bool = true){
    
        guard let channelId = self.channel?.id else{return}
        
        if newsResults.count <= 0 {
            
            self.showWaitLoadView()
            
            return NewsUtil.LoadNewsListArrayData(channelId,times: "\(Int64(NSDate().timeIntervalSince1970*1000))",finish: {
                
                self.hiddenWaitLoadView()
                
                self.tableView.mj_footer.endRefreshing()
                
                self.tableView.reloadData()
                
                }, fail: {
                    
                    self.tableView.mj_footer.endRefreshing()
            })
        }
        
        
        if let last = self.newsResults.first{

            var time = last.ptimes
            
            if last.ptimes.hoursBeforeDate(NSDate()) >= 12{
            
                time = NSDate().dateByAddingHours(-12)
            }
            
            NewsUtil.RefreshNewsListArrayData(channelId, create: show,times: "\(Int64(time.timeIntervalSince1970*1000))", finish: { (count) in
                
                self.tableView.mj_header.endRefreshing()
                
                self.tableView.reloadData()
                
                if !show {return}
                
                let message = count <= 0 ? "没有加载到新的数据" : "一共刷新了\(count)条数据"
                
                self.messageHandleMethod(message)
                
                }, fail: {
                    self.tableView.mj_header.endRefreshing()
                    
                    self.tableView.reloadData()
                    
                    if !show {return}
                    self.messageHandleMethod("没有加载到新的数据")
            })
        }
    }
    
    // 加载新闻内容方法
    private func loadNewsDataMethod(){
    
        if let channelId = self.channel?.id,last = self.newsResults.last {
            
            NewsUtil.LoadNewsListArrayData(channelId,times: "\(Int64(last.ptimes.timeIntervalSince1970*1000))",finish: {
                
                self.tableView.mj_footer.endRefreshing()
                
                self.tableView.reloadData()
                
                }, fail: {
                    
                    self.tableView.mj_footer.endRefreshing()
            })
        }
    }
    
    // 消息提示视图处理方法
    private func messageHandleMethod(message:String = "",backColor:UIColor=UIColor.a_color2,hidden:Bool = false,anmaiter:Bool = true){
        
        if self.timer.valid { self.timer.invalidate() }
        
        self.messageLabel.text = message
        self.messageLabel.backgroundColor = backColor
        
        let show = CGAffineTransformIdentity // 显示视图
        let hiddent = CGAffineTransformTranslate(self.messageLabel.transform, 0, -self.messageLabel.frame.height) // 隐藏加载视图
        
        UIView.animateWithDuration(anmaiter ? 0.3 : 0) {
            
            self.messageLabel.transform = hidden ? hiddent : show
        }
        
        if hidden {return} // 如果隐藏就不需要再次隐藏了
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(NewslistViewController.hiddenTips(_:)), userInfo: nil, repeats: false)
    }
    
    // 隐藏提示视图
    func hiddenTips(timer:NSTimer){
        
        let hiddent = CGAffineTransformTranslate(self.messageLabel.transform, 0, -self.messageLabel.frame.height) // 隐藏加载视图
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.messageLabel.transform = hiddent
        })
    }
}


extension NewslistViewController:IndicatorInfoProvider{

    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let info = IndicatorInfo(title: channel?.cname ?? "")
        
        return info
    }
}