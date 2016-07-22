//
//  FocusHeaderView.swift
//  Journalism
//
//  Created by Mister on 16/7/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class FoucusHeaderView: UIView {
    
    @IBOutlet var headerImageView:UIImageView!
    
    @IBOutlet var moreButton:UIButton!
    @IBOutlet var cancelButton:UIButton!
    @IBOutlet var foucusButton:FoucusButton!
    
    @IBOutlet var nameLabel:UILabel!
    
    
    @IBOutlet var headerCenterConstraint: NSLayoutConstraint!
    @IBOutlet var nameCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet var nameTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet var headerWidthConstraint: NSLayoutConstraint!
    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet var borderRightConstraint: NSLayoutConstraint!
    
    var titleCenterOffest:CGFloat = 0
    var headerCenterOffest:CGFloat = 0
    
    func setNewC(pname:String){
    
        self.nameLabel.text = pname
        let titleWidth = NSString(string:pname).boundingRectWithSize(CGSize(width: 2000, height: 100), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil).width
        
        let ss = (titleWidth+11+30)/2
        headerCenterOffest = -(ss-15)
        titleCenterOffest = (ss-titleWidth/2)
    }
    
    func setProcess(pro:CGFloat){
        
        self.headerTopConstraint.constant = 30+(57-30)*(1-pro)
        self.headerWidthConstraint.constant = 24+(60-24)*(1-pro)
        self.headerHeightConstraint.constant = 24+(60-24)*(1-pro)
        self.headerCenterConstraint.constant = headerCenterOffest+(-headerCenterOffest)*(1-pro)
        self.headerImageView.layer.cornerRadius = self.headerHeightConstraint.constant/2
        
        self.borderRightConstraint.constant = 17*(1-pro)
        
        self.foucusButton.alpha = 1-pro
        
        self.nameTopConstraint.constant = 34+(127-34)*(1-pro)
        self.nameCenterConstraint.constant = titleCenterOffest-fabs(titleCenterOffest)*(1-pro)
        
        self.nameLabel.font = UIFont.systemFontOfSize(15+(22-15)*(1-pro))
    }
    
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        self.headerImageView.layer.cornerRadius = 30
    }
}


class FoucusButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initMethod()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initMethod()
    }
    
    func initMethod(){
        
        self.clipsToBounds = true
        
        self.titleLabel?.font = UIFont.a_font5
        
        self.setTitleColor(UIColor.hexStringToColor("#e71f19"), forState: .Normal)
        
        self.layer.cornerRadius = 30
        self.layer.borderColor = UIColor.hexStringToColor("#e71f19").CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
        
        self.setTitle("关注", forState: UIControlState.Normal)
        
        self.setBackgroundColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.setBackgroundColor(UIColor.hexStringToColor("#e71f19").colorWithAlphaComponent(0.3), forState: UIControlState.Selected)
        self.setBackgroundColor(UIColor.hexStringToColor("#e71f19").colorWithAlphaComponent(0.3), forState: UIControlState.Highlighted)
    }
}
