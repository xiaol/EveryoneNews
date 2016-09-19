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

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
     
        var bounds = self.bounds
        
        bounds.size = CGSize(width: 44, height: 44)
        
        return bounds.contains(point)
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
    var indexPath:IndexPath!
    
    func setCommentMethod(_ comment:Comment,tableView:UITableView,indexPath:IndexPath){
        
        self.comment = comment
        self.tableView = tableView
        self.indexPath = indexPath
        
        praiseLabel.font = UIFont.a_font7
        cnameLabel.font = UIFont.a_font4
        infoLabel.font = UIFont.a_font7
        contentLabel.font = UIFont.a_font3
        
        praiseLabel.isHidden = comment.commend <= 0
        praiseButton.isEnabled = comment.uid != ShareLUser.uid
        praiseedButton.isHidden = comment.upflag == 0 // 用户没有点赞隐藏
        
        praiseLabel.text = "\(comment.commend)"
        
        contentLabel.text = comment.content
        infoLabel.text = comment.ctimes.weiboTimeDescription
        cnameLabel.text = comment.uname
        
        if let url = URL(string: comment.avatar) {
            
            avatarView.pin_setImage(from: url, placeholderImage: UIImage.sharePlaceholderImage)
        }
    }
    
    // 点赞
    @IBAction func clickPriaiseButton(_ sender: AnyObject) {
        
        if ShareLUser.utype == 2 {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: USERNEDDLOGINTHENCANDOSOMETHING), object: nil)
        }else{
            
            CustomRequest.praiseComment(comment, finish: {
                
//                let section = NSIndexSet(index: self.indexPath.section)
                
                self.tableView.reloadRows(at: [self.indexPath], with: UITableViewRowAnimation.automatic)
            })
        }
    }
    
    // 取消点赞
    @IBAction func clickPriaiseedButton(_ sender: AnyObject) {
        
        if ShareLUser.utype == 2 {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: USERNEDDLOGINTHENCANDOSOMETHING), object: nil)
        }else{
            
            CustomRequest.nopraiseComment(self.comment, finish: {
                
                self.tableView.reloadRows(at: [self.indexPath], with: UITableViewRowAnimation.automatic)
            })
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)
        //下分割线
        context?.setStrokeColor(UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).cgColor)
        context?.stroke(CGRect(x: 18, y: rect.height, width: rect.width - 36, height: 1));
    }
}

class SearchTableViewCell:UITableViewCell{
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)
        //下分割线
        context?.setStrokeColor(UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).cgColor)
        context?.stroke(CGRect(x: 0, y: rect.height, width: rect.width, height: 1));
    }
}

class LikeAndPYQTableViewCell:UITableViewCell{
    
    
    @IBOutlet var concernImage: UIImageView!
    @IBOutlet var noconcernImage: UIImageView!
    
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var weChatCriButton: UIView!
    @IBOutlet var concernButton: UIView!
    @IBOutlet var contentWidthConstraint: NSLayoutConstraint!
    
    func setNew(_ new:New){
    
        self.concernButton.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
           
            if new.refreshs()?.isconcerned == 1 {
            
                if ShareLUser.utype == 2 {
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: USERNEDDLOGINTHENCANDOSOMETHING), object: nil)
                }else{
                    
                    CustomRequest.noconcernedNew(new)
                }
            }else{
            
                if ShareLUser.utype == 2 {
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: USERNEDDLOGINTHENCANDOSOMETHING), object: nil)
                }else{
                    
                    CustomRequest.concernedNew(new)
                }
            }
        }))
        
        
        concernImage.isHidden = new.refreshs()?.isconcerned == 0
        contentLabel.text = "\(new.refreshs()?.concern ?? 0)"
        
        let size = CGSize(width: 500, height: 200)
        let titleHeight = NSString(string:contentLabel.text ?? "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font2], context: nil).width
        contentWidthConstraint.constant = 18+18+14+titleHeight
    }
}

class MoreTableViewCell:UITableViewCell{
    
    
}


class circularView:UIView{

    override func draw(_ rect: CGRect) {
    
        self.layer.cornerRadius = rect.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).cgColor
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
    
    func setAboutMethod(_ about:About,hiddenY:Bool){
    
        self.hiddenYear = hiddenY
        
        
        YearLabel.font = UIFont.a_font8
        MAndDLabel.font = UIFont.a_font8
        contentLabel.font = UIFont.a_font2
        pnameLabel.font = UIFont.a_font7
        
        YearLabel.layer.cornerRadius = 1
        MAndDLabel.layer.cornerRadius = 1
        
        YearLabel.clipsToBounds = true
        MAndDLabel.clipsToBounds = true
        
        let fromStr = about.from.lowercased()
        let yesabout = UIColor(red: 0, green: 145/255, blue: 250/255, alpha: 1)
        let noabout = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        
        MAndDLabel.backgroundColor = (fromStr == "baidu" || fromStr == "google") ? yesabout : noabout
        
        pnameLabel.text = about.pname
        YearLabel.text = "\(about.ptimes.year())"
        MAndDLabel.text = about.ptimes.toString(DateFormat.custom(" MM/dd "))
        contentLabel.text = about.title
        self.contentLabel.textColor = about.isread == 1 ? UIColor.a_color4 : UIColor.a_color3
        
        self.titleHeadightConstraint.constant = hiddenY ? 0 : 21
        
        if let im = about.img,let url = URL(string: im) {
            
            if im.characters.count <= 0 {
                
                cntentRightSpaceConstraint.constant = 17
                descImageView.isHidden = true
            }else{
                
                cntentRightSpaceConstraint.constant = 17+81+15
                descImageView.isHidden = false
                descImageView.pin_setImage(from: url, placeholderImage: UIImage.sharePlaceholderImage)
            }
        }
        
        self.layoutIfNeeded()
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)
        //下分割线
        context?.setStrokeColor(UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).cgColor)
        context?.stroke(CGRect(x: 30, y: rect.height, width: rect.width - 17-17-7-6.5, height: 1));
        
        context?.move(to: CGPoint(x: 20, y: self.isHeader ? (hiddenYear ? 20+6 : 20)  : 0))       //移到線段的第一個點
        context?.addLine(to: CGPoint(x: 20, y: rect.height))       //畫出一條線
        context?.setLineDash(phase: 2, lengths: [1,1])
//        context?.setLineDash(context, 0, [1,1], 2)    //設定虛線
        
        context?.setLineWidth(1)               //設定線段粗細
        UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).set()                        //設定線段顏色
        context?.strokePath()                    //畫出線段
    }
}





class DetailFoucesCell: UITableViewCell {
    
    @IBOutlet var iconImageView:UIImageView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var descLabel:UILabel!
    
    @IBOutlet var fButton:FocusButtonTopAndButton!
    
    func setNewContent(_ pname:String){
    
        self.fButton.pname = pname
        self.titleLabel.text = pname
        self.descLabel.text = "这是一段描述"
        
        self.fButton.refresh()
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.font = UIFont.a_font2
        
        self.descLabel.textColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        self.descLabel.font = UIFont.a_font5
    }
}

class LeftBorderView:UIView{

    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(rect)
        //下分割线
        context?.setStrokeColor(UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).cgColor)
        context?.stroke(CGRect(x: 0, y: 10, width: 1, height: 47));                //畫出線段
    }
}


import SnapKit


enum FocusButtonState {
    case noraml
    case loading
}

class FocusButtonTopAndButton:UIButton{
    
    lazy var loadView = UIActivityIndicatorView()
    lazy var imageView1 = UIImageView()
    
    var pname = ""
    
    var exiter = false
    
    var loadingState = false
    
    func refresh(){
    
        loadingState = false
        
        self.exiter = Focus.isExiter(self.pname)
        
        loadView.activityIndicatorViewStyle = .gray
        
        loadView.stopAnimating()
        self.loadView.isHidden = true
        
        self.imageView1.isHidden = !self.exiter
        
        self.imageView?.isHidden = self.exiter
        self.titleLabel?.isHidden = self.exiter
    }
    
    func loading(){
        loadingState = true
        
        loadView.startAnimating()
        self.loadView.isHidden = false
        
        self.imageView1.isHidden = true
        self.imageView?.isHidden = true
        self.titleLabel?.isHidden = true
    }
    
    override var isHighlighted: Bool{
    
        didSet{
            
            if loadingState {
            
                loading()
            }else{
                
                self.refresh()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        self.loadingState = false
        
        loadView.isHidden = true
        
        self.addSubview(loadView)
        
        self.addSubview(imageView1)
        
        self.loadView.snp_makeConstraints { (make) in
            
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 22, height: 22))
        }
        
        imageView1.image = UIImage(named: "关注前进")
        
        imageView1.snp_makeConstraints { (make) in
            
            make.center.equalTo(self)
        }
        
        self.refresh()
    }
    
    

    override func layoutSubviews() {
        
        
        super.layoutSubviews()
        
        
        
        // Center image
        var center = self.imageView?.center ?? CGPoint.zero
        center.x = self.frame.size.width/2
        center.y = (self.imageView?.frame.size.height ?? 0)/2+15
        self.imageView?.center = center
        
        //Center text
        var newFrame = self.titleLabel?.frame ?? CGRect.zero
        newFrame.origin.x = 0
        newFrame.origin.y = (self.imageView?.center.y ?? 0) + 16
        newFrame.size.width = self.frame.size.width
        
        self.titleLabel?.frame = newFrame
        self.titleLabel?.textAlignment = .center
        
        self.refresh()
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(rect)
        //下分割线
        context?.setStrokeColor(UIColor.hexStringToColor("#e9e9e9").cgColor)
        context?.stroke(CGRect(x: 0, y: 11.5, width: 1.5, height: 47))
    }
}
