//
//  LPPress.m
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPPress.h"
#import "MJExtension.h"



@implementation LPPress

- (NSMutableAttributedString *)titleString
{
    return [self.title attributedStringWithFont:[UIFont fontWithName:FontName size:16] color:[UIColor colorFromHexString:TitleColor] lineSpacing:3];
}

+ (void)load
{
    [self setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"sublist": @"LPPointview"
                 };
    }];
}

@end
