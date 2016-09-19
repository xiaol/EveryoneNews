//
//  Focus.swift
//  Journalism
//
//  Created by Mister on 16/7/21.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import Alamofire
import RealmSwift
import AFDateHelper
import SwaggerClient

///  频道的数据模型
open class Focus: Object {
    
    dynamic var id = 1 /// 来源ID
    dynamic var ctime = ""  /// 关注事件
    dynamic var name = "" /// 用于获取评论的 docid
    dynamic var icon = "" /// 新闻标题
    dynamic var descr = "" /// 新闻标题
    dynamic var concern = 0 /// 来源ID
    
    dynamic var color = "" /// 新闻标题
    
    dynamic var cdate = Date()
    
    dynamic var isf = 0 /// 来源ID
    
    dynamic var issearch = 0 /// 来源ID
    
    override open static func primaryKey() -> String? {
        return "name"
    }
}


extension Focus{
    
    /**
     获取搜索出来的关注对象
     
     - returns: 搜索出来的关注对象集合
     */
    class func SearchArray() -> Results<Focus>{
        
        let realm = try! Realm()
        
        return realm.objects(Focus).filter("issearch = 1")
    }
    
    
    /**
     获取关注的个数
     
     - returns: 个数
     */
    class func ExFocusArrayCount() -> Int{
        
        let realm = try! Realm()
        
        return realm.objects(Focus.self).filter("isf = 1").count
    }
    
    /**
     获取集合
     
     - returns: <#return value description#>
     */
    class func ExFocusArray() -> Results<Focus>{
        
        let realm = try! Realm()
        
        return realm.objects(Focus.self).filter("isf = 1")
    }
    
    
    /**
     删除新闻
     
     - parameter result: <#result description#>
     */
    class func deleteByNameArray(_ result:NSArray ){
    
        let realm = try! Realm()
        
//        var nameArray = [String]()
//        
//        for res in result {
//        
//            if let name = res.objectForKey("name") as? String { nameArray.append(name)}
//        }
        
        try! realm.write({
            
            for focus in realm.objects(Focus.self) {
                
                focus.isf = 0
            }
            
        })
    }
    
    
    /**
     根据来源信息获取背景颜色
     
     - parameter name: 名称
     
     - returns: 颜色
     */
    class func gColor(_ name:String) -> UIColor{
    
        let realm = try! Realm()
        
        let hexStr = realm.objects(Focus.self).filter("name = '\(name)'").first?.color ?? UIColor.RandmColor()
        
        return UIColor.hexStringToColor(hexStr)
    }
    
    /**
     是否存在
     
     - parameter pname: <#pname description#>
     
     - returns: <#return value description#>
     */
    class func isExiter(_ pname:String) -> Bool{
    
        let realm = try! Realm()
        
        let pre = NSPredicate(format: "name = %@ AND isf = 1", pname)
        
        return realm.objects(Focus.self).filter(pre).count > 0
    }
    
    
    /**
     是否存在
     
     - parameter pname: <#pname description#>
     
     - returns: <#return value description#>
     */
    class func isExiters(_ pname:String) -> Bool{
        
        let realm = try! Realm()
        
        return realm.objects(Focus.self).filter("name = '\(pname)'").count > 0
    }
    
    /**
     获取关注列表下的新闻
     
     - parameter finish: 完成
     - parameter fail:   失败
     */
    class func refreshFocusNewList(_ times:TimeInterval=Date().dateByAddingHours(-3).timeIntervalSince1970*1000,finish:((_ message:String)->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(SwaggerClientAPI.basePath+"/ns/pbs/cocs/r" ,method:.get, parameters: ["uid":"\(ShareLUser.uid)","tcr":"\(Int64(times))","p":"1","c":"20"], encoding: URLEncoding.default, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let rv = res.result.value as? NSDictionary,let rcode = rv.object(forKey: "code") as? Int,let result = rv.object(forKey: "data") as? NSArray else{ fail?();return}
            
            if rcode != 2000 {fail?();return}
            
            let resultss = New.delFocus() // 先把数据库关注的新闻置空
            
            let addBefor = resultss.count
            
            let realm = try! Realm()
            
            for new in result {
            
                guard let nid = (new as AnyObject).object(forKey: "nid") as? Int else{ break }
                
                let isExt = realm.object(ofType: New.self, forPrimaryKey: nid as AnyObject) != nil
                
                try! realm.write({
                    
                    realm.create(New.self, value: new, update: true)
                    
                    self.AnalysisPutTimeAndImageList(new as! NSDictionary, realm: realm)
                    
                    var value = ["nid":nid,"channel":-1994,"isfocus":1]
                    
                    if isExt { value = ["nid":nid,"isfocus":1] }
                    
                    realm.create(New.self, value: value, update: true)
                })
            }
            
            let addAfter = resultss.count
            
            let addCount = addAfter - addBefor
            
            if addCount <= 0 {
                finish?("没有加载到新的数据")
            }else{
            
                finish?("一共刷新了\(addCount)条数据")
            }
        }
    }
    
    
    /**
     加载的新闻
     
     - parameter finish: 完成
     - parameter fail:   失败
     */
    class func loadFocusNewList(_ times:TimeInterval,finish:((_ nomore:Bool)->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request( SwaggerClientAPI.basePath+"/ns/pbs/cocs/l",method:.get, parameters: ["uid":"\(ShareLUser.uid)","tcr":"\(Int64(times))","p":"1","c":"20"], encoding: URLEncoding.default, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let rv = res.result.value as? NSDictionary,let rcode = rv.object(forKey: "code") as? Int,let result = rv.object(forKey: "data") as? NSArray else{ fail?();return}
            
            if rcode != 2000 {fail?();return}
            
            if result.count <= 0 {
            
                finish?(true)
                return
            }
            
            let realm = try! Realm()
            
            for new in result {
                
                guard let nid = (new as AnyObject).object(forKey: "nid") as? Int else{ break }
                
                let isExt = realm.object(ofType: New.self, forPrimaryKey: nid as AnyObject) != nil
                
                try! realm.write({
                    
                    realm.create(New.self, value: new, update: true)
                    
                    self.AnalysisPutTimeAndImageList(new as! NSDictionary, realm: realm)
                    
                    var value = ["nid":nid,"channel":-1994,"isfocus":1]
                    
                    if isExt { value = ["nid":nid,"isfocus":1] }
                    
                    realm.create(New.self, value: value, update: true)
                })
            }
            
            finish?(false)
        }
    }
    
    
    // 完善新闻事件
    class func AnalysisPutTimeAndImageList(_ channel:NSDictionary,realm:Realm,ishot:Int=0,iscollected:Int=0){
        
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
        }
    }
    
    
    /**
     刷新用户关注列表
     
     - parameter finish:  刷新完成
     - parameter fail:    刷新失败
     */
    class func refresh(_ finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request( SwaggerClientAPI.basePath+"/ns/pbs/cocs", method: .get, parameters: ["uid":"\(ShareLUser.uid)"], encoding: URLEncoding.default, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let rv = res.result.value as? NSDictionary,let rcode = rv.object(forKey: "code") as? Int,let result = rv.object(forKey: "data") as? NSArray else{ fail?();return}
            
            if rcode != 2000 {fail?();return}
            
            let realm = try! Realm()
            
            Focus.deleteByNameArray(result)
            
            try! realm.write({
                
                for res in result {
                    
                    if let name = (res as AnyObject).object(forKey: "name") as? String{
                        
                        if !self.isExiters(name) {
                            
                            realm.create(Focus.self, value: ["name":name,"color":UIColor.RandmColor()], update: true)
                        }
                        
                        realm.create(Focus.self, value: ["name":name,"isf":1], update: true)
                    }
                    
                    realm.create(Focus.self, value: res, update: true)
                }
            })
            
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: USERFOCUSPNAMENOTIFITION), object: nil)
            
            finish?()
        }
    }
    
    
    /**
     关注新闻来源
     
     - parameter new: 新闻对象
     - parameter finish:  关心完成
     - parameter fail:    关心失败
     */
    class func focusPub(_ pname:String,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(SwaggerClientAPI.basePath+"/ns/pbs/cocs",method:.post, parameters: ["uid":"\(ShareLUser.uid)","pname":pname], encoding: URLEncoding.default, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let code = result.object(forKey: "code") as? Int else{ fail?();return}
            
            if code != 2000 { fail?() ;return}
            
            self.refresh(finish, fail: fail)
        }
    }
    
    /**
     取消关注新闻来源
     
     - parameter new: 新闻对象
     - parameter finish:  关心完成
     - parameter fail:    关心失败
     */
    class func nofocusPub(_ pname:String,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request( SwaggerClientAPI.basePath+"/ns/pbs/cocs",method:.delete, parameters: ["uid":"\(ShareLUser.uid)","pname":pname], encoding: URLEncoding.default, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let code = result.object(forKey: "code") as? Int else{ fail?();return}
            
            if code != 2000 { fail?() ;return}
            
            self.delteByPname(pname)
            
            self.refresh(finish, fail: fail)
        }
    }
    
    /**
     删除新闻
     
     - parameter pname: <#pname description#>
     */
    class func delteByPname(_ pname:String){
    
        let realm = try! Realm()
        
        try! realm.write({
            
            for focus in realm.objects(New.self).filter("pname = '\(pname)'") {
                
                focus.isfocus = 0
            }
            
        })
    }
    
    /**
     取消关注新闻来源
     
     - parameter new: 新闻对象
     - parameter finish:  关心完成
     - parameter fail:    关心失败
     */
    class func noFocusPub(_ pname:String,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(SwaggerClientAPI.basePath+"/ns/pbs/cocs", method:.delete, parameters: ["uid":"\(ShareLUser.uid)","nid":pname], encoding: URLEncoding.default, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let code = result.object(forKey: "code") as? Int else{ fail?();return}
            
            if code != 2000 { fail?() ;return}
            
            self.refresh(finish, fail: fail)
        }
    }
}
