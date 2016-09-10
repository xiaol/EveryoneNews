//
//  NSMutableAttributedString+LP.m
//  EveryoneNews
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSMutableAttributedString+LP.h"
#import "TTTAttributedLabel.h"
#import <DTCoreText/DTCoreTextLayouter.h>

@implementation NSMutableAttributedString (LP)
- (CGFloat)lineHeight
{
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
}

- (CGSize)sizeWithConstraintSize:(CGSize)maxSize
{
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading context:nil].size;
    
}

- (CGFloat)heightWithConstraintWidth:(CGFloat)width
{
    return [self sizeWithConstraintSize:CGSizeMake(width, MAXFLOAT)].height;
}

- (BOOL)isMoreThanOneLineConstraintToWidth:(CGFloat)width
{
    return [self sizeWithConstraintSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width > width ;
}

- (CGFloat)textViewHeightWithConstraintWidth:(CGFloat)width {
    return [self textViewHeightForAttributedText:self width:width];
}

- (CGFloat)tttAttributeLabel:(CGFloat) width {
    return  [TTTAttributedLabel sizeThatFitsAttributedString:self withConstraints:CGSizeMake(width, MAXFLOAT) limitedToNumberOfLines:0].height;
}

- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)attributedString width:(CGFloat)width {
    DTCoreTextLayouter *layouter = [[DTCoreTextLayouter alloc] initWithAttributedString:attributedString];
    
    CGRect maxRect = CGRectMake(0, 0, width, CGFLOAT_HEIGHT_UNKNOWN);
    NSRange entireString = NSMakeRange(0, [attributedString length]);
    DTCoreTextLayoutFrame *layoutFrame = [layouter layoutFrameWithRect:maxRect range:entireString];
    
    CGSize sizeNeeded = [layoutFrame frame].size;
    return sizeNeeded.height;
}

 

@end
