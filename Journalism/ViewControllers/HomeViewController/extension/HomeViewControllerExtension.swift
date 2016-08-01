//
//  HomeViewControllerExtension.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift
import PINRemoteImage
import XLPagerTabStrip

extension HomeViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadMoreButtonView()
        self.InitChannelViewMethod()
        self.ReloadChannelHttpRequest()
        self.initialPagerTabStripMethod()
        
        /**
         *  该方法会检测用户设置字体大小的方法
         *  当用户设置字体后，会发起该通知。完成修改频道排序列表显示的方法以及频道列表的字体修改
         *
         *  @param FONTMODALSTYLEIDENTIFITER  用户发起的通知的名称
         *  @param nil                        所携带的数据
         *  @param NSOperationQueue.mainQueue 需要执行接下来操作的县城
         *
         *  @return 所需要完成的操作
         */
        NSNotificationCenter.defaultCenter().addObserverForName(FONTMODALSTYLEIDENTIFITER, object: nil, queue: NSOperationQueue.mainQueue()) { (_) in
            
            self.ChannelManagerContainerCollectionView.reloadData()
            self.buttonBarView.reloadData()
        }
        
        // 需要用户注册才可继续操作
        NSNotificationCenter.defaultCenter().addObserverForName(USERNEDDLOGINTHENCANDOSOMETHING, object: nil, queue: NSOperationQueue.mainQueue()) { (_) in
            
            let viewController = UIStoryboard.shareUserStoryBoard.get_LoginViewController()
            
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    
    // 点击用户头像所触发的事件
    @IBAction func ClickUserHeadPhotoAction(sender: AnyObject) {
        
        var viewController:UIViewController!
        
        if ShareLUser.utype != 2 {
            
            viewController = UIStoryboard.shareUserStoryBoard.get_UserCenterViewController()
            self.presentViewController(viewController, animated: true, completion: nil)
        }else{
            
            NSNotificationCenter.defaultCenter().postNotificationName(USERNEDDLOGINTHENCANDOSOMETHING, object: nil)
        }
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animateAlongsideTransition({ (_) in // 横评的时候，处理频道管理显示视图的大小问题
            
            if self.ChannelManagerTitleView.alpha == 1 {
            
                self.HandleChannelManagerStatus()
            }
            
            self.reloadMoreButtonView()
            
            self.ChannelManagerContainerCollectionView.reloadData()
            
            }, completion: nil)
    }
    
    /**
     舒心是否隐藏加号视图
     */
    func reloadMoreButtonView(){
    
        self.MoreButtonBackView.snp_updateConstraints { (make) in
            
            make.width.equalTo(UIScreen.mainScreen().bounds.width > UIScreen.mainScreen().bounds.height ? 0 : 44)
        }
        
        self.MoreButtonBackView.layoutIfNeeded()
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
            newCell?.label.textColor = UIColor.a_color2
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
        }else if channel.id == 1994 {
            displayViewController.newsResults = self.newsResults.filter("isfocus = 1 AND isdelete = 0 ")
        }else{
            displayViewController.newsResults = self.newsResults.filter("channel = %@ AND isdelete = 0 ",channel.id)
        }
        
        displayViewController.delegate = self
        
        return displayViewController
    }
}
