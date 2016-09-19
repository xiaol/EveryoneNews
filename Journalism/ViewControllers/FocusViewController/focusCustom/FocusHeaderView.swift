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
    
    func setNewC(_ pname:String){
        
        self.nameLabel.text = pname
        let titleWidth = NSString(string:pname).boundingRect(with: CGSize(width: 2000, height: 100), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)], context: nil).width
        
        let ss = (titleWidth+11+30)/2
        headerCenterOffest = -(ss-15)
        titleCenterOffest = (ss-titleWidth/2)
        
        foucusButton.pname = pname
        foucusButton.refresh()
    }
    
    func setProcess(_ pro:CGFloat){
        
        self.headerTopConstraint.constant = 30+(57-30)*(1-pro)
        self.headerWidthConstraint.constant = 24+(60-24)*(1-pro)
        self.headerHeightConstraint.constant = 24+(60-24)*(1-pro)
        self.headerCenterConstraint.constant = headerCenterOffest+(-headerCenterOffest)*(1-pro)
        self.headerImageView.layer.cornerRadius = self.headerHeightConstraint.constant/2
        
        self.borderRightConstraint.constant = 17*(1-pro)
        
        self.foucusButton.alpha = 1-pro
        
        self.nameTopConstraint.constant = 34+(127-34)*(1-pro)
        self.nameCenterConstraint.constant = titleCenterOffest-fabs(titleCenterOffest)*(1-pro)
        
        self.nameLabel.font = UIFont.systemFont(ofSize: 15+(22-15)*(1-pro))
    }
    
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        self.headerImageView.layer.cornerRadius = 30
    }
}


class FoucusButton: UIButton {
    
    var pname = ""{
        
        didSet{
            
            self.refresh()
        }
    }
    
    let loadV = UIActivityIndicatorView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initMethod()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initMethod()
    }
    
    func initMethod(){
        
        loadV.activityIndicatorViewStyle = .gray
        self.addSubview(self.loadV)
        
        loadV.snp.makeConstraints { (make) in
            
            make.center.equalTo(self)
        }
        
        loadV.hidesWhenStopped = false
        
        loadV.startAnimating()
        loadV.isHidden = true
        
        self.clipsToBounds = true
        
        self.titleLabel?.font = UIFont.a_font5
        
        
        self.layer.cornerRadius = 30
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: USERFOCUSPNAMENOTIFITION), object: nil, queue: OperationQueue.main) { (_) in
            
            self.refresh()
        }
        
        self.removeActions(events: .touchUpInside)
        
        self.addAction(events: .touchUpInside) { (_) in
            
            if ShareLUser.utype == 2 {
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: USERNEDDLOGINTHENCANDOSOMETHING), object: nil)
            }else{
                
                self.loading()
                
                if !Focus.isExiter(self.pname) {
                    
                    Focus.focusPub(self.pname)
                }else{
                
                    Focus.nofocusPub(self.pname)
                }
            }
        }
    }
    
    /**
     刷新当前按钮
     */
    fileprivate func loading(){
        
        self.setTitleColor(UIColor.clear, for: UIControlState())
        
        self.loadV.startAnimating()
        self.loadV.isHidden = false
    }
    
    
    /**
     设置按钮显示状态
     
     - parameter focus: 关注状态
     */
    fileprivate func refresh(){
        
        self.loadV.stopAnimating()
        self.loadV.isHidden = true
        
        if Focus.isExiter(self.pname) {
            
            self.setTitle("已关注", for: UIControlState())
            
            self.setTitleColor(UIColor.a_color10, for: UIControlState())
            self.layer.borderColor = UIColor.a_color10.cgColor
            
            self.setBackgroundColor(UIColor.white, forState: UIControlState())
            self.setBackgroundColor(UIColor.a_color10.withAlphaComponent(0.3), forState: UIControlState.selected)
            self.setBackgroundColor(UIColor.a_color10.withAlphaComponent(0.3), forState: UIControlState.highlighted)
        }else{
            
            self.setTitle("关注", for: UIControlState())
            
            self.setTitleColor(UIColor.hexStringToColor("#e71f19"), for: UIControlState())
            self.layer.borderColor = UIColor.hexStringToColor("#e71f19").cgColor
            
            self.setBackgroundColor(UIColor.white, forState: UIControlState())
            self.setBackgroundColor(UIColor.hexStringToColor("#e71f19").withAlphaComponent(0.3), forState: UIControlState.selected)
            self.setBackgroundColor(UIColor.hexStringToColor("#e71f19").withAlphaComponent(0.3), forState: UIControlState.highlighted)
        }
    }
}
