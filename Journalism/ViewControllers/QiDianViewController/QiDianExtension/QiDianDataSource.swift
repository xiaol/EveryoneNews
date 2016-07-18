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
        
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! QiDianCell
        
        cell.setQiDian(indexPath.row%2==0)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 71
    }
}
