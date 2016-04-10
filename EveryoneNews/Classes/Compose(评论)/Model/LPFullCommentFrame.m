//
//  LPParaCommentFrame.m
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPFullCommentFrame.h"
#import "LPComment.h"

static const CGFloat iconPaddingLeft = 10.0f;
static const CGFloat iconPaddingTop = 15.0f;
static const CGFloat namePaddingLeft = 6;
static const CGFloat namePaddingTop = 18;

static const CGFloat userIconWidth = 25.0f;
static const CGFloat upButtonWidth = 14;
static const CGFloat upButtonHeight = 13;

@implementation LPFullCommentFrame

- (void)setComment:(LPComment *)comment
{
    _comment = comment;
    NSString *upCount = [NSString stringWithFormat:@"%@赞", comment.up];
    
    CGFloat iconX = iconPaddingLeft;
    CGFloat iconY = iconPaddingTop;
    CGFloat iconW = userIconWidth;
    CGFloat iconH = userIconWidth;
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);

    CGFloat nameX = CGRectGetMaxX(_iconF) + namePaddingLeft;
    CGFloat nameY = namePaddingTop;
    CGFloat nameW = 200;
    CGFloat nameH = [@"123" heightForLineWithFont:[UIFont systemFontOfSize:15]];;
    _nameLabelF = CGRectMake(nameX, nameY, nameW, nameH);

    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(_nameLabelF) + 8;
    CGFloat timeW = nameW;
    CGFloat timeH = [@"123" heightForLineWithFont:[UIFont systemFontOfSize:10]];;
    _timeLabelF = CGRectMake(timeX, timeY, timeW, timeH);

    CGFloat textX = nameX;
    CGFloat textY = CGRectGetMaxY(_timeLabelF) + 16;
    CGFloat textW = ScreenWidth - textX * 2 - iconPaddingLeft;
    CGFloat textH = [[comment commentStringWithColor:comment.color] heightWithConstraintWidth:textW];
    
    _commentLabelF = CGRectMake(textX, textY, textW, textH);
    
    CGSize size = [upCount sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat upCountsW = size.width + 6;
    CGFloat upCountsH = size.height;
    CGFloat upCountsX = ScreenWidth - upCountsW - iconPaddingLeft;
    CGFloat upCountsY = iconPaddingLeft + (iconH -  upCountsH) / 2;
    _upCountsLabelF = CGRectMake(upCountsX, upCountsY, upCountsW, upCountsH);
    
    CGFloat upButtonX = CGRectGetMinX(_upCountsLabelF) - upButtonWidth;
    CGFloat upButtonY =  iconPaddingLeft + (iconH -  upCountsH) / 2;
    _upButtonF = CGRectMake(upButtonX, upButtonY, upButtonWidth, upButtonHeight);
    
    _cellHeight = CGRectGetMaxY(_commentLabelF) + iconPaddingLeft + 16;
}

@end
