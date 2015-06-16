//
//  LPPoint.m
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPComment.h"

@implementation LPComment

- (NSMutableAttributedString *)commentStringWithCategory:(NSString *)category
{
    UIColor *color = [UIColor colorFromCategory:category];
    return [self.srcText attributedStringWithFont:[UIFont systemFontOfSize:CommentFontSize] color:color lineSpacing:CommentLineSpacing];
}
@end
