//
//  LPConcernPress.h
//  EveryoneNews
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

//"sourceSiteName": "新浪新闻-体育",
//"updateTime": "2015-07-19 05:22",
//"imgnum": 1,
//"isCommentsFlag": 0,
//"create_time": "2015-07-19 05:30:21",
//"start_title": "新浪新闻-体育",
//"id": "55aac56d786cae106fd0425a",
//"category": "新闻",
//"title": "阿森纳魔法师5万人膜拜",
//"source": "sina",
//"imgUrl": "http://www.sinaimg.cn/ty/g/pl/2015-07-19/U7881P6T12D7658050F44DT20150719052216.jpg",
//"isWeiboFlag": 0,
//"update_time": "2015-07-19 05:22",
//"sourceUrl": "http://sports.sina.cn/premierleague/arsenal/2015-07-19/detail-ifxfaswf7672328.d.html?vt=4&pos=10",
//"tags": "阿森纳,魔法师,卡索拉",
//"source_url": "http://sports.sina.cn/premierleague/arsenal/2015-07-19/detail-ifxfaswf7672328.d.html?vt=4&pos=10",
//"isImgWallFlag": 0,
//"isZhihuFlag": 0,
//"url": "http://sports.sina.cn/premierleague/arsenal/2015-07-19/detail-ifxfaswf7672328.d.html?vt=4&pos=10",
//"author": "",
//"isBaikeFlag": 0,
//"channel_id": "6",
//"channel": "直男常备",
//"start_url": "http://sports.sina.cn/?vt=4&pos=108"

@interface LPConcernPress : NSObject
@property (nonatomic, copy) NSString *sourceSiteName;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sourceUrl;
@property (nonatomic, copy) NSString *channel_id;
@property (nonatomic, assign) int isImgWallFlag;
@property (nonatomic, assign) int isZhihuFlag;
@property (nonatomic, assign) int isWeiboFlag;
@property (nonatomic, assign) int isBaikeFlag;
@property (nonatomic, copy) NSString *pressID;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, assign) int isCommentsFlag;
@property (nonatomic, assign) int imgnum;

@end
