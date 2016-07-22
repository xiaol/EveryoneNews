//
//  DetailAndCommitViewController.swift
//  Journalism
//
//  Created by 荆文征 on 16/5/21.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip

@objc protocol PreViewControllerDelegate {
    optional func NoCollectionAction(new:New) // 开始
}

class DetailAndCommitViewController:ButtonBarPagerTabStripViewController,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate,WaitLoadProtcol{

    var predelegate: PreViewControllerDelegate!
    
    //MARK: 收藏相关
    var isDismiss = false // 是不是直接返回
    var isFoucsDismiss = false // 是不是点击跳抓恢复
    let DismissedAnimation = CustomViewControllerDismissedAnimation()
    let PresentdAnimation = CustomViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画
    
    override func shouldAutorotate() -> Bool {
        
        return isDismiss ? false : true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return isDismiss ? UIInterfaceOrientationMask.Portrait : UIInterfaceOrientationMask.All
    }
    
    
    //MARK: 正常浏览
    var new:New? // 新闻
    
    @IBOutlet var topClickView:UIView!
    
    @IBOutlet var inputTextView: UITextView! // 输入视图
    @IBOutlet var inputCommitButton: UIButton! // 提交评论按钮
    @IBOutlet var inputBackView: UIView! // 输入评论背景视图
    @IBOutlet var inputContentView: UIView! // 输入评论内容视图
    @IBOutlet var inputContentViewBottomConstraint: NSLayoutConstraint! // 输入视图下方约束
    
    @IBOutlet var collectButton: UIButton! // 没有收藏按钮
    @IBOutlet var collectedButton: UIButton! // 已经收藏按钮
    
    @IBOutlet var OcclusionView: UIView! // 当没有新闻的时候现实的提示页面
    @IBOutlet var commentsLabel: UILabel! // 评论数目
    @IBOutlet var CommentAndPostButton: UIButton! // 评论和原文
    @IBOutlet weak var titleLabel: UILabel! // 标题Label
    
    @IBOutlet var dissButton: UIButton! // 左上角更多按钮
    @IBOutlet var moreButton: UIButton! // 右上角更多按钮
    let detailViewTransitioning = DetailViewAndCommitViewControllerPopAnimatedTransitioning() // Dismiss 反悔动画
    let detailViewInteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画

    var commitViewController:CommitViewController!
    var detailViewController:DetailViewController!
    
    let dataSource = [UIViewController]() // 设置DataSource 
    
    var normalResults:Results<Comment>!
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.resignNotification() // 注册键盘弹出，隐藏见小夕
        
        self.containerView.bounces = false
        self.buttonBarView.hidden = true
        self.titleLabel.text = self.title
        
        self.dissButton.hidden = new == nil
        self.moreButton.hidden = new == nil
        self.OcclusionView.hidden = new != nil
        
        self.navigationController?.delegate = self
        
        self.containerView.panGestureRecognizer.addTarget(self, action: #selector(DetailAndCommitViewController.pan(_:))) // 添加一个视图
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailAndCommitViewController.setCButton), name: USERCOMMENTNOTIFITION, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailAndCommitViewController.getToCommitViewControllerNotification(_:)), name: CLICKTOCOMMENTVIEWCONTROLLER, object: nil) // 当评论页面的查看更多的评论的按钮被评论的消息机制
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailAndCommitViewController.setCollectionButton), name: COLLECTEDNEWORNOCOLLECTEDNEW, object: nil) //收藏状态发生变化
        
        self.setCollectionButton()
        
        if let n = new { // 刷新最热评论 和 普通评论
            CommentUtil.LoadNoramlCommentsList(n)
        }
        
        /**
         *  用户点击 滑动到顶端视图
         */
        self.topClickView.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            
            if self.currentIndex == 0 {
            
                self.detailViewController.tableView.setContentOffset(CGPointZero, animated: true)
            }
           
            if self.currentIndex == 1 {
                
                self.commitViewController.tableView.setContentOffset(CGPointZero, animated: true)
            }
        }))
    }
    
    // 获取到了评论视图的请求了
    func getToCommitViewControllerNotification(notification:NSNotification){
        self.moveToViewControllerAtIndex(1, animated: true)
    }
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        detailViewController = UIStoryboard.shareStoryBoard.get_DetailViewController(new) // 获得详情视图
        commitViewController = UIStoryboard.shareStoryBoard.get_CommitViewController(new) // 获取评论视图
        
        self.detailViewController.ShowF = self
        self.detailViewController.fdismiss = self.isFoucsDismiss
        self.detailViewController.dismiss = self.isDismiss
        
        return [detailViewController,commitViewController]
    }
    

    
    /// 点击新闻收藏按钮
    @IBAction func touchCollected(sender: AnyObject) {
        
        if ShareLUser.utype == 2 {
            
            NSNotificationCenter.defaultCenter().postNotificationName(USERNEDDLOGINTHENCANDOSOMETHING, object: nil)
        }else{
            
            if let n = self.new {
                
                CustomRequest.collectedNew(n)
            }
        }
    }
    
    /// 点击取消新闻收藏按钮
    @IBAction func touchNoCollected(sender: AnyObject) {
        
        if ShareLUser.utype == 2 {
            
            NSNotificationCenter.defaultCenter().postNotificationName(USERNEDDLOGINTHENCANDOSOMETHING, object: nil)
        }else{
            
            if let n = self.new {
                
                CustomRequest.nocollectedNew(n)
            }
        }
    }
    
    /**
     设置收藏按钮方法
     */
    func setCollectionButton(){
    
        self.collectedButton.hidden = (self.new?.refreshs() ?? self.new)?.iscollected == 0
    }
    
    @IBOutlet var CommentButtonBackView:UIView!
    @IBOutlet var CommentButtonLeftSpace: NSLayoutConstraint! // 输入视图下方约束
    
    override func pagerTabStripViewController(pagerTabStripViewController: PagerTabStripViewController, updateIndicatorFromIndex fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        
        if fromIndex == toIndex {
        
            self.setCButton()
            
            return self.CommentButtonLeftSpace.constant = 0
        }
        
        if fromIndex == 0 {
        
            self.CommentButtonLeftSpace.constant = -(self.CommentButtonBackView.frame.width)*progressPercentage
        }else{
        
            self.CommentButtonLeftSpace.constant = -(self.CommentButtonBackView.frame.width)*(1-progressPercentage)
        }
        
        self.view.layoutIfNeeded()
    }
    
    /// 点击查看评论按钮
    @IBAction func touchCommentButton(sender: AnyObject) {
        
        self.moveToViewControllerAtIndex(1, animated: true)
    }
    
    /// 点击去原文按钮
    @IBAction func touchPostButton(sender: AnyObject) {
        
        self.moveToViewControllerAtIndex(0, animated: true)
    }
    
    /**
     设置评论按钮
     */
    func setCButton(){
    
        self.commentsLabel.clipsToBounds = true
        self.commentsLabel.layer.borderColor = UIColor.whiteColor().CGColor
        self.commentsLabel.layer.borderWidth = 1.5
        self.commentsLabel.layer.cornerRadius = 3
        self.commentsLabel.text = new == nil ? " 0 " : " \(new!.comment) "
        self.commentsLabel.hidden = (new == nil || (new?.comment) ?? 0 == 0)
        
        let image = (new == nil || (new?.comment) ?? 0 == 0) ? UIImage(named: "详情页未评论") : UIImage(named: "详情页已评论")
        
        self.CommentAndPostButton.setImage(image, forState: UIControlState.Normal)
    }
}