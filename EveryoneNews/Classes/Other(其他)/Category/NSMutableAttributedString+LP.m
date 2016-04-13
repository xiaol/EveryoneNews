//
//  NSMutableAttributedString+LP.m
//  EveryoneNews
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSMutableAttributedString+LP.h"

@implementation NSMutableAttributedString (LP)
- (CGFloat)lineHeight
{
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
}

- (CGSize)sizeWithConstraintSize:(CGSize)maxSize
{
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}

- (CGFloat)heightWithConstraintWidth:(CGFloat)width
{
    return [self sizeWithConstraintSize:CGSizeMake(width, MAXFLOAT)].height;
}

- (BOOL)isMoreThanOneLineConstraintToWidth:(CGFloat)width
{
    return [self sizeWithConstraintSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width > width ;
}

@end
