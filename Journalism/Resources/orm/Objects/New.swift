//
//  New.swift
//  Journalism
//
//  Created by Mister on 16/5/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift


public class StringObject: Object {
    dynamic var value = ""
}


///  频道的数据模型
public class New: Object {
    /// 新闻ID
    dynamic var nid = 1
    /// 新闻Url
    dynamic var url = ""
    /// 用于获取评论的 docid
    dynamic var docid = ""
    /// 新闻标题
    dynamic var title = ""
    
    
    /// 新闻事件
    dynamic var ptime = ""
    dynamic var ptimes = NSDate()
    
    /// 新闻来源
    dynamic var pname = ""
    
    /// 来源地址
    dynamic var purl = ""
    
    /// 频道ID
    dynamic var channel = 0
    
    /// 收藏数
    dynamic var collect = 0
    /// 关心数
    dynamic var concern = 0
    /// 评论数
    dynamic var comment = 0
    
    /// 列表图格式，0、1、2、3
    dynamic var style = 0
    
    /// 图片具体数据
    let imgsList = List<StringObject>() // Should be declared with `let`
    
    dynamic var province = "" // 省
    dynamic var city = "" // 城市
    dynamic var district = "" // 区
    
    dynamic var isdelete = 0 // 区
    
    
    override public static func primaryKey() -> String? {
        return "nid"
    }
    
}