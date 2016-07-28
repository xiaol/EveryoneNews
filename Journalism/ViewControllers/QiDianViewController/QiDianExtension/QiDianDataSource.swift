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
        
        cell.foucsButton.removeActions(.TouchUpInside)
        cell.foucsButton.addAction(UIControlEvents.TouchUpInside) { (_) in
            
            if ShareLUser.utype == 2 {
                
                NSNotificationCenter.defaultCenter().postNotificationName(USERNEDDLOGINTHENCANDOSOMETHING, object: nil)
            }else{
                
                self.ForNFMethod(cell,name: focus.name)
            }
        }
        
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
    
    
    private func ForNFMethod(cell:QiDianCell,name:String){
        
        cell.foucsButton.loading()
        
        if !Focus.isExiter(name) {
            
            Focus.focusPub(name, finish: {
                
                NSNotificationCenter.defaultCenter().postNotificationName(USERFOCUSPNAMENOTIFITION, object: nil)
                
                cell.foucsButton.refresh()
                
                }, fail: {
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(USERFOCUSPNAMENOTIFITION, object: nil)
                    
                    cell.foucsButton.refresh()
            })
            
        }else{
            
            Focus.nofocusPub(name, finish: {
                
                NSNotificationCenter.defaultCenter().postNotificationName(USERFOCUSPNAMENOTIFITION, object: nil)
                
                cell.foucsButton.refresh()
                
                }, fail: {
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(USERFOCUSPNAMENOTIFITION, object: nil)
                    
                    cell.foucsButton.refresh()
            })
        }
    }
}
