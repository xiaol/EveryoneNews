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
        
        _sourceUrl = dict[@"sourceUrl"];
        _titleStr = dict[@"title"];
        _subArr = dict[@"sublist"];
        
        _aspectStr = [NSString stringWithFormat:@"%@家观点", dict[@"otherNum"]];
        _responseUrls = dict[@"urls_response"];
        _updateTime = dict[@"updateTime"];
        _sourceSiteName = dict[@"sourceSiteName"];
        _rootClass = dict[@"root_class"];
        _categoryStr = dict[@"category"];
        _specialStr = [NSString stringWithFormat:@"1%@", dict[@"special"]];
        if ([_specialStr isEqualToString:@"19"]) {
            _imgArr = dict[@"imgUrl_ex"];
            _imgStr = _imgArr[0];
        } else {
            _imgStr = dict[@"imgUrl"];
        }
        
        
//        NSLog(@"imgStr:%@ \n       sourceUrl:%@ \n      titleStr:%@ \n", _imgStr, _sourceUrl, _titleStr);
//        NSLog(@"subArr:%@", _subArr);
//        NSLog(@"aspectStr:%@\n      responseUrls:%@", _aspectStr, _responseUrls);
//        NSLog(@"updateTime:%@\n     sourceSiteName:%@\n", _updateTime, _sourceSiteName);
//        NSLog(@"rootClass:%@", _rootClass);
    }
    return self;
}

@end
