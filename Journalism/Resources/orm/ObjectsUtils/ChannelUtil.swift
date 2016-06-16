//
//  ChannelUtil.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift
import SwaggerClient

class ChannelUtil: NSObject {
    
    /**
     请求 频道 列表
     
     - parameter finish: 完成回调方法
     */
    class func RefreshChannleObjects(finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        let realm = try! Realm()
        ChannelAPI.nsChsGet(s: nil) { (data, error) in
            if let _ = error {fail?(); return }
            if let code = data?.objectForKey("code") as? Int {
                if code != 2000 {fail?();return}
                if let data = data?.objectForKey("data") as? NSArray {
                    
                    let incount = realm.objects(Channel).count <= 0
                    
                    try! realm.write({
                        for channel in data {
                            realm.create(Channel.self, value: channel, update: true)
                        }
                    })
                    
                    try! realm.write({
                        realm.objects(Channel).filter("cname = '奇点'").setValue(0, forKey: "orderindex")
                        
                        if incount {
                            realm.objects(Channel).filter("cname = '科技'").setValue(1, forKey: "orderindex")
                            realm.objects(Channel).filter("cname = '外媒'").setValue(2, forKey: "orderindex")
                            realm.objects(Channel).filter("cname = '点集'").setValue(3, forKey: "orderindex")
                        }
                    })
                    finish?()
                }else{fail?();return}
            }
        }
    }
    
    /**
    获取频道列表
     
     - returns: 所有的额频道方式
     */
    class func GetChannelRealmObjects() -> Results<Channel>{
        let realm = try! Realm()
        let channles = realm.objects(Channel).sorted("orderindex", ascending: true)
        return channles
    }
    
    class func ChannelUpdate(id:Int,isdelete:Int,orderIndex:Int){
        let realm = try! Realm()
        
        try! realm.write({
            realm.create(Channel.self, value: ["id":id,"orderindex":orderIndex,"isdelete":isdelete], update: true)
        })
    }
    
}
