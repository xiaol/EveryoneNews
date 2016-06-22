//
//  RequestCustomClass.swift
//  Journalism
//
//  Created by Mister on 16/6/20.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import Alamofire
import RealmSwift
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
}