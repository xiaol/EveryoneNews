//
//  Channel.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift

///  频道的数据模型
class Channel: Object {
    dynamic var id = 0 //
    dynamic var cname = ""
    dynamic var state = 0
    
    dynamic var orderindex = 100
    dynamic var isdelete = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
