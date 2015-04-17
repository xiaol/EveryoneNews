//
//  AbsDatasource.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/17.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "AbsDatasource.h"

@implementation AbsDatasource

+(id)absDatasourceWithStr:(NSString *)absStr
{
    return [[AbsDatasource alloc] initWithStr:absStr];
}

- (id)initWithStr:(NSString *)absStr
{
    if (self = [super init]) {
        _absStr = absStr;
    }
    return self;
}

@end
