//
//  UserCommentViewController.swift
//  Journalism
//
//  Created by Mister on 16/6/22.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift

class UserCollectionViewController:UIViewController,UITableViewDelegate,PreViewControllerDelegate{
    
    var newsResults:Results<New>!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var pan: UIPanGestureRecognizer!
    
    @IBOutlet var noCollectedCount: UIView!
    
    let DismissedAnimation = CustomViewControllerDismissedAnimation()
    let PresentdAnimation = CustomViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.newsResults = NewsUtil.NewArray().filter("iscollected = 1 AND isdelete = 0")
        
        self.noCollectedCount.hidden = self.newsResults.count <= 0
        
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(pan)
        pan.delegate = self
        
        
        self.tableView.mj_header = NewRefreshHeaderView(refreshingBlock: {
            
            self.finishRefresh()
        })
        
        // 获得字体变化通知，完成刷新字体大小方法
        NSNotificationCenter.defaultCenter().addObserverForName(FONTMODALSTYLEIDENTIFITER, object: nil, queue: NSOperationQueue.mainQueue()) { (_) in
            
            self.tableView.reloadData()
        }
        NSNotificationCenter.defaultCenter().addObserverForName(COLLECTEDNEWORNOCOLLECTEDNEW, object: nil, queue: NSOperationQueue.mainQueue()) { (_) in
            
             self.finishRefresh()
        }
        
        self.finishRefresh()
    }
    
    
    private func finishRefresh(){
    
        NewsUtil.getAllCollectionResultMthod({
            
            self.tableView.mj_header.endRefreshing()
            self.noCollectedCount.hidden = self.newsResults.count > 0
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        })
    }
    
    func NoCollectionAction(new: New) {
        
        CustomRequest.nocollectedNew(new)
    }
}



extension UserCollectionViewController:UIViewControllerPreviewingDelegate{
    
    @available(iOS 9.0, *)
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        self.showViewController(viewControllerToCommit, sender: nil)
    }
    
    @available(iOS 9.0, *)
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if let cell = previewingContext.sourceView as? NewBaseTableViewCell,indexPath = self.tableView.indexPathForCell(cell){
            let new = newsResults[indexPath.row]
            new.isRead() // 设置为已读
            let viewController = UIStoryboard.shareStoryBoard.get_DetailAndCommitViewController(new)
            viewController.isDismiss = true
            viewController.predelegate = self
            return viewController
        }
        return nil
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if newsResults == nil {return 0}
        
        return newsResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell :NewBaseTableViewCell!
        
        let new = newsResults[indexPath.row]
        
        if new.style == 0 {
            
            cell =  tableView.dequeueReusableCellWithIdentifier("NewNormalTableViewCell") as! NewNormalTableViewCell
            
            cell.setNewObject(new)
            
        }else if new.style == 1 {
            
            cell =  tableView.dequeueReusableCellWithIdentifier("NewOneTableViewCell") as! NewOneTableViewCell
            
            cell.setNewObject(new)
            
        }else if new.style == 2 {
            
            cell =  tableView.dequeueReusableCellWithIdentifier("NewTwoTableViewCell") as! NewTwoTableViewCell
            
            cell.setNewObject(new)
            
        }else if new.style == 3 {
            
            cell =  tableView.dequeueReusableCellWithIdentifier("NewThreeTableViewCell") as! NewThreeTableViewCell
            
            cell.setNewObject(new)
        }
        
        if #available(iOS 9.0, *) {
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapability.Available) && !tableView.editing{
                self.registerForPreviewingWithDelegate(self, sourceView: cell)
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let new = newsResults[indexPath.row]
        
        new.isRead() // 设置为已读
        
        if new.isidentification == 1 {
            
            self.tableView.mj_header.beginRefreshing()
            
            return
        }
        
        let viewController = UIStoryboard.shareStoryBoard.get_DetailAndCommitViewController(new)
        
        viewController.isDismiss = true
        
        self.showViewController(viewController, sender: nil)
        
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let new = newsResults[indexPath.row]

        return new.HeightByNewConstraint(tableView)
    }
}
