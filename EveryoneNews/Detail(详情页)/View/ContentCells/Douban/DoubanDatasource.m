//
//  DoubanDatasource.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "DoubanDatasource.h"

@implementation DoubanDatasource

+ (id)doubanDatasourceWithArr:(NSArray *)array
{
    return [[DoubanDatasource alloc] initWithArray:array];
}

- (id)initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        _tagArr = array;
    }
    return self;
}

@end
