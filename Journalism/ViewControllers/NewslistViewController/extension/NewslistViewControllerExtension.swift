//
//  NewslistViewControllerExtension.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift
import AFDateHelper
import SwaggerClient
import PINRemoteImage
import XLPagerTabStrip

extension NewslistViewController:IndicatorInfoProvider{

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        if let channelId = self.channel?.id {
            
            NewsUtil.RefreshChannleObjects(channelId, finish: {
                
                self.tableView.reloadData()
            })
        }
        
        self.TextForChangehandleMethod()
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let info = IndicatorInfo(title: channel?.cname ?? "")
        
        return info
    }
    
    // 当系统的文字发生变化的时候出发的方法
    private func TextForChangehandleMethod(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.preferredContentSizeChanged(_:)), name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    // 刷新当前页面
    func preferredContentSizeChanged(notifi:NSNotification){
        
        self.tableView.beginUpdates()
        
        self.tableView.reloadData()
        
        self.tableView.endUpdates()
        
    }
}



extension NewslistViewController:UITableViewDataSource{

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if newsResults == nil {return 0}
        
        return newsResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell :NewBaseTableViewCell!
        
        let new = newsResults[indexPath.row]
        
        if new.imgStyle == 0 {
        
            cell =  tableView.dequeueReusableCellWithIdentifier("NewNormalTableViewCell") as! NewNormalTableViewCell
            
            cell.setNewObject(new)
            
            return cell
            
        }else if new.imgStyle == 1 {
            
            cell =  tableView.dequeueReusableCellWithIdentifier("NewOneTableViewCell") as! NewOneTableViewCell
            
            cell.setNewObject(new)
            
            return cell
            
        }else if new.imgStyle == 2 {
            
            cell =  tableView.dequeueReusableCellWithIdentifier("NewTwoTableViewCell") as! NewTwoTableViewCell
            
            cell.setNewObject(new)
            
            return cell
            
        }else if new.imgStyle == 3 {
            
            cell =  tableView.dequeueReusableCellWithIdentifier("NewThreeTableViewCell") as! NewThreeTableViewCell
            
            cell.setNewObject(new)
            
            return cell
        }
        
        
        return cell
    }
    
}

extension NewslistViewController:UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let new = newsResults[indexPath.row]
        
        let viewController = UIStoryboard.shareStoryBoard.get_DetailViewController(new)
        
        self.navigationController?.showDetailViewController(viewController, sender: nil)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let new = newsResults[indexPath.row]
        
        return new.HeightByNewConstraint(tableView)
    }
    
}