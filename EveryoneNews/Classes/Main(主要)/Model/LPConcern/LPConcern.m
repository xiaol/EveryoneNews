//
//  LPConcern.m
//  EveryoneNews
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPConcern.h"

@implementation LPConcern

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.channel_name];
}

//- (NSString *)channel_name
//{
//    return [_channel_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//}

@end
