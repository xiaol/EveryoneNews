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
    class func searchNewArrayByKey(_ key:String,p:String="1",l:String="20",delete:Bool=true,finish:((_ key:String,_ nomore:Bool,_ fin:Bool)->Void)?=nil){
        
        SearchHistory.create(key)
        
        SearchAPI.nsEsSGet(keywords: key, p: p, l: l) { (datas, error) in
            
            guard let body = datas,let code = body.object(forKey: "code") as? Int else { finish?(key,false,false);return}
            if code == 2002 {finish?(key,true,true);return}
            if code != 2000 { finish?(key,false,false); return }
            
            let realm = try! Realm()
            if delete { New.deleSearch() }
            guard let da = body.object(forKey: "data"),let data = (da as AnyObject).object(forKey: "news") as? NSArray else{finish?(key,false,false);return}
            
            try! realm.write({
                for (index,channel) in data.enumerated() {
                    
                    if index == 2 {
                        realm.create(New.self,value: ["nid":-1111,"issearch":1],update:true)
                    }
                    
                    realm.create(New.self, value: channel, update: true)
                    
                    self.AnalysisPutTimeAndImageList(channel:channel as! NSDictionary, realm: realm,iscollected:0)
                    
                    if let nid = (channel as AnyObject).object(forKey: "nid") as? Int {
                        
                        let title = (channel as AnyObject).object(forKey: "title") as! String
                        
                        let attributed = try! NSMutableAttributedString(data: title.data(using: String.Encoding.unicode)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
                        
                        realm.create(New.self, value: ["nid":nid,"issearch":1,"title":attributed.string,"channel":999,"searchTitle":title], update: true)
                    }
                    
                    /**
                     *  如果是删除的
                     */
                    if delete {
                    
                        if index == 0 {
                            
                            if let nid = (channel as AnyObject).object(forKey: "nid") as? Int {
                            
                                realm.create(New.self,value: ["nid":nid,"orderIndex":1],update:true)
                            }
                        }
                        
                        if index == 1 {
                            
                            if let nid = (channel as AnyObject).object(forKey: "nid") as? Int {
                                
                                realm.create(New.self,value: ["nid":nid,"orderIndex":2],update:true)
                            }
                        }
                        
                        if index == 2 {
                            
                            realm.create(New.self,value: ["nid":-1111,"orderIndex":3],update:true)
                        }
                    }
                }
                
                if let publisher = (da as AnyObject).object(forKey: "publisher") as? NSArray {
                
                    for pub in publisher {
                        
                        realm.create(Focus.self, value: pub, update: true)
                        
                        if let name = (pub as AnyObject).object(forKey: "name") as? String {
                            
                            realm.create(Focus.self, value: ["name":name,"issearch":1], update: true)
                        }
                    }
                }
            })
            
            finish?(key,false,true)
        }
    }
    
    
    /**
     获取所有的收藏新闻
     
     - parameter finish: <#finish description#>
     */
    class func getAllCollectionResultMthod(_ finish:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ finish?();return }
        
        let requestBudile = NewAPI.nsAuColsGetWithRequestBuilder(uid: "\(ShareLUser.uid)")
        
        requestBudile.addHeaders(["Authorization":token])
        
        requestBudile.execute { (response, error) in
            
            let realm = try! Realm()
            
            guard let body = response?.body,let code = body.object(forKey: "code") as? Int else {finish?();return}
            
            if code == 2000 || code == 2002{
            
                try! realm.write({
                    
                    realm.objects(New.self).filter("iscollected = 1").forEach({ (new) in
                        
                        new.iscollected = 0
                    })
                })
            }
            
            guard let data = body.object(forKey: "data") as? NSArray else{  finish?();return} // 加载失败
            
            try! realm.write({
                for channel in data {
                    realm.create(New.self, value: channel, update: true)
                    self.AnalysisPutTimeAndImageList(channel:channel as! NSDictionary, realm: realm,iscollected:1)
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
    class func RefreshNewsListArrayData(_ channelId:Int,delete:Bool=false,create:Bool=false,times:String = "\(Int64(Date().timeIntervalSince1970*1000))",finish:((_ count:Int)->Void)?=nil,fail:(()->Void)?=nil){
        
        
        guard let token = ShareLUser.token else{ fail?();return }
        
        let requestBudile = NewAPI.nsFedRGetWithRequestBuilder(cid: "\(channelId)", tcr: times, tmk: "0",uid:"\(ShareLUser.uid)")
        
        requestBudile.addHeaders(["Authorization":token])
        
        requestBudile.execute { (response, error) in
            
            guard let body = response?.body,let code = body.object(forKey: "code") as? Int else{fail?();return}
            
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
                    
                    realm.delete(realm.objects(New.self).filter("isidentification = 1 AND ishotnew = 1"))
                }else{
                    
                    realm.delete(realm.objects(New.self).filter("isidentification = 1 AND channel = \(channelId)"))
                }
            })
            
            guard let data = body.object(forKey: "data") as? NSArray else{  finish?(0);return} // 加载失败

            // 获取所有数据
            var newsResults = realm.objects(New.self)

            // 获取当前频道所操作的数据个数，并且
            try! realm.write({
                if hot == 1 {
                    
                    newsResults = newsResults.filter("ishotnew = 1 AND isdelete = 0").sorted(byProperty: "ptimes", ascending: false)
                }else{
                    
                    newsResults = newsResults.filter("channel = %@ AND isdelete = 0 AND ishotnew = 0",channelId).sorted(byProperty: "ptimes", ascending: false)
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
                    self.AnalysisPutTimeAndImageList(channelId,channel: channel as! NSDictionary, realm: realm,ishot:hot)
                }
            })
            
            // 新增完成的数目
            let currenOunt = newsResults.count - beforeCount
            
            // 决定是否完成新增
            if create && currenOunt > 0{
                let date = Date(timeIntervalSince1970: ((times as NSString).doubleValue+1)/1000)
                let nid = hot == 1 ? -100 : -channelId
                try! realm.write({
                    realm.create(New.self, value: ["nid":nid,"channel": channelId,"isidentification":1,"ishotnew":hot,"ptimes":date], update: true)
                })
            }
            
            finish?(currenOunt) // 记录个数
        }
    }
    
    /**
     上拉下载新闻列表
     
     - parameter channelId: 频道ID
     - parameter refresh:   是否需要刷新
     - parameter times:     加载的时间
     - parameter finish:    完成
     - parameter fail:      失败
     */
    class func LoadNewsListArrayData(_ channelId:Int,refresh:Bool=false,times:String = "\(Int64(Date().timeIntervalSince1970*1000))",finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ fail?();return }
        
        let requestBudile = NewAPI.nsFedLGetWithRequestBuilder(cid: "\(channelId)", tcr: times, tmk: "0",uid:"\(ShareLUser.uid)")
        
        requestBudile.addHeaders(["Authorization":token])
        
        requestBudile.execute { (response, error) in
            
            guard let body = response?.body,let data = body.object(forKey: "data") as? NSArray else{  fail?();return}
            
            let realm = try! Realm()
            
            try! realm.write({
                
                if refresh {
                    realm.delete(realm.objects(New.self).filter("channel = \(channelId)"))
                }
                
                for channel in data {
                    
                    if let rtype = (channel as AnyObject).object(forKey: "rtype") as? Int , rtype == 3 {
                    
                        print("获取到一个新新闻了")
                    }
                    
                    if let nid = (channel as AnyObject).object(forKey: "nid") as? Int , realm.object(ofType: New.self, forPrimaryKey: nid as AnyObject) == nil {
                        
                        realm.create(New.self, value: channel, update: true)
                        
                        self.AnalysisPutTimeAndImageList(channelId,channel: channel as! NSDictionary, realm: realm,ishot:(channelId == 1 ? 1 : 0))
                    }
                }
            })
            
            finish?()
        }
    }
    
    // 完善新闻事件
    fileprivate class func AnalysisPutTimeAndImageList(_ cid:Int = -1,channel:NSDictionary,realm:Realm,ishot:Int=0,iscollected:Int=0){
        
        if let nid = channel.object(forKey: "nid") as? Int {
            
            if let pubTime = channel.object(forKey: "ptime") as? String {
                
                let date = Date(fromString: pubTime, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"))
                
                realm.create(New.self, value: ["nid":nid,"ptimes":date], update: true)
            }
            
            if let imageList = channel.object(forKey: "imgs") as? NSArray {
                
                var array = [StringObject]()
                
                imageList.enumerateObjects({ (imageUrl, _, _) in
                    
                    let sp = StringObject()
                    sp.value = imageUrl as! String
                    array.append(sp)
                })
                
                realm.create(New.self, value: ["nid":nid,"imgsList":array], update: true)
            }
            
            if let new = realm.object(ofType: New.self, forPrimaryKey: nid as AnyObject) , cid > 0 {
                
                if let _ = new.channelList.filter("channel = %@",cid).first { } else {
                    
                    let sp = IntegetObject()
                    sp.channel = cid
                    new.channelList.append(sp)
                }
            }
            
            realm.create(New.self, value: ["nid":nid,"ishotnew":ishot,"iscollected":iscollected], update: true)
        }
    }
    
    class func NewArray() -> Results<New>{
        
        let realm = try! Realm()
        let channles = realm.objects(New.self).sorted(byProperty: "ptimes", ascending: false)
        return channles
    }
}


extension String {

    func toAttributedString(_ font:UIFont=UIFont.a_font2) -> NSAttributedString{
        
        return AttributedStringLoader.sharedLoader.imageForUrl(self)
    }
}

/// 属性字符串 缓存器
class AttributedStringLoader {
    

    lazy var cache = NSCache<AnyObject,AnyObject>()
    
    static var sharedLoader:AttributedStringLoader!{
        return AttributedStringLoader()
    }
    
    /**
     根据提供的String 继而提供 属性字符串
     
     - parameter string: 原本 字符串
     - parameter font:   字体 对象 默认为 系统2号字体
     
     - returns: 返回属性字符串
     */
    func imageForUrl(_ string : String,font:UIFont=UIFont.a_font2) -> NSAttributedString {
        
        if let aString = self.cache.object(forKey: string as AnyObject) as? NSAttributedString { return aString }
        
        let attributed = try! NSMutableAttributedString(data: string.data(using: String.Encoding.unicode)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
        
        attributed.addAttributes([NSFontAttributeName:font], range: NSMakeRange(0, attributed.length))
        
        self.cache.setObject(attributed, forKey: string as AnyObject)
        
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
        
        if let plainData = self.docid.data(using: String.Encoding.utf8){
            
            return plainData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        }
        
        return ""
    }
    
    func HeightByNewConstraint(_ tableView:UITableView,html:Bool = false) -> CGFloat{

        
        let width = tableView.frame.width
        
        let size = CGSize(width: width-24, height: 1000)
        var titleHeight:CGFloat = 0
        
        if html {
            
            titleHeight = self.title.toAttributedString().boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).height
        }else{
            
            titleHeight = NSString(string:self.title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font2], context: nil).height
        }
        
        var calHeight:CGFloat = 0
        
        if self.style == 0 {
            
            let pubHeight = NSString(string:self.pname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
            
            calHeight = 15+18+17+pubHeight+titleHeight
        }else if self.style == 1{
            
            
            calHeight = 15+77+17
        }else if self.style == 2{
            
            let pubHeight = NSString(string:self.pname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
            
            calHeight = titleHeight+15+17+8+183+pubHeight+7
            
        }else if self.style == 3{
            
            let pubHeight = NSString(string:self.pname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
            
            calHeight = 77+15+7+8+titleHeight+pubHeight+17
        }else{
        
            let pubHeight = NSString(string:self.pname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
            
            calHeight = titleHeight+15+17+8+183+pubHeight+7
        }

        return calHeight
    }
}
