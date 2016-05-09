//
//  LPRelatePoint.m
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPRelatePoint.h"
#import "LPFontSizeManager.h"
@implementation LPRelatePoint

- (NSMutableAttributedString *)titleString {
    return [_title attributedStringWithFont:[UIFont systemFontOfSize:[[LPFontSizeManager sharedManager] currentDetailRelatePointFontSize]] color:[UIColor colorFromHexString:LPColor3] lineSpacing:0];
}

- (NSMutableAttributedString *)sourceString {
   return [_sourceSite attributedStringWithFont:[UIFont systemFontOfSize:LPFont7] color:[UIColor colorFromHexString:LPColor4] lineSpacing:0];
}
@end
