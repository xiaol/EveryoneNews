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
        
        self.noCollectedCount.isHidden = self.newsResults.count <= 0
        
        tableView.panGestureRecognizer.require(toFail: pan)
        pan.delegate = self
        
        
        self.tableView.mj_header = NewRefreshHeaderView(refreshingBlock: {
            
            self.finishRefresh()
        })
        
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
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: FONTMODALSTYLEIDENTIFITER), object: nil, queue: OperationQueue.main) { (_) in
            
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: COLLECTEDNEWORNOCOLLECTEDNEW), object: nil, queue: OperationQueue.main) { (_) in
            
             self.finishRefresh()
        }
        
        self.finishRefresh()
    }
    
    
    fileprivate func finishRefresh(){
    
        NewsUtil.getAllCollectionResultMthod({
            
            self.tableView.mj_header.endRefreshing()
            self.noCollectedCount.isHidden = self.newsResults.count > 0
            self.tableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
        })
    }
    
    func NoCollectionAction(_ new: New) {
        
        CustomRequest.nocollectedNew(new)
    }
}



extension UserCollectionViewController:UIViewControllerPreviewingDelegate{
    
    @available(iOS 9.0, *)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        self.show(viewControllerToCommit, sender: nil)
    }
    
    @available(iOS 9.0, *)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if let cell = previewingContext.sourceView as? NewBaseTableViewCell,let indexPath = self.tableView.indexPath(for: cell){
            let new = newsResults[(indexPath as NSIndexPath).row]
            if new.isread == 0 {
                new.isRead() // 设置为已读
            }
            let viewController = UIStoryboard.shareStoryBoard.get_DetailAndCommitViewController(new)
            viewController.isDismiss = true
            viewController.predelegate = self
            return viewController
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if newsResults == nil {return 0}
        
        return newsResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        var cell :NewBaseTableViewCell!
        
        let new = newsResults[(indexPath as NSIndexPath).row]
        
        if new.style == 0 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewNormalTableViewCell") as! NewNormalTableViewCell
            
            cell.setNewObject(new)
            
        }else if new.style == 1 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewOneTableViewCell") as! NewOneTableViewCell
            
            cell.setNewObject(new)
            
        }else if new.style == 2 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewTwoTableViewCell") as! NewTwoTableViewCell
            
            cell.setNewObject(new)
            
        }else if new.style == 3 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewThreeTableViewCell") as! NewThreeTableViewCell
            
            cell.setNewObject(new)
        }else{ 
            
            cell = tableView.dequeueReusableCell(withIdentifier: "NewTwoTableViewCell") as! NewTwoTableViewCell
            
            switch new.style-10 {
            case 1:
                cell.setNewObject(new,bigImg: 0)
            case 2:
                cell.setNewObject(new,bigImg: 1)
            default:
                cell.setNewObject(new,bigImg: 2)
            }
        }
        
        if #available(iOS 9.0, *) {
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapability.available) && !tableView.isEditing{
                
                if let perView = cell.viewControllerPreviewing {
                    
                    self.unregisterForPreviewing(withContext: perView)
                }
                
                cell.viewControllerPreviewing =  self.registerForPreviewing(with: self, sourceView: cell)
            }
        }
        
        return cell
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let new = newsResults[(indexPath as NSIndexPath).row]
        
        if new.isread == 0 {
            new.isRead() // 设置为已读
        }
        
        if new.isidentification == 1 {
            
            self.tableView.mj_header.beginRefreshing()
            
            return
        }
        
        let viewController = UIStoryboard.shareStoryBoard.get_DetailAndCommitViewController(new)
        
        viewController.isDismiss = true
        
        self.show(viewController, sender: nil)
        
        self.tableView.reloadData()
    }
    
    @objc(tableView:estimatedHeightForRowAtIndexPath:) func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let new = newsResults[(indexPath as NSIndexPath).row]

        return new.HeightByNewConstraint(tableView)
    }
}

