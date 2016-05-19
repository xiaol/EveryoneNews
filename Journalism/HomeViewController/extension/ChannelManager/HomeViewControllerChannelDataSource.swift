//
//  HomeViewControllerChannelExtension.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewControllerChannelDataSource:NSObject,UICollectionViewDataSource{

    internal let channels = ChannelUtil.GetChannelRealmObjects() // 获取所有数据库中的频道
    
    private var didSelectItemAtIndexPathBlock:((indexPath:NSIndexPath)->Void)?
    
    func setDidSelectItemAtIndexPathBlock(didSelectItemAtIndexPathBlock:((indexPath:NSIndexPath)->Void)?){
    
        self.didSelectItemAtIndexPathBlock = didSelectItemAtIndexPathBlock
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
        
            return channels.filter("isdelete == 0").count
        }
        
        return channels.filter("isdelete == 1").count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("channelCell", forIndexPath: indexPath) as! HomeChannelCollectionViewCell
        
        cell.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        
        cell.layer.cornerRadius = cell.frame.height/2
        
        cell.clipsToBounds = true
        
        if indexPath.section == 0 {
            
            cell.titleLabel.text = self.channels.filter("isdelete == 0")[indexPath.item].cname
            
        }else{
            
            cell.titleLabel.text = self.channels.filter("isdelete == 1")[indexPath.item].cname
        }
        
        if cell.titleLabel.text == "热点" {
            
            cell.backgroundColor = UIColor.clearColor()
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
    
        if kind == UICollectionElementKindSectionHeader {
        
            let reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "reusableView", forIndexPath: indexPath)
            
            return reusableView
        }
        
        return UICollectionReusableView()
    }
}



extension HomeViewControllerChannelDataSource:UICollectionViewDelegateFlowLayout{

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.didSelectItemAtIndexPathBlock?(indexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
    
        return CGSize(width: (collectionView.frame.width-5*25)/4, height: 30)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
    
        return UIEdgeInsets(top: 15, left: 25, bottom: 15, right: 25)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
    
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
    
        return 25
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
    
        if section == 1 {return CGSize(width: 0, height: 30)}
        
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
    
        return CGSizeZero
    }
}



class HomeChannelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
}