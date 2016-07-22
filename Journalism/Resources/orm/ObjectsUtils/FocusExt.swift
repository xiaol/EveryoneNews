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
    class func InsertNewFocus(info:NSDictionary){
    
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
    class func LoadNewListByPname(pname:String,times:NSTimeInterval=NSDate().dateByAddingHours(-3).timeIntervalSince1970*1000,finish:((nomore:Bool)->Void)?=nil,fail:(()->Void)?=nil){
        
        guard let token = ShareLUser.token else{ return }
        
        Manager.shareManager.request(.GET, SwaggerClientAPI.basePath+"/ns/pbs", parameters: ["uid":"\(ShareLUser.uid)","pname":pname,"info":"1","tcr":"\(Int64(times))","p":"1","c":"20"], encoding: ParameterEncoding.URLEncodedInURL, headers: ["Authorization":token,"X-Requested-With":"*"]).responseJSON { (res) in
            
            guard let rv = res.result.value as? NSDictionary,let rcode = rv.objectForKey("code") as? Int,data = rv.objectForKey("data") as? NSDictionary,result = data.objectForKey("news") as? NSArray,info = data.objectForKey("info") as? NSDictionary else{ fail?();return}
            
            self.InsertNewFocus(info)
            
            if result.count <= 0 {
            
                finish?(nomore:true)
                return
            }
            
            if rcode != 2000 {fail?();return}
            
            let realm = try! Realm()
            
            for new in result {
                
                guard let nid = new.objectForKey("nid") as? Int else{ break }
                
                let isExt = realm.objectForPrimaryKey(New.self, key: nid) != nil
                
                try! realm.write({
                    
                    realm.create(New.self, value: new, update: true)
                    
                    self.AnalysisPutTimeAndImageList(new as! NSDictionary, realm: realm)
                    
                    var value = ["nid":nid,"channel":-1994,"isFocusArray":1]
                    
                    if isExt { value = ["nid":nid,"isFocusArray":1] }
                    
                    realm.create(New.self, value: value, update: true)
                })
            }
            
            finish?(nomore:false)
        }
    }
}