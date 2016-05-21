//
//  HomeViewControllerChannelExtension.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift

@objc protocol HomeViewControllerChannelDataSourceDelegate {
    
    optional func ChannelManagerMoveItemsMethod() // 开始
    
    optional func ChannelManagerBeginDraggind() // 开始
    
    optional func ChannelManagerEndDraggind() // 结束
    
    optional func ChannelManagerDidSelectItemAtIndexPath(indexPath:NSIndexPath) // 结束
    
    optional func ChannelManagerChange() // 发生变化 比如新增或者减少
}

class HomeViewControllerChannelDataSource:NSObject,UICollectionViewDataSource{

    var CollectionViewDragIng = false // 是否正在编辑状态 在这个对象里的是否正在编辑状态，处理当用户点击某一个Item的时候。是删除还是选中这一个频道，进行浏览
    var ChannelCurrentIndex = 0 // 当前选中的频道Index
    internal var channels = ChannelUtil.GetChannelRealmObjects() // 获取所有数据库中的频道
    internal var delegate:HomeViewControllerChannelDataSourceDelegate! // 代理对象

    private var ChannelNoDeleteArray = [Channel]() // 没有删除的列表集合
    private var ChannelIsDeleteArray = [Channel]() //已经删除的列表集合
    
    // 刷新数据源方法
    internal func ReloadChannelsArray(){
    
        self.ChannelNoDeleteArray.removeAll()
        self.ChannelIsDeleteArray.removeAll()
        
        for chan in channels.filter("isdelete == 0") {ChannelNoDeleteArray.append(chan)} // 设置没有删除的列表集合
        for chan in channels.filter("isdelete == 1") {ChannelIsDeleteArray.append(chan)} // 设置已经删除的列表集合
    }
    
    // 设置两个Section 0 为没有删除的频道列表 1位已经删除的频道列表
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {return 2}
    // 设置两个Section不同的Item树木 0 为没有删除的频道列表 1位已经删除的频道列表
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return (section == 0 ? ChannelNoDeleteArray : ChannelIsDeleteArray).count}
    // 设置每一个UICollectionCell 展示形象
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("channelCell", forIndexPath: indexPath) as! HomeChannelCollectionViewCell
        // 设置选中的频道区别于其他频道的标题颜色
        cell.titleLabel.textColor = ChannelCurrentIndex == indexPath.item && indexPath.section == 0 ? UIColor(red: 53/255, green:166/255, blue: 251/255, alpha: 1) : UIColor.blackColor()
        // 设置频道的信息
        cell.setChannel((indexPath.section == 0 ? self.ChannelNoDeleteArray:self.ChannelIsDeleteArray)[indexPath.item])
        return cell
    }
    
    /**
     这个方法主要是为了生成频道列表UICollectionView 显示 ‘点击添加更多栏目’ 头文件的
     */
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{return kind == UICollectionElementKindSectionHeader ? collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "reusableView", forIndexPath: indexPath) : UICollectionReusableView()}
}



extension HomeViewControllerChannelDataSource:UICollectionViewDelegateFlowLayout{

    // 点击某一个UICollectionViewCell代理方法
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 { // 当用户点击下方的频道列表的某一个频道的时候，说明用户希望添加一个新的频道
            self.ChannelIsDeleteArray.removeAtIndex(indexPath.item) // 在下方删除选中的东西
            self.ChannelNoDeleteArray.append(self.ChannelIsDeleteArray[0]) // 在上方的东西添加一个数据
            collectionView.moveItemAtIndexPath(indexPath, toIndexPath: NSIndexPath(forItem: ChannelNoDeleteArray.count-1, inSection: 0)) // 动画完成这个操作
            self.delegate.ChannelManagerChange?()
        }else{
            if self.CollectionViewDragIng { // 如果当前标示正在进行编辑频道列表的话 进行删除频道列表的操作
                self.ChannelNoDeleteArray.removeAtIndex(indexPath.item) // 在上方没有删除的频道列表中删除选中的频道对象
                self.ChannelIsDeleteArray.append(self.ChannelNoDeleteArray[0]) // 在下方删除的频道列表中新增任何一个对象
                collectionView.moveItemAtIndexPath(indexPath, toIndexPath: NSIndexPath(forItem: 0, inSection: 1)) // 动画提示用户完成这个操作
                self.delegate.ChannelManagerChange?() //调用现在这个对象里的 频道有改变的 代理方法～
            }else{ // 如果标示为没有进行编辑，则进行选择某一个频道，显示某一个频道固定内容的操作
                self.delegate.ChannelManagerDidSelectItemAtIndexPath?(indexPath)  //调用现在这个对象里的 选择某一个频道的 代理方法～
            }
        }
    }
    
    // 设置频道的cell大小
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        let width = UIScreen.mainScreen().bounds.width > UIScreen.mainScreen().bounds.height ? collectionView.bounds.height : collectionView.bounds.width
        
        return CGSize(width: (width-5*25)/4, height: 30)}
    // 设置每一个Section的 上下左右 的 间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{return UIEdgeInsets(top: 15, left: 25, bottom: 15, right: 25)}
    // 设置每一个UIcollectionView行数的间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{return 20}
    // 设置每一个UICollectionViewCell的间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{return 25}
    // 设置UICollectionView的头部视图的大小
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{return CGSize(width: 0, height:section == 1 ? 30 : 0)}
    // 设置UICollectionView的脚部视图的大小
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{return CGSizeZero}
}


extension HomeViewControllerChannelDataSource:KDRearrangeableCollectionViewDelegate{

    // 移动某一个NSIndexPath至另一个NSindexPath的代理方法
    func moveDataItem(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {self.delegate.ChannelManagerMoveItemsMethod?()}
    
    // 结束拖动的代理方法
    func ChannelManagerEndDraggind() { self.delegate.ChannelManagerEndDraggind?()}
    
    // 开始拖动的代理方法
    func ChannelManagerBeginDraggind() {self.delegate.ChannelManagerBeginDraggind?()}
}


class HomeChannelCollectionViewCell: UICollectionViewCell {
    
    var channelId = 0
    
    @IBOutlet var channelDeleteView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    func setChannel(channel:Channel){
    
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = self.frame.height/2
        
        self.titleLabel.text = channel.cname
        self.channelId = channel.id
        
        self.channelDeleteView.hidden = true
        
        if self.titleLabel.text == "热点" {
            
            self.backgroundColor = UIColor.clearColor()
        }
    }
}