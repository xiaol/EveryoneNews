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
    @objc optional func NoCollectionAction(_ new:New) // 开始
}

class DetailAndCommitViewController:ButtonBarPagerTabStripViewController,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate,WaitLoadProtcol{

    var predelegate: PreViewControllerDelegate!
    
    //MARK: 收藏相关
    var isDismiss = false // 是不是直接返回
    var isFoucsDismiss = false // 是不是点击跳抓恢复
    let DismissedAnimation = CustomViewControllerDismissedAnimation()
    let PresentdAnimation = CustomViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画
    
    override var shouldAutorotate : Bool {
        
        return isDismiss ? false : true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        return isDismiss ? UIInterfaceOrientationMask.portrait : UIInterfaceOrientationMask.all
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
        self.buttonBarView.isHidden = true
        self.titleLabel.text = self.title
        
        self.dissButton.isHidden = new == nil
        self.moreButton.isHidden = new == nil
        self.OcclusionView.isHidden = new != nil
        
        self.navigationController?.delegate = self
        
        self.containerView.panGestureRecognizer.addTarget(self, action: #selector(DetailAndCommitViewController.pan(_:))) // 添加一个视图
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailAndCommitViewController.setCButton), name: NSNotification.Name(rawValue: USERCOMMENTNOTIFITION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailAndCommitViewController.getToCommitViewControllerNotification(_:)), name: NSNotification.Name(rawValue: CLICKTOCOMMENTVIEWCONTROLLER), object: nil) // 当评论页面的查看更多的评论的按钮被评论的消息机制
        NotificationCenter.default.addObserver(self, selector: #selector(DetailAndCommitViewController.setCollectionButton), name: NSNotification.Name(rawValue: COLLECTEDNEWORNOCOLLECTEDNEW), object: nil) //收藏状态发生变化
        
        self.setCollectionButton()
        
        if let n = new { // 刷新最热评论 和 普通评论
            CommentUtil.LoadNoramlCommentsList(n)
            AboutUtil.getAboutListArrayData(n)
        }
        
        
        /**
         *  用户点击 滑动到顶端视图
         */
        self.topClickView.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            
            if self.currentIndex == 0 {
            
                self.detailViewController.tableView.setContentOffset(CGPoint.zero, animated: true)
            }
           
            if self.currentIndex == 1 {
                
                self.commitViewController.tableView.setContentOffset(CGPoint.zero, animated: true)
            }
        }))
    }
    
    // 获取到了评论视图的请求了
    func getToCommitViewControllerNotification(_ notification:Foundation.Notification){
        self.moveToViewController(at: 1, animated: true)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        detailViewController = UIStoryboard.shareStoryBoard.get_DetailViewController(new) // 获得详情视图
        commitViewController = UIStoryboard.shareStoryBoard.get_CommitViewController(new) // 获取评论视图
        
        self.detailViewController.ShowF = self
        self.detailViewController.fdismiss = self.isFoucsDismiss
        self.detailViewController.dismiss = self.isDismiss
        
        return [detailViewController,commitViewController]
    }
    

    
    /// 点击新闻收藏按钮
    @IBAction func touchCollected(_ sender: AnyObject) {
        
        if ShareLUser.utype == 2 {
            
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: USERNEDDLOGINTHENCANDOSOMETHING), object: nil)
        }else{
            
            if let n = self.new {
                
                CustomRequest.collectedNew(n, finish: {
                    
                    self.showNoInterest(title: "收藏完成",height:43,width:135)
                })
            }
        }
    }
    
    /// 点击取消新闻收藏按钮
    @IBAction func touchNoCollected(_ sender: AnyObject) {
        
        if ShareLUser.utype == 2 {
            
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: USERNEDDLOGINTHENCANDOSOMETHING), object: nil)
        }else{
            
            if let n = self.new {
                
                CustomRequest.nocollectedNew(n, finish: { 
                
                    self.showNoInterest(title: "取消收藏完成",height:43,width:160)
                })
            }
        }
    }
    
    /**
     设置收藏按钮方法
     */
    func setCollectionButton(){
    
        self.collectedButton.isHidden = (self.new?.refreshs() ?? self.new)?.iscollected == 0
    }
    
    @IBOutlet var CommentButtonBackView:UIView!
    @IBOutlet var CommentButtonLeftSpace: NSLayoutConstraint! // 输入视图下方约束
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        
        if fromIndex == toIndex {
            
            self.setCButton()
            
            return self.ButtonMethod()
        }
        
        if fromIndex == 0 {
            
            self.CommentButtonLeftSpace.constant = -(self.CommentButtonBackView.frame.width)*progressPercentage
        }else{
            
            self.CommentButtonLeftSpace.constant = -(self.CommentButtonBackView.frame.width)*(1-progressPercentage)
        }
        
        self.view.layoutIfNeeded()
    }
    
    /// 点击查看评论按钮
    @IBAction func touchCommentButton(_ sender: AnyObject) {
        
        self.moveToViewController(at: 1, animated: true)
        
        self.ButtonMethod()
    }
    
    /// 点击去原文按钮
    @IBAction func touchPostButton(_ sender: AnyObject) {
        
        self.moveToViewController(at: 0, animated: true)
        
        self.ButtonMethod()
    }
    
    /**
     按钮设置
     */
    fileprivate func ButtonMethod(){
    
        self.CommentButtonLeftSpace.constant = self.currentIndex == 0 ? 0 : -self.CommentButtonBackView.frame.width
        
        self.view.layoutIfNeeded()
    }
    
    /**
     设置评论按钮
     */
    func setCButton(){
    
        self.commentsLabel.clipsToBounds = true
        self.commentsLabel.layer.borderColor = UIColor.white.cgColor
        self.commentsLabel.layer.borderWidth = 1.5
        self.commentsLabel.layer.cornerRadius = 3
        self.commentsLabel.text = new == nil ? " 0 " : " \(new!.comment) "
        self.commentsLabel.isHidden = (new == nil || (new?.comment) ?? 0 == 0)
        
        let image = (new == nil || (new?.comment) ?? 0 == 0) ? UIImage(named: "详情页未评论") : UIImage(named: "详情页已评论")
        
        self.CommentAndPostButton.setImage(image, for: UIControlState())
    }
}
