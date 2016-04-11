//
//  UIColor+Additions.h
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Additions)

UIColor *UIColorWithRGBFloatValue(CGFloat red,CGFloat green,CGFloat blue);

+ (nullable UIColor *) colorWithHexString: (nullable NSString *) stringToConvert;

+ (nullable UIColor *) colorWithDesignIndex:(NSInteger)index;

+ (BOOL) isTheSameColor:(nullable UIColor*)color1 anotherColor:(nullable UIColor*)color2;

@end

NS_ASSUME_NONNULL_END
