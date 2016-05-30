//
//  NewContent.swift
//  Journalism
//
//  Created by Mister on 16/5/30.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift


///  频道的数据模型
public class Content: Object {

    /// 用于获取评论的 docid
    dynamic var txt: String? = nil

    /// 新闻Url
    dynamic var img: String? = nil

    /// 新闻标题
    dynamic var vid: String? = nil

}



///  频道的数据模型
public class NewContent: Object {
    /// 新闻ID
    dynamic var nid = 1
    /// 用于获取评论的 docid
    dynamic var docid = ""
    /// 新闻Url
    dynamic var url = ""
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
    /// 正文图片数量
    dynamic var inum = 0
    
    /// 新闻标题
    dynamic var descr = ""

    
    /// 列表图格式，0、1、2、3
    dynamic var style = 0
    
    /// 图片具体数据
    let tagsList = List<StringObject>() // Should be declared with `let`
    let content = List<Content>() // Should be declared with `let`
    
    /// 收藏数
    dynamic var collect = 0
    /// 关心数
    dynamic var concern = 0
    /// 评论数
    dynamic var comment = 0
    
    override public static func primaryKey() -> String? {
        return "nid"
    }
    
}