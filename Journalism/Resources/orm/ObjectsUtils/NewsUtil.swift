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
     根据用户提供的字段进行新闻的获取
     
     - parameter key:    新闻的关键字
     - parameter finish: 完成的回调
     */
    class func searchNewArrayByKey(key:String,p:String="1",l:String="20",delete:Bool=true,finish:((key:String,nomore:Bool,fin:Bool)->Void)?=nil){
        
        SearchHistory.create(key)
        
        SearchAPI.nsEsSGet(keywords: key, p: p, l: l) { (datas, error) in
            
            guard let body = datas,code = body.objectForKey("code") as? Int else { finish?(key: key,nomore: false,fin: false);return}
            if code == 2002 {finish?(key: key,nomore: true,fin: true);return}
            if code != 2000 { finish?(key: key,nomore: false,fin: false); return }
            
            let realm = try! Realm()
            if delete { New.deleSearch() }
            guard let da = body.objectForKey("data"),let data = da.objectForKey("news") as? NSArray else{finish?(key: key,nomore: false,fin: false);return}
            
            try! realm.write({
                for (index,channel) in data.enumerate() {
                    
                    if index == 2 {
                        realm.create(New.self,value: ["nid":-1111,"issearch":1],update:true)
                    }
                    
                    realm.create(New.self, value: channel, update: true)
                    
                    self.AnalysisPutTimeAndImageList(channel as! NSDictionary, realm: realm,iscollected:0)
                    
                    if let nid = channel.objectForKey("nid") as? Int {
                        
                        let title = channel.objectForKey("title") as! String
                        
                        let attributed = try! NSMutableAttributedString(data: title.dataUsingEncoding(NSUnicodeStringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
                        
                        realm.create(New.self, value: ["nid":nid,"issearch":1,"title":attributed.string,"channel":999,"searchTitle":title], update: true)
                    }
                    
                    /**
                     *  如果是删除的
                     */
                    if delete {
                    
                        if index == 0 {
                            
                            if let nid = channel.objectForKey("nid") as? Int {
                            
                                realm.create(New.self,value: ["nid":nid,"orderIndex":1],update:true)
                            }
                        }
                        
                        if index == 1 {
                            
                            if let nid = channel.objectForKey("nid") as? Int {
                                
                                realm.create(New.self,value: ["nid":nid,"orderIndex":2],update:true)
                            }
                        }
                        
                        if index == 2 {
                            
                            realm.create(New.self,value: ["nid":-1111,"orderIndex":3],update:true)
                        }
                    }
                }
                
                if let publisher = da.objectForKey("publisher") as? NSArray {
                
                    for pub in publisher {
                        
                        print(pub)
                        
                        realm.create(Focus.self, value: pub, update: true)
                        
                        if let name = pub.objectForKey("name") as? String {
                            
                            realm.create(Focus.self, value: ["name":name,"issearch":1], update: true)
                        }
                    }
                }
            })
            
            finish?(key: key,nomore: false,fin: true)
        }
    }
    
    
    /**
     获取所有的收藏新闻
     
     - parameter finish: <#finish description#>
     */
    class func getAllCollectionResultMthod(finish:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ finish?();return }
        
        let requestBudile = NewAPI.nsAuColsGetWithRequestBuilder(uid: "\(ShareLUser.uid)")
        
        requestBudile.addHeaders(["Authorization":token])
        
        requestBudile.execute { (response, error) in
            
            let realm = try! Realm()
            
            guard let body = response?.body,code = body.objectForKey("code") as? Int else {finish?();return}
            
            if code == 2000 || code == 2002{
            
                try! realm.write({
                    
                    realm.objects(New).filter("iscollected = 1").forEach({ (new) in
                        
                        new.iscollected = 0
                    })
                })
            }
            
            guard let data = body.objectForKey("data") as? NSArray else{  finish?();return} // 加载失败
            
            try! realm.write({
                for channel in data {
                    realm.create(New.self, value: channel, update: true)
                    self.AnalysisPutTimeAndImageList(channel as! NSDictionary, realm: realm,iscollected:1)
                }
            })
            
            finish?()
        }
    }
    
    /**
     刷新新闻
     
     - parameter channelId: 刷新的频道ID
     - parameter delete:    是否删除，标识是否需要删除假的新闻
     - parameter create:    是否需要创建 标识 是否需要创建假的额新闻
     - parameter times:     刷新频道的事件 默认为当前时间
     - parameter finish:    完成的回调
     - parameter fail:      失败的回调
     */
    class func RefreshNewsListArrayData(channelId:Int,delete:Bool=false,create:Bool=false,times:String = "\(Int64(NSDate().timeIntervalSince1970*1000))",finish:((count:Int)->Void)?=nil,fail:(()->Void)?=nil){
        
        
        guard let token = ShareLUser.token else{ fail?();return }
        
        let requestBudile = NewAPI.nsFedRGetWithRequestBuilder(cid: "\(channelId)", tcr: times, tmk: "0",uid:"\(ShareLUser.uid)")
        
        requestBudile.addHeaders(["Authorization":token])
        
        requestBudile.execute { (response, error) in
            
            guard let body = response?.body,let code = body.objectForKey("code") as? Int else{fail?();return}
            
            if code == 4003 {
                ShareLUserRequest.resetLogin({ 
                    
                })
                
                fail?();return
            }
            
            let realm = try! Realm()
            
            let hot = channelId == 1 ? 1 : 0
            
            // 删除标记当前频道的标记对象
            try! realm.write({
                if hot == 1 {
                    
                    realm.delete(realm.objects(New).filter("isidentification = 1 AND ishotnew = 1"))
                }else{
                    
                    realm.delete(realm.objects(New).filter("isidentification = 1 AND channel = \(channelId)"))
                }
            })
            
            guard let data = body.objectForKey("data") as? NSArray else{  finish?(count: 0);return} // 加载失败

            // 获取所有数据
            var newsResults = realm.objects(New)

            // 获取当前频道所操作的数据个数，并且
            try! realm.write({
                if hot == 1 {
                    
                    newsResults = newsResults.filter("ishotnew = 1 AND isdelete = 0").sorted("ptimes", ascending: false)
                }else{
                    
                    newsResults = newsResults.filter("channel = %@ AND isdelete = 0 AND ishotnew = 0",channelId).sorted("ptimes", ascending: false)
                }
            })
            
            if delete && newsResults.count > 30{ // 如果是第一次刷新，并且数据量大于30，则完成数据清除
                
                let willDelete = newsResults.filter("ptimes < %@", newsResults[30].ptimes)
                
                try! realm.write({ // 删除冗余的新闻
                    
                    willDelete.forEach({ (new) in // 确保不喜欢的新闻 绝对消失
                        
                        if new.isdelete == 0 {
                            realm.delete(new)
                        }
                    })
                })
            }
            
            // 记录个数
            let beforeCount = newsResults.count
            
            try! realm.write({
                for channel in data {
                    realm.create(New.self, value: channel, update: true)
                    self.AnalysisPutTimeAndImageList(channel as! NSDictionary, realm: realm,ishot:hot)
                }
            })
            
            // 新增完成的数目
            let currenOunt = newsResults.count - beforeCount
            
            // 决定是否完成新增
            if create && currenOunt > 0{
                let date = NSDate(timeIntervalSince1970: ((times as NSString).doubleValue+1)/1000)
                let nid = hot == 1 ? -100 : -channelId
                try! realm.write({
                    realm.create(New.self, value: ["nid":nid,"channel": channelId,"isidentification":1,"ishotnew":hot,"ptimes":date], update: true)
                })
            }
            
            finish?(count: currenOunt) // 记录个数
        }
    }
    
    
    class func LoadNewsListArrayData(channelId:Int,refresh:Bool=false,times:String = "\(Int64(NSDate().timeIntervalSince1970*1000))",finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ fail?();return }
        
        let requestBudile = NewAPI.nsFedLGetWithRequestBuilder(cid: "\(channelId)", tcr: times, tmk: "0",uid:"\(ShareLUser.uid)")
        
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
    private class func AnalysisPutTimeAndImageList(channel:NSDictionary,realm:Realm,ishot:Int=0,iscollected:Int=0){
        
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
            
            realm.create(New.self, value: ["nid":nid,"ishotnew":ishot,"iscollected":iscollected], update: true)
        }
    }
    
    class func NewArray() -> Results<New>{
        
        let realm = try! Realm()
        let channles = realm.objects(New).sorted("ptimes", ascending: false)
        return channles
    }
}


extension String {

    func toAttributedString(font:UIFont=UIFont.a_font2) -> NSAttributedString{
        
        return AttributedStringLoader.sharedLoader.imageForUrl(self)
    }
}

/// 属性字符串 缓存器
class AttributedStringLoader {
    
    lazy var cache = NSCache()
    
    class var sharedLoader:AttributedStringLoader!{
        get{
            struct backTaskLeton{
                static var predicate:dispatch_once_t = 0
                static var instance:AttributedStringLoader? = nil
            }
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                backTaskLeton.instance = AttributedStringLoader()
            })
            return backTaskLeton.instance
        }
    }
    
    /**
     根据提供的String 继而提供 属性字符串
     
     - parameter string: 原本 字符串
     - parameter font:   字体 对象 默认为 系统2号字体
     
     - returns: 返回属性字符串
     */
    func imageForUrl(string : String,font:UIFont=UIFont.a_font2) -> NSAttributedString {
        
        if let aString = self.cache.objectForKey(string) as? NSAttributedString { return aString }
        
        let attributed = try! NSMutableAttributedString(data: string.dataUsingEncoding(NSUnicodeStringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
        
        attributed.addAttributes([NSFontAttributeName:font], range: NSMakeRange(0, attributed.length))
        
        self.cache.setObject(attributed, forKey: string)
        
        return attributed
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
    
    func HeightByNewConstraint(tableView:UITableView,html:Bool = false) -> CGFloat{

        
        let width = tableView.frame.width
        
        let size = CGSize(width: width-24, height: 1000)
        var titleHeight:CGFloat = 0
        
        if html {
            
            titleHeight = self.title.toAttributedString().boundingRectWithSize(size, options: .UsesLineFragmentOrigin, context: nil).height
        }else{
            
            titleHeight = NSString(string:self.title).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font2], context: nil).height
        }
        
        var calHeight:CGFloat = 0
        
        if self.style == 0 {
            
            let pubHeight = NSString(string:self.pname).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
            
            calHeight = 15+18+17+pubHeight+titleHeight
        }else if self.style == 1{
            
            
            calHeight = 15+77+17
        }else if self.style == 2{
            
            let pubHeight = NSString(string:self.pname).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
            
            calHeight = titleHeight+15+17+8+183+pubHeight+7
            
        }else if self.style == 3{
            
            let pubHeight = NSString(string:self.pname).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
            
            calHeight = 77+15+7+8+titleHeight+pubHeight+17
        }else{
        
            let pubHeight = NSString(string:self.pname).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
            
            calHeight = titleHeight+15+17+8+183+pubHeight+7
        }

        return calHeight
    }
}