//
//  ZhihuDatasource.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhihuDatasource : NSObject

@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;

+ (id)zhihuWithDict:(NSDictionary *)dict;

@end
