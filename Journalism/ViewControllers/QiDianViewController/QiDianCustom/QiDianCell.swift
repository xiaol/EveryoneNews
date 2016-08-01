//
//  QiDianCell.swift
//  Journalism
//
//  Created by Mister on 16/7/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SnapKit

class QiDianCell:UITableViewCell{

    @IBOutlet var foucsButton:FoucusButton!
    @IBOutlet var headImageView:UIImageView!
    
    var titleLabel:UILabel!
    var fouceLabel:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel = UILabel()
        self.fouceLabel = UILabel()
        
        self.titleLabel.font = UIFont.a_font2
        self.titleLabel.textColor = UIColor.a_color3
        
        self.fouceLabel.font = UIFont.a_font5
        self.fouceLabel.textColor = UIColor.a_color4
        
        self.addSubview(titleLabel)
        self.addSubview(fouceLabel)
    }
    
    func setQiDian(focus:Focus){
    
        self.headImageView.layer.cornerRadius = 8
        
        self.titleLabel.text = focus.name
        self.fouceLabel.text = "9.6万人关注"
        
        self.titleLabel.hidden = false
        
        let s = false
        
        self.fouceLabel.hidden = !s
        
        foucsButton.pname = focus.name
        
        
//        if s {
//
//            self.titleLabel.snp_makeConstraints(closure: { (make) in
//                
//                make.top.equalTo(self.headImageView.snp_top).offset(4)
//                make.left.equalTo(self.headImageView.snp_right).offset(12)
//            })
//            
//            self.fouceLabel.snp_makeConstraints(closure: { (make) in
//                
//                make.top.equalTo(self.titleLabel.snp_bottom).offset(10)
//                make.left.equalTo(self.headImageView.snp_right).offset(12)
//            })
//        }else{
        
            self.titleLabel.snp_makeConstraints(closure: { (make) in
                
                make.centerY.equalTo(self.headImageView.snp_centerY)
                make.left.equalTo(self.headImageView.snp_right).offset(12)
            })
//        }
        
        
        
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, rect)
        //下分割线
        CGContextSetStrokeColorWithColor(context, UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).CGColor)
        CGContextStrokeRect(context, CGRectMake(18, rect.height, rect.width-18, 1));
    }
}
