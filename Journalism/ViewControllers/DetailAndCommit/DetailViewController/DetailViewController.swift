//
//  DetailViewController.swift
//  Journalism
//
//  Created by 荆文征 on 16/5/22.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import WebKit
import MJRefresh
import RealmSwift
import XLPagerTabStrip

class DetailViewController: UIViewController,WaitLoadProtcol {
    
    var waitView:WaitView!
    var new:New? // 当前要展示的新闻对象
    
    let realm = try! Realm()
    
    var newCon:NewContent!
    var hotResults:Results<Comment>!
    var aboutResults:Results<About>!
    
    var webView: WKWebView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let new = new {
            
            newCon = new.getNewContentObject()
            
            aboutResults = realm.objects(About.self).filter("nid = \(new.nid)").sorted("ptimes", ascending: false)
            hotResults = realm.objects(Comment.self).filter("nid = \(new.nid) AND ishot = 1").sorted("commend", ascending: false)
            
            CommentUtil.LoadHotsCommentsList(new, finish: {
                
                self.tableView.reloadData()
            })
            
            AboutUtil.getAboutListArrayData(new, finish: { (count) in
                
                self.tableView.reloadData()
            })
        }
        
        self.integrationMethod()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailViewController.setCollectionButton), name: CONCERNNEWORNOCOLLECTEDNEW, object: nil) //收藏状态发生变化
    }
    
    func setCollectionButton(){
        
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}


extension DetailViewController:IndicatorInfoProvider{
    
    /**
      当设备的方向发生变化时，将会调用这个方法
     当设备的方向发生了变化之后，我们要为之重新设置详情页中webview的高度。
     
     - parameter size:        方向完成后的大小
     - parameter coordinator: 方向变化的动画渐变对象
     */
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animateAlongsideTransition({ (_) in
            
            self.adaptionWebViewHeightMethod()
            
            }, completion: nil)
        
    }
    
    /**
     PageView DataSource 设置当前识图的标题
     
     - parameter pagerTabStripController: 视图对象
     - returns: 标题对象
     */
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let info = IndicatorInfo(title: "评论")
        
        return info
    }
}
