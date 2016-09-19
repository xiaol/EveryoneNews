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

class Manager{

    static var shareManager:SessionManager{
        
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }
}

class CustomRequest: NSObject {
    /**
     点赞
     
     - parameter comment: 评论对象
     - parameter finish:  点赞完成
     - parameter fail:    点赞失败
     */
    class func praiseComment(_ comment:Comment,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(SwaggerClientAPI.basePath + "/ns/coms/up", method: .post, parameters: ["uid":"\(ShareLUser.uid)","cid":"\(comment.id)"], encoding: URLEncoding.default, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let data = result.object(forKey: "data") as? Int else{ fail?();return}
            
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
    class func nopraiseComment(_ comment:Comment,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(SwaggerClientAPI.basePath+"/ns/coms/up", method : HTTPMethod.delete, parameters: ["uid":"\(ShareLUser.uid)","cid":"\(comment.id)"], encoding: URLEncoding.default, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let data = result.object(forKey: "data") as? Int else{ fail?();return}
            
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
     
     - parameter new: 新闻对象
     - parameter finish:  点赞完成
     - parameter fail:    点赞失败
     */
    class func collectedNew(_ new:New,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(SwaggerClientAPI.basePath+"/ns/cols",method: .post , parameters: ["uid":"\(ShareLUser.uid)","nid":"\(new.nid)"], encoding: URLEncoding.default, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let code = result.object(forKey: "code") as? Int else{ fail?();return}
            
            if code != 2000 { fail?() ;return}
            
            
            let realm = try! Realm()
            
            try! realm.write({
                
                new.iscollected = 1
            })
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: COLLECTEDNEWORNOCOLLECTEDNEW), object: nil)
            
            finish?()
        }
    }
    
    /**
     取消收藏新闻
     
     - parameter new: 新闻对象
     - parameter finish:  点赞完成
     - parameter fail:    点赞失败
     */
    class func nocollectedNew(_ new:New,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(SwaggerClientAPI.basePath+"/ns/cols",method:.delete , parameters: ["uid":"\(ShareLUser.uid)","nid":"\(new.nid)"], encoding:  URLEncoding.default, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let code = result.object(forKey: "code") as? Int else{ fail?();return}
            
            if code != 2000 { fail?() ;return}
            
            let realm = try! Realm()
            
            try! realm.write({
                
                new.iscollected = 0
            })
            
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: COLLECTEDNEWORNOCOLLECTEDNEW), object: nil)
            
            finish?()
        }
    }
    
    /**
     关心新闻
     
     - parameter new: 新闻对象
     - parameter finish:  关心完成
     - parameter fail:    关心失败
     */
    class func concernedNew(_ new:New,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(SwaggerClientAPI.basePath+"/ns/cocs",method:.post , parameters: ["uid":"\(ShareLUser.uid)","nid":"\(new.nid)"], encoding: URLEncoding.default, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let code = result.object(forKey: "code") as? Int,let data = result.object(forKey: "data") as? Int else{ fail?();return}
            
            if code != 2000 { fail?() ;return}
            
            
            let realm = try! Realm()
            
            try! realm.write({
                
                new.isconcerned = 1
                new.concern = data
            })
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: CONCERNNEWORNOCOLLECTEDNEW), object: nil)
            
            finish?()
        }
    }
    
    /**
     取消关心新闻
     
     - parameter new: 新闻对象
     - parameter finish:  关心完成
     - parameter fail:    关心失败
     */
    class func noconcernedNew(_ new:New,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(SwaggerClientAPI.basePath+"/ns/cocs",method:.delete , parameters: ["uid":"\(ShareLUser.uid)","nid":"\(new.nid)"], encoding: URLEncoding.default, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let code = result.object(forKey: "code") as? Int,let data = result.object(forKey: "data") as? Int else{ fail?();return}
            
            if code != 2000 { fail?() ;return}
            
            let realm = try! Realm()
            
            try! realm.write({
                
                new.isconcerned = 0
                new.concern = data
            })
            
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: CONCERNNEWORNOCOLLECTEDNEW), object: nil)
            
            finish?()
        }
    }
    
    /**
     评论新闻
     
     - parameter content: 评论内容
     - parameter finish:  点赞完成
     - parameter fail:    点赞失败
     */
    class func commentNew(_ content:String,new:New,finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        
        
        guard let token = ShareLUser.token else{ return }
        
        let time = Date()
        let timeStr = time.toString(DateFormat.custom("yyyy-MM-dd hh:mm:ss"))
        let cc = CommectCreate()
        cc.content = content
        cc.docid = new.docid
        cc.ctime = timeStr
        cc.commend = 0
        cc.uid = Int32(ShareLUser.uid)
        cc.uname = ShareLUser.uname
        cc.avatar = ShareLUser.avatar
        
        let requestBudile = CommentAPI.nsComsPostWithRequestBuilder(userRegisterInfo: cc)
        
        Manager.shareManager.request(SwaggerClientAPI.basePath+"/ns/coms", method: .post , parameters: requestBudile.parameters, encoding: JSONEncoding.default, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let result = res.result.value as? NSDictionary,let code = result.object(forKey: "code") as? Int else{ fail?();return}
            
            if code != 2000 { fail?() ;return}
            
            guard let id = result.object(forKey: "data") as? Int else{fail?() ;return}
            
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
     
     - parameter finish:  点赞完成
     - parameter fail:    点赞失败
     */
    class func HotSearch(_ finish:(()->Void)?=nil,fail:(()->Void)?=nil){

        Manager.shareManager.request("http://121.40.34.56/news/baijia/fetchElementary", method: .post ).responseJSON { (res) in
            
            guard let result = res.result.value as? NSArray else{ fail?();return}
            
            let realm = try! Realm()
            
            try! realm.write({
            
                realm.delete(realm.objects(HotSearchs.self))
                
                for hotSearch in result {
                    
                    realm.create(HotSearchs.self, value: hotSearch, update: true)
                    
                    if let title = (hotSearch as AnyObject).object(forKey: "title") as? String,let pubTime = (hotSearch as AnyObject).object(forKey: "createTime") as? String{
                    
                        let date = Date(fromString: pubTime, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"))
                        
                        realm.create(HotSearchs.self, value: ["title":title,"createTimes":date], update: true)
                    }
                }
            })
            
            finish?()
        }
    }
    
    
    
}
