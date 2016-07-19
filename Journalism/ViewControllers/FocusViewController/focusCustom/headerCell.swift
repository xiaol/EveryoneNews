//
//  headerCell.swift
//  Journalism
//
//  Created by Mister on 16/7/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class FocusTableViewCell:UITableViewCell{

    @IBOutlet var descLabel:UILabel!
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        descLabel.font = UIFont.a_font4
    }
}