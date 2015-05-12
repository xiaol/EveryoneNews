//
//  BigImgDatasource.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/21.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "BigImgDatasource.h"

@implementation BigImgDatasource

+ (id)bigImgDatasourceWithDict:(NSDictionary *)dict
{
    return [[BigImgDatasource alloc] initWithDict:dict];
}

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
//        _categoryStr = dict[@"category"];
//        _titleStr = dict[@"title"];
//        _imgStr = dict[@"imgUrl"];
        
        _imgStr = dict[@"imgUrl"];
        _sourceUrl = dict[@"sourceUrl"];
        _titleStr = dict[@"title"];
//        _subArr = dict[@"sublist"];
        
//        _aspectStr = [NSString stringWithFormat:@"%@家观点", dict[@"otherNum"]];
        _responseUrls = dict[@"urls_response"];
        _updateTime = dict[@"updateTime"];
        _sourceSiteName = dict[@"sourceSiteName"];
        _rootClass = dict[@"root_class"];
        _categoryStr = dict[@"category"];
        _isTop = @"no";

    }
    return self;
}

@end
