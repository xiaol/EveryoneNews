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

class DetailAndCommitViewController:ButtonBarPagerTabStripViewController,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate{

    var new:New? // 新闻
    @IBOutlet var inputTextView: UITextView! // 输入视图
    @IBOutlet var inputCommitButton: UIButton! // 提交评论按钮
    @IBOutlet var inputBackView: UIView! // 输入评论背景视图
    @IBOutlet var inputContentView: UIView! // 输入评论内容视图
    @IBOutlet var inputContentViewBottomConstraint: NSLayoutConstraint! // 输入视图下方约束
    
    @IBOutlet var collectButton: UIButton! // 没有收藏按钮
    @IBOutlet var collectedButton: UIButton! // 已经收藏按钮
    
    @IBOutlet var shareBackView: UIView! // 分享背景视图
    @IBOutlet var shareContentView: UIView! // 分享内容视图
    
    @IBOutlet var OcclusionView: UIView! // 当没有新闻的时候现实的提示页面
    @IBOutlet var commentsLabel: UILabel! // 评论数目
    @IBOutlet var CommentAndPostButton: UIButton! // 评论和原文
    @IBOutlet weak var titleLabel: UILabel! // 标题Label
    
    @IBOutlet var dissButton: UIButton! // 左上角更多按钮
    @IBOutlet var moreButton: UIButton! // 右上角更多按钮
    let detailViewTransitioning = DetailViewAndCommitViewControllerPopAnimatedTransitioning() // Dismiss 反悔动画
    let detailViewInteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画


    let dataSource = [UIViewController]() // 设置DataSource 
    
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailAndCommitViewController.getToCommitViewControllerNotification(_:)), name: CLICKTOCOMMENTVIEWCONTROLLER, object: nil) // 当评论页面的查看更多的评论的按钮被评论的消息机制
        
        self.shreContentViewMethod(true, animate: false)
        
        if let n = new { // 刷新最热评论 和 普通评论
            CommentUtil.LoadNoramlCommentsList(n)
        }
        
        
        self.setCommentOrDetailButton()
    }
    
    // 获取到了评论视图的请求了
    func getToCommitViewControllerNotification(notification:NSNotification){
        self.moveToViewControllerAtIndex(1, animated: true)
    }
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let detailViewController = UIStoryboard.shareStoryBoard.get_DetailViewController(new) // 获得详情视图
        let commitViewController = UIStoryboard.shareStoryBoard.get_CommitViewController(new) // 获取评论视图
        
        return [detailViewController,commitViewController]
    }
    
    /// 点击评论文章切换按钮
    @IBAction func touchCommentAndPost(sender: AnyObject) {
        
        self.moveToViewControllerAtIndex(self.currentIndex == 0 ? 1 : 0, animated: true)
    }
    
    override func pagerTabStripViewController(pagerTabStripViewController: PagerTabStripViewController, updateIndicatorFromIndex fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        
        if indexWasChanged {
            self.setCommentOrDetailButton()
        }
    }
    
    // 设置滑动页面的时候是，评论还是前往原文
    private func setCommentOrDetailButton(){
    
        self.commentsLabel.clipsToBounds = true
        self.commentsLabel.layer.borderColor = UIColor.whiteColor().CGColor
        self.commentsLabel.layer.borderWidth = 1.5
        self.commentsLabel.layer.cornerRadius = 3
        self.commentsLabel.text = new == nil ? " 0 " : " \(new!.comment) "
        self.commentsLabel.hidden = new?.comment <= 0 || currentIndex == 1
        
        if currentIndex == 0 {
            if new?.comment <= 0 {
                self.CommentAndPostButton.setImage(UIImage(named: "详情页未评论"), forState: UIControlState.Normal)
            }else{
                self.CommentAndPostButton.setImage(UIImage(named: "详情页已评论"), forState: UIControlState.Normal)
            }
        }
        if currentIndex == 1 {
            self.CommentAndPostButton.setImage(UIImage(named: "详情页原文"), forState: UIControlState.Normal)
        }
    }
}