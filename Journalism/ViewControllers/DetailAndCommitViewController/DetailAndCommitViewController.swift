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

    var new:New?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let detailViewTransitioning = DetailViewAndCommitViewControllerPopAnimatedTransitioning() // Dismiss 反悔动画
    let detailViewInteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画

    let dataSource = [UIViewController]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.containerView.bounces = false
        self.buttonBarView.hidden = true
        self.titleLabel.text = self.title
        
        self.navigationController?.delegate = self
        
        self.containerView.panGestureRecognizer.addTarget(self, action: #selector(DetailAndCommitViewController.pan(_:)))
    }

    
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        
        
    }
    
    // 切换全屏活着完成反悔上一个界面
    @IBAction func touchViewController(sender: AnyObject) {
        
        let horizontal = UIScreen.mainScreen().bounds.width > UIScreen.mainScreen().bounds.height
        
        if horizontal && IS_PLUS{
            
            self.splitViewController?.preferredDisplayMode = self.splitViewController?.preferredDisplayMode == .AllVisible ? .PrimaryHidden : .AllVisible
            
        }else{
        
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let detailViewController = UIStoryboard.shareStoryBoard.get_DetailViewController(new)
        let commitViewController = UIStoryboard.shareStoryBoard.get_CommitViewController(new)
        
        return [detailViewController,commitViewController]
    }
}