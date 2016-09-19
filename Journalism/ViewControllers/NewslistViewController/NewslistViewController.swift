//
//  NewslistViewController.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift
import PINRemoteImage

@objc protocol NewslistViewControllerNoLikeDelegate{

    /**
     当用户点击不喜欢按钮，出发的delegate
     
     - parameter cell:   不喜欢按钮所在的cell
     - parameter finish: 当用户处理完方法后
     
     - returns: 空
     */
    @objc optional func ClickNoLikeButtonOfUITableViewCell(_ cell:NewBaseTableViewCell,finish:((_ cancel:Bool)->Void)) -> Void
}


class NewslistViewController: UIViewController,WaitLoadProtcol {
    
    // 刷新视图
    var waitView:WaitView!
    
    var notificationToken: NotificationToken? = nil
    
    var focusNotificationToken: NotificationToken? = nil
    
    var timer = Timer()
    var fuckHeaderCellView:UIView!
    @IBOutlet var messageLabel: UILabel! // 加载完成消息提示
    
    var focusResults:Results<Focus> = Focus.ExFocusArray()
    var newsResults:Results<New> = New.allArray()
    
    var delegate:NewslistViewControllerNoLikeDelegate!
    
    internal var channel:Channel? // 该新闻列表的频道对象
    
    @IBOutlet var tableView: UITableView! // UITableView 视图对象
    
    
    override var shouldAutorotate : Bool {
        
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.all
    }
}
