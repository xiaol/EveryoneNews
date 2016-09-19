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
    var titleLabel1:UILabel!
    var fouceLabel:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel = UILabel()
        self.titleLabel1 = UILabel()
        self.fouceLabel = UILabel()
        
        self.titleLabel.font = UIFont.a_font2
        self.titleLabel.textColor = UIColor.a_color3
        
        self.titleLabel1.font = UIFont.a_font2
        self.titleLabel1.textColor = UIColor.a_color3
        
        self.fouceLabel.font = UIFont.a_font5
        self.fouceLabel.textColor = UIColor.a_color4
        
        self.addSubview(titleLabel)
        self.addSubview(titleLabel1)
        self.addSubview(fouceLabel)
        

    }
    
    func setQiDian(_ focus:Focus){
    
        self.headImageView.layer.cornerRadius = 8
        
        self.titleLabel.text = focus.name
        self.titleLabel1.text = focus.name
        self.fouceLabel.text = "\(focus.concern)个人关注"
        
        self.titleLabel.isHidden = false
        
        let s = focus.concern > 0
        
        self.fouceLabel.isHidden = !s
        
        foucsButton.pname = focus.name
        
        
        self.titleLabel.isHidden = s
        self.titleLabel1.isHidden = !s
        self.fouceLabel.isHidden = !s
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)
        //下分割线
        context?.setStrokeColor(UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).cgColor)
        context?.stroke(CGRect(x: 18, y: rect.height, width: rect.width-18, height: 1));
        
        self.titleLabel1.snp.makeConstraints({ (make) in
            
            make.top.equalTo(self.headImageView.snp.top).offset(1)
            make.left.equalTo(self.headImageView.snp.right).offset(12)
        })
        
        self.fouceLabel.snp.makeConstraints({ (make) in
            
            make.bottom.equalTo(self.headImageView.snp.bottom).offset(-1)
            make.left.equalTo(self.headImageView.snp.right).offset(12)
        })
        
        self.titleLabel.snp.makeConstraints({ (make) in
            
            make.centerY.equalTo(self.headImageView.snp.centerY)
            make.left.equalTo(self.headImageView.snp.right).offset(12)
            make.right.equalTo(self.foucsButton.snp.left).offset(-22)
        })
    }
}
