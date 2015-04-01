//
//  BaiduDatasource.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/31.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "BaiduDatasource.h"

@implementation BaiduDatasource

+ (id)baiduDatasourceWithDict:(NSDictionary *)dict
{
    return [[BaiduDatasource alloc] initWithDict:dict];
}

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        _url = dict[@"url"];
        _abstract = dict[@"abstract"];
        _title = dict[@"title"];
        
    }
    return self;
}

@end
