//
//  LPComment.h
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
//"sourceUrl": "http://laoyaoba.com/ss6/html/85/n-554185.html",
//"srcText": "真能扯，上市半年的手机还在抢，你还有脸扯加大供应量",
//"paragraphIndex": 0,
//"createTime": "2015-05-08 15:24:33",
//"userName": "上海市手机网友[打不过就din屋] ",
//"down": "0",
//"desText": "",
//"uuid": "",
//"up": "151",
//"comments_count": 8,
//"type": "text_paragraph",
//"userIcon": null
@interface LPComment : NSObject

@property (nonatomic, copy) NSString *sourceUrl;

@property (nonatomic, copy) NSString *srcText;

@property (nonatomic, copy) NSString *paragraphIndex;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *down;

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, copy) NSString *up;

@property (nonatomic, copy) NSString *comments_count;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *userIcon;

@property (nonatomic, copy) NSString *category;

- (NSMutableAttributedString *)commentStringWithCategory:(NSString *)category;

@end
