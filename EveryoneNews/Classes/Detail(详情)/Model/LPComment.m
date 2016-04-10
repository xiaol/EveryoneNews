//
//  LPPoint.m
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPComment.h"
#import "LPConcern.h"
#import "LPFontSizeManager.h"

@implementation LPComment

- (NSMutableAttributedString *)commentStringWithColor:(UIColor *)color {
    return [self.srcText attributedStringWithFont:[UIFont systemFontOfSize:[LPFontSizeManager sharedManager].currentDetailCommentFontSize] color:color lineSpacing:CommentLineSpacing];
}

//- (CGFloat)commentTextLineHeight
//{
//    NSString *str = @"你好";
//    NSMutableAttributedString *attrStr = [str attributedStringWithFont:[UIFont systemFontOfSize:CommentFontSize] color:[UIColor whiteColor] lineSpacing:CommentLineSpacing];
//    return [attrStr heightWithConstraintWidth:MAXFLOAT];
//}
@end
