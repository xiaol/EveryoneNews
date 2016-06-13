//
//  FooterView.swift
//  Journalism
//
//  Created by Mister on 16/6/13.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import MJRefresh



class NewRefreshFooterView: MJRefreshAutoFooter {
    
    let loadMoreAnimationKey = "loadMoreRotation"
    
    let labelWidth:CGFloat = 160
    let imageViewWidth:CGFloat = 14
    let imageViewHeitht:CGFloat = 14
    let loadMoreHeight:CGFloat = 40
    
    var view:UIView!
    var label:UILabel!
    var imageView:UIImageView!
    var animation:CABasicAnimation!
    
    override func prepare() {
        
        super.prepare()
        
        self.mj_h = 50
        
        let view = UIView()
        
        let label = UILabel()
        label.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        label.font = UIFont.boldSystemFontOfSize(14)
        label.textAlignment = .Center
        view.addSubview(label)
        self.label = label
        
        let imageView = UIImageView(image: UIImage(named: "加载更多"))
        imageView.contentMode = .ScaleAspectFit
        view.addSubview(imageView)
        self.imageView = imageView
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.repeatCount = FLT_MAX
        animation.duration = 0.5
        animation.cumulative = true
        animation.toValue = NSValue(CATransform3D: CATransform3DMakeRotation(CGFloat(M_PI), 0, 0, 1))
        self.animation = animation
        
        self.view = view
        
        self.addSubview(self.view)
    }
    
    override func placeSubviews() {
        
        super.placeSubviews()
        
        self.view.frame = CGRect(x: 0, y: 0, width: labelWidth + imageViewWidth, height: loadMoreHeight)
        self.view.center = CGPoint(x: self.mj_w/2, y: self.mj_h/2)
        
        self.imageView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeitht)
        self.imageView.center.y = self.view.frame.height/2
        
        self.label.frame = CGRect(x: CGRectGetMaxX(self.imageView.frame)+10, y: 0, width: labelWidth, height: loadMoreHeight)
        self.label.center.y = self.view.frame.height/2
    }
    
    override var state: MJRefreshState{
        
        didSet{
            
            switch state {
            case .Idle:
                self.label.text = ""
                self.imageView.hidden = true
            case .Refreshing:
                self.label.text = "正在载入"
                self.imageView.hidden = false
                self.label.frame = CGRect(x: CGRectGetMaxX(self.imageView.frame)+10, y: 0, width: labelWidth, height: loadMoreHeight)
                self.imageView.layer.addAnimation(self.animation, forKey: loadMoreAnimationKey)
            case .NoMoreData:
                self.label.text = "已显示全部内容"
                self.imageView.hidden = true
                self.label.frame = CGRect(x: CGRectGetMaxX(self.imageView.frame), y: 0, width: labelWidth, height: loadMoreHeight)
                self.imageView.layer.removeAnimationForKey(loadMoreAnimationKey)
            default:
                break
            }
        }
    }
}

