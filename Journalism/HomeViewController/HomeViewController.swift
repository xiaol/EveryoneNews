//
//  HomeViewController.swift
//  Journalism
//
//  Created by Mister on 16/5/16.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import Foundation
import XLPagerTabStrip

class HomeViewController: ButtonBarPagerTabStripViewController {
    
    internal var standardViewControllers = [UIViewController]() // 为了防止重新加载时图，新建一个视图集合库
    internal var reloadViewControllers = [UIViewController]() // buttonBarViewController 数据源对象集合
    internal let channels = ChannelUtil.GetChannelRealmObjects() // 获取所有数据库中的频道
    
    // MARK: - PagerTabStripDataSource
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        if self.reloadViewControllers.count <= 0 {reloadViewControllers.append(UIStoryboard.shareStoryBoard.get_DisplayViewController())}
        return reloadViewControllers
    }
}