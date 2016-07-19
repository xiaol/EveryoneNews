//
//  NewslistViewControllerExtension.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift
import MJRefresh
import PINRemoteImage
import XLPagerTabStrip

extension NewslistViewController{

    /**
     当视图准备显示的时候所做的一些提前的额准备
     1. 设置表格的头部视图和底部视图的高度均为0，来满足设计的需要
     2. 将提示数目的视图隐藏
     3. 设置上拉和下拉的表头尾视图的设置
     4. 如果当前频道是起点频道 则设置为试用下拉刷新的方法来加载数据 如果不是，则使用平常的方法就可以了
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.sectionFooterHeight = 0
        self.tableView.sectionHeaderHeight = 0
        
        self.messageHandleMethod(hidden:true, anmaiter: false) // 隐藏提示视图
        
        self.tableView.mj_header = NewRefreshHeaderView(refreshingBlock: {
                
            self.refreshNewsDataMethod(create:true,show: true)
        })
        
        self.tableView.mj_footer = NewRefreshFooterView {
            
            self.loadNewsDataMethod()
        }
        
        if channel?.id == 1 {
        
            self.refreshNewsDataMethod(del: true,create:true,show: true)
        }else{
            
            print(newsResults.count)
            
            if newsResults == nil || newsResults.count <= 30 {
            
                
                self.refreshNewsDataMethod(del: true,create:true,show: true)
            }
            
            /**
             *  监视当前新闻发生变化之后，进行数据的刷新
             */
            self.notificationToken = newsResults.addNotificationBlock { (_) in
                
                self.tableView.reloadData()
            }
        }
        
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
            
            self.tableView.reloadData()
        }
    }
}




// MARK: - 刷新数据或者下拉加载数据的处理放啊集合
extension NewslistViewController{
    /**
     下拉刷新 获取更新的新闻数据
     当用户第一次进入时，数据往往是不存在，首先需要上拉加载一些数据。
     只有在当前频道为奇点频道的时候才会展示加载成功消息
     
     默认请求第一张 的 20条新闻消息
     
     - parameter show: 是否显示加载成功消息
     */
    private func refreshNewsDataMethod(del delete:Bool = false,create:Bool = false,show:Bool = false){
        
        guard let channelId = self.channel?.id else{return self.handleMessageShowMethod("未知错误", show: true,bc: UIColor.a_noConn)}
        
        if newsResults.count <= 0 {
            
            self.showWaitLoadView()
            
            return NewsUtil.LoadNewsListArrayData(channelId,times: "\(Int64(NSDate().timeIntervalSince1970*1000))",finish: {
                
                let message = self.newsResults.count <= 0 ? "没有加载到新的数据" : "一共刷新了\(self.newsResults.count)条数据"
                
                self.handleMessageShowMethod(message, show: show)
                
                }, fail: {
                    
                    self.waitView.setNoNetWork({ 
                        
                        self.refreshNewsDataMethod(del: delete, create: create, show: show)
                    })
            })
        }else if let last = self.newsResults.first{
            
            var time = last.ptimes
            
            if last.ptimes.hoursBeforeDate(NSDate()) >= 12{
                
                time = NSDate().dateByAddingHours(-12)
            }
            
            NewsUtil.RefreshNewsListArrayData(channelId,delete:delete, create: create,times: "\(Int64(time.timeIntervalSince1970*1000))", finish: { (count) in
                
                let message = count <= 0 ? "没有加载到新的数据" : "一共刷新了\(count)条数据"
                self.handleMessageShowMethod(message, show: show)
                }, fail: {
                    
                    self.handleMessageShowMethod("加载数据失败", show: show,bc: UIColor.a_noConn)
            })
        }else{
            self.handleMessageShowMethod("未知错误", show: true,bc: UIColor.a_noConn)
        }
    }
    
    /**
     处理消息提示显示方法，和初始化方法
     */
    private func handleMessageShowMethod(message:String,show:Bool,bc:UIColor=UIColor.a_color2){

        self.hiddenWaitLoadView()
        
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
        
        self.tableView.reloadData()
        
        if !show {return}
        self.messageHandleMethod(message,backColor: bc)
    }
    
    /**
     上啦加载新闻，当用户向上拉去的时候，获取当前所有新闻最后一条的新闻的世间之后的世间
     默认获取的个数位20个。
     默认是获取第一页。
     */
    private func loadNewsDataMethod(){
        
        if let channelId = self.channel?.id,last = self.newsResults.last {
            
            NewsUtil.LoadNewsListArrayData(channelId,times: "\(Int64(last.ptimes.timeIntervalSince1970*1000))",finish: {
                
                self.tableView.mj_footer.endRefreshing()
                
                self.tableView.reloadData()
                
                }, fail: {
                    
                    self.tableView.mj_footer.endRefreshing()
            })
        }
    }
}

// MARK: - 显示刷新数目视图的处理方法集合
extension NewslistViewController{

    /**
     下拉刷新成功后向用户提醒刷新数目的显示方法
     如果参数 hidden 为 true 则为隐藏，如果为 false 则为 显示
     
     - parameter message:   要向用户展示的消息
     - parameter backColor: 向用户展示的消息背景颜色，默认为app 主色调
     - parameter hidden:    是隐藏还是
     - parameter anmaiter:  需不需要动画显示
     */
    private func messageHandleMethod(message:String = "",backColor:UIColor=UIColor.a_color2,hidden:Bool = false,anmaiter:Bool = true){
        
        if self.timer.valid { self.timer.invalidate() }
        
        self.messageLabel.text = message
        self.messageLabel.backgroundColor = backColor
        
        let show = CGAffineTransformIdentity // 显示视图
        let hiddent = CGAffineTransformTranslate(self.messageLabel.transform, 0, -self.messageLabel.frame.height) // 隐藏加载视图
        
        UIView.animateWithDuration(anmaiter ? 0.3 : 0) {
            
            self.messageLabel.transform = hidden ? hiddent : show
        }
        
        if hidden {return} // 如果隐藏就不需要再次隐藏了
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(NewslistViewController.hiddenTips(_:)), userInfo: nil, repeats: false)
    }
    
    /**
     隐藏提示条的方法，会被时间定时器调用
     
     - parameter timer: 定时器对象
     */
    func hiddenTips(timer:NSTimer){
        
        let hiddent = CGAffineTransformTranslate(self.messageLabel.transform, 0, -self.messageLabel.frame.height) // 隐藏加载视图
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.messageLabel.transform = hiddent
        })
    }
}


extension NewslistViewController:IndicatorInfoProvider{

    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let info = IndicatorInfo(title: channel?.cname ?? "")
        
        return info
    }
}