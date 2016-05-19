//
//  ChannelManager.swift
//  Journalism
//
//  Created by Mister on 16/5/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension HomeViewController{
    
    @IBAction func ClickManagerChannelButton(sender: AnyObject) {
        
        self.HandleChannelManagerStatus()
    }
    
    // 初始化频道视图管理
    internal func InitChannelViewMethod(){
    
        self.ChannelManagerButton.transform = CGAffineTransformIdentity // 初始化管理按钮位置
        self.ChannelManagerTitleView.alpha = 0 // 初始化管理按钮位置
        self.ChannelManagerContainerView.transform = CGAffineTransformTranslate(self.ChannelManagerContainerView.transform, 0, -UIScreen.mainScreen().bounds.height)
        
        self.channelDataSource.setDidSelectItemAtIndexPathBlock { (indexPath) in
            
            self.HandleChannelManagerStatus()
            
            self.moveToViewControllerAtIndex(indexPath.item)
        }
    }
    
    // 处理频道管理的状态
    internal func HandleChannelManagerStatus(animater:Bool = true){
    
        UIView.animateWithDuration(0.3) {
            
            self.ChannelManagerContainerView.transform = (self.ChannelManagerTitleView.alpha == 0) ? CGAffineTransformIdentity :CGAffineTransformTranslate(self.ChannelManagerContainerView.transform, 0, -UIScreen.mainScreen().bounds.height)
        }
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.ChannelManagerButton.transform = (self.ChannelManagerTitleView.alpha == 0) ? CGAffineTransformRotate(self.ChannelManagerButton.transform, -CGFloat(M_PI_4)) : CGAffineTransformIdentity
            self.ChannelManagerTitleView.alpha = self.ChannelManagerTitleView.alpha == 0 ? 1 : 0
            
            }, completion: nil)
    }
}