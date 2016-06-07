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
    
    class func RefreshNewsListArrayData(channelId:Int,create:Bool=false,times:String = "\(Int64(NSDate().timeIntervalSince1970*1000))",finish:((count:Int)->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = SDK_User.token else{ fail?();return }
        
        let requestBudile = NewAPI.nsFedRGetWithRequestBuilder(cid: "\(channelId)", tcr: times, tmk: "0")
        
        requestBudile.addHeaders(["Authorization":token])
        
        requestBudile.execute { (response, error) in
            
            guard let body = response?.body,let data = body.objectForKey("data") as? NSArray else{  fail?();return}
            
            let realm = try! Realm()
            
            try! realm.write({
                
                let hot = channelId == 1 ? 1 : 0
                
                if hot == 1 {
                    
                    realm.delete(realm.objects(New).filter("isidentification = 1 AND ishotnew = 1"))
                }else{
                    
                    realm.delete(realm.objects(New).filter("isidentification = 1 AND channel = \(channelId)"))
                }
                
                if create && data.count > 0{
                    
                    let date = NSDate(timeIntervalSince1970: ((times as NSString).doubleValue-1)/1000)
                    let nid = hot == 1 ? -100 : -channelId
                    realm.create(New.self, value: ["nid":nid,"channel": channelId,"isidentification":1,"ishotnew":hot,"ptimes":date], update: true)
                }
                
                for channel in data {
                    
                    realm.create(New.self, value: channel, update: true)
                    self.AnalysisPutTimeAndImageList(channel as! NSDictionary, realm: realm,ishot:hot)
                }
            })
            
            finish?(count: data.count)
        }
    }
    
    
    class func LoadNewsListArrayData(channelId:Int,refresh:Bool=false,times:String = "\(Int64(NSDate().timeIntervalSince1970*1000))",finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = SDK_User.token else{ fail?();return }
        
        let requestBudile = NewAPI.nsFedLGetWithRequestBuilder(cid: "\(channelId)", tcr: times, tmk: "0")
        
        requestBudile.addHeaders(["Authorization":token])
        
        requestBudile.execute { (response, error) in
            
            guard let body = response?.body,let data = body.objectForKey("data") as? NSArray else{  fail?();return}
            
            let realm = try! Realm()
            
            try! realm.write({
                
                if refresh {
                    realm.delete(realm.objects(New).filter("channel = \(channelId)"))
                }
                
                for channel in data {
                    
                    realm.create(New.self, value: channel, update: true)
                    self.AnalysisPutTimeAndImageList(channel as! NSDictionary, realm: realm,ishot:(channelId == 1 ? 1 : 0))
                }
            })
            
            finish?()
        }
    }
    
    // 完善新闻事件
    private class func AnalysisPutTimeAndImageList(channel:NSDictionary,realm:Realm,ishot:Int=0){
        
        if let nid = channel.objectForKey("nid") as? Int {
            
            if let pubTime = channel.objectForKey("ptime") as? String {
                
                let date = NSDate(fromString: pubTime, format: DateFormat.Custom("yyyy-MM-dd HH:mm:ss"))
                
                realm.create(New.self, value: ["nid":nid,"ptimes":date], update: true)
            }
            
            if let imageList = channel.objectForKey("imgs") as? NSArray {
                
                var array = [StringObject]()
                
                imageList.enumerateObjectsUsingBlock({ (imageUrl, _, _) in
                    
                    let sp = StringObject()
                    sp.value = imageUrl as! String
                    array.append(sp)
                })
                
                realm.create(New.self, value: ["nid":nid,"imgsList":array], update: true)
            }
            
            realm.create(New.self, value: ["nid":nid,"ishotnew":ishot], update: true)
        }
    }
    
    class func NewArray() -> Results<New>{
        
        let realm = try! Realm()
        let channles = realm.objects(New).sorted("ptimes", ascending: false)
        return channles
    }
}




extension New {
    
    /// 自杀
    func suicide(){
        
        let realm = try! Realm()
        
        try! realm.write({
            
            realm.create(New.self, value: ["nid":self.nid,"isdelete":1], update: true)
        })
    }
    
    func docidBase64() -> String{
        
        if let plainData = self.docid.dataUsingEncoding(NSUTF8StringEncoding){
            
            return plainData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        }
        
        return ""
    }
    
    func HeightByNewConstraint(tableView:UITableView) -> CGFloat{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NewNormalTableViewCell") as! NewBaseTableViewCell
        
        let width = tableView.frame.width
        
        if self.style == 0 {
            
            let size = CGSize(width: width-24, height: 1000)
            
            let titleHeight = NSString(string:self.title).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:cell.titleLabel.font], context: nil).height
            
            let pubHeight = NSString(string:self.pname).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)], context: nil).height
            
            return 15+18+17+pubHeight+titleHeight
        }else if self.style == 1{
            
            
            return 15+77+17
        }else if self.style == 2{
            
            let size = CGSize(width: width-24, height: 1000)
            
            let titleHeight = NSString(string:self.title).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:cell.titleLabel.font], context: nil).height
            
            let pubHeight = NSString(string:self.pname).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)], context: nil).height
            
            return titleHeight+15+17+8+183+pubHeight+7
            
        }else if self.style == 3{
            
            let size = CGSize(width: width-24, height: 1000)
            
            let titleHeight = NSString(string:self.title).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:cell.titleLabel.font], context: nil).height
            
            let pubHeight = NSString(string:self.pname).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)], context: nil).height
            
            return 77+15+7+8+titleHeight+pubHeight+17
        }
        
        return 20
    }
}