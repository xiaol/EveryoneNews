//
//  NSDate+LP.h
//  testString
//
//  Created by apple on 15/5/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LP)

+ (NSDate *)localeDate;

+ (NSString *)dateStringSince:(int) i join:(NSString *)join;

@end
