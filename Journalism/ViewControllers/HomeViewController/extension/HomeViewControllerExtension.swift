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
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: FONTMODALSTYLEIDENTIFITER), object: nil, queue: OperationQueue.main) { (_) in
            
            self.ChannelManagerContainerCollectionView.reloadData()
            self.buttonBarView.reloadData()
        }
    }
    
    
    // 点击用户头像所触发的事件
    @IBAction func ClickUserHeadPhotoAction(_ sender: AnyObject) {
        
        var viewController:UIViewController!
        
        if ShareLUser.utype != 2 {
            
            viewController = UIStoryboard.shareUserStoryBoard.get_UserCenterViewController()
            self.present(viewController, animated: true, completion: nil)
        }else{
            
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: USERNEDDLOGINTHENCANDOSOMETHING), object: nil)
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (_) in // 横评的时候，处理频道管理显示视图的大小问题
            
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
    
        self.MoreButtonBackView.snp.updateConstraints { (make) in
            
            make.width.equalTo(UIScreen.main.bounds.width > UIScreen.main.bounds.height ? 0 : 44)
        }
        
        self.MoreButtonBackView.layoutIfNeeded()
    }
    
    // 初始化分页视图方法
    fileprivate func initialPagerTabStripMethod(){
    
        pagerBehaviour = .progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: false) // 设置为达到两边后不可以进行再滑动
        
        settings.style.buttonBarItemFont = UIFont.boldSystemFont(ofSize: 15) // 设置显示标题的字体大小
        buttonBarView.backgroundColor = UIColor.white // 设置标题模块的背景颜色
        buttonBarView.selectedBar.backgroundColor = UIColor(red: 53/255, green:166/255, blue: 251/255, alpha: 0.2) // 设置选中的barview 的背景颜色
        settings.style.buttonBarItemBackgroundColor = UIColor.clear // 设置ButtonItem 背景颜色
        
        self.ChannelManagerContainerCollectionView.scrollsToTop = false
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in // 设置滑动时改编字体
            
            guard changeCurrentIndex == true else { return }
            self.ReloadVisCellsSelectedMethod(self.currentIndex) // 刷新这个频道管理的额标题颜色
            self.ChannelDataSource.ChannelCurrentIndex = self.currentIndex
            
            oldCell?.label.textColor = UIColor.black.withAlphaComponent(0.8)
            newCell?.label.textColor = UIColor.a_color2
        }
    }
    

    
    // 首先根据本地数据库刷新页面。 之后使用网络刷新页面
    fileprivate func ReloadChannelHttpRequest(){
        
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
    fileprivate func getDisplayViewController(_ channel:Channel) -> UIViewController{
    
        let displayViewController = UIStoryboard.shareStoryBoard.get_NewslistViewController(channel)
        
        displayViewController.title = channel.cname
        
        if channel.id == 1{
            
            displayViewController.newsResults = self.newsResults.filter("ishotnew = 1 AND isdelete = 0")
        }else if channel.id == 1994 {
            displayViewController.newsResults = self.newsResults.filter("isfocus = 1 AND isdelete = 0 ")
        }else{
            displayViewController.newsResults = self.newsResults.filter("(ANY channelList.channel = %@ AND isdelete = 0 ) OR ( channel = %@ AND isidentification = 1 )",channel.id,channel.id)
        }
        
        displayViewController.delegate = self
        
        return displayViewController
    }
}
