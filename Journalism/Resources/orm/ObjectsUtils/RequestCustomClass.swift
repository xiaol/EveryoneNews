//
//  RequestCustomClass.swift
//  Journalism
//
//  Created by Mister on 16/6/20.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import Alamofire
import RealmSwift
import AFDateHelper
import SwaggerClient

extension Manager{
    
    class var shareManager:Manager!{
        get{
            struct backTaskLeton{
                static var predicate:dispatch_once_t = 0
                static var manager:Manager? = nil
            }
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                configuration.HTTPShouldSetCookies = false
                configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
                backTaskLeton.manager = Manager(configuration: configuration, delegate: Manager.SessionDelegate(), serverTrustPolicyManager: nil)
            })
            return backTaskLeton.manager!
        }
    }
}

class CustomRequest: NSObject {
    /**
     点赞
     
     - parameter comment: 评论对象
     - parameter finish:  点赞完成
     - parameter fail:    点赞失败
     */
    class func praiseComment(comment:Comment,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(.POST, SwaggerClientAPI.basePath+"/ns/coms/up", parameters: ["uid":"\(ShareLUser.uid)","cid":"\(comment.id)"], encoding: ParameterEncoding.URLEncodedInURL, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let data = result.objectForKey("data") as? Int else{ fail?();return}
            
            let realm = try! Realm()
            
            try! realm.write({
                comment.upflag = 1
                comment.commend = data
            })
            
            finish?()
        }
    }
    
    /**
     取消点赞
     
     - parameter comment: 评论对象
     - parameter finish:  点赞完成
     - parameter fail:    点赞失败
     */
    class func nopraiseComment(comment:Comment,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(.DELETE, SwaggerClientAPI.basePath+"/ns/coms/up", parameters: ["uid":"\(ShareLUser.uid)","cid":"\(comment.id)"], encoding: ParameterEncoding.URLEncodedInURL, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let data = result.objectForKey("data") as? Int else{ fail?();return}
            
            let realm = try! Realm()
            
            try! realm.write({
                comment.upflag = 0
                comment.commend = data
            })
            
            finish?()
        }
    }
    
    
    /**
     收藏新闻
     
     - parameter comment: 评论对象
     - parameter finish:  点赞完成
     - parameter fail:    点赞失败
     */
    class func collectedNew(new:New,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(.POST, SwaggerClientAPI.basePath+"/ns/cols", parameters: ["uid":"\(ShareLUser.uid)","nid":"\(new.nid)"], encoding: ParameterEncoding.URLEncodedInURL, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let code = result.objectForKey("code") as? Int else{ fail?();return}
            
            if code != 2000 { fail?() ;return}
            
            NSNotificationCenter.defaultCenter().postNotificationName(COLLECTEDNEWORNOCOLLECTEDNEW, object: nil)
            
            let realm = try! Realm()
            
            try! realm.write({
                
            })
            
            finish?()
        }
    }
    
    /**
     取消收藏新闻
     
     - parameter comment: 评论对象
     - parameter finish:  点赞完成
     - parameter fail:    点赞失败
     */
    class func nocollectedNew(new:New,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(.DELETE, SwaggerClientAPI.basePath+"/ns/cols", parameters: ["uid":"\(ShareLUser.uid)","nid":"\(new.nid)"], encoding: ParameterEncoding.URLEncodedInURL, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let code = result.objectForKey("code") as? Int else{ fail?();return}
            
            if code != 2000 { fail?() ;return}
            
            
            NSNotificationCenter.defaultCenter().postNotificationName(COLLECTEDNEWORNOCOLLECTEDNEW, object: nil)
            
//            let realm = try! Realm()
//            
//            try! realm.write({
//                
//            })
            
            finish?()
        }
    }
    
    /**
     评论新闻
     
     - parameter comment: 评论对象
     - parameter finish:  点赞完成
     - parameter fail:    点赞失败
     */
    class func commentNew(content:String,new:New,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        
        guard let token = ShareLUser.token else{ return }
        
        let time = NSDate()
        let timeStr = time.toString(format: DateFormat.Custom("yyyy-MM-dd hh:mm:ss"))
        let cc = CommectCreate()
        cc.content = content
        cc.docid = new.docid
        cc.ctime = timeStr
        cc.commend = 0
        cc.uid = Int32(ShareLUser.uid)
        cc.uname = ShareLUser.uname
        cc.avatar = ShareLUser.avatar
        
        let requestBudile = CommentAPI.nsComsPostWithRequestBuilder(userRegisterInfo: cc)
        
        Manager.shareManager.request(.POST, SwaggerClientAPI.basePath+"/ns/coms", parameters: requestBudile.parameters, encoding: ParameterEncoding.JSON, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let code = result.objectForKey("code") as? Int else{ fail?();return}
            
            if code != 2000 { fail?() ;return}
            
            guard let id = result.objectForKey("data") as? Int else{fail?() ;return}
            
            let comment = Comment()
            comment.id = Int(id)
            comment.nid = new.nid
            comment.uid = ShareLUser.uid
            comment.ctime = timeStr
            comment.content = content
            comment.uname = ShareLUser.uname
            comment.avatar = ShareLUser.avatar
            comment.docid = new.docid
            comment.ctimes = time
            
            let realm = try! Realm()
            try! realm.write({
                
                new.comment += 1
                realm.add(comment)
            })
            
            finish?()
        }
    }
    
    /**
     获取热点搜索接口
     
     - parameter comment: 评论对象
     - parameter finish:  点赞完成
     - parameter fail:    点赞失败
     */
    class func HotSearch(finish:(()->Void)?=nil,fail:(()->Void)?=nil){

        Manager.shareManager.request(.POST, "http://121.40.34.56/news/baijia/fetchElementary").responseJSON { (res) in
            
            guard let result = res.result.value as? NSArray else{ fail?();return}
            
            let realm = try! Realm()
            
            try! realm.write({
            
                realm.delete(realm.objects(HotSearchs))
                
                for hotSearch in result {
                    
                    realm.create(HotSearchs.self, value: hotSearch, update: true)
                    
                    if let title = hotSearch.objectForKey("title") as? String,let pubTime = hotSearch.objectForKey("createTime") as? String{
                    
                        let date = NSDate(fromString: pubTime, format: DateFormat.Custom("yyyy-MM-dd HH:mm:ss"))
                        
                        realm.create(HotSearchs.self, value: ["title":title,"createTimes":date], update: true)
                    }
                }
            })
            
            finish?()
        }
    }
}