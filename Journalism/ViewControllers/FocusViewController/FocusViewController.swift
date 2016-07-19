//
//  FocusViewController.swift
//  Journalism
//
//  Created by Mister on 16/7/12.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift

class FocusViewController: UIViewController {
    
    @IBOutlet var tableView:UITableView!
    
    @IBOutlet var headerView:FoucusHeaderView!
    
    @IBOutlet var pan: UIPanGestureRecognizer!
    
    var dismiss = false
    
    let DismissedAnimation = CustomViewControllerDismissedAnimation()
    let PresentdAnimation = CustomViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }
    
    var newContent:NewContent!
    
    lazy var newsResults:Results<New> = {
    
        return New.foucsArray(self.newContent.pname)
    }()
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.headerView.setNewC(self.newContent)
        
//        self.tableView.tableHeaderView = self.headerView
        self.tableView.scrollIndicatorInsets.top = 170
        self.tableView.contentInset.top = 170
        
        
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(pan)
        pan.delegate = self
        
        /**
         *  该方法会检测用户设置字体大小的方法
         *  当用户设置字体后，会发起该通知。
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
    
    
    @IBAction func ClickCancel(sender:AnyObject){
    
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


