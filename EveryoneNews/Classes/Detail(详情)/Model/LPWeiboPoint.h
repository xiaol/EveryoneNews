//
//  LPWeiboPoint.h
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

//"sourceSitename": "weibo",
//"img": "",
//"title": "真能扯，上市半年的手机还在抢，你还有脸扯加大供应量",
//"url": "",
//"up": "151",
//"profileImageUrl": "",
//"down": "0",
//"isCommentFlag": 1,
//"user": "网易上海市手机网友[打不过就din屋] "
@interface LPWeiboPoint : NSObject
@property (nonatomic, copy) NSString *sourceSitename;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *up;

@property (nonatomic, copy) NSString *profileImageUrl;

@property (nonatomic, copy) NSString *down;

@property (nonatomic, copy) NSString *isCommentFlag;

@property (nonatomic, copy) NSString *user;
@end
