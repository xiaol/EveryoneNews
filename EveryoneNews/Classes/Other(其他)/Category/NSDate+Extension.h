//
//  NSDate+Extension.h
//  EveryoneNews
//
//  Created by Feng on 15/7/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
//把NSDate 对象转换成毫秒值
+ (NSUInteger)dateToMilliSeconds:(NSDate *)datetime;

//将时间戳转换为NSDate类型
+ (NSDate *)getDateTimeFromMilliSeconds:(NSUInteger) miliSeconds;
@end
