//
//  New.swift
//  Journalism
//
//  Created by Mister on 16/5/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift
import ObjectMapper


public class StringObject: Object {
    dynamic var value = ""
}


///  频道的数据模型
public class New: Object {
    
    dynamic var pubName = ""
    dynamic var imgStyle = 0
    dynamic var city = ""
    dynamic var docid = ""
    dynamic var pubTimes = NSDate()
    dynamic var title = ""
    dynamic var url = ""
    dynamic var pubUrl = ""
    dynamic var province = ""
    dynamic var commentsCount = 0
    dynamic var district = ""
    dynamic var channelId = 0
    let imgLists = List<StringObject>() // Should be declared with `let`
    
    override public static func primaryKey() -> String? {
        return "docid"
    }
    
}