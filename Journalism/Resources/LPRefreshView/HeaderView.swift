//
//  HeaderView.swift
//  Journalism
//
//  Created by Mister on 16/6/13.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import MJRefresh

class NewRefreshHeaderView: MJRefreshHeader {
    
    var label:UILabel!
    var loading:UIActivityIndicatorView!
    
    override func prepare() {
        
        super.prepare()
        
        self.mj_h = 54
        
        let loading = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.addSubview(loading)
        self.loading = loading
        
        let label = UILabel()
        label.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        label.font = UIFont.systemFontOfSize(10)
        label.textAlignment = .Center
        self.addSubview(label)
        self.label = label
        
    }
    
    override func placeSubviews() {
        
        super.placeSubviews()
        
        self.loading.frame = CGRect(x: (UIScreen.mainScreen().bounds.width-22)/2, y: 2, width: 15, height: 15)
        
        let labelX = (UIScreen.mainScreen().bounds.width-100)/2
        let labelY = CGRectGetMaxY(self.loading.frame)+8
        
        self.label.frame = CGRect(x: labelX, y: labelY, width: 100, height: 12)
    }
    
    override var state: MJRefreshState{
    
        didSet{
        
            switch state {
            case .Idle:
                self.label.text = "准备推荐"
                self.loading.stopAnimating()
            case .Pulling:
                self.label.text = "松开立即刷新"
                self.loading.startAnimating()
            case .Refreshing:
                self.label.text = "正在推荐"
                self.loading.startAnimating()
            default:
                break
            }
        }
    }
}
