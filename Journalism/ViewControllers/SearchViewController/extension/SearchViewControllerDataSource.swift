//
//  SearchViewControllerDataSource.swift
//  Journalism
//
//  Created by Mister on 16/6/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension SearchViewController:UITableViewDataSource{
    
    /**
     返回一共有2个section
     
     - parameter tableView: 表格
     
     - returns: section的个数
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 2 }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if section == 0 {
        
            return 1
        }
        
        return self.results.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("his")! as UITableViewCell
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("hot") as! SearchHistoryTableViewCell
        
        cell.titleLabel.text = self.results[indexPath.row].title
        
        return cell
    }
}



extension SearchViewController:UITableViewDelegate{

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return nil }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 && self.results.count <= 0  {return nil}
        
        let cell = tableView.dequeueReusableCellWithIdentifier("header") as! SearchHeaderTableViewCell
        cell.setHeader(section == 0 ? HeaderStyle.Hot : HeaderStyle.History)
        let containerView = UIView(frame:cell.frame)
        cell.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        containerView.addSubview(cell)
        containerView.clipsToBounds = true
        
        cell.clearButton.removeActions(.TouchUpInside)
        cell.clearButton.addAction(.TouchUpInside) { (_) in
            
            self.alertToAskUserClearHistory()
        }
        
        return containerView
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 35
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
        
            return 150
        }
        
        return 54
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {return}
        
        let key = self.results[indexPath.row].title
        
        let search = UIStoryboard.shareStoryBoard.get_SearchListViewController(key)
        
        self.presentViewController(search, animated: true, completion: nil)

    }
}



extension SearchViewController{

    private func alertToAskUserClearHistory(){
    
        let aler = UIAlertController(title: "是否清楚搜索记录", message: "清除不可恢复", preferredStyle: UIAlertControllerStyle.Alert)
        
        aler.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        
        aler.addAction(UIAlertAction(title: "清除", style: UIAlertActionStyle.Destructive, handler: { (_) in
           
            SearchHistory.delAll()
        }))
            
        self.presentViewController(aler, animated: true, completion: nil)
    }
}












