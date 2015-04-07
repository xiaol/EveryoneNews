//
//  AutoLabelSize.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/7.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "AutoLabelSize.h"

@implementation AutoLabelSize

+ (CGSize)autoLabSizeWithStr:(NSString *)str Fontsize:(CGFloat)size SizeW:(CGFloat)sizeW SizeH:(CGFloat)sizeH
{
    NSDictionary * attribute = @{NSFontAttributeName: [UIFont fontWithName:kFont size:size]};
    CGSize nameSize = [str boundingRectWithSize:CGSizeMake(sizeW, sizeH) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return nameSize;
}

@end
