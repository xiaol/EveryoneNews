//
//  LPPoint.m
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPComment.h"

#import "LPFontSizeManager.h"
#import "LPFontSize.h"

@implementation LPComment

- (NSMutableAttributedString *)commentStringWithColor:(UIColor *)color {
    LPFontSize *lpFontSize = [LPFontSizeManager sharedManager].lpFontSize;
    return [self.srcText attributedStringWithFont:[UIFont systemFontOfSize:lpFontSize.currentDetailCommentFontSize] color:color lineSpacing:CommentLineSpacing];
}

@end
