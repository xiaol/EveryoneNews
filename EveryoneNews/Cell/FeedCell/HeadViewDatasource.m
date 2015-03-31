//
//  HeadViewDatasource.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/23.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "HeadViewDatasource.h"

@implementation HeadViewDatasource

+(id)headViewDatasourceWithDict:(NSDictionary *)dict
{
    return [[HeadViewDatasource alloc] initWithDict:dict];
}

-(id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        _imgStr = dict[@"imgUrl"];
        _sourceUrl = dict[@"sourceUrl"];
        _titleStr = dict[@"title"];
//        _otherNum = (int)dict[@"otherNum"];
        _subArr = dict[@"sublist"];
        
//        _sourceTitle = @"给这只汪的生日蛋糕~~~";     //sublist title
        _aspectStr = [NSString stringWithFormat:@"%@家观点", dict[@"otherNum"]];
//        _sourceName = @"凤凰网:";
        _responseUrls = dict[@"urls_response"];
        _updateTime = dict[@"updateTime"];
        _sourceSiteName = dict[@"sourceSiteName"];
    }
    return self;
}

@end
