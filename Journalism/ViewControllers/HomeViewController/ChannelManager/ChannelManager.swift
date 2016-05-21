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
        
        
        let width = UIScreen.mainScreen().bounds.width > UIScreen.mainScreen().bounds.height ? UIScreen.mainScreen().bounds.width : UIScreen.mainScreen().bounds.height
        
        self.ChannelManagerContainerView.transform = CGAffineTransformTranslate(self.ChannelManagerContainerView.transform, 0, -width) // 将频道列表视图隐藏
        self.ChannelDataSource.delegate = self
        (self.ChannelManagerContainerCollectionView.collectionViewLayout as! KDRearrangeableCollectionViewFlowLayout).delegate = self.ChannelDataSource
    }
    
    // 点击修改标题
    @IBAction func ClickEditButton(sender: AnyObject) {
        
        self.ChannelManagerEditButtonAble(!self.CollectionViewDragIng)
    }
    
    // 处理频道管理的状态
    internal func HandleChannelManagerStatus(animater:Bool = true){
    
        if self.ChannelManagerTitleView.alpha == 0 { /// 打开的时候进行数据显示视图的刷新
        
            self.CollectionViewDragIng = false // 设置当前的 是和否正在编辑对象 用于完成是否显示删除按钮
            self.ChannelDragButton.CollectionViewDragIng = false // 设置按钮的编辑对象，完成显示成为什么样子
            self.ChannelDataSource.channels = self.channels // 设置频道列表的数据源插件
            self.ChannelDataSource.ReloadChannelsArray() // 刷新频道列表视图的数据源
            self.ChannelDataSource.ChannelCurrentIndex = self.currentIndex // 设置频道列表数据源正在选中的Index
            self.ChannelManagerContainerCollectionView.reloadData()
            (self.ChannelManagerContainerCollectionView.collectionViewLayout as! KDRearrangeableCollectionViewFlowLayout).CollectionViewDragIng = false
        }
        
        UIView.animateWithDuration(0.3) {
            
            let width = UIScreen.mainScreen().bounds.width > UIScreen.mainScreen().bounds.height ? UIScreen.mainScreen().bounds.width : UIScreen.mainScreen().bounds.height
            
            self.ChannelManagerContainerView.transform = (self.ChannelManagerTitleView.alpha == 0) ? CGAffineTransformIdentity :CGAffineTransformTranslate(self.ChannelManagerContainerView.transform, 0, -width)
        }
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.ChannelManagerButton.transform = (self.ChannelManagerTitleView.alpha == 0) ? CGAffineTransformRotate(self.ChannelManagerButton.transform, -CGFloat(M_PI_4)) : CGAffineTransformIdentity
            self.ChannelManagerTitleView.alpha = self.ChannelManagerTitleView.alpha == 0 ? 1 : 0
            
            }, completion: nil)
    }
}




// MARK: - HomeViewControllerChannelDataSourceDelegate
extension HomeViewController:HomeViewControllerChannelDataSourceDelegate{
    
    // 改变位置顺序了
    func ChannelManagerMoveItemsMethod() {
        
        self.ReloadVisCellsMethod()
    }
    
    
    // 删除或者新增一个新的频道了
    func ChannelManagerChange() {
        
        self.ReloadVisCellsMethod()
    }
    
    // 选择某一个频道
    func ChannelManagerDidSelectItemAtIndexPath(indexPath: NSIndexPath) {
        
        self.HandleChannelManagerStatus()
        
        self.moveToViewControllerAtIndex(indexPath.item)
    }
    
    // 开始拖拽某一个频道
    func ChannelManagerBeginDraggind() { // 开始拖拽
        
        self.ChannelManagerEditButtonAble(true)
    }
    
    private func ChannelManagerEditButtonAble(abel:Bool){
    
        self.CollectionViewDragIng = abel
        self.ChannelDataSource.CollectionViewDragIng = self.CollectionViewDragIng //
        self.ChannelDragButton.CollectionViewDragIng = self.CollectionViewDragIng // 使按钮进入编辑状态
        (self.ChannelManagerContainerCollectionView.collectionViewLayout as! KDRearrangeableCollectionViewFlowLayout).CollectionViewDragIng = self.CollectionViewDragIng
        
        
        self.ReloadVisCellsMethod()
    }
}


extension HomeViewController{

    // 刷新正在选中的频道标题颜色
    func ReloadVisCellsSelectedMethod(item:Int){
        
        for collectionViewCell in self.ChannelManagerContainerCollectionView.visibleCells() {
            
            if let cell = collectionViewCell as? HomeChannelCollectionViewCell,indexPath = self.ChannelManagerContainerCollectionView.indexPathForCell(cell) {
                
                cell.titleLabel.textColor = indexPath.section == 0 && indexPath.item == item ? UIColor(red: 53/255, green:166/255, blue: 251/255, alpha: 1) : UIColor.blackColor()
            }
        }
    }
    
    
    // 刷新删除按钮
    private func ReloadVisCellsMethod(){
        
        for collectionViewCell in self.ChannelManagerContainerCollectionView.visibleCells() {
            
            if let cell = collectionViewCell as? HomeChannelCollectionViewCell,indexPath = self.ChannelManagerContainerCollectionView.indexPathForCell(cell) {
                
                ChannelUtil.ChannelUpdate(cell.channelId, isdelete: indexPath.section == 1 ? 1 : 0, orderIndex: indexPath.item)
                
                cell.channelDeleteView.hidden = !CollectionViewDragIng ? true : indexPath.section == 1 || indexPath.item == 0
            }
        }
        
        self.ReloadViewControllers()
    }
}