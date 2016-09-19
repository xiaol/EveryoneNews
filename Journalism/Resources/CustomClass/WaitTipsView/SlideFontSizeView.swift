//
//  SlideFontSizeView.swift
//  Journalism
//
//  Created by Mister on 16/6/17.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SnapKit

class FontSizeSlideView: UIView {

    lazy var backView = UIView()
    
    lazy var bbackView = UIView()
    
    let topView:CustomTopView = CustomTopView() // 上方 标题 和 完成按钮 背景视图
    lazy var titleLabel = UILabel() // 上方 标题 和 完成按钮 背景视图
    lazy var finishButton = UIButton() // 上方 标题 和 完成按钮 背景视图
    
    let fontView = UIView()
    
    let fontView1 = UILabel()
    let fontView2 = UILabel()
    let fontView3 = UILabel()
    let fontView4 = UILabel()

    let silde = UISlider()
    
    let hline = UIView()
    let vline1 = UIView()
    let vline2 = UIView()
    let vline3 = UIView()
    let vline4 = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        self.addSubview(bbackView)
        
        bbackView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        bbackView.snp.makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.leftMargin.equalTo(0)
            make.bottom.equalTo(0)
            make.rightMargin.equalTo(0)
        }
        
        // 设置背景视图
        backView.backgroundColor = UIColor.a_color9
        self.addSubview(backView)
        
        backView.snp.makeConstraints { (make) in
            
            make.height.equalTo(159)
            make.leftMargin.equalTo(0)
            make.bottom.equalTo(0)
            make.rightMargin.equalTo(0)
        }
        
        backView.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            
            make.height.equalTo(40)
            make.top.equalTo(self.backView).offset(0)
            make.left.equalTo(self.backView.snp.left).offset(0)
            make.right.equalTo(self.backView.snp.right).offset(0)
        }
        
        titleLabel.text = "字体大小"
        titleLabel.textColor = UIColor.a_color3
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        self.topView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            
            make.center.equalTo(topView.center)
        }
        
        finishButton.setTitle("完成", for: UIControlState())
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        finishButton.setTitleColor(UIColor.a_color7, for: UIControlState())
        finishButton.setTitleColor(UIColor.a_color3, for: UIControlState.highlighted)
        finishButton.setTitleColor(UIColor.a_color3, for: UIControlState.selected)
        self.topView.addSubview(finishButton)
        
        finishButton.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(self.titleLabel.snp.centerY)
            make.rightMargin.equalTo(self.topView).offset(-18)
        }
        
        
        self.backView.addSubview(fontView)
        fontView.snp.makeConstraints { (make) in
            
            make.height.equalTo(20)
            make.top.equalTo(self.topView.snp.bottom).offset(20)
            make.left.equalTo(self.backView).offset(0)
            make.right.equalTo(self.backView).offset(0)
        }
        
        fontView.clipsToBounds = false
        
        fontView4.text = "小"
        fontView4.textColor = UIColor.a_color3
        fontView4.font = UIFont.systemFont(ofSize: 16)
        fontView4.textAlignment = .center
        fontView.addSubview(fontView4)
        
        fontView4.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.fontView.snp.centerY)
            make.left.equalTo(self.fontView.snp.left).offset(0)
            make.width.equalTo(self.fontView.snp.width).dividedBy(4)
        }
        
        fontView1.text = "标准"
        fontView1.textColor = UIColor.a_color3
        fontView1.font = UIFont.systemFont(ofSize: 16)
        fontView1.textAlignment = .center
        fontView.addSubview(fontView1)
        fontView1.snp.makeConstraints { (make) in
            
            make.width.equalTo(self.fontView.snp.width).dividedBy(4)
            make.centerY.equalTo(self.fontView.snp.centerY)
            make.left.equalTo(self.fontView4.snp.right).offset(0)
        }
        
        fontView2.text = "大"
        fontView2.textColor = UIColor.a_color3
        fontView2.font = UIFont.systemFont(ofSize: 16)
        fontView2.textAlignment = .center
        fontView.addSubview(fontView2)
        
        fontView2.snp.makeConstraints { (make) in
            make.width.equalTo(self.fontView.snp.width).dividedBy(4)
            make.centerY.equalTo(self.fontView.snp.centerY)
            make.left.equalTo(self.fontView1.snp.right).offset(0)
        }
        
        fontView3.text = "超大"
        fontView3.textColor = UIColor.a_color3
        fontView3.font = UIFont.systemFont(ofSize: 16)
        fontView3.textAlignment = .center
        fontView.addSubview(fontView3)
        
        fontView3.snp.makeConstraints { (make) in
            make.width.equalTo(self.fontView.snp.width).dividedBy(4)
            make.centerY.equalTo(self.fontView.snp.centerY)
            make.left.equalTo(self.fontView2.snp.right).offset(0)
        }
        
 

        
        silde.minimumValue = -1
        silde.maximumValue = 2
        backView.addSubview(hline)
        backView.addSubview(vline1)
        backView.addSubview(vline2)
        backView.addSubview(vline3)
        backView.addSubview(vline4)
        backView.addSubview(silde)
        
        silde.value = UIFont.a_fontModalStyle
        
        silde.setThumbImage(UIImage(named: "滑块背景"), for: UIControlState())
        silde.minimumTrackTintColor = UIColor.clear
        silde.maximumTrackTintColor = UIColor.clear
        silde.snp.makeConstraints { (make) in
            
            make.top.equalTo(self.fontView.snp.bottom).offset(10)
            make.rightMargin.equalTo(self.fontView3.snp.centerX).offset(5)
            make.leftMargin.equalTo(self.fontView4.snp.centerX).offset(-5)
        }
        
        silde.isContinuous = false

        hline.backgroundColor = UIColor.a_color5
        hline.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.centerY.equalTo(self.silde.snp.centerY)
            make.leftMargin.equalTo(self.vline4).offset(0)
            make.rightMargin.equalTo(self.vline3).offset(0)
        }
        
        vline1.backgroundColor = UIColor.a_color5
        vline1.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(12)
            make.centerY.equalTo(self.hline.snp.centerY)
            make.centerX.equalTo(self.fontView1.snp.centerX)
        }
        
        vline2.backgroundColor = UIColor.a_color5
        vline2.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(12)
            make.centerY.equalTo(self.hline.snp.centerY)
            make.centerX.equalTo(self.fontView2.snp.centerX)
        }
        
        vline3.backgroundColor = UIColor.a_color5
        vline3.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(12)
            make.centerY.equalTo(self.hline.snp.centerY)
            make.centerX.equalTo(self.fontView3.snp.centerX)
        }
        
        vline4.backgroundColor = UIColor.a_color5
        vline4.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(12)
            make.centerY.equalTo(self.hline.snp.centerY)
            make.centerX.equalTo(self.fontView4.snp.centerX)
        }
        
        self.setSlideValue()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setSlideValue(){
    
        fontView1.isUserInteractionEnabled = true
        fontView2.isUserInteractionEnabled = true
        fontView3.isUserInteractionEnabled = true
        fontView4.isUserInteractionEnabled = true
        
        silde.removeActions(events: .valueChanged)
        silde.addAction(events: UIControlEvents.valueChanged) { (control) in
            
            self.SetValueMethod(Float(lroundf(self.silde.value)))
        }
        silde.addGestureRecognizer(UITapGestureRecognizer(block: { (tap) in
            
            let originx = tap.location(in: self.silde).x
            
            let value = (self.silde.maximumValue-self.silde.minimumValue)*Float(originx/self.silde.frame.width)-1
            
            self.SetValueMethod(Float(lroundf(value)))
        }))
        fontView1.addGestureRecognizer(UITapGestureRecognizer(block: { (tap) in
            
            self.SetValueMethod(0)
        }))
        
        fontView2.addGestureRecognizer(UITapGestureRecognizer(block: { (tap) in
            
            self.SetValueMethod(1)
        }))
        
        fontView3.addGestureRecognizer(UITapGestureRecognizer(block: { (tap) in
            
            self.SetValueMethod(2)
        }))
        
        fontView4.addGestureRecognizer(UITapGestureRecognizer(block: { (tap) in
            
            self.SetValueMethod(-1)
        }))
        
        finishButton.removeActions(events: .touchUpInside)
        finishButton.addAction(events: UIControlEvents.touchUpInside) { (_) in
            
            self.dismissView()
        }
        
        bbackView.addGestureRecognizer(UITapGestureRecognizer(block: { (tap) in
            
            self.dismissView()
        }))
    }
    
    fileprivate func dismissView(){
    
        UIView.animate(withDuration: 0.3, animations: {
            
            self.backView.transform = self.backView.transform.translatedBy(x: 0, y: self.backView.frame.height)
            
        }, completion: { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                
                self.bbackView.alpha = 0
                
                }, completion: { (_) in
                    
                    self.removeFromSuperview()
            })
        }) 
    }
    
    // 设置Value
    fileprivate func SetValueMethod(_ value:Float){
    
        DispatchQueue.main.async { 
            UIFont.a_fontModalStyle = value
        }
        
        self.silde.setValue(value, animated: true)
    }
    
    
    /// 获取单例模式下的UIStoryBoard对象
    static var shareNoInterest:FontSizeSlideView!{
        
       return FontSizeSlideView(frame: CGRect.zero)
    }
}



class CustomTopView: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.a_color9.cgColor)
        context?.fill(rect)
        //下分割线
        context?.setStrokeColor(UIColor.a_color5.cgColor)
        context?.stroke(CGRect(x: 18, y: rect.height, width: rect.width - 36, height: 1));
    }
}
