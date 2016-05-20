//
//  HomeViewControllerExtension.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip

extension HomeViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.InitChannelViewMethod()
        self.ReloadChannelHttpRequest()
        self.initialPagerTabStripMethod()
    }
    
    // 初始化分页视图方法
    private func initialPagerTabStripMethod(){
    
        pagerBehaviour = .Progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: false) // 设置为达到两边后不可以进行再滑动
        
        settings.style.buttonBarItemFont = UIFont.boldSystemFontOfSize(15) // 设置显示标题的字体大小
        buttonBarView.backgroundColor = UIColor.whiteColor() // 设置标题模块的背景颜色
        buttonBarView.selectedBar.backgroundColor = UIColor(red: 53/255, green:166/255, blue: 251/255, alpha: 0.2) // 设置选中的barview 的背景颜色
        settings.style.buttonBarItemBackgroundColor = UIColor.clearColor() // 设置ButtonItem 背景颜色
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in // 设置滑动时改编字体
            guard changeCurrentIndex == true else { return }
            
            self.ReloadVisCellsSelectedMethod(self.currentIndex) // 刷新这个频道管理的额标题颜色
            
            self.ChannelDataSource.ChannelCurrentIndex = self.currentIndex
            
            oldCell?.label.textColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
            newCell?.label.textColor = UIColor(red: 53/255, green:166/255, blue: 251/255, alpha: 1)
        }
    }
    
    // 首先根据本地数据库刷新页面。 之后使用网络刷新页面
    private func ReloadChannelHttpRequest(){
        
        self.ReloadViewControllers()
        
        ChannelUtil.RefreshChannleObjects({
            self.ReloadViewControllers()
            self.ChannelManagerContainerCollectionView.reloadData()
            }, fail: nil)
    }
    
    
    // 刷新频道列表
    internal func ReloadViewControllers(){
        
        self.reloadViewControllers.removeAll()
        
        for channel in channels.filter("isdelete == 0") {
            
            let viewControllers = standardViewControllers.filter({ (view) -> Bool in return view.title == channel.cname })
            
            let viewController:UIViewController!
            
            if viewControllers.count <= 0 {
                let ex = UIStoryboard.shareStoryBoard.get_DisplayViewController(channel)
                
                ex.title = channel.cname
                ex.newsResults = self.newsResults.filter("channelId = %@",channel.id)
                
                viewController = ex
                self.standardViewControllers.append(viewController)
                
            }else{
                
                viewController = viewControllers.first!
            }
            
            self.reloadViewControllers.append(viewController)
        }
        
        self.reloadPagerTabStripView()
    }
}
