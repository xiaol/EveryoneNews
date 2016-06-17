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
        self.backgroundColor = UIColor.clearColor()
        
        self.addSubview(bbackView)
        
        bbackView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
        bbackView.snp_makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.leftMargin.equalTo(0)
            make.bottom.equalTo(0)
            make.rightMargin.equalTo(0)
        }
        
        // 设置背景视图
        backView.backgroundColor = UIColor.a_color9
        self.addSubview(backView)
        
        backView.snp_makeConstraints { (make) in
            
            make.height.equalTo(159)
            make.leftMargin.equalTo(0)
            make.bottom.equalTo(0)
            make.rightMargin.equalTo(0)
        }
        
        backView.addSubview(topView)
        topView.snp_makeConstraints { (make) in
            
            make.height.equalTo(40)
            make.top.equalTo(self.backView).offset(0)
            make.left.equalTo(self.backView.snp_left).offset(0)
            make.right.equalTo(self.backView.snp_right).offset(0)
        }
        
        titleLabel.text = "字体大小"
        titleLabel.textColor = UIColor.a_color3
        titleLabel.font = UIFont.systemFontOfSize(16)
        
        self.topView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            
            make.center.equalTo(topView.center)
        }
        
        finishButton.setTitle("完成", forState: UIControlState.Normal)
        finishButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        finishButton.setTitleColor(UIColor.a_color7, forState: UIControlState.Normal)
        finishButton.setTitleColor(UIColor.a_color3, forState: UIControlState.Highlighted)
        finishButton.setTitleColor(UIColor.a_color3, forState: UIControlState.Selected)
        self.topView.addSubview(finishButton)
        
        finishButton.snp_makeConstraints { (make) in
            
            make.centerY.equalTo(self.titleLabel.snp_centerY)
            make.rightMargin.equalTo(self.topView).offset(-18)
        }
        
        
        self.backView.addSubview(fontView)
        fontView.snp_makeConstraints { (make) in
            
            make.height.equalTo(20)
            make.top.equalTo(self.topView.snp_bottom).offset(20)
            make.left.equalTo(self.backView).offset(0)
            make.right.equalTo(self.backView).offset(0)
        }
        
        fontView.clipsToBounds = false
        
        fontView4.text = "小"
        fontView4.textColor = UIColor.a_color3
        fontView4.font = UIFont.systemFontOfSize(16)
        fontView4.textAlignment = .Center
        fontView.addSubview(fontView4)
        
        fontView4.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.fontView.snp_centerY)
            make.left.equalTo(self.fontView.snp_left).offset(0)
            make.width.equalTo(self.fontView.snp_width).dividedBy(4)
        }
        
        fontView1.text = "标准"
        fontView1.textColor = UIColor.a_color3
        fontView1.font = UIFont.systemFontOfSize(16)
        fontView1.textAlignment = .Center
        fontView.addSubview(fontView1)
        fontView1.snp_makeConstraints { (make) in
            
            make.width.equalTo(self.fontView.snp_width).dividedBy(4)
            make.centerY.equalTo(self.fontView.snp_centerY)
            make.left.equalTo(self.fontView4.snp_right).offset(0)
        }
        
        fontView2.text = "大"
        fontView2.textColor = UIColor.a_color3
        fontView2.font = UIFont.systemFontOfSize(16)
        fontView2.textAlignment = .Center
        fontView.addSubview(fontView2)
        
        fontView2.snp_makeConstraints { (make) in
            make.width.equalTo(self.fontView.snp_width).dividedBy(4)
            make.centerY.equalTo(self.fontView.snp_centerY)
            make.left.equalTo(self.fontView1.snp_right).offset(0)
        }
        
        fontView3.text = "超大"
        fontView3.textColor = UIColor.a_color3
        fontView3.font = UIFont.systemFontOfSize(16)
        fontView3.textAlignment = .Center
        fontView.addSubview(fontView3)
        
        fontView3.snp_makeConstraints { (make) in
            make.width.equalTo(self.fontView.snp_width).dividedBy(4)
            make.centerY.equalTo(self.fontView.snp_centerY)
            make.left.equalTo(self.fontView2.snp_right).offset(0)
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
        
        silde.setThumbImage(UIImage(named: "滑块背景"), forState: UIControlState.Normal)
        silde.minimumTrackTintColor = UIColor.clearColor()
        silde.maximumTrackTintColor = UIColor.clearColor()
        silde.snp_makeConstraints { (make) in
            
            make.top.equalTo(self.fontView.snp_bottom).offset(10)
            make.rightMargin.equalTo(self.fontView3.snp_centerX).offset(5)
            make.leftMargin.equalTo(self.fontView4.snp_centerX).offset(-5)
        }
        
        silde.continuous = false

        hline.backgroundColor = UIColor.a_color5
        hline.snp_makeConstraints { (make) in
            make.height.equalTo(1)
            make.centerY.equalTo(self.silde.snp_centerY)
            make.leftMargin.equalTo(self.vline4).offset(0)
            make.rightMargin.equalTo(self.vline3).offset(0)
        }
        
        vline1.backgroundColor = UIColor.a_color5
        vline1.snp_makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(12)
            make.centerY.equalTo(self.hline.snp_centerY)
            make.centerX.equalTo(self.fontView1.snp_centerX)
        }
        
        vline2.backgroundColor = UIColor.a_color5
        vline2.snp_makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(12)
            make.centerY.equalTo(self.hline.snp_centerY)
            make.centerX.equalTo(self.fontView2.snp_centerX)
        }
        
        vline3.backgroundColor = UIColor.a_color5
        vline3.snp_makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(12)
            make.centerY.equalTo(self.hline.snp_centerY)
            make.centerX.equalTo(self.fontView3.snp_centerX)
        }
        
        vline4.backgroundColor = UIColor.a_color5
        vline4.snp_makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(12)
            make.centerY.equalTo(self.hline.snp_centerY)
            make.centerX.equalTo(self.fontView4.snp_centerX)
        }
        
        self.setSlideValue()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setSlideValue(){
    
        fontView1.userInteractionEnabled = true
        fontView2.userInteractionEnabled = true
        fontView3.userInteractionEnabled = true
        
        silde.removeActions(.ValueChanged)
        silde.addAction(UIControlEvents.ValueChanged) { (control) in
            
            self.SetValueMethod(Float(lroundf(self.silde.value)))
        }
        silde.addGestureRecognizer(UITapGestureRecognizer(block: { (tap) in
            
            let originx = tap.locationInView(self.silde).x
            
            let value = (self.silde.maximumValue-self.silde.minimumValue)*Float(originx/self.silde.frame.width)
            
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
        
        finishButton.removeActions(.TouchUpInside)
        finishButton.addAction(UIControlEvents.TouchUpInside) { (_) in
            
            self.dismissView()
        }
        
        bbackView.addGestureRecognizer(UITapGestureRecognizer(block: { (tap) in
            
            self.dismissView()
        }))
    }
    
    private func dismissView(){
    
        UIView.animateWithDuration(0.3, animations: {
            
            self.backView.transform = CGAffineTransformTranslate(self.backView.transform, 0, self.backView.frame.height)
            
        }) { (_) in
            UIView.animateWithDuration(0.2, animations: {
                
                self.bbackView.alpha = 0
                
                }, completion: { (_) in
                    
                    self.removeFromSuperview()
            })
        }
    }
    
    // 设置Value
    private func SetValueMethod(value:Float){
    
        print(value)
        
        UIFont.a_fontModalStyle = value
        
        NSNotificationCenter.defaultCenter().postNotificationName(FONTMODALSTYLEIDENTIFITER, object: nil)
        
        self.silde.setValue(value, animated: true)
    }
    
    
    /// 获取单例模式下的UIStoryBoard对象
    class var shareNoInterest:FontSizeSlideView!{
        
        get{
            
            struct backTaskLeton{
                
                static var predicate:dispatch_once_t = 0
                
                static var bgTask:FontSizeSlideView? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                
                backTaskLeton.bgTask = FontSizeSlideView(frame: CGRectZero)
            })
            
            return backTaskLeton.bgTask
        }
    }
}



class CustomTopView: UIView {
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        CGContextSetFillColorWithColor(context, UIColor.a_color9.CGColor)
        CGContextFillRect(context, rect)
        //下分割线
        CGContextSetStrokeColorWithColor(context, UIColor.a_color5.CGColor)
        CGContextStrokeRect(context, CGRectMake(18, rect.height, rect.width - 36, 1));
    }
}