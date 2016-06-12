//
//  Comment.swift
//  Journalism
//
//  Created by Mister on 16/6/1.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift

///  频道的数据模型
public class Comment: Object {
    
    dynamic var id = 1 // 新闻评论ID
    dynamic var nid = 1 // 新闻ID
    dynamic var uid = 1 // 创建该评论的用户ID
    dynamic var commend = 0 //点赞数
    dynamic var upflag = 0 // 用户是否能对该条评论点赞，0、1 对应 可点、不可点
    
    dynamic var content = "" // 评论正文
    dynamic var ctime = "" //创建时间
    dynamic var uname = "" //创建该评论的用户名
    dynamic var avatar = "" // 新闻标题
    dynamic var docid = "" // 该评论对应的新闻 docid
    
    dynamic var ishot = 0
    
    dynamic var ctimes = NSDate() //创建时间
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}