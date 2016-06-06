//
//  CustomTableViewCell.swift
//  Journalism
//
//  Created by Mister on 16/5/31.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import PINRemoteImage

class CommentsTableViewCell:UITableViewCell{
    
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var cnameLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var avatarView: HeadPhotoView!
    
    @IBOutlet var praiseLabel: UILabel!
    @IBOutlet var praiseButton: UIButton!
    
    func setCommentMethod(comment:Comment){
        praiseLabel.hidden = comment.comment <= 0
        praiseButton.hidden = comment.uid == SDK_User.uid
        
        praiseLabel.text = "\(comment.comment)"
        
        contentLabel.text = comment.content
        infoLabel.text = comment.ctimes.weiboTimeDescription
        cnameLabel.text = comment.uname
        
        if let url = NSURL(string: comment.avatar) {
            
            avatarView.pin_setImageFromURL(url, placeholderImage: UIImage.sharePlaceholderImage)
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, rect)
        //下分割线
        CGContextSetStrokeColorWithColor(context, UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).CGColor)
        CGContextStrokeRect(context, CGRectMake(18, rect.height, rect.width - 36, 1));
    }
}

class LikeAndPYQTableViewCell:UITableViewCell{
    
    
}

class MoreTableViewCell:UITableViewCell{
    
    
}