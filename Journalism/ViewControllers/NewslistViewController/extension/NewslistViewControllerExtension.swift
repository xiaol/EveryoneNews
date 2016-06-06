//
//  NewslistViewControllerExtension.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import MJRefresh
import PINRemoteImage
import XLPagerTabStrip

extension NewslistViewController{

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.messageHandleMethod(hidden:true, anmaiter: false) // 隐藏提示视图
        
        let header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.refreshNewsDataMethod()
        })
        
        header.lastUpdatedTimeLabel.hidden = true
        header.stateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        
        let footer = MJRefreshAutoNormalFooter {
            
            self.loadNewsDataMethod()
        }
        
        self.tableView.mj_header = header
        self.tableView.mj_footer = footer
        
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
        
//        self.TextForChangehandleMethod()
        self.refreshNewsDataMethod(false)
    }
    
    /// 刷新新闻内容方法
    private func refreshNewsDataMethod(show:Bool = true){
    
        guard let channelId = self.channel?.id else{return}
        
        if newsResults.count <= 0 {
            
            return NewsUtil.LoadNewsListArrayData(channelId,times: "\(Int64(NSDate().timeIntervalSince1970*1000))",finish: {
                
                self.tableView.mj_footer.endRefreshing()
                
                self.tableView.reloadData()
                
                }, fail: {
                    
                    self.tableView.mj_footer.endRefreshing()
            })
        }
        
        
        if let last = self.newsResults.first{

            NewsUtil.RefreshNewsListArrayData(channelId, create: true,times: "\(Int64(last.ptimes.timeIntervalSince1970*1000))", finish: { (count) in
                
                self.tableView.mj_header.endRefreshing()
                
                self.tableView.reloadData()
                
                if !show {return}
                
                self.messageHandleMethod("一共刷新了\(count)条数据")
                
                }, fail: {
                    self.tableView.mj_header.endRefreshing()
                    
                    if !show {return}
                    self.messageHandleMethod("没有加载到数据")
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
    
    
    private func messageHandleMethod(message:String = "",hidden:Bool = false,anmaiter:Bool = true){
        
        self.messageLabel.text = message
        
        let show = CGAffineTransformIdentity // 显示视图
        let hiddent = CGAffineTransformTranslate(self.messageLabel.transform, 0, -self.messageLabel.frame.height) // 隐藏加载视图
        
        UIView.animateWithDuration(anmaiter ? 0.3 : 0) {
            
            self.messageLabel.transform = hidden ? hiddent : show
        }
        
        if hidden {return}
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue(), {
            
          UIView.animateWithDuration(0.5, animations: { 
            
            self.messageLabel.transform = hiddent
          })
        })
    }
    

    
//    // 当系统的文字发生变化的时候出发的方法
//    private func TextForChangehandleMethod(){
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.preferredContentSizeChanged(_:)), name: UIContentSizeCategoryDidChangeNotification, object: nil)
//    }
//    
//    // 刷新当前页面
//    func preferredContentSizeChanged(notifi:NSNotification){
//        
//        self.tableView.beginUpdates()
//        
//        self.tableView.reloadData()
//        
//        self.tableView.endUpdates()
//        
//    }
}


extension NewslistViewController:IndicatorInfoProvider{

    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let info = IndicatorInfo(title: channel?.cname ?? "")
        
        return info
    }
}