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
    
    dynamic var nid = 1 /// 新闻ID
    dynamic var url = ""  /// 新闻Url
    dynamic var docid = "" /// 用于获取评论的 docid
    dynamic var title = "" /// 新闻标题
    dynamic var ptime = ""  /// 新闻事件
    dynamic var ptimes = NSDate()
    dynamic var pname = ""  /// 新闻来源
    dynamic var purl = "" /// 来源地址
    dynamic var channel = 0 /// 频道ID
    dynamic var collect = 0 /// 收藏数
    dynamic var concern = 0 /// 关心数
    dynamic var comment = 0 /// 评论数
    dynamic var style = 0 /// 列表图格式，0、1、2、3
    let imgsList = List<StringObject>() /// 图片具体数据
    
    
    dynamic var province = "" // 省
    dynamic var city = "" // 城市
    dynamic var district = "" // 区
    
    dynamic var isdelete = 0 // 区
    
    dynamic var isread = 0 // 是否阅读
    
    dynamic var ishotnew = 0 /// 是不是热点新闻
    dynamic var isidentification = 0 /// 是不是热点新闻
    
    override public static func primaryKey() -> String? {
        return "nid"
    }
}

extension New{

    func isRead(){
        
        let realm = try! Realm()
        
        try! realm.write {
            
            self.isread = 1
        }
    }
}