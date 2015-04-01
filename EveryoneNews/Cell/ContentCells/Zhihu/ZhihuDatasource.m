//
//  ZhihuDatasource.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "ZhihuDatasource.h"

@implementation ZhihuDatasource

+ (id)zhihuWithDict:(NSDictionary *)dict
{
    return [[ZhihuDatasource alloc] initWithDict:dict];
}

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        _url = dict[@"url"];
        _user = dict[@"user"];
        _title = dict[@"title"];
        
    }
    return self;
}

@end
