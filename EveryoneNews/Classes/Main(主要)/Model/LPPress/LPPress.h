//
//  LPPress.h
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LPConcern;
//{
//    "originsourceSiteName": "网易新闻图片",
//    "updateTime": "2015-05-14 20:53:41",
//    "sourceSiteName": "网易国际新闻",
//    "sublist": [
//    {
//        "sourceSitename": "weibo",
//        "img": null,
//        "title": "8岁大的俄罗斯小萝莉和他老爸练习拳击,气场强大,行云流水,太帅气了![赞] ",
//        "url": "http://m.weibo.cn/2365961811/ChNQU2rAS?wm=5091_0010&from=ba_s0010",
//        "profileImageUrl": "",
//        "user": "皓伦王明川"
//    },
//    {
//        "url": "http://www.zhihu.com/question/26940413",
//        "sourceSitename": "zhihu",
//        "user": "熊斌",
//        "title": "美国对俄罗斯的一系列制裁会对俄罗斯造成什么影响？如果你是普京政府将采取什么有效措施？"
//    }
//                ],
//    "tag": [
//            "俄罗斯",
//            "化学家"
//            ],
//    "urls_response": [ ],
//    "category": "国际",
//    "special": 1,
//    "eventId": "http://news.hexun.com/2015-05-14/175821675.html?from=rss",
//    "title": "化学家拍摄彩色照片记录百年前的俄罗斯",
//    "ne": {
//        "time": [ ],
//        "gpe": [
//                "俄罗斯"
//                ],
//        "person": [ ],
//        "loc": [ ],
//        "org": [ ]
//    },
//    "otherNum": 1,
//    "isOnline": 1,
//    "channel": "国际",
//    "sourceUrl": "http://news.163.com/photoview/00AO0001/90303.html",
//    "description": "俄罗斯化学师Sergey Prokudin-Grosky曾是20世纪初期彩色照片摄影的先锋，他用彩色摄影记录下1909年-1915年的俄国。IC供图 谢绝转载",
//    "createTime": "2015-05-14 19:40:07",
//    "root_class": "40度",
//    "imgUrl": "http://img3.cache.netease.com/photo/0001/2015-05-14/APJQDG9700AO0001.jpg",
//    "_id": "http://news.163.com/photoview/00AO0001/90303.html"
//},

@interface LPPress : NSObject
/**
 *  cell类型 （1：大图；400：单图图文；9：多图图文; 1000：时间栏）
 */
@property (nonatomic, copy) NSString *special;

/**
 *  图片
 */
@property (nonatomic, copy) NSString *imgUrl;

/**
 *  多图
 */
@property (nonatomic, strong) NSArray *imgUrl_ex;

/**
 *  新闻类别 （国际，体育等）
 */
@property (nonatomic, copy) NSString *category;

/**
 *  新闻标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  几家观点
 */
@property (nonatomic, copy) NSString *otherNum;

/**
 *  观点列表
 */
@property (nonatomic, strong) NSArray *sublist;

/**
 *  以下传递给详情页
 */
@property (nonatomic, copy) NSString *sourceUrl;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *sourceSiteName;
@property (nonatomic, copy) NSString *root_class;
@property (nonatomic, copy) NSString *isCommentsFlag;
@property (nonatomic, copy) NSString *isWeiboFlag;
@property (nonatomic, copy) NSString *isZhihuFlag;
@property (nonatomic, copy) NSString *isBaikeFlag;
@property (nonatomic, copy) NSString *isImgWallFlag;

@property (nonatomic, strong) LPConcern *concern;

- (NSMutableAttributedString *)titleString;

- (NSString *)redefineCategory;

@end
