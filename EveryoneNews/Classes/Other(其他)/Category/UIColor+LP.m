//
//  UIColor+LP.m
//  EveryoneNews
//
//  Created by apple on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIColor+LP.h"
#import "LPConcern.h"

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

+ (instancetype)colorFromConcern:(LPConcern *)concern alpha:(CGFloat)alpha {
    NSString *colorString = @"ffffff";
    switch (concern.channel_id.intValue) {
        case 0:
            colorString = @"#ff1652";
            break;
        case 1:
            colorString = @"#ee6270";
            break;
        case 2:
            colorString = @"#6279a3";
            break;
        case 3:
            colorString = @"#f788a2";
            break;
        case 4:
            colorString = @"#37ccd9";
            break;
        case 5:
            colorString = @"#b56f40";
            break;
        case 6:
            colorString = @"#35e4c1";
            break;
        case 8:
            colorString = @"#f6aa32";
            break;
        case 9:
            colorString = @"#35a6fb";
            break;
        case 10:
            colorString = @"#e2ab4b";
            break;
        case 11:
            colorString = @"#2bc972";
            break;
        case 12:
            colorString = @"#9153c6";
            break;
        case 13:
            colorString = @"#ffda59";
            break;
        case 14:
            colorString = @"#7174ff";
            break;
        default:
            break;
    }
    return [self colorFromHexString:colorString alpha:alpha];
}

+ (instancetype)colorFromConcern:(LPConcern *)concern {
    return [self colorFromConcern:concern alpha:1.0];
}

+ (instancetype)colorFromCategory:(NSString *)text
{
    return [self colorFromCategory:text alpha:1.0];
}

@end
