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
    
    @objc optional func ChannelManagerMoveItemsMethod() // 开始
    
    @objc optional func ChannelManagerBeginDraggind() // 开始
    
    @objc optional func ChannelManagerEndDraggind() // 结束
    
    @objc optional func ChannelManagerDidSelectItemAtIndexPath(_ indexPath:IndexPath) // 结束
    
    @objc optional func ChannelManagerChange() // 发生变化 比如新增或者减少
}

class HomeViewControllerChannelDataSource:NSObject,UICollectionViewDataSource{

    var CollectionViewDragIng = false // 是否正在编辑状态 在这个对象里的是否正在编辑状态，处理当用户点击某一个Item的时候。是删除还是选中这一个频道，进行浏览
    var ChannelCurrentIndex = 0 // 当前选中的频道Index
    internal var channels = ChannelUtil.GetChannelRealmObjects() // 获取所有数据库中的频道
    internal var delegate:HomeViewControllerChannelDataSourceDelegate! // 代理对象

    fileprivate var ChannelNoDeleteArray = [Channel]() // 没有删除的列表集合
    fileprivate var ChannelIsDeleteArray = [Channel]() //已经删除的列表集合
    
    // 刷新数据源方法
    internal func ReloadChannelsArray(){
    
        self.ChannelNoDeleteArray.removeAll()
        self.ChannelIsDeleteArray.removeAll()
        
        for chan in channels.filter("isdelete == 0") {ChannelNoDeleteArray.append(chan)} // 设置没有删除的列表集合
        for chan in channels.filter("isdelete == 1") {ChannelIsDeleteArray.append(chan)} // 设置已经删除的列表集合
    }
    
    // 设置两个Section 0 为没有删除的频道列表 1位已经删除的频道列表
    func numberOfSections(in collectionView: UICollectionView) -> Int {return 2}
    // 设置两个Section不同的Item树木 0 为没有删除的频道列表 1位已经删除的频道列表
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return (section == 0 ? ChannelNoDeleteArray : ChannelIsDeleteArray).count}
    // 设置每一个UICollectionCell 展示形象
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "channelCell", for: indexPath) as! HomeChannelCollectionViewCell
        // 设置选中的频道区别于其他频道的标题颜色
        cell.titleLabel.textColor = ChannelCurrentIndex == (indexPath as NSIndexPath).item && (indexPath as NSIndexPath).section == 0 ? UIColor(red: 53/255, green:166/255, blue: 251/255, alpha: 1) : UIColor.black
        // 设置频道的信息
        cell.setChannel(((indexPath as NSIndexPath).section == 0 ? self.ChannelNoDeleteArray:self.ChannelIsDeleteArray)[(indexPath as NSIndexPath).item])
        cell.titleLabel.font = UIFont.a_font3_2
        return cell
    }
    
    /**
     这个方法主要是为了生成频道列表UICollectionView 显示 ‘点击添加更多栏目’ 头文件的
     */
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{return kind == UICollectionElementKindSectionHeader ? collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "reusableView", for: indexPath) : UICollectionReusableView()}
}



extension HomeViewControllerChannelDataSource:UICollectionViewDelegateFlowLayout{

    // 点击某一个UICollectionViewCell代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.isUserInteractionEnabled = false
        if (indexPath as NSIndexPath).section == 1 { // 当用户点击下方的频道列表的某一个频道的时候，说明用户希望添加一个新的频道
            self.ChannelIsDeleteArray.remove(at: (indexPath as NSIndexPath).item) // 在下方删除选中的东西
            self.ChannelNoDeleteArray.append(self.ChannelIsDeleteArray[0]) // 在上方的东西添加一个数据
            collectionView.moveItem(at: indexPath, to: IndexPath(item: ChannelNoDeleteArray.count-1, section: 0)) // 动画完成这个操作
            self.delegate.ChannelManagerChange?()
        }else if (indexPath as NSIndexPath).row != 0{
            if self.CollectionViewDragIng { // 如果当前标示正在进行编辑频道列表的话 进行删除频道列表的操作
                self.ChannelNoDeleteArray.remove(at: (indexPath as NSIndexPath).item) // 在上方没有删除的频道列表中删除选中的频道对象
                self.ChannelIsDeleteArray.append(self.ChannelNoDeleteArray[0]) // 在下方删除的频道列表中新增任何一个对象
                collectionView.moveItem(at: indexPath, to: IndexPath(item: 0, section: 1)) // 动画提示用户完成这个操作
                self.delegate.ChannelManagerChange?() //调用现在这个对象里的 频道有改变的 代理方法～
            }else{ // 如果标示为没有进行编辑，则进行选择某一个频道，显示某一个频道固定内容的操作
                self.delegate.ChannelManagerDidSelectItemAtIndexPath?(indexPath)  //调用现在这个对象里的 选择某一个频道的 代理方法～
            }
        }
        collectionView.isUserInteractionEnabled = true
    }
    
    // 设置频道的cell大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let width = UIScreen.main.bounds.width > UIScreen.main.bounds.height ? collectionView.frame.height : collectionView.frame.width
        
        return CGSize(width: (width-5*25)/4, height: 30)}
    // 设置每一个Section的 上下左右 的 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{return UIEdgeInsets(top: 15, left: 25, bottom: 15, right: 25)}
    // 设置每一个UIcollectionView行数的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{return 20}
    // 设置每一个UICollectionViewCell的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{return 25}
    // 设置UICollectionView的头部视图的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{return CGSize(width: 0, height:section == 1 ? 30 : 0)}
    // 设置UICollectionView的脚部视图的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{return CGSize.zero}
}


extension HomeViewControllerChannelDataSource:KDRearrangeableCollectionViewDelegate{
    internal func moveDataItem(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        self.delegate.ChannelManagerMoveItemsMethod?()
    }

    
    // 结束拖动的代理方法
    func ChannelManagerEndDraggind() { self.delegate.ChannelManagerEndDraggind?()}
    
    // 开始拖动的代理方法
    func ChannelManagerBeginDraggind() {self.delegate.ChannelManagerBeginDraggind?()}
}


class HomeChannelCollectionViewCell: UICollectionViewCell {
    
    var channelId = 0
    
    @IBOutlet var channelDeleteView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    func setChannel(_ channel:Channel){
    
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = self.frame.height/2
        
        self.titleLabel.text = channel.cname
        self.channelId = channel.id
        
        self.channelDeleteView.isHidden = true
        
        if self.titleLabel.text == "奇点" {
            
            self.backgroundColor = UIColor.clear
        }
    }
}
