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

extension NewslistViewController:IndicatorInfoProvider{

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        self.refreshNewsDataMethod()
    }
    
    /// 刷新新闻内容方法
    private func refreshNewsDataMethod(){
    
        if let channelId = self.channel?.id {
            
            NewsUtil.LoadNewsListArrayData(channelId,refresh:true, finish: {
                
                self.tableView.mj_header.endRefreshing()
                
                self.tableView.reloadData()
                
                }, fail: {
                    
                    self.tableView.mj_header.endRefreshing()
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
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let info = IndicatorInfo(title: channel?.cname ?? "")
        
        return info
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



extension NewslistViewController:UITableViewDataSource{

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if newsResults == nil {return 0}
        
        return newsResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell :NewBaseTableViewCell!
        
        let new = newsResults[indexPath.row]
        
        if new.style == 0 {
        
            cell =  tableView.dequeueReusableCellWithIdentifier("NewNormalTableViewCell") as! NewNormalTableViewCell
            
            cell.setNewObject(new)
            
        }else if new.style == 1 {
            
            cell =  tableView.dequeueReusableCellWithIdentifier("NewOneTableViewCell") as! NewOneTableViewCell
            
            cell.setNewObject(new)
            
        }else if new.style == 2 {
            
            cell =  tableView.dequeueReusableCellWithIdentifier("NewTwoTableViewCell") as! NewTwoTableViewCell
            
            cell.setNewObject(new)
            
        }else if new.style == 3 {
            
            cell =  tableView.dequeueReusableCellWithIdentifier("NewThreeTableViewCell") as! NewThreeTableViewCell
            
            cell.setNewObject(new)
        }
        
        cell.noLikeButton.removeActions(UIControlEvents.TouchUpInside)
        cell.noLikeButton.addAction(UIControlEvents.TouchUpInside) { (_) in
            
            self.handleActionMethod(cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    private func handleActionMethod(cell :NewBaseTableViewCell,indexPath:NSIndexPath){
        
        var delayInSeconds = 0.0
        
        let porint = cell.convertRect(cell.bounds, toView: self.view).origin
        
        if porint.y < 0 {
            
            delayInSeconds = 0.5
            
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        
        let needHeight = porint.y+cell.frame.height+128
        
        if  needHeight > self.tableView.frame.height {
            
            delayInSeconds = 0.5
            
            let result = needHeight-self.tableView.frame.height
            
            let toPoint = CGPoint(x: 0, y: self.tableView.contentOffset.y+result)
            
            self.tableView.setContentOffset(toPoint, animated: true)
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(delayInSeconds * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { // 2
            self.delegate.ClickNoLikeButtonOfUITableViewCell?(cell, finish: { (cancel) in
                
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
                
                if !cancel {
                
                    self.newsResults[indexPath.row].suicide()
                    
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { // 2
                        
                        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
                    }
                }
            })
        }
    }
    
}

extension NewslistViewController:UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let new = newsResults[indexPath.row]
        
        let viewController = UIStoryboard.shareStoryBoard.get_DetailAndCommitViewController(new)
        
        if IS_PLUS {
            
            self.showDetailViewController(viewController, sender: nil)
        }else{
        
            self.showViewController(viewController, sender: nil)
        }
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let new = newsResults[indexPath.row]
        
        return new.HeightByNewConstraint(tableView)
    }
    
}