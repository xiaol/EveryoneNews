//
//  WaitView.swift
//  Journalism
//
//  Created by Mister on 16/6/15.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SnapKit

class WaitView: UIView {
    
    /// 获取单例模式下的UIStoryBoard对象
    static var shareWaitView:WaitView!{
        
        return WaitView()
    }
    
    var imgView = UIImageView()
    var descLabel = UILabel()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        imgView = UIImageView(image: UIImage(named: "关注占位图"))
        let image1 = UIImage(named: "xl_1")!
        let image2 = UIImage(named: "xl_2")!
        let image3 = UIImage(named: "xl_3")!
        let image4 = UIImage(named: "xl_4")!
        
        self.imgView.animationImages = [image1,image2,image3,image4]
        self.imgView.animationDuration = 0.6
        self.imgView.startAnimating()
        self.addSubview(imgView)
        
        imgView.snp.makeConstraints { (make) in
            
            make.center.equalTo(self)
        }
        
        descLabel = UILabel()
        descLabel.text = "正在努力加载..."
        descLabel.font = UIFont.systemFont(ofSize: 12)
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
    
    
    /**
     设置无网络情况。
     
     - parameter click: 点击事件
     */
    func setNoNetWork(_ click:(()->Void)?){
        
        self.imgView.stopAnimating()
        
        self.imgView.image = UIImage(named: "无信号－无信号icon")
        self.descLabel.text = "加载失败，请联网后点击重试"
        self.imgView.isUserInteractionEnabled = false
        self.descLabel.isUserInteractionEnabled = false
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            
            click?()
        }))
    }
}


//class WaitView: UIView {
//    
//    lazy var label = UILabel()
//    lazy var imageView = UIImageView()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        self.backgroundColor = UIColor.white
//        
//        self.imageView = UIImageView(image: UIImage(named: "关注占位图"))
//        
//        let image1 = UIImage(named: "xl_1")!
//        let image2 = UIImage(named: "xl_2")!
//        let image3 = UIImage(named: "xl_3")!
//        let image4 = UIImage(named: "xl_4")!
//        
//        self.imageView.animationImages = [image1,image2,image3,image4]
//        self.imageView.animationDuration = 0.6
//        self.imageView.startAnimating()
//        
//        self.addSubview(imageView)
//        
//        
//        label.text = "正在努力加载..."
//        label.font = UIFont.systemFont(ofSize: 12)
//        label.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
//        label.textAlignment = .center
//        
//        self.addSubview(label)
//        
//        imageView.snp.makeConstraints { (make) in
//            
//            make.center.equalTo(self.snp.center)
//        }
//        
//        label.snp.makeConstraints { (make) in
//            
//            make.centerX.equalTo(self.snp.centerX)
//            make.margins.top.equalTo(self.imageView.snp.bottom).offset(20)
//        }
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    /// 获取单例模式下的UIStoryBoard对象
//    static var shareWaitView:WaitView!{
//        
//       return WaitView()
//    }
//    
//    /**
//     设置无网络情况。
//     
//     - parameter click: 点击事件
//     */
//    func setNoNetWork(_ click:(()->Void)?){
//    
//        self.imageView.stopAnimating()
//        
//        self.imageView.image = UIImage(named: "无信号－无信号icon")
//        self.label.text = "加载失败，请联网后点击重试"
//        self.imageView.isUserInteractionEnabled = false
//        self.label.isUserInteractionEnabled = false
//        
//        self.isUserInteractionEnabled = true
//        self.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
//            
//            click?()
//        }))
//    }
//}
