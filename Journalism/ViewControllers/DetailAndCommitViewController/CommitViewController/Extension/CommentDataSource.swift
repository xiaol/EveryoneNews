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
        
        return 24
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if let hot = hotResults,normal = normalResults {
            
            if hot.count > 0 && normal.count > 0 {
                
                return 2
            }
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        
        
        
        
        if hotResults.count > 0 && normalResults.count > 0 && section == 0{
            
            return hotResults.count
            
        }else if normalResults.count > 0{
            
            return normalResults.count
        }else{
            
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var comment:Comment!
        
        if hotResults.count > 0 && normalResults.count > 0 && indexPath.section == 0{
            
            comment = hotResults[indexPath.item]
        }else if normalResults.count > 0{
            
            comment = normalResults[indexPath.item]
        }else{
            
            return 300
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
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("newcomments") as! CommentsTableViewHeader
        
        if hotResults.count > 0 && normalResults.count > 0{
            
            let text = hotResults.count > 0 ? "(\(hotResults.count))" : ""
            
            cell.titleLabel.text = "最热评论\(text)"
        }else{
            
            let text = new!.comment > 0 ? "(\(new!.comment))" : ""
            
            cell.titleLabel.text = "最新评论\(text)"
        }
        
        return cell
    }
}