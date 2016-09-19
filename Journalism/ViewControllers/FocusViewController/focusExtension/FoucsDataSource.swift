//
//  FoucsDelegate.swift
//  Journalism
//
//  Created by Mister on 16/7/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension FocusViewController:UITableViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        
        var source:CGFloat = 0
        
        /**
         *  如果约束值小于了64.则取64
         */
        if 0 - offsetY <= 64 {
            
            source = 64
        }else if 0 - offsetY >= 170 { // 如果大于170 则取170
            
            source = 170
        }else{
            
            source = 0-offsetY
        }
        
        if source > 170 || source < 64 {return}
        
        self.heightConstraint.constant = source
        
        self.headerView.setProcess((170-source)/(170-64))
        
//        self.headerView.layer.layoutIfNeeded()
    }
}


extension FocusViewController:UIViewControllerPreviewingDelegate,PreViewControllerDelegate{
    
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
            viewController.isFoucsDismiss = true
            viewController.predelegate = self
            return viewController
        }
        return nil
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {return 1}
        
        return newsResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 0 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "fhs")!
            
            return cell
        }
        
        var cell :NewBaseTableViewCell!
        
        let new = newsResults[(indexPath as NSIndexPath).row]
        
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
        
        if #available(iOS 9.0, *) {
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapability.available) && !tableView.isEditing{
                if let perView = cell.viewControllerPreviewing { self.unregisterForPreviewing(withContext: perView)}
                cell.viewControllerPreviewing =  self.registerForPreviewing(with: self, sourceView: cell)
            }
        }
        
        return cell
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 {return}
        
        let new = newsResults[(indexPath as NSIndexPath).row]
        if new.isread == 0 {
            
            new.isRead() // 设置为已读
        }
        
        let viewController = UIStoryboard.shareStoryBoard.get_DetailAndCommitViewController(new)
        
        viewController.isDismiss = true
        viewController.isFoucsDismiss = true
        
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
//        if indexPath.section == 0 {
//        
//            return self.stringAndHeight("别人可以自嘲，但是你不可以附和")
//        }
//        
//        let new = newsResults[indexPath.row]
//
//        return new.HeightByNewConstraint(tableView,html: false)
//    }
    
    
//    private func stringAndHeight(desc:String) -> CGFloat{
//    
//        let size = CGSize(width: UIScreen.mainScreen().bounds.width-24, height: 1000)
//        
//        let titleheight = NSString(string:desc).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font4], context: nil).height
//        
//        return titleheight+16+19+17+1+16+1+13+18
//        
//        return 45
//    }
}


