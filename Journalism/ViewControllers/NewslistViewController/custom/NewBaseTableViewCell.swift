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
        self.pubLabel.text = new.pname
        self.commentCountLabel.text = "\(new.comment)评"
        self.timeLabel.text = new.ptimes.weiboTimeDescription
        self.commentCountLabel.hidden = new.comment > 0 ? false : true
        self.titleLabel.textColor = new.isread == 1 ? UIColor.a_color4 : UIColor.a_color3
    }
    
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, rect)
        //下分割线
        CGContextSetStrokeColorWithColor(context, UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).CGColor)
        CGContextStrokeRect(context, CGRectMake(0, rect.height, rect.width, 1));
    }
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
        
        if let url = NSURL(string: new.imgsList[0].value) {
            
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
        
        if let url = NSURL(string: new.imgsList[0].value) {
            
            imageView1.pin_setImageFromURL(url, placeholderImage: UIImage.sharePlaceholderImage)
        }
        
        if let url = NSURL(string: new.imgsList[1].value) {
            
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
        
        if let url = NSURL(string: new.imgsList[0].value) {
            
            imageView1.pin_setImageFromURL(url, placeholderImage: UIImage.sharePlaceholderImage)
        }
        
        if let url = NSURL(string: new.imgsList[1].value) {
            
            imageView2.pin_setImageFromURL(url, placeholderImage: UIImage.sharePlaceholderImage)
        }
        
        if let url = NSURL(string: new.imgsList[2].value) {
            
            imageView3.pin_setImageFromURL(url, placeholderImage: UIImage.sharePlaceholderImage)
        }
    }
}


class SearchView: UIButton {
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        self.layer.borderColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = rect.height/2
        
    }
}
