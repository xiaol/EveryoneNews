//
//  UIColor+Additions.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIColor+Additions.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIColor (Additions)

UIColor *UIColorWithRGBFloatValue(CGFloat red,CGFloat green,CGFloat blue)
{
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1.f];
}

+ (nullable UIColor *) colorWithHexString: (nullable NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString= [cString substringWithRange:range];
    
    // Scan values
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((CGFloat) r / 255.0f)
                           green:((CGFloat) g / 255.0f)
                            blue:((CGFloat) b / 255.0f)
                           alpha:1.0f];
}


+ (nullable UIColor *) colorWithDesignIndex:(NSInteger)index{
    
    static  NSArray *textColors = nil;//主题黄色10
    
    if (textColors == nil) {
        //                 0         1          2          3          4
        textColors=@[@"#fafafa",@"#333333",@"#0091fa",@"#1a1a1a",@"#999999",
                     //    5         6          7          8          9
                     @"#e4e4e4",@"#bb1c1c",@"#666666",@"#d9effe",@"#f6f6f6",
                     //    10        11        12         13
                     @"#c0c0c0",@"#7e7e7e",@"#e65349",@"00c194"];
    }
    
    if ( (index >= 0 && index < [textColors count]) == NO) {
        return [UIColor blackColor];
    }
    
    static NSMutableDictionary *colorContainer = nil;
    if (colorContainer == nil) {
        colorContainer = [NSMutableDictionary dictionary];
    }
    
    UIColor *retColor =  [colorContainer objectForKey:[NSNumber numberWithInteger:index]];
    if (retColor == nil) {
        retColor = [UIColor colorWithHexString:textColors[index]];
        [colorContainer setObject:retColor forKey:[NSNumber numberWithInteger:index]];
        return retColor;
    }else{
        return retColor;
    }
    
}


+ (BOOL) isTheSameColor:(nullable UIColor*)color1 anotherColor:(nullable UIColor*)color2
{
    if (CGColorEqualToColor(color1.CGColor, color2.CGColor)) {
        return YES;
    }
    else {
        return NO;
    }
}

@end

NS_ASSUME_NONNULL_END
