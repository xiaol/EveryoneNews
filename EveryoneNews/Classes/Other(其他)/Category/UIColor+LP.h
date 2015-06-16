//
//  UIColor+LP.h
//  EveryoneNews
//
//  Created by apple on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LP)

+ (instancetype)colorFromHexString:(NSString *)hexString;
+ (instancetype)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (instancetype)colorFromCategory:(NSString *)category;
+ (instancetype)colorFromCategory:(NSString *)text alpha:(CGFloat)alpha;
@end
