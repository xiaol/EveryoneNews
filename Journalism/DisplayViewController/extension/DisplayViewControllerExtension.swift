//
//  DisplayViewControllerExtension.swift
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

extension DisplayViewController:IndicatorInfoProvider{

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        if let channelId = self.channel?.id {
            
            if newsResults.count <= 0 || newsResults.first?.pubTimes.hoursAfterDate(NSDate()) > 1{
            
                NewsUtil.RefreshChannleObjects(channelId, finish: {
                    
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let info = IndicatorInfo(title: channel?.cname ?? "")
        
        return info
    }
}



extension DisplayViewController:UITableViewDataSource{

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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

extension DisplayViewController:UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let new = newsResults[indexPath.row]
        
        return new.HeightByNewConstraint()
    }
    
}