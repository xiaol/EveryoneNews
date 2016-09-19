//
//  FocusExt.swift
//  Journalism
//
//  Created by Mister on 16/7/22.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import Alamofire
import RealmSwift
import AFDateHelper
import SwaggerClient

extension Focus{

    /**
     根据Info 信息
     
     - parameter info: 信息对象
     */
    class func InsertNewFocus(_ info:NSDictionary){
    
        let realm = try! Realm()
        
        try! realm.write({
            
            realm.create(Focus.self, value: info, update: true)
        })
    }
    
    /**
     获取关注列表下的新闻
     
     - parameter finish: 完成
     - parameter fail:   失败
     */
    class func LoadNewListByPname(_ pname:String,times:TimeInterval=Date().dateByAddingHours(-3).timeIntervalSince1970*1000,finish:((_ nomore:Bool)->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request( SwaggerClientAPI.basePath+"/ns/pbs",method:.get, parameters: ["uid":"\(ShareLUser.uid)","pname":pname,"info":"1","tcr":"\(Int64(times))","p":"1","c":"20"], encoding: URLEncoding.default, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let rv = res.result.value as? NSDictionary,let rcode = rv.object(forKey: "code") as? Int,let data = rv.object(forKey: "data") as? NSDictionary,let result = data.object(forKey: "news") as? NSArray,let info = data.object(forKey: "info") as? NSDictionary else{ fail?();return}
            
            self.InsertNewFocus(info)
            
            if result.count <= 0 {
            
                finish?(true)
                return
            }
            
            if rcode != 2000 {fail?();return}
            
            let realm = try! Realm()
            
            for new in result {
                
                guard let nid = (new as AnyObject).object(forKey: "nid") as? Int else{ break }
                
                let isExt = realm.object(ofType: New.self, forPrimaryKey: nid as AnyObject) != nil
                
                try! realm.write({
                    
                    realm.create(New.self, value: new, update: true)
                    
                    self.AnalysisPutTimeAndImageList(new as! NSDictionary, realm: realm)
                    
                    var value = ["nid":nid,"channel":-1994,"isFocusArray":1]
                    
                    if isExt { value = ["nid":nid,"isFocusArray":1] }
                    
                    realm.create(New.self, value: value, update: true)
                })
            }
            
            finish?(false)
        }
    }
}
