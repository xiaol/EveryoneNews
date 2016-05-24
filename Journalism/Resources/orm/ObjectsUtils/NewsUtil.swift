//
//  NewsUtil.swift
//  Journalism
//
//  Created by Mister on 16/5/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift
import AFDateHelper
import SwaggerClient

class NewsUtil: NSObject {
    
    /**
     请求 频道 列表
     
     - parameter finish: 完成回调方法
     */
    class func RefreshChannleObjects(channelId:Int,finish:(()->Void)?){
        
        let times = "\(Int64(NSDate().timeIntervalSince1970*1000))"
        
        NewsAPI.loadGet(cid: "\(channelId)", tstart: times, page: nil, offset: nil) { (data, error) in
            
            let realm = try! Realm()
            
            if let _ = error {return }
            
            if let code = data?.objectForKey("code") as? Int {
                if code != 0 {return}
                if let data = data?.objectForKey("data") as? NSArray {
                    
                    try! realm.write({
                        
                        for channel in data {
                            
                            realm.create(New.self, value: channel, update: true)
                            
                            self.AnalysisPutTimeAndImageList(channel as! NSDictionary, realm: realm)
                        }
                    })
                    
                    finish?()
                }
            }
        }
    }
    
    // 完善新闻事件
    private class func AnalysisPutTimeAndImageList(channel:NSDictionary,realm:Realm){
    
        if let objcid = channel.objectForKey("docid") as? String {
            
            if let pubTime = channel.objectForKey("pubTime") as? String {
                
                let date = NSDate(fromString: pubTime, format: DateFormat.Custom("yyyy-MM-dd HH:mm:ss"))
                
                realm.create(New.self, value: ["docid":objcid,"pubTimes":date], update: true)
            }
            
            if let imageList = channel.objectForKey("imgList") as? NSArray {
                
                var array = [StringObject]()
                
                imageList.enumerateObjectsUsingBlock({ (imageUrl, _, _) in
                    
                    let sp = StringObject()
                    sp.value = imageUrl as! String
                    array.append(sp)
                })
                
                realm.create(New.self, value: ["docid":objcid,"imgLists":array], update: true)
            }
        }
    }
    
    class func NewArray() -> Results<New>{
        
        let realm = try! Realm()
        let channles = realm.objects(New).sorted("pubTimes", ascending: false)
        return channles
    }
    
}




extension New {

    func HeightByNewConstraint(tableView:UITableView) -> CGFloat{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NewNormalTableViewCell") as! NewBaseTableViewCell
        
        let width = tableView.frame.width
        
        if self.imgStyle == 0 {
        
            let size = CGSize(width: width-24, height: 1000)
            
            let titleHeight = NSString(string:self.title).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:cell.titleLabel.font], context: nil).height
            
            let pubHeight = NSString(string:self.pubName).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)], context: nil).height
            
            return 15+18+17+pubHeight+titleHeight
        }else if self.imgStyle == 1{
        
            
            return 15+77+17
        }else if self.imgStyle == 2{
            
            let size = CGSize(width: width-24, height: 1000)
            
            let titleHeight = NSString(string:self.title).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:cell.titleLabel.font], context: nil).height
            
            let pubHeight = NSString(string:self.pubName).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)], context: nil).height
            
            return titleHeight+15+17+8+183+pubHeight+7
            
        }else if self.imgStyle == 3{
            
            let size = CGSize(width: width-24, height: 1000)
            
            let titleHeight = NSString(string:self.title).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:cell.titleLabel.font], context: nil).height
            
            let pubHeight = NSString(string:self.pubName).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)], context: nil).height
            
            return 77+15+7+8+titleHeight+pubHeight+17
        }
        
        return 20
    }
}