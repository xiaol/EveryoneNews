//
//  Focus.swift
//  Journalism
//
//  Created by Mister on 16/7/21.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import Alamofire
import RealmSwift
import SwaggerClient

///  频道的数据模型
public class Focus: Object {
    
    dynamic var id = 1 /// 来源ID
    dynamic var ctime = ""  /// 关注事件
    dynamic var name = "" /// 用于获取评论的 docid
    dynamic var icon = "" /// 新闻标题
    dynamic var descr = "" /// 新闻标题
    dynamic var concern = 1 /// 来源ID
    
    dynamic var cdate = NSDate()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}


extension Focus{

    class func isExiter(pname:String) -> Bool{
    
        let realm = try! Realm()
        
        return realm.objects(Focus.self).filter("name = '\(pname)'").count > 0
    }
    
    
    class func refreshFocusNewList(finish:(()->Void)?=nil,fail:(()->Void)?=nil){
    
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(.GET, SwaggerClientAPI.basePath+"/ns/pbs/cocs/r", parameters: ["uid":"\(ShareLUser.uid)"], encoding: ParameterEncoding.JSON, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let rv = res.result.value as? NSDictionary,let rcode = rv.objectForKey("code") as? Int,let result = rv.objectForKey("data") as? NSArray else{ fail?();return}
            
            if rcode != 2000 {fail?();return}
            
            let realm = try! Realm()
            
            try! realm.write({
                
                realm.delete(realm.objects(Focus.self))
                
                for res in result {
                    
                    realm.create(Focus.self, value: res, update: true)
                }
            })
            
            finish?()
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
            
            try! realm.write({
                
                realm.delete(realm.objects(Focus.self))
                
                for res in result {
                    
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
    class func noFocusPub(pname:String,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(.DELETE, SwaggerClientAPI.basePath+"/ns/pbs/cocs", parameters: ["uid":"\(ShareLUser.uid)","nid":pname], encoding: ParameterEncoding.URLEncodedInURL, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let code = result.objectForKey("code") as? Int else{ fail?();return}
            
            if code != 2000 { fail?() ;return}
            
            self.refresh(finish, fail: fail)
        }
    }
}