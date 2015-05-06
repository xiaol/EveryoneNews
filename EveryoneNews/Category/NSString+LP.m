//
//  NSString+LP.m
//  EveryoneNews
//
//  Created by apple on 15/5/5.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "NSString+LP.h"

@implementation NSString (LP)

- (NSString *)timeFormat
{
    return [[[self stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}
@end
