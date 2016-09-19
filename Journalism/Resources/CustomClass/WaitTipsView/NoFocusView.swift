//
//  NoFocusView.swift
//  Journalism
//
//  Created by Mister on 16/8/1.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SnapKit

class NoFocusView: UIView {

    /// 获取单例模式下的UIStoryBoard对象
    static var shareNoFocusView:NoFocusView!{
        
        return NoFocusView()
    }
    
    var imgView = UIImageView()
    var descLabel = UILabel()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    
        self.backgroundColor = UIColor.white
        
        imgView = UIImageView(image: UIImage(named: "关注占位图"))
        
        self.addSubview(imgView)
        
        imgView.snp.makeConstraints { (make) in
            
            make.center.equalTo(self)
        }
        
        descLabel = UILabel()
        descLabel.text = "没有关注到任何信息"
        descLabel.font = UIFont.a_font6
        descLabel.textColor = UIColor.a_color4
        
        self.addSubview(descLabel)
        
        self.descLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(self.imgView.snp.bottom).offset(8)
            make.centerX.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
