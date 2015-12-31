//
//  LPDetailContent.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPDetailContent.h"

@implementation LPDetailContent

- (NSMutableAttributedString *)bodyString
{
    return [self.txt attributedStringWithFont:[UIFont systemFontOfSize:BodyFontSize] color:[UIColor blackColor] lineSpacing:BodyLineSpacing];
}

@end
