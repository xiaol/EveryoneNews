//
//  Relate.m
//  EveryoneNews
//
//  Created by apple on 15/5/20.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "Relate.h"

@implementation Relate

+ (instancetype)relateWithDict:(NSDictionary *)dict
{
    return [[Relate alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
       // [self setValuesForKeysWithDictionary:dict];
        _url = dict[@"url"];
        _sourceSitename = dict[@"sourceSitename"];
        _img = dict[@"img"];
        _title = dict[@"title"];
        _height = dict[@"height"];
        _width = dict[@"width"];
    }
    return self;
}

@end
