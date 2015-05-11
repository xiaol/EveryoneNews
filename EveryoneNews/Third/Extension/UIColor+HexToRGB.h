//
//  UIColor+HexToRGB.h
//  newPocketPlayer
//
//  Created by 于咏畅 on 14-7-28.
//  Copyright (c) 2014年 yyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexToRGB)

+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
