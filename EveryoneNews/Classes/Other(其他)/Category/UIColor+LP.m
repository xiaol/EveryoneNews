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
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

+ (instancetype)colorFromCategory:(NSString *)text alpha:(CGFloat)alpha
{
    if ([text isEqualToString:@"科技"]) {
        return [UIColor colorFromHexString:@"#35a6fb" alpha:alpha];
    } else if ([text isEqualToString:@"港台"]){
        return [UIColor colorFromHexString:@"#b56f40" alpha:alpha];
    } else if ([text isEqualToString:@"财经"]){
        return [UIColor colorFromHexString:@"#f6aa32" alpha:alpha];
    } else if ([text isEqualToString:@"社会"]){
        return [UIColor colorFromHexString:@"#45aecd" alpha:alpha];
    } else if ([text isEqualToString:@"体育"]){
        return [UIColor colorFromHexString:@"#70c011" alpha:alpha];
    } else if ([text isEqualToString:@"国际"]){
        return [UIColor colorFromHexString:@"#ee6270" alpha:alpha];
    } else if ([text isEqualToString:@"娱乐"]){
        return [UIColor colorFromHexString:@"#9153c6" alpha:alpha];
    } else if ([text isEqualToString:@"时事"]){
        return [UIColor colorFromHexString:@"#ef6430" alpha:alpha];
    } else if ([text isEqualToString:@"焦点"]){
        return [UIColor colorFromHexString:@"#ff1652" alpha:alpha];
    } else if ([text isEqualToString:@"内地"]){
        return [UIColor colorFromHexString:@"#72d29b" alpha:alpha];
    } else if ([text isEqualToString:@"国内"]){
        return [UIColor colorFromHexString:@"#8bace9" alpha:alpha];
    } else {
        return [UIColor clearColor];
    }
}
+ (instancetype)colorFromCategory:(NSString *)text
{
    return [self colorFromCategory:text alpha:1.0];
}

@end
