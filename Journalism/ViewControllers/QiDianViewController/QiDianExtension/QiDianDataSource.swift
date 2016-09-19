//
//  QiDianDataSource.swift
//  Journalism
//
//  Created by Mister on 16/7/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension QiDianViewController:UITableViewDataSource,UITableViewDelegate{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return focusResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! QiDianCell
        
        let focus = focusResults[(indexPath as NSIndexPath).row]
        
        cell.setQiDian(focus)
        
        cell.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            
            let viewC = UIStoryboard.shareStoryBoard.get_FocusViewController(focus.name)
            
            viewC.dismiss = true
            
            self.present(viewC, animated: true, completion: nil)
        }))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 71
    }
}
