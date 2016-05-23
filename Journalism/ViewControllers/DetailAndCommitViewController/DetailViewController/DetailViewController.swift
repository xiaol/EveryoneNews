//
//  DetailViewController.swift
//  Journalism
//
//  Created by 荆文征 on 16/5/22.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DetailViewController: UIViewController,IndicatorInfoProvider {
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let info = IndicatorInfo(title: "评论")
        
        return info
    }
}
