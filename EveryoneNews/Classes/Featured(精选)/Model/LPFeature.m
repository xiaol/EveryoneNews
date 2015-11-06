//
//  LPFeature.m
//  EveryoneNews
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPFeature.h"

@implementation LPFeature

- (NSMutableAttributedString *)titleString {
    return [_title attributedStringWithFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:20] color:[UIColor whiteColor] lineSpacing:5];
}
@end
