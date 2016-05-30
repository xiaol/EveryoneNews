//
//  CommitViewController.swift
//  Journalism
//
//  Created by 荆文征 on 16/5/22.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CommitViewController: UIViewController,IndicatorInfoProvider {
    
    var new:New!
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let info = IndicatorInfo(title: "评论")
        
        return info
    }
    
}
