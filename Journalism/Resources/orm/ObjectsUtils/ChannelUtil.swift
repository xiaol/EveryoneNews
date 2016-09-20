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
    class func RefreshChannleObjects(_ finish:(()->Void)?=nil,fail:(()->Void)?=nil){
        let realm = try! Realm()
        ChannelAPI.nsChsGet(s: nil) { (data, error) in
            if let _ = error {fail?(); return }
            
            if let code = data?.object(forKey: "code") as? Int {
                if code != 2000 {fail?();return}
                if let data = data?.object(forKey: "data") as? NSArray {
                    
                    let incount = realm.objects(Channel.self).count <= 0
                    
                    try! realm.write({
                        for channel in data {
                            realm.create(Channel.self, value: channel, update: true)
                        }
                    })
                    
                    try! realm.write({
                        realm.objects(Channel.self).filter("cname = '奇点'").setValue(0, forKey: "orderindex")
                        
                        if incount {
                            realm.objects(Channel.self).filter("cname = '科技'").setValue(1, forKey: "orderindex")
                            realm.objects(Channel.self).filter("cname = '外媒'").setValue(2, forKey: "orderindex")
                            realm.objects(Channel.self).filter("cname = '点集'").setValue(3, forKey: "orderindex")
                            realm.create(Channel.self, value: ["id":1994,"cname":"关注","state":0,"orderindex":4,"isdelete":0], update: true)
                            
                            realm.objects(Channel.self).filter("cname = '美文'").setValue(1, forKey: "isdelete")
                            realm.objects(Channel.self).filter("cname = '趣图'").setValue(1, forKey: "isdelete")
                            realm.objects(Channel.self).filter("cname = '奇闻'").setValue(1, forKey: "isdelete")
                            realm.objects(Channel.self).filter("cname = '萌宠'").setValue(1, forKey: "isdelete")
                            realm.objects(Channel.self).filter("cname = '自媒体'").setValue(1, forKey: "isdelete")
                            realm.objects(Channel.self).filter("cname = '科学'").setValue(1, forKey: "isdelete")
                            realm.objects(Channel.self).filter("cname = '养生'").setValue(1, forKey: "isdelete")
                            realm.objects(Channel.self).filter("cname = '股票'").setValue(1, forKey: "isdelete")
                        }
                        
                        if let del = realm.objects(Channel.self).filter("cname = '美女'").first {
                        
                            realm.delete(del)
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
        let channles = realm.objects(Channel.self).sorted(byProperty: "orderindex", ascending: true)
        return channles
    }
    
    class func ChannelUpdate(_ id:Int,isdelete:Int,orderIndex:Int){
        let realm = try! Realm()
        
        try! realm.write({
            realm.create(Channel.self, value: ["id":id,"orderindex":orderIndex,"isdelete":isdelete], update: true)
        })
    }
    
}


extension Channel {
    
    /**
     获取正常的频道列表数据
     
     - returns: 正常的频道列表数据
     */
    public class func NormalChannelArray() -> Results<Channel> {
        
        return self.ChannelArray(filters: NSPredicate(format: "isdelete = 0"))
    }
    
    /**
     获取正常的频道列表数据
     
     - returns: 正常的频道列表数据
     */
    public class func DeletedChannelArray() -> Results<Channel> {
        
        return self.ChannelArray(filters: NSPredicate(format: "isdelete = 1"))
    }
    
    /**
     修改 频道的 排序 属性
     
     - parameter orderindex: 要改变成为的 排序 顺序
     */
    public func ChangeOrderIndex(orderindex:Int){
        let realm = try! Realm()
        try! realm.write { self.orderindex = orderindex }
    }
    
    /**
     根据提供的筛选条件进行数据的获取
     
     - parameter filters: 筛选条件
     
     - returns: 返回 数据
     */
    private class func ChannelArray(filters:NSPredicate...) -> Results<Channel>{
        let realm = try! Realm()
        var results = realm.objects(Channel.self).sorted(byProperty: "orderindex")
        for filter in filters { results =  results.filter(filter) }
        return results
    }
}

