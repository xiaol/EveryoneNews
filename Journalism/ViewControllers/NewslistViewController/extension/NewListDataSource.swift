//
//  NewListDataSource.swift
//  Journalism
//
//  Created by Mister on 16/6/2.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit


extension NewslistViewController:UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 53
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("search")! as UITableViewCell
        
        cell.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            
            self.fuckHeaderCellView = cell
            
            self.presentViewController(UIStoryboard.shareStoryBoard.get_SearchViewController(), animated: true, completion: nil)
        }))
        let containerView = UIView(frame:cell.frame)
        cell.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        containerView.addSubview(cell)
        return containerView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if newsResults == nil {return 0}
        
        return newsResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell :NewBaseTableViewCell!
        
        let new = newsResults[indexPath.row]
        
        if new.isidentification == 1 {
         
            let cell = tableView.dequeueReusableCellWithIdentifier("refreshcell")! as UITableViewCell
            
            return cell
        }
        
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
                
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                
                if !cancel {
                    
                    self.newsResults[indexPath.row].suicide()
                    
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { // 2
                        
                        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.None)
                        
                        self.showNoInterest()
                    }
                }
            })
        }
    }
    
}

import RealmSwift

extension NewslistViewController:UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let new = newsResults[indexPath.row]
        
        new.isRead() // 设置为已读
        
        if new.isidentification == 1 {
            
            self.tableView.mj_header.beginRefreshing()
            
            return
        }
        
        let viewController = UIStoryboard.shareStoryBoard.get_DetailAndCommitViewController(new)
        
        if IS_PLUS {
            
            self.showDetailViewController(viewController, sender: nil)
        }else{
            
            self.showViewController(viewController, sender: nil)
        }
        
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let new = newsResults[indexPath.row]
        
        if new.isidentification == 1 {
        
            return 40
        }
        
        return new.HeightByNewConstraint(tableView)
}

}