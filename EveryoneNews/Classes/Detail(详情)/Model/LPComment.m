//
//  LPPoint.m
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPComment.h"
#import "LPConcern.h"

@implementation LPComment

//- (NSMutableAttributedString *)commentStringWithCategory:(NSString *)category
//{
//    UIColor *color = [UIColor colorFromCategory:category];
//    return [self.srcText attributedStringWithFont:[UIFont systemFontOfSize:CommentFontSize] color:color lineSpacing:CommentLineSpacing];
//}
//
//- (NSMutableAttributedString *)commentStringWithConcern:(LPConcern *)concern {
//    UIColor *color = [UIColor colorFromConcern:concern];
//    return [self.srcText attributedStringWithFont:[UIFont systemFontOfSize:CommentFontSize] color:color lineSpacing:CommentLineSpacing];
//}

- (NSMutableAttributedString *)commentStringWithColor:(UIColor *)color {
    return [self.srcText attributedStringWithFont:[UIFont systemFontOfSize:CommentFontSize] color:color lineSpacing:CommentLineSpacing];
}

- (CGFloat)commentTextLineHeight
{
    NSString *str = @"你好";
    NSMutableAttributedString *attrStr = [str attributedStringWithFont:[UIFont systemFontOfSize:CommentFontSize] color:[UIColor whiteColor] lineSpacing:CommentLineSpacing];
    return [attrStr heightWithConstraintWidth:MAXFLOAT];
}
@end
