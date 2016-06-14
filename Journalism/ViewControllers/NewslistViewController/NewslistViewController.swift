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

    optional func ClickNoLikeButtonOfUITableViewCell(cell:NewBaseTableViewCell,finish:((cancel:Bool)->Void)) -> Void
}


class NewslistViewController: UIViewController,WaitLoadProtcol {
    
    var notificationToken: NotificationToken? = nil
    
    var timer = NSTimer()
    
    var fuckHeaderCellView:UIView!
    
    @IBOutlet var messageLabel: UILabel! // 加载完成消息提示
    
    var newsResults:Results<New>!
    
    var delegate:NewslistViewControllerNoLikeDelegate!
    
    internal var channel:Channel? // 该新闻列表的频道对象
    
    @IBOutlet var tableView: UITableView! // UITableView 视图对象
}
