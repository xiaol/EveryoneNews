//
//  NSArray+isEmpty.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/5/18.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "NSArray+isEmpty.h"

@implementation NSArray (isEmpty)

+(BOOL)isEmpty:(NSArray *)array
{
    if (array != nil && ![array isKindOfClass:[NSNull class]] && array.count != 0) {
        return NO;
    } else {
        return YES;
    }
}

@end
