//
//  HotSearch.swift
//  Journalism
//
//  Created by Mister on 16/6/30.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift

///  频道的数据模型
class HotSearchs: Object {
    dynamic var title = "" //
    dynamic var createTime = ""
    
    
    dynamic var createTimes = Date()
    
    override static func primaryKey() -> String? {
        return "title"
    }
}


extension HotSearchs{

    class func getList() -> Results<HotSearchs>{
        
        let realm = try! Realm()
        
        return realm.objects(HotSearchs.self).sorted(byProperty: "createTimes", ascending: false)
    }
}
