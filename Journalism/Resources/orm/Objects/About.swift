//
//  About.swift
//  Journalism
//
//  Created by Mister on 16/6/6.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift

///  频道的数据模型
public class About: Object {
    
    dynamic var nid = 0 // 相关新闻地址
    dynamic var url = "" // 相关新闻地址
    dynamic var title = "" // 相关新闻标题
    dynamic var from = "" // 新闻来源
    dynamic var rank = 0 //点赞数
    dynamic var pname = "" // 用户是否能对该条评论点赞，0、1 对应 可点、不可点
    
    dynamic var ptime = "" // 评论正文
    dynamic var img:String? = nil  //创建时间
    dynamic var abs = "" //创建该评论的用户名
    
    dynamic var ptimes = NSDate() //创建时间
    
    override public static func primaryKey() -> String? {
        return "url"
    }
}