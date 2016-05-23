//
//  NewBaseTableViewCell.swift
//  Journalism
//
//  Created by Mister on 16/5/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift
import PINRemoteImage

class NewBaseTableViewCell: UITableViewCell {
    
    @IBOutlet var timeLabel: UILabel! // 标题 label 控件
    @IBOutlet var titleLabel: UILabel! // 标题 label 控件
    @IBOutlet var pubLabel: UILabel! // 来源 和时间 label控件
    @IBOutlet var noLikeButton: UIButton! // 不喜欢 button 控件
    @IBOutlet var commentCountLabel: UILabel! // 评论 label 控件
    
    func setNewObject(new:New){
    
        self.titleLabel.text = new.title
        self.pubLabel.text = new.pubName
        self.commentCountLabel.text = "\(new.commentsCount)评"
        self.timeLabel.text = new.pubTimes.weiboTimeDescription
        self.commentCountLabel.hidden = new.commentsCount > 0 ? false : true
        
        
        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsZero
    }
//    
//    override func drawRect(rect: CGRect) {
//        super.drawRect(rect)
//        
//        //// Bottom
//        let layout = CAShapeLayer()
//        let path = UIBezierPath()
//        path.moveToPoint(CGPoint(x: 0, y: self.frame.size.height-0.2))
//        path.addLineToPoint(CGPoint(x: self.frame.size.width, y: self.frame.size.height-0.2))
//        
//        path.lineWidth = 0.2
//        UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 0.7).setStroke()
//        path.stroke()
//        
//        layout.path = path.CGPath
//    }
}


class NewNormalTableViewCell: NewBaseTableViewCell {
    
    override func setNewObject(new:New){
        
        super.setNewObject(new)
    }
}

class NewOneTableViewCell: NewBaseTableViewCell {
    
    @IBOutlet var imageView1: UIImageView!

    override func setNewObject(new:New){
        
        super.setNewObject(new)
        
        
        self.imageView1.pin_updateWithProgress = true
        
        if let url = NSURL(string: new.imgLists[0].value) {
            
            imageView1.pin_setImageFromURL(url, placeholderImage: UIImage.sharePlaceholderImage)
        }
    }
}

class NewTwoTableViewCell: NewBaseTableViewCell {
    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!

    override func setNewObject(new:New){
        
        super.setNewObject(new)
        
        self.imageView1.pin_updateWithProgress = true
        self.imageView2.pin_updateWithProgress = true
        
        if let url = NSURL(string: new.imgLists[0].value) {
            
            imageView1.pin_setImageFromURL(url, placeholderImage: UIImage.sharePlaceholderImage)
        }
        
        if let url = NSURL(string: new.imgLists[1].value) {
            
            imageView2.pin_setImageFromURL(url, placeholderImage: UIImage.sharePlaceholderImage)
        }
        
    }
}

class NewThreeTableViewCell: NewBaseTableViewCell {
    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    

    override func setNewObject(new:New){
        
        super.setNewObject(new)
        
        self.imageView1.pin_updateWithProgress = true
        self.imageView2.pin_updateWithProgress = true
        self.imageView3.pin_updateWithProgress = true
        
        if let url = NSURL(string: new.imgLists[0].value) {
            
            imageView1.pin_setImageFromURL(url, placeholderImage: UIImage.sharePlaceholderImage)
        }
        
        if let url = NSURL(string: new.imgLists[1].value) {
            
            imageView2.pin_setImageFromURL(url, placeholderImage: UIImage.sharePlaceholderImage)
        }
        
        if let url = NSURL(string: new.imgLists[2].value) {
            
            imageView3.pin_setImageFromURL(url, placeholderImage: UIImage.sharePlaceholderImage)
        }
    }
}