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
public class Focus: Object {
    
    dynamic var id = 1 /// 来源ID
    dynamic var ctime = ""  /// 关注事件
    dynamic var name = "" /// 用于获取评论的 docid
    dynamic var icon = "" /// 新闻标题
    dynamic var descr = "" /// 新闻标题
    dynamic var concern = 1 /// 来源ID
    
    dynamic var color = "" /// 新闻标题
    
    dynamic var cdate = NSDate()
    
    dynamic var isf = 0 /// 来源ID
    
    override public static func primaryKey() -> String? {
        return "name"
    }
}


extension Focus{
    
    /**
     获取关注的个数
     
     - returns: 个数
     */
    class func ExFocusArrayCount() -> Int{
        
        let realm = try! Realm()
        
        return realm.objects(Focus.self).filter("isf = 1").count
    }
    
    
    
    /**
     删除新闻
     
     - parameter result: <#result description#>
     */
    class func deleteByNameArray(result:NSArray ){
    
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
    class func gColor(name:String) -> UIColor{
    
        let realm = try! Realm()
        
        let hexStr = realm.objects(Focus.self).filter("name = '\(name)'").first?.color ?? UIColor.RandmColor()
        
        return UIColor.hexStringToColor(hexStr)
    }
    
    /**
     是否存在
     
     - parameter pname: <#pname description#>
     
     - returns: <#return value description#>
     */
    class func isExiter(pname:String) -> Bool{
    
        let realm = try! Realm()
        
        return realm.objects(Focus.self).filter("name = '\(pname)' AND isf = 1").count > 0
    }
    /**
     获取关注列表下的新闻
     
     - parameter finish: 完成
     - parameter fail:   失败
     */
    class func refreshFocusNewList(times:NSTimeInterval=NSDate().dateByAddingHours(-3).timeIntervalSince1970*1000,finish:((message:String)->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(.GET, SwaggerClientAPI.basePath+"/ns/pbs/cocs/r", parameters: ["uid":"\(ShareLUser.uid)","tcr":"\(Int64(times))","p":"1","c":"20"], encoding: ParameterEncoding.URLEncodedInURL, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let rv = res.result.value as? NSDictionary,let rcode = rv.objectForKey("code") as? Int,let result = rv.objectForKey("data") as? NSArray else{ fail?();return}
            
            if rcode != 2000 {fail?();return}
            
            let resultss = New.delFocus() // 先把数据库关注的新闻置空
            
            let addBefor = resultss.count
            
            let realm = try! Realm()
            
            for new in result {
            
                guard let nid = new.objectForKey("nid") as? Int else{ break }
                
                let isExt = realm.objectForPrimaryKey(New.self, key: nid) != nil
                
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
                finish?(message: "没有加载到新的数据")
            }else{
            
                finish?(message: "一共刷新了\(addCount)条数据")
            }
        }
    }
    
    
    /**
     加载的新闻
     
     - parameter finish: 完成
     - parameter fail:   失败
     */
    class func loadFocusNewList(times:NSTimeInterval,finish:((nomore:Bool)->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(.GET, SwaggerClientAPI.basePath+"/ns/pbs/cocs/l", parameters: ["uid":"\(ShareLUser.uid)","tcr":"\(Int64(times))","p":"1","c":"20"], encoding: ParameterEncoding.URLEncodedInURL, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let rv = res.result.value as? NSDictionary,let rcode = rv.objectForKey("code") as? Int,let result = rv.objectForKey("data") as? NSArray else{ fail?();return}
            
            if rcode != 2000 {fail?();return}
            
            if result.count <= 0 {
            
                finish?(nomore:true)
                return
            }
            
            let realm = try! Realm()
            
            for new in result {
                
                guard let nid = new.objectForKey("nid") as? Int else{ break }
                
                let isExt = realm.objectForPrimaryKey(New.self, key: nid) != nil
                
                try! realm.write({
                    
                    realm.create(New.self, value: new, update: true)
                    
                    self.AnalysisPutTimeAndImageList(new as! NSDictionary, realm: realm)
                    
                    var value = ["nid":nid,"channel":-1994,"isfocus":1]
                    
                    if isExt { value = ["nid":nid,"isfocus":1] }
                    
                    realm.create(New.self, value: value, update: true)
                })
            }
            
            finish?(nomore:false)
        }
    }
    
    
    // 完善新闻事件
    class func AnalysisPutTimeAndImageList(channel:NSDictionary,realm:Realm,ishot:Int=0,iscollected:Int=0){
        
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
        }
    }
    
    
    /**
     刷新用户关注列表
     
     - parameter finish:  刷新完成
     - parameter fail:    刷新失败
     */
    class func refresh(finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(.GET, SwaggerClientAPI.basePath+"/ns/pbs/cocs", parameters: ["uid":"\(ShareLUser.uid)"], encoding: ParameterEncoding.URLEncodedInURL, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let rv = res.result.value as? NSDictionary,let rcode = rv.objectForKey("code") as? Int,let result = rv.objectForKey("data") as? NSArray else{ fail?();return}
            
            if rcode != 2000 {fail?();return}
            
            let realm = try! Realm()
            
            Focus.deleteByNameArray(result)
            
            try! realm.write({
                
                for res in result {
                    
                    if let name = res.objectForKey("name") as? String{
                        
                        if !self.isExiter(name) {
                            
                            realm.create(Focus.self, value: ["name":name,"color":UIColor.RandmColor()], update: true)
                        }
                        
                        realm.create(Focus.self, value: ["name":name,"isf":1], update: true)
                    }
                    
                    realm.create(Focus.self, value: res, update: true)
                }
            })
            
            finish?()
        }
    }
    
    
    /**
     关注新闻来源
     
     - parameter new: 新闻对象
     - parameter finish:  关心完成
     - parameter fail:    关心失败
     */
    class func focusPub(pname:String,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(.POST, SwaggerClientAPI.basePath+"/ns/pbs/cocs", parameters: ["uid":"\(ShareLUser.uid)","pname":pname], encoding: ParameterEncoding.URLEncodedInURL, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let code = result.objectForKey("code") as? Int else{ fail?();return}
            
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
    class func nofocusPub(pname:String,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(.DELETE, SwaggerClientAPI.basePath+"/ns/pbs/cocs", parameters: ["uid":"\(ShareLUser.uid)","pname":pname], encoding: ParameterEncoding.URLEncodedInURL, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let code = result.objectForKey("code") as? Int else{ fail?();return}
            
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
    class func noFocusPub(pname:String,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(.DELETE, SwaggerClientAPI.basePath+"/ns/pbs/cocs", parameters: ["uid":"\(ShareLUser.uid)","nid":pname], encoding: ParameterEncoding.URLEncodedInURL, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let code = result.objectForKey("code") as? Int else{ fail?();return}
            
            if code != 2000 { fail?() ;return}
            
            self.refresh(finish, fail: fail)
        }
    }
}