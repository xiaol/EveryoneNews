//
//  NSString+LP.h
//  EveryoneNews
//
//  Created by apple on 15/5/5.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LP)


/**
 *  把时间字符串格式化
 *
 *  @return 纯数字字符串
 */
- (NSString *)timeFormat;

/**
 *  NSDate转换NSString
 *
 *  @param date 
 *
 *  @return
 */
+ (NSString *)stringFromDate:(NSDate *)date;

@end
