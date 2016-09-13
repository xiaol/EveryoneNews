//
//  Subscribe.swift
//  Journalism
//
//  Created by Mister on 16/9/13.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import Foundation

struct Subscribe {
    
    /// 标题
    let title:String
    /// 图标图片名称
    let imageName:String
    
    /**
     获取随机的9个对象
     
     - returns: <#return value description#>
     */
    static func RandSubscribeArray() -> [Subscribe]{
        
        let subscribeArrary = SubscribeArrary()
        
        var RandSubArray = [Subscribe]()
        
        for index in RandIndexArray() {
            
            RandSubArray.append(subscribeArrary[index])
        }
        
        return RandSubArray
    }
    
    /**
     获取所有的订阅号对象集合
     
     - returns: 订阅号对象集合
     */
    private static func SubscribeArrary() -> [Subscribe]{
        
        let subscriber1 = Subscribe(title: "36氪" , imageName:"36氪")
        let subscriber2 = Subscribe(title: "爱范儿" , imageName:"爱范儿")
        let subscriber3 = Subscribe(title: "半糖" , imageName:"半糖")
        let subscriber4 = Subscribe(title: "北美省钱快报" , imageName:"北美省钱快报")
        let subscriber5 = Subscribe(title: "别致" , imageName:"别致")
        let subscriber6 = Subscribe(title: "财新周刊" , imageName:"财新周刊")
        let subscriber7 = Subscribe(title: "第一财经周刊" , imageName:"第一财经周刊")
        let subscriber8 = Subscribe(title: "豆瓣东西" , imageName:"豆瓣东西")
        let subscriber9 = Subscribe(title: "豆瓣一刻" , imageName:"豆瓣一刻")
        let subscriber10 = Subscribe(title: "毒舌指南" , imageName:"毒舌指南")
        let subscriber11 = Subscribe(title: "国家地理" , imageName:"国家地理")
        let subscriber12 = Subscribe(title: "果壳精选" , imageName:"果壳精选")
        let subscriber13 = Subscribe(title: "果库" , imageName:"果库")
        let subscriber14 = Subscribe(title: "好好住" , imageName:"好好住")
        let subscriber15 = Subscribe(title: "好物" , imageName:"好物")
        let subscriber16 = Subscribe(title: "和讯财经" , imageName:"和讯财经")
        let subscriber17 = Subscribe(title: "虎嗅" , imageName:"虎嗅")
        let subscriber18 = Subscribe(title: "华尔街见闻" , imageName:"华尔街见闻")
        let subscriber19 = Subscribe(title: "欢喜Fancy" , imageName:"欢喜Fancy")
        let subscriber20 = Subscribe(title: "机核" , imageName:"机核")
        
        let subscriber21 = Subscribe(title: "极客头条" , imageName:"极客头条")
        let subscriber22 = Subscribe(title: "煎蛋" , imageName:"煎蛋")
        let subscriber23 = Subscribe(title: "节操精选" , imageName:"节操精选")
        let subscriber24 = Subscribe(title: "界面" , imageName:"界面")
        let subscriber25 = Subscribe(title: "快科技" , imageName:"快科技")
        let subscriber26 = Subscribe(title: "雷锋网" , imageName:"雷锋网")
        let subscriber27 = Subscribe(title: "马蜂窝自由行" , imageName:"马蜂窝自由行")
        let subscriber28 = Subscribe(title: "面包猎人" , imageName:"面包猎人")
        let subscriber29 = Subscribe(title: "内涵段子" , imageName:"内涵段子")
        let subscriber30 = Subscribe(title: "企鹅吃喝指南" , imageName:"企鹅吃喝指南")
        let subscriber31 = Subscribe(title: "糗事百科" , imageName:"糗事百科")
        let subscriber32 = Subscribe(title: "去哪儿旅游" , imageName:"去哪儿旅游")
        let subscriber33 = Subscribe(title: "任玩堂" , imageName:"任玩堂")
        let subscriber34 = Subscribe(title: "三联生活周刊" , imageName:"三联生活周刊")
        let subscriber35 = Subscribe(title: "少数派" , imageName:"少数派")
        let subscriber36 = Subscribe(title: "手游那点事" , imageName:"手游那点事")
        let subscriber37 = Subscribe(title: "数字尾巴" , imageName:"数字尾巴")
        let subscriber38 = Subscribe(title: "太平洋电脑网" , imageName:"太平洋电脑网")
        let subscriber39 = Subscribe(title: "钛媒体" , imageName:"钛媒体")
        let subscriber40 = Subscribe(title: "体育疯" , imageName:"体育疯")
        
        let subscriber41 = Subscribe(title: "土巴兔装修" , imageName:"土巴兔装修")
        let subscriber42 = Subscribe(title: "网易财经" , imageName:"网易财经")
        let subscriber43 = Subscribe(title: "威锋" , imageName:"威锋")
        let subscriber44 = Subscribe(title: "无讼阅读" , imageName:"无讼阅读")
        let subscriber45 = Subscribe(title: "严肃八卦" , imageName:"严肃八卦")
        let subscriber46 = Subscribe(title: "一个" , imageName:"一个")
        let subscriber47 = Subscribe(title: "一人一城" , imageName:"一人一城")
        let subscriber48 = Subscribe(title: "悦食家" , imageName:"悦食家")
        let subscriber49 = Subscribe(title: "悦食中国" , imageName:"悦食中国")
        let subscriber50 = Subscribe(title: "AppSo" , imageName:"AppSo")
        let subscriber51 = Subscribe(title: "HOT男人" , imageName:"HTO男人")
        let subscriber52 = Subscribe(title: "IT之家" , imageName:"IT之家")
        let subscriber53 = Subscribe(title: "v 电影" , imageName:"v 电影")
        let subscriber54 = Subscribe(title: "ZEALER" , imageName:"ZEALER")
        
        return [subscriber1,subscriber2,subscriber3,subscriber4,subscriber5,subscriber6,subscriber7,subscriber8,subscriber9,subscriber10,subscriber11,subscriber12,subscriber13,subscriber14,subscriber15,subscriber16,subscriber17,subscriber18,subscriber19,subscriber20,subscriber21,subscriber22,subscriber23,subscriber24,subscriber25,subscriber26,subscriber27,subscriber28,subscriber29,subscriber30,subscriber31,subscriber32,subscriber33,subscriber34,subscriber35,subscriber36,subscriber37,subscriber38,subscriber39,subscriber40,subscriber41,subscriber42,subscriber43,subscriber44,subscriber45,subscriber46,subscriber47,subscriber48,subscriber49,subscriber50,subscriber51,subscriber52,subscriber53,subscriber54]
    }
    
    /**
     随机的Index 集合
     
     - returns: Index 集合
     */
    private static func RandIndexArray() -> [Int]{
        
        var indexArray = [Int]()
        
        while true{
            
            let rand = Int(arc4random_uniform(53))
            
            if !indexArray.contains(rand) {
                
                indexArray.append(rand)
                
                if indexArray.count == 9 {
                    break
                }
            }
        }
        return indexArray
    }
}


class CustomSubscribeButton: UIButton {
    
    static let CNormalImg = UIImage(named: "加号")
    static let CSelectImg = UIImage(named: "对勾")
    
    let NormalImg = UIImage(named: "加号")
    let SelectImg = UIImage(named: "对勾")
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.setImage(self.NormalImg, forState: UIControlState.Normal)
        
        self.addAction(UIControlEvents.TouchUpInside) { (_) in
            
            if self.imageForState(.Normal) == self.NormalImg {
                
                self.setImage(self.SelectImg, forState: UIControlState.Normal)
            }else{
                
                self.setImage(self.NormalImg, forState: UIControlState.Normal)
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("SubscribeStateChange", object: nil)
        }
    }
}