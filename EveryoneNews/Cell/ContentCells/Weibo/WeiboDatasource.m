//
//  WeiboDatasource.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "WeiboDatasource.h"

@implementation WeiboDatasource

+ (id)weiboDatasourceWithArr:(NSArray *)array
{
    return [[WeiboDatasource alloc] initWithArr:array];
}

- (id)initWithArr:(NSArray *)array
{
    if (self = [super init]) {
//        _url = dict[@"url"];
//        _sourceSitename = dict[@"sourceSitename"];
//        _user = dict[@"user"];
//        _title = dict[@"title"];
        _weiboArr = array;
    }
    return self;
}

@end
