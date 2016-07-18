//
//  QiDianViewController.swift
//  Journalism
//
//  Created by Mister on 16/7/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class QiDianViewController: UIViewController,PreViewControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var pan: UIPanGestureRecognizer!
    
    let DismissedAnimation = CustomViewControllerDismissedAnimation()
    let PresentdAnimation = CustomViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(pan)
        pan.delegate = self
    }
}


