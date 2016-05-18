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
    class func RefreshChannleObjects(finish:(()->Void)?){
        let realm = try! Realm()
        ChannelsAPI.channelsGet(online: nil) { (data, error) in
            if let _ = error {return}
            if let code = data?.objectForKey("code") as? Int {
                if code != 0 {return}
                if let data = data?.objectForKey("data") as? NSArray {
                    for channel in data {
                        try! realm.write({
                            realm.create(Channel.self, value: channel, update: true)
                        })
                        
                    }
//                    let channles = realm.objects(Channel).sorted("orderindex", ascending: true).filter("isdelete == 0")
                    finish?()
                }
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
    
}
