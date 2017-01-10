//
//  UIColor+LP.m
//  EveryoneNews
//
//  Created by apple on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIColor+LP.h"

@implementation UIColor (LP)

+ (instancetype)colorFromHexString:(NSString *)hexString
{
    return [UIColor colorFromHexString:hexString alpha:1.0];
}

+ (instancetype)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    if (!hexString) {
        return [UIColor blackColor];
    }
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}



@end
