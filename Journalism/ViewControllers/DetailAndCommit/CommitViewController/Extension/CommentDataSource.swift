//
//  CommentDataSource.swift
//  Journalism
//
//  Created by Mister on 16/6/1.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit


extension CommitViewController{

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        guard let hot = hotResults,_ = normalResults else{
            
            if section == 1 {
            
                return 24
            }
            
            return 0
        }
        
        if section == 0 && hot.count <= 0 {
        
            return 0
        }
        
        return 24
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
    }
    
    // 返回有几个 Section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    // 设置每一个Section 的 返回个数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let hot = hotResults,noraml = normalResults else{ return 0}
        
        if section == 0 {
        
            return hot.count
        }
        
        if noraml.count > 0 {
        
            return noraml.count
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var comment:Comment!
        
        if indexPath.section == 0 {
        
            comment = hotResults[indexPath.item]
        }
        
        if indexPath.section == 1 && (normalResults == nil || normalResults.count <= 0) {
        
            return 300
        }else{
        
            comment = normalResults[indexPath.item]
        }
        
        return comment.HeightByNewConstraint(tableView)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var comment:Comment!
        
        if hotResults.count > 0 && normalResults.count > 0 && indexPath.section == 0{
            
            comment = hotResults[indexPath.item]
        }else if normalResults.count > 0{
            
            comment = normalResults[indexPath.item]
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("nocell")! as UITableViewCell
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("comments") as! CommentsTableViewCell
        
        cell.setCommentMethod(comment)
        
        cell.setNeedsDisplay()
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("newcomments") as! CommentsTableViewHeader
        
        if section == 0 {
            
            let text = hotResults.count > 0 ? "(\(hotResults.count))" : ""
            
            cell.titleLabel.text = "最热评论\(text)"
            
        }else{
        
            let text = new!.comment > 0 ? "(\(new!.comment))" : ""
            
            cell.titleLabel.text = "最新评论\(text)"
        }
        
        return cell
    }
}