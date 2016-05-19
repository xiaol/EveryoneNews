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
    
    
    internal let newsResults = NewsUtil.NewArray() // 获取所有新闻的频道
    internal let channels = ChannelUtil.GetChannelRealmObjects() // 获取所有数据库中的频道
    
    
    @IBOutlet var channelDataSource: HomeViewControllerChannelDataSource! // 频道管理视图的数据源
    
    @IBOutlet var ChannelManagerButton: UIButton! // 频道管理按钮
    @IBOutlet var ChannelManagerTitleView: UIView! // 频道管理标题视图
    @IBOutlet var ChannelManagerContainerView: UIView! // 频道管理内容视图
    @IBOutlet var ChannelManagerContainerCollectionView: UICollectionView! // 频道管理按钮
    
    internal var standardViewControllers = [UIViewController]() // 为了防止重新加载时图，新建一个视图集合库
    internal var reloadViewControllers = [UIViewController]() // buttonBarViewController 数据源对象集合
    
    // MARK: - PagerTabStripDataSource
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        if self.reloadViewControllers.count <= 0 {reloadViewControllers.append(UIStoryboard.shareStoryBoard.get_DisplayViewController())}
        return reloadViewControllers
    }
}