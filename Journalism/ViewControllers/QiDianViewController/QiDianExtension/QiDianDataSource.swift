//
//  QiDianDataSource.swift
//  Journalism
//
//  Created by Mister on 16/7/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension QiDianViewController:UITableViewDataSource,UITableViewDelegate{

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return focusResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! QiDianCell
        
        let focus = focusResults[indexPath.row]
        
        cell.setQiDian(focus)
        
        cell.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            
            let viewC = UIStoryboard.shareStoryBoard.get_FocusViewController(focus.name)
            
            viewC.dismiss = true
            
            self.presentViewController(viewC, animated: true, completion: nil)
        }))
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 71
    }
}
