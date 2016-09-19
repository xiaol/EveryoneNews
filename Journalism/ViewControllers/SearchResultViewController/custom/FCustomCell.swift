//
//  FCustomCell.swift
//  Journalism
//
//  Created by Mister on 16/7/15.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class CCCCCell: UITableViewCell {}


class FocusCell: UITableViewCell {
    
    @IBOutlet var title:UILabel!
    @IBOutlet var backView:UIView!
    
    fileprivate var view1:ICONView!
    fileprivate var view2:ICONView!
    fileprivate var view3:ICONView!
    fileprivate var view4:ICONView!
    
    fileprivate var finish = false
    
    fileprivate var vc:UIViewController!
    
    func fouceCell(_ vc:UIViewController,focusResults:Results<Focus>){
        
//        if finish { return }
        
        
        if let view = view1 {
            view.removeFromSuperview()
        }
        
        if let view = view2 {
            view.removeFromSuperview()
        }
        
        if let view = view3 {
            view.removeFromSuperview()
        }
        
        if let view = view4 {
            view.removeFromSuperview()
        }
        
        self.vc = vc
        
        self.finish = true
        
        title.font = UIFont.a_font2
        title.textColor = UIColor.a_color3
        
        switch focusResults.count {
        case 4:
            self.set4Method()
        case 3:
            self.set3Method()
        case 2:
            self.set2Method()
        case 1:
            self.set1Method()
        default:
            self.set4Method()
            break
        }
        
        self.setDataSource(focusResults)
    }
    
    /**
      设置数据源
     */
    fileprivate func setDataSource(_ focusResults:Results<Focus>){
        
        if let view = view1 {
            
            if focusResults.count > 0 {
            
                view.iconImageView.image = UIImage(named: "zhanwei")
                view.titleLabel.text = focusResults[0].name
                
                if let views = view as? FouceICONOneView {
                
                    views.fbutton.pname = focusResults[0].name
                }
                
                self.SetTapMethod(view, pname: focusResults[0].name)
            }
        }
        
        if let view = view2 {
            if focusResults.count > 1 {
                view.iconImageView.image = UIImage(named: "zhanwei")
                view.titleLabel.text = focusResults[1].name
                self.SetTapMethod(view, pname: focusResults[1].name)
            }
        }
        
        if let view = view3 {
            if focusResults.count > 2 {
                view.iconImageView.image = UIImage(named: "zhanwei")
                view.titleLabel.text = focusResults[2].name
                self.SetTapMethod(view, pname: focusResults[2].name)
            }
        }
        
        if let view = view4 {
            
            if focusResults.count > 4 {
            
                view.iconImageView.image = UIImage(named: "更多")
                view.titleLabel.text = "更多"
                
                view.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
                    
                    let qidian = UIStoryboard.shareStoryBoard.get_QiDianViewController()
                    
                    self.vc.present(qidian, animated: true, completion: nil)
                }))
                
                return
            }
            
            if focusResults.count > 3 {
                view.iconImageView.image = UIImage(named: "zhanwei")
                view.titleLabel.text = focusResults[3].name
                
                self.SetTapMethod(view, pname: focusResults[3].name)
            }
        }
    }
    
    fileprivate func SetTapMethod(_ view:UIView,pname:String){
    
        view.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
           
            let viewC = UIStoryboard.shareStoryBoard.get_FocusViewController(pname)
            
            viewC.dismiss = true
            
            self.vc.present(viewC, animated: true, completion: nil)
        }))
    }
    
    
    class func heightCell(_ count:Int = 4) -> CGFloat{
        
        let size = CGSize(width: 2000, height: 2000)
        let titleHeight = NSString(string:"测试").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font2], context: nil).height
        let subTitleHeight = NSString(string:"测试").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font5], context: nil).height
        
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
    fileprivate func set4Method(){
        
        // 设置第一个关注低分
        view1 = ICONView()
        self.backView.addSubview(view1)
        view1.snp.makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp.width).dividedBy(4)
        }
        
        view2 = ICONView()
        self.backView.addSubview(view2)
        
        view2.snp.makeConstraints { (make) in
            
            make.left.equalTo(view1.snp.right).offset(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp.width).dividedBy(4)
        }
        
        view3 = ICONView()
        self.backView.addSubview(view3)
        
        view3.snp.makeConstraints { (make) in
            
            make.left.equalTo(view2.snp.right).offset(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp.width).dividedBy(4)
        }
        
        view4 = ICONView()
        self.backView.addSubview(view4)
        
        view4.snp.makeConstraints { (make) in
            
            make.left.equalTo(view3.snp.right).offset(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp.width).dividedBy(4)
        }
    }
    
    /**
     设置三个数目的数据源的情况
     */
    fileprivate func set3Method(){
        
        // 设置第一个关注低分
        view1 = ICONView()
        self.backView.addSubview(view1)
        view1.snp.makeConstraints { (make) in
            
            make.left.equalTo(UIScreen.main.bounds.width/4/2)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp.width).dividedBy(4)
        }
        
        view2 = ICONView()
        self.backView.addSubview(view2)
        
        view2.snp.makeConstraints { (make) in
            
            make.left.equalTo(view1.snp.right).offset(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp.width).dividedBy(4)
        }
        
        view3 = ICONView()
        self.backView.addSubview(view3)
        
        view3.snp.makeConstraints { (make) in
            
            make.left.equalTo(view2.snp.right).offset(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp.width).dividedBy(4)
        }
    }
    
    /**
     设置只有两个个关注对象的布局
     */
    fileprivate func set2Method(){
        
        // 设置第一个关注低分
        view1 = ICONView()
        self.backView.addSubview(view1)
        view1.snp.makeConstraints { (make) in
            
            make.left.equalTo(UIScreen.main.bounds.width/4)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp.width).dividedBy(4)
        }
        
        view2 = ICONView()
        self.backView.addSubview(view2)
        
        view2.snp.makeConstraints { (make) in
            
            make.left.equalTo(view1.snp.right).offset(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.backView.snp.width).dividedBy(4)
        }
    }
    
    /**
     设置只有一个关注对象的布局
     */
    fileprivate func set1Method(){
        
        view1 = FouceICONOneView()
        self.backView.addSubview(view1)
        view1.snp.makeConstraints { (make) in
            
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
        
        
        iconImageView = ICONImageView(frame: CGRect.zero)
        self.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 59, height: 59))
        }
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.a_font5
        titleLabel.textColor = UIColor.a_color3
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(iconImageView.snp.bottom).offset(7)
            make.centerX.equalTo(self)
            make.left.equalTo(8)
            make.right.equalTo(-8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class BorderView:UIView{
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)
        //上分割线
        context?.setStrokeColor(UIColor.a_color5.cgColor)
        context?.stroke(CGRect(x: 0, y: 0, width: rect.width, height: 0.5));
        //下分割线
        context?.setStrokeColor(UIColor.a_color5.cgColor)
        context?.stroke(CGRect(x: 0, y: rect.height, width: rect.width, height: 0.5));
    }
}

/// 关注视图的图片类型
private class ICONImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.hexStringToColor("#dedede").cgColor
        self.layer.borderWidth = 0.5
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 只有一个关注对象的时候展示的视图
private class FouceICONOneView:ICONView{
    
    var fbutton:FoucusButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel.removeFromSuperview()
        self.iconImageView.removeFromSuperview()
        
        self.titleLabel = nil
        self.iconImageView = nil
        
        
        iconImageView = ICONImageView(frame: CGRect.zero)
        self.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            
            make.left.equalTo(19)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 59, height: 59))
        }
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.a_font5
        titleLabel.textColor = UIColor.a_color3
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(iconImageView.snp.right).offset(7)
            make.centerY.equalTo(self)
        }
        
        fbutton = FoucusButton()
        self.addSubview(fbutton)
        fbutton.snp.makeConstraints { (make) in
            
            make.size.equalTo(CGSize(width: 60, height: 24))
            make.right.equalTo(-19)
            make.centerY.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
