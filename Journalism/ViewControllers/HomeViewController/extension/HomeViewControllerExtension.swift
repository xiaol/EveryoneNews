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
        
        self.TextForChangehandleMethod()
    }
    
    
    // 点击用户头像所触发的事件
    @IBAction func ClickUserHeadPhotoAction(sender: AnyObject) {
        
        let viewController = UIStoryboard.shareUserStoryBoard.get_UserCenterViewController()
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animateAlongsideTransition({ (_) in // 横评的时候，处理频道管理显示视图的大小问题
            
            self.ChannelManagerContainerCollectionView.reloadData()
            
            }, completion: nil)
    }
    
    // 初始化分页视图方法
    private func initialPagerTabStripMethod(){
    
        pagerBehaviour = .Progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: false) // 设置为达到两边后不可以进行再滑动
        
        settings.style.buttonBarItemFont = UIFont.boldSystemFontOfSize(15) // 设置显示标题的字体大小
        buttonBarView.backgroundColor = UIColor.whiteColor() // 设置标题模块的背景颜色
        buttonBarView.selectedBar.backgroundColor = UIColor(red: 53/255, green:166/255, blue: 251/255, alpha: 0.2) // 设置选中的barview 的背景颜色
        settings.style.buttonBarItemBackgroundColor = UIColor.clearColor() // 设置ButtonItem 背景颜色
        
        self.ChannelManagerContainerCollectionView.scrollsToTop = false
        
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
    
    // 当系统的文字发生变化的时候出发的方法
    private func TextForChangehandleMethod(){
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.preferredContentSizeChanged(_:)), name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    // 刷新当前页面
    func preferredContentSizeChanged(notifi:NSNotification){
        
        
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
        self.view.layoutIfNeeded()
        self.view.layoutIfNeeded()
        
        self.view.invalidateIntrinsicContentSize()
        
        self.reloadPagerTabStripView()
    }
    
    // 刷新频道列表
    internal func ReloadViewControllers(){
        
        self.reloadViewControllers.removeAll()
        
        for channel in channels.filter("isdelete == 0") {
            
            let viewControllers = standardViewControllers.filter({ (view) -> Bool in return view.title == channel.cname })
            
            var viewController:UIViewController!
            
            if viewControllers.count <= 0 {

                viewController = self.getDisplayViewController(channel)
                
                self.standardViewControllers.append(viewController)
            }else{
                
                viewController = viewControllers.first!
            }
            
            self.reloadViewControllers.append(viewController)
        }
        
        self.reloadPagerTabStripView()
    }
    
    // 获取详情页面
    private func getDisplayViewController(channel:Channel) -> UIViewController{
    
        let displayViewController = UIStoryboard.shareStoryBoard.get_NewslistViewController(channel)
        
        displayViewController.title = channel.cname
        
        if channel.id == 1{
            
            displayViewController.newsResults = self.newsResults.filter("ishotnew = 1 AND isdelete = 0")
        }else{
        
            displayViewController.newsResults = self.newsResults.filter("channel = %@ AND isdelete = 0",channel.id)
        }
        
        displayViewController.delegate = self
        
        return displayViewController
    }
}
