//
//  SLDataSource.swift
//  Journalism
//
//  Created by Mister on 16/6/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

var count = 2

extension SearchListViewController:UIViewControllerPreviewingDelegate,PreViewControllerDelegate{

    @available(iOS 9.0, *)
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        self.showViewController(viewControllerToCommit, sender: nil)
    }
    
    @available(iOS 9.0, *)
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if let cell = previewingContext.sourceView as? NewBaseTableViewCell,indexPath = self.tableView.indexPathForCell(cell){
            let new = newsResults[indexPath.row]
            new.isRead() // 设置为已读
            let viewController = UIStoryboard.shareStoryBoard.get_DetailAndCommitViewController(new)
            viewController.isDismiss = true
            viewController.predelegate = self
            return viewController
        }
        return nil
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell :NewBaseTableViewCell!
        
        let new = newsResults[indexPath.row]
        
        if indexPath.row == 2 {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("fouce") as! FocusCell
            
            cell.fouceCell(count)
            
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
        
        cell.titleLabel.attributedText =  new.searchTitle.toAttributedString()
        
        if #available(iOS 9.0, *) {
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapability.Available) && !tableView.editing{
                self.registerForPreviewingWithDelegate(self, sourceView: cell)
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let new = newsResults[indexPath.row]
        
        new.isRead() // 设置为已读
        
        if new.isidentification == 1 {
            
            self.tableView.mj_header.beginRefreshing()
            
            return
        }
        
        let viewController = UIStoryboard.shareStoryBoard.get_DetailAndCommitViewController(new)
        
        viewController.isDismiss = true
        
        self.showViewController(viewController, sender: nil)
        
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 2 {
            
            return FocusCell.heightCell(count)
        }
        
        let new = newsResults[indexPath.row]
        
        return new.HeightByNewConstraint(tableView,html: true)
    }
}




