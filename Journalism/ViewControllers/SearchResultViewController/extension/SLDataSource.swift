//
//  SLDataSource.swift
//  Journalism
//
//  Created by Mister on 16/6/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

var count = 4

extension SearchListViewController:UIViewControllerPreviewingDelegate,PreViewControllerDelegate{

    @available(iOS 9.0, *)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        self.show(viewControllerToCommit, sender: nil)
    }
    
    @available(iOS 9.0, *)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if let cell = previewingContext.sourceView as? NewBaseTableViewCell,let indexPath = self.tableView.indexPath(for: cell){
            let new = newsResults[(indexPath as NSIndexPath).row]
            if new.isread == 0 {
                new.isRead() // 设置为已读
            }
            let viewController = UIStoryboard.shareStoryBoard.get_DetailAndCommitViewController(new)
            viewController.isDismiss = true
            viewController.predelegate = self
            return viewController
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        var cell :NewBaseTableViewCell!
        
        let new = newsResults[(indexPath as NSIndexPath).row]
        
        if new.nid == -1111{
        
            if self.focusResults.count <= 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cccc")!
                
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "fouce") as! FocusCell
            
            cell.fouceCell(self,focusResults: self.focusResults)
            
            return cell
        }
        
        if new.style == 0 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewNormalTableViewCell") as! NewNormalTableViewCell
            cell.setNewObject(new)
            
        }else if new.style == 1 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewOneTableViewCell") as! NewOneTableViewCell
            cell.setNewObject(new)
            
        }else if new.style == 2 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewTwoTableViewCell") as! NewTwoTableViewCell
            cell.setNewObject(new)
            
        }else if new.style == 3 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewThreeTableViewCell") as! NewThreeTableViewCell
            cell.setNewObject(new)
        }
        
        cell.titleLabel.attributedText = new.searchTitle.toAttributedString()
        
        if #available(iOS 9.0, *) {
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapability.available) && !tableView.isEditing{
                
                if let perView = cell.viewControllerPreviewing {
                    
                    self.unregisterForPreviewing(withContext: perView)
                }
                
                cell.viewControllerPreviewing =  self.registerForPreviewing(with: self, sourceView: cell)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        let new = newsResults[(indexPath as NSIndexPath).row]
        
        if new.nid == -1111 {
            
            return
        }
        if new.isread == 0 {
            new.isRead() // 设置为已读
        }
        
        let viewController = UIStoryboard.shareStoryBoard.get_DetailAndCommitViewController(new)
        
        viewController.isDismiss = true
        
        self.show(viewController, sender: nil)
        
        self.tableView.reloadData()
    }
    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        return 100
//    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        let new = newsResults[indexPath.row]
//        
//        if new.nid == -1111 {
//            
//            return self.focusResults.count > 0 ? FocusCell.heightCell(count) : 0
//        }
//        
//        return new.HeightByNewConstraint(tableView)
//    }
}




