//
//  NSDate+Extension.m
//  EveryoneNews
//
//  Created by Feng on 15/7/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
//把NSDate 对象转换成毫秒值
+ (NSUInteger)dateToMilliSeconds:(NSDate *)datetime
{
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    NSUInteger totalMilliseconds = interval*1000 ;
    return totalMilliseconds;
}
//将时间戳转换为NSDate类型
+ (NSDate *)getDateTimeFromMilliSeconds:(NSUInteger) miliSeconds
{
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;//这里的.0一定要加上，不然除下来的数据会被截断导致时间不一致
    return [NSDate dateWithTimeIntervalSince1970:seconds];
}
@end
