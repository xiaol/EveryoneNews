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


class NewslistViewController: UIViewController {
    
    var newsResults:Results<New>!
    
    var delegate:NewslistViewControllerNoLikeDelegate!
    
    internal var currentPage = 1
    
    internal var channel:Channel? // 该新闻列表的频道对象
    
    @IBOutlet var tableView: UITableView! // UITableView 视图对象
    
}
