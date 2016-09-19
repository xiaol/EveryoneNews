//
//  FoucsedVIew.swift
//  Journalism
//
//  Created by Mister on 16/7/8.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SnapKit

class FoucsedView: UIView {

    let backView = UIView()
    let mbackView = UIView()
    
    let doneButton = UIButton()
    let topView = BottomBorderView()
    
    let okImageView = UIImageView()
    let title = UILabel()
    
    let topLabel = UILabel()
    let bottom = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(backView)
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        
        backView.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
           
            self.removeFromSuperview()
        }))
        
        
        self.addSubview(mbackView)
        self.mbackView.backgroundColor = UIColor.a_color9
        self.mbackView.clipsToBounds = true
        self.mbackView.layer.cornerRadius = 6
        
        
        self.mbackView.addSubview(doneButton)
        self.mbackView.addSubview(topView)
        
        self.topView.addSubview(okImageView)
        self.topView.addSubview(title)
        self.topView.addSubview(topLabel)
        self.topView.addSubview(bottom)
        
        backView.snp.makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.left.equalTo(0)
        }
        
        mbackView.snp.makeConstraints { (make) in
            
            make.center.equalTo(self.snp.center)
            make.width.equalTo(252)
            make.height.equalTo(153)
        }
        
        self.doneButton.backgroundColor = UIColor.clear
        doneButton.setTitle("知道了", for: UIControlState())
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        doneButton.setTitleColor(UIColor.a_color3, for: UIControlState())
        doneButton.setTitleColor(UIColor.a_color3.withAlphaComponent(0.5), for: UIControlState.selected)
        doneButton.setTitleColor(UIColor.a_color3.withAlphaComponent(0.5), for: UIControlState.highlighted)
        
        
        self.doneButton.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(38)
        }
        
        self.doneButton.backgroundColor = UIColor.clear
        
        self.topView.snp.makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(self.doneButton.snp.top)
        }
        
        self.title.text = "关注成功"
        self.title.font = UIFont.a_font3
        self.title.textColor = UIColor.a_color3
        self.title.snp.makeConstraints { (make) in
            
            make.top.equalTo(26)
            make.centerX.equalTo(self.topView.snp.centerX)
        }
        
        self.okImageView.image = UIImage(named: "关注成功icon")
        self.okImageView.snp.makeConstraints { (make) in
            
            make.right.equalTo(self.title.snp.left).offset(-6)
            make.centerY.equalTo(self.title.snp.centerY)
        }
        
        
        self.topLabel.text = "你可以在[关注]频道"
        self.topLabel.font = UIFont.a_font5
        self.topLabel.textColor = UIColor.a_color7
        self.topLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(title.snp.bottom).offset(12)
            make.centerX.equalTo(self.topView.snp.centerX)
        }
        
        
        self.bottom.text = "查看他更新的相关内容"
        self.bottom.font = UIFont.a_font5
        self.bottom.textColor = UIColor.a_color7
        self.bottom.snp.makeConstraints { (make) in
            
            make.top.equalTo(topLabel.snp.bottom).offset(5)
            make.centerX.equalTo(self.topView.snp.centerX)
        }
        
        self.doneButton.removeActions(events: .touchUpInside)
        self.doneButton.addAction(events: .touchUpInside) { (_) in
            
            self.removeFromSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//        
//        
//        self.okImageView.alpha = 1
//        
//        let anim = CASpringAnimation(keyPath: "transform")
//        
//        anim.damping = 10
//        
//        anim.fromValue = NSValue(CATransform3D: CATransform3DMakeScale(0, 0, 0))
//        anim.toValue = NSValue(CATransform3D: CATransform3DMakeScale(1, 1, 1))
//        anim.duration = anim.settlingDuration
//        anim.fillMode = kCAFillModeForwards
//        
//        self.okImageView.layer.addAnimation(anim, forKey: "fuck")
//    }
//    

}


class BottomBorderView:UIView{

    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画机制
        context?.setFillColor(UIColor.a_color9.cgColor)
        context?.fill(rect)
        
        // 绘制下边框
        context?.setStrokeColor(UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).cgColor)
        context?.stroke(CGRect(x: 0, y: rect.height, width: rect.width, height: 1))
    }
}
