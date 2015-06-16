//
//  LPParaCommentFrame.m
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPParaCommentFrame.h"
#import "LPComment.h"

//@property (nonatomic, assign) CGRect iconF;
//@property (nonatomic, assign) CGRect nameLabelF;
//@property (nonatomic, assign) CGRect timeLabelF;
//@property (nonatomic, assign) CGRect commentLabelF;

#define padding 10
@implementation LPParaCommentFrame

- (void)setComment:(LPComment *)comment
{
    _comment = comment;
    CGFloat iconX = padding;
    CGFloat iconY = padding;
    CGFloat iconW = UserIconWidth;
    CGFloat iconH = iconW;
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat nameX = CGRectGetMaxX(_iconF) + padding;
    CGFloat nameY = CGRectGetMinY(_iconF);
    CGFloat nameW = ScreenWidth - padding * 2 - iconW - 30;
    CGFloat nameH = iconH / 2;
    _nameLabelF = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat timeX = CGRectGetMaxX(_iconF) + padding;
    CGFloat timeY = CGRectGetMaxY(_nameLabelF);
    CGFloat timeW = nameW;
    CGFloat timeH = nameH;
    _timeLabelF = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat textX = padding;
    CGFloat textY = MAX(CGRectGetMaxY(_iconF), CGRectGetMaxY(_timeLabelF)) + padding + 2;
    CGFloat textW = ScreenWidth - padding * 2;
    CGFloat textH = [[comment commentStringWithCategory:comment.category] heightWithConstraintWidth:textW];
    _commentLabelF = CGRectMake(textX, textY, textW, textH);
    
    _cellHeight = CGRectGetMaxY(_commentLabelF) + padding;
}

@end
