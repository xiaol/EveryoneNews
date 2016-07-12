//
//  FocusViewController.swift
//  Journalism
//
//  Created by Mister on 16/7/12.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class FocusViewController: UIViewController {
    
    @IBOutlet var tableView:UITableView!
    
    @IBOutlet var headerView:FoucusHeaderView!
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.tableHeaderView = self.headerView
        self.tableView.scrollIndicatorInsets.top = 170

    }
}


extension FocusViewController:UITableViewDelegate{

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        
        var source:CGFloat = 0
        
        if 170 - offsetY <= 64 {
            
            source = 64
        }else if 170 - offsetY >= 170 {
        
            source = 170
        }else{
        
            source = 170-offsetY
        }
        
        self.heightConstraint.constant = source
        
        self.headerView.setProcess((170-source)/(170-64))
        
        self.headerView.layer.layoutIfNeeded()
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
}

class FoucusHeaderView: UIView {
    
    @IBOutlet var headerImageView:UIImageView!
    
    @IBOutlet var moreButton:UIButton!
    @IBOutlet var cancelButton:UIButton!
    @IBOutlet var foucusButton:UIButton!
    
    @IBOutlet var nameLabel:UILabel!
    
    
    @IBOutlet var headerCenterConstraint: NSLayoutConstraint!
    @IBOutlet var nameCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet var nameTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet var headerWidthConstraint: NSLayoutConstraint!
    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet var borderRightConstraint: NSLayoutConstraint!
    
    func setProcess(pro:CGFloat){
        
        self.headerTopConstraint.constant = 30+(57-30)*(1-pro)
        self.headerWidthConstraint.constant = 24+(60-24)*(1-pro)
        self.headerHeightConstraint.constant = 24+(60-24)*(1-pro)
        self.headerCenterConstraint.constant = -20+20*(1-pro)
        self.headerImageView.layer.cornerRadius = self.headerHeightConstraint.constant/2
        
        self.borderRightConstraint.constant = 17*(1-pro)
        
        self.foucusButton.alpha = 1-pro
        
        self.nameTopConstraint.constant = 34+(127-34)*(1-pro)
        self.nameCenterConstraint.constant = 30-30*(1-pro)
        
        self.nameLabel.font = UIFont.systemFontOfSize(15+(22-15)*(1-pro))
    }
    
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        self.headerImageView.layer.cornerRadius = 30
        self.foucusButton.layer.borderColor = UIColor.hexStringToColor("#e71f19").CGColor
        self.foucusButton.layer.borderWidth = 1
        self.foucusButton.layer.cornerRadius = 12
    }
}