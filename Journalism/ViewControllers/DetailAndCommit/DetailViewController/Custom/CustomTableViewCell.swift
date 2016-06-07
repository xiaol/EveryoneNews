//
//  CustomTableViewCell.swift
//  Journalism
//
//  Created by Mister on 16/5/31.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import AFDateHelper
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


class circularView:UIView{

    override func drawRect(rect: CGRect) {
    
        self.layer.cornerRadius = rect.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).CGColor
        self.clipsToBounds = true
    }
}

class AboutTableViewCell:UITableViewCell{

    @IBOutlet var YearLabel: UILabel! // 年份label
    @IBOutlet var MAndDLabel: UILabel! // 月 日 label
    @IBOutlet var contentLabel: UILabel! // 内容Label
    @IBOutlet var descImageView: UIImageView! // 图片视图
    @IBOutlet var pnameLabel: UILabel! // 来源名称
    
    @IBOutlet var descImageWidthConstraint: NSLayoutConstraint! // 图片宽度约束对象
    @IBOutlet var cntentRightSpaceConstraint: NSLayoutConstraint! // 图片宽度约束对象
    
    func setAboutMethod(about:About){
    
        pnameLabel.text = about.pname
        YearLabel.text = "\(about.ptimes.year())"
        MAndDLabel.text = about.ptimes.toString(format: DateFormat.Custom("MM/dd"))
        contentLabel.text = about.title
        
        
        if let im = about.img,let url = NSURL(string: im) {
            
            if im.characters.count <= 0 {
            
                cntentRightSpaceConstraint.constant = 17
                descImageView.hidden = true
            }else{
            
                cntentRightSpaceConstraint.constant = 17+81+15
                descImageView.hidden = false
                descImageView.pin_setImageFromURL(url, placeholderImage: UIImage.sharePlaceholderImage)
            }
            
        }else{
        

        }
        
        self.layoutIfNeeded()
    }
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, rect)
        //下分割线
        CGContextSetStrokeColorWithColor(context, UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).CGColor)
        CGContextStrokeRect(context, CGRectMake(30, rect.height, rect.width - 36, 1));
        
        CGContextMoveToPoint(context, 20, 0)       //移到線段的第一個點
        CGContextAddLineToPoint(context, 20, rect.height)       //畫出一條線
        CGContextSetLineDash(context, 0, [1,1], 2)    //設定虛線
        CGContextSetLineWidth(context, 1)               //設定線段粗細
        UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).set()                        //設定線段顏色
        CGContextStrokePath(context)                    //畫出線段
    }
}