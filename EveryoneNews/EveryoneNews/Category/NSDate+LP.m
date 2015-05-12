
//
//  NSDate+LP.m
//  testString
//
//  Created by apple on 15/5/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSDate+LP.h"

@implementation NSDate (LP)

+ (NSDate *)localeDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    return [date dateByAddingTimeInterval:interval];
}

+ (NSString *)dateStringSince:(int)i join:(NSString *)join
{
    NSString *month = @"";
    NSString *day = @"";
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-(i*24*3600)];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    if (components.month < 10) {
        month = [NSString stringWithFormat:@"0%d", components.month];
    } else {
        month = [NSString stringWithFormat:@"%d", components.month];
    }
    if (components.day < 10) {
        day = [NSString stringWithFormat:@"0%d", components.day];
    } else {
        day = [NSString stringWithFormat:@"%d", components.day];
    }
    return [NSString stringWithFormat:@"%@%@%@", month, join, day];

}

@end
