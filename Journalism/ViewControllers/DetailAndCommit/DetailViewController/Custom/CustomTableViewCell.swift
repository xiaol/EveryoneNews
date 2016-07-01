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


class PButtton:UIButton{

    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
     
        var bounds = self.bounds
        
        bounds.size = CGSize(width: 44, height: 44)
        
        return CGRectContainsPoint(bounds, point)
    }
}


class CommentsTableViewCell:UITableViewCell{
    
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var cnameLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var avatarView: HeadPhotoView!
    
    @IBOutlet var praiseLabel: UILabel!
    @IBOutlet var praiseButton: UIButton!
    @IBOutlet var praiseedButton: UIButton!
    
    var comment:Comment!
    var tableView:UITableView!
    var indexPath:NSIndexPath!
    
    func setCommentMethod(comment:Comment,tableView:UITableView,indexPath:NSIndexPath){
        
        self.comment = comment
        self.tableView = tableView
        self.indexPath = indexPath
        
        praiseLabel.font = UIFont.a_font7
        cnameLabel.font = UIFont.a_font4
        infoLabel.font = UIFont.a_font7
        contentLabel.font = UIFont.a_font3
        
        praiseLabel.hidden = comment.commend <= 0
        praiseButton.enabled = comment.uid != ShareLUser.uid
        praiseedButton.hidden = comment.upflag == 0 // 用户没有点赞隐藏
        
        praiseLabel.text = "\(comment.commend)"
        
        contentLabel.text = comment.content
        infoLabel.text = comment.ctimes.weiboTimeDescription
        cnameLabel.text = comment.uname
        
        if let url = NSURL(string: comment.avatar) {
            
            avatarView.pin_setImageFromURL(url, placeholderImage: UIImage.sharePlaceholderImage)
        }
    }
    
    // 点赞
    @IBAction func clickPriaiseButton(sender: AnyObject) {
        
        if ShareLUser.utype == 2 {
            
            NSNotificationCenter.defaultCenter().postNotificationName(USERNEDDLOGINTHENCANDOSOMETHING, object: nil)
        }else{
            
            CustomRequest.praiseComment(comment, finish: {
                
//                let section = NSIndexSet(index: self.indexPath.section)
                
                self.tableView.reloadRowsAtIndexPaths([self.indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
        }
    }
    
    // 取消点赞
    @IBAction func clickPriaiseedButton(sender: AnyObject) {
        
        if ShareLUser.utype == 2 {
            
            NSNotificationCenter.defaultCenter().postNotificationName(USERNEDDLOGINTHENCANDOSOMETHING, object: nil)
        }else{
            
            CustomRequest.nopraiseComment(self.comment, finish: {
                
                self.tableView.reloadRowsAtIndexPaths([self.indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
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

class SearchTableViewCell:UITableViewCell{
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, rect)
        //下分割线
        CGContextSetStrokeColorWithColor(context, UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).CGColor)
        CGContextStrokeRect(context, CGRectMake(0, rect.height, rect.width, 1));
    }
}

class LikeAndPYQTableViewCell:UITableViewCell{
    
    
    @IBOutlet var concernImage: UIImageView!
    @IBOutlet var noconcernImage: UIImageView!
    
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var weChatCriButton: UIView!
    @IBOutlet var concernButton: UIView!
    @IBOutlet var contentWidthConstraint: NSLayoutConstraint!
    
    func setNew(new:New){
    
        self.concernButton.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
           
            if new.refreshs()?.isconcerned == 1 {
            
                if ShareLUser.utype == 2 {
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(USERNEDDLOGINTHENCANDOSOMETHING, object: nil)
                }else{
                    
                    CustomRequest.noconcernedNew(new)
                }
            }else{
            
                if ShareLUser.utype == 2 {
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(USERNEDDLOGINTHENCANDOSOMETHING, object: nil)
                }else{
                    
                    CustomRequest.concernedNew(new)
                }
            }
        }))
        
        
        concernImage.hidden = new.refreshs()?.isconcerned == 0
        contentLabel.text = "\(new.refreshs()?.concern ?? 0)"
        
        let size = CGSize(width: 500, height: 200)
        let titleHeight = NSString(string:contentLabel.text ?? "").boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font2], context: nil).width
        contentWidthConstraint.constant = 18+18+14+titleHeight
    }
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
    @IBOutlet var titleHeadightConstraint: NSLayoutConstraint! // 图片宽度约束对象
    
    var isHeader = false
    var hiddenYear = false
    
    func setAboutMethod(about:About,hiddenY:Bool){
    
        self.hiddenYear = hiddenY
        
        
        YearLabel.font = UIFont.a_font8
        MAndDLabel.font = UIFont.a_font8
        contentLabel.font = UIFont.a_font2
        pnameLabel.font = UIFont.a_font7
        
        YearLabel.layer.cornerRadius = 1
        MAndDLabel.layer.cornerRadius = 1
        
        YearLabel.clipsToBounds = true
        MAndDLabel.clipsToBounds = true
        
        let fromStr = about.from.lowercaseString
        let yesabout = UIColor(red: 0, green: 145/255, blue: 250/255, alpha: 1)
        let noabout = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        
        MAndDLabel.backgroundColor = (fromStr == "baidu" || fromStr == "google") ? yesabout : noabout
        
        pnameLabel.text = about.pname
        YearLabel.text = "\(about.ptimes.year())"
        MAndDLabel.text = about.ptimes.toString(format: DateFormat.Custom(" MM/dd "))
        contentLabel.text = about.title
        self.contentLabel.textColor = about.isread == 1 ? UIColor.a_color4 : UIColor.a_color3
        
        self.titleHeadightConstraint.constant = hiddenY ? 0 : 21
        
        if let im = about.img,let url = NSURL(string: im) {
            
            if im.characters.count <= 0 {
                
                cntentRightSpaceConstraint.constant = 17
                descImageView.hidden = true
            }else{
                
                cntentRightSpaceConstraint.constant = 17+81+15
                descImageView.hidden = false
                descImageView.pin_setImageFromURL(url, placeholderImage: UIImage.sharePlaceholderImage)
            }
        }
        
        self.layoutIfNeeded()
    }
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, rect)
        //下分割线
        CGContextSetStrokeColorWithColor(context, UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).CGColor)
        CGContextStrokeRect(context, CGRectMake(30, rect.height, rect.width - 17-17-7-6.5, 1));
        
        CGContextMoveToPoint(context, 20, self.isHeader ? (hiddenYear ? 20+6 : 20)  : 0)       //移到線段的第一個點
        CGContextAddLineToPoint(context, 20, rect.height)       //畫出一條線
        CGContextSetLineDash(context, 0, [1,1], 2)    //設定虛線
        CGContextSetLineWidth(context, 1)               //設定線段粗細
        UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).set()                        //設定線段顏色
        CGContextStrokePath(context)                    //畫出線段
    }
}