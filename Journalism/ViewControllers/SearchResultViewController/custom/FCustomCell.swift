//
//  FCustomCell.swift
//  Journalism
//
//  Created by Mister on 16/7/15.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SnapKit

class FocusCell: UITableViewCell {
    
    @IBOutlet var title:UILabel!
    @IBOutlet var backView:UIView!
    
    private var view1:ICONView!
    private var view2:ICONView!
    private var view3:ICONView!
    private var view4:ICONView!
    
    private var finish = false
    
    func fouceCell(count:Int = 4){
        
        if finish { return }
        
        self.finish = true
        
        title.font = UIFont.a_font2
        title.textColor = UIColor.a_color3
        
        switch count {
        case 4:
            self.set4Method()
        case 3:
            self.set3Method()
        case 2:
            self.set2Method()
        case 1:
            self.set1Method()
        default:
            break
        }
        
        self.setDataSource()
    }
    
    /**
      设置数据源
     */
    private func setDataSource(){
        
        if let view = view1 {
            view.iconImageView.image = UIImage(named: "timg")
            view.titleLabel.text = "历史"
        }
        
        if let view = view2 {
            view.iconImageView.image = UIImage(named: "timg")
            view.titleLabel.text = "历史"
        }
        
        if let view = view3 {
            view.iconImageView.image = UIImage(named: "timg")
            view.titleLabel.text = "历史"
        }
        
        if let view = view4 {
            view.iconImageView.image = UIImage(named: "timg")
            view.titleLabel.text = "历史"
        }
    }
    
    class func heightCell(count:Int = 4) -> CGFloat{
        
        let size = CGSize(width: 2000, height: 2000)
        let titleHeight = NSString(string:"测试").boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font2], context: nil).height
        let subTitleHeight = NSString(string:"测试").boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font5], context: nil).height
        
        switch count {
        case 2,3,4:
            return 11+11+18+17+59+7+18+titleHeight+subTitleHeight
        default:
            return 11+11+18+titleHeight+17+18+59
        }
    }
    
    /**
     设置4个数目的数据源的情况
     */
    private func set4Method(){
        
        // 设置第一个关注低分
        view1 = ICONView()
        self.backView.addSubview(view1)
        view1.snp_makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp_width).dividedBy(4)
        }
        
        view2 = ICONView()
        self.backView.addSubview(view2)
        
        view2.snp_makeConstraints { (make) in
            
            make.left.equalTo(view1.snp_right).offset(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp_width).dividedBy(4)
        }
        
        view3 = ICONView()
        self.backView.addSubview(view3)
        
        view3.snp_makeConstraints { (make) in
            
            make.left.equalTo(view2.snp_right).offset(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp_width).dividedBy(4)
        }
        
        view4 = ICONView()
        self.backView.addSubview(view4)
        
        view4.snp_makeConstraints { (make) in
            
            make.left.equalTo(view3.snp_right).offset(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp_width).dividedBy(4)
        }
    }
    
    /**
     设置三个数目的数据源的情况
     */
    private func set3Method(){
        
        // 设置第一个关注低分
        view1 = ICONView()
        self.backView.addSubview(view1)
        view1.snp_makeConstraints { (make) in
            
            make.left.equalTo(UIScreen.mainScreen().bounds.width/4/2)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp_width).dividedBy(4)
        }
        
        view2 = ICONView()
        self.backView.addSubview(view2)
        
        view2.snp_makeConstraints { (make) in
            
            make.left.equalTo(view1.snp_right).offset(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp_width).dividedBy(4)
        }
        
        view3 = ICONView()
        self.backView.addSubview(view3)
        
        view3.snp_makeConstraints { (make) in
            
            make.left.equalTo(view2.snp_right).offset(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp_width).dividedBy(4)
        }
    }
    
    /**
     设置只有两个个关注对象的布局
     */
    private func set2Method(){
        
        // 设置第一个关注低分
        view1 = ICONView()
        self.backView.addSubview(view1)
        view1.snp_makeConstraints { (make) in
            
            make.left.equalTo(UIScreen.mainScreen().bounds.width/4)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp_width).dividedBy(4)
        }
        
        view2 = ICONView()
        self.backView.addSubview(view2)
        
        view2.snp_makeConstraints { (make) in
            
            make.left.equalTo(view1.snp_right).offset(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp_width).dividedBy(4)
        }
    }
    
    /**
     设置只有一个关注对象的布局
     */
    private func set1Method(){
        
        view1 = FouceICONOneView()
        self.backView.addSubview(view1)
        view1.snp_makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.left.equalTo(0)
        }
    }
}

private class ICONView:UIView{
    
    var titleLabel:UILabel!
    var iconImageView:ICONImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        iconImageView = ICONImageView(frame: CGRectZero)
        self.addSubview(iconImageView)
        iconImageView.snp_makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 59, height: 59))
        }
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.a_font5
        titleLabel.textColor = UIColor.a_color3
        titleLabel.textAlignment = .Center
        self.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            
            make.top.equalTo(iconImageView.snp_bottom).offset(7)
            make.centerX.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class BorderView:UIView{
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, rect)
        //上分割线
        CGContextSetStrokeColorWithColor(context, UIColor.a_color5.CGColor)
        CGContextStrokeRect(context, CGRectMake(0, 0, rect.width, 0.5));
        //下分割线
        CGContextSetStrokeColorWithColor(context, UIColor.a_color5.CGColor)
        CGContextStrokeRect(context, CGRectMake(0, rect.height, rect.width, 0.5));
    }
}

/// 关注视图的图片类型
private class ICONImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.hexStringToColor("#dedede").CGColor
        self.layer.borderWidth = 0.5
        self.clipsToBounds = true
        self.contentMode = .ScaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 只有一个关注对象的时候展示的视图
private class FouceICONOneView:ICONView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel.removeFromSuperview()
        self.iconImageView.removeFromSuperview()
        
        self.titleLabel = nil
        self.iconImageView = nil
        
        
        iconImageView = ICONImageView(frame: CGRectZero)
        self.addSubview(iconImageView)
        iconImageView.snp_makeConstraints { (make) in
            
            make.left.equalTo(19)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 59, height: 59))
        }
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.a_font5
        titleLabel.textColor = UIColor.a_color3
        titleLabel.textAlignment = .Center
        self.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            
            make.left.equalTo(iconImageView.snp_right).offset(7)
            make.centerY.equalTo(self)
        }
        
        let button = FoucusButton()
        self.addSubview(button)
        button.snp_makeConstraints { (make) in
            
            make.size.equalTo(CGSize(width: 60, height: 24))
            make.right.equalTo(-19)
            make.centerY.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}