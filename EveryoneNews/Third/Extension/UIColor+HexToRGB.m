//
//  UIColor+HexToRGB.m
//  newPocketPlayer
//
//  Created by 于咏畅 on 14-7-28.
//  Copyright (c) 2014年 yyc. All rights reserved.
//

#import "UIColor+HexToRGB.h"

@implementation UIColor (HexToRGB)

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
	
    [scanner scanHexInt:&rgbValue];
	
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


@end
