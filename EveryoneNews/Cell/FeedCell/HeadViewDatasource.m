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
        _imgStr = @"http://ww3.sinaimg.cn/mw1024/686da053gw1eqfpk11zmzj20go0ci3zj.jpg";
        _titleStr = @"一个人吃饭的时候会感到孤单，但一个人吃零食的时候就不会！";
        _sourceTitle = @"给这只汪的生日蛋糕~~~";
        _aspectStr = @"还有3244个看点";
        _sourceName = @"凤凰网:";
    }
    return self;
}

@end
