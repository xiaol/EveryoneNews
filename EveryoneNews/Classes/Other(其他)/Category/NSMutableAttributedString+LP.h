//
//  NSMutableAttributedString+LP.h
//  EveryoneNews
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (LP)

- (CGFloat)lineHeight;
- (CGSize)sizeWithConstraintSize:(CGSize)maxSize;
- (CGFloat)heightWithConstraintWidth:(CGFloat)width;
- (BOOL)isMoreThanOneLineConstraintToWidth:(CGFloat)width;

@end
