//
//  LPCommentFrame.m
//  EveryoneNews
//
//  Created by dongdan on 16/3/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPCommentFrame.h"
#import "LPComment.h"

@implementation LPCommentFrame

const static CGFloat headerViewHeight = 40;
const static CGFloat bottomViewHeight = 47;

const static CGFloat padding = 13;
const static CGFloat contentPadding = 10;

static const CGFloat iconPaddingLeft = 10.0f;
static const CGFloat iconPaddingTop = 15.0f;
static const CGFloat namePaddingLeft = 6;
static const CGFloat namePaddingTop = 18;

static const CGFloat userIconWidth = 25.0f;
static const CGFloat upButtonWidth = 14;
static const CGFloat upButtonHeight = 13;

- (void)setComment:(LPComment *)comment {
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
    CGFloat nameH = [@"123" heightForLineWithFont:[UIFont systemFontOfSize:15]];
    _nameF = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(_nameF) + 8;
    CGFloat timeW = nameW;
    CGFloat timeH = [@"123" heightForLineWithFont:[UIFont systemFontOfSize:10]];
    _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat textX = nameX;
    CGFloat textY = CGRectGetMaxY(_timeF) + 16;
    CGFloat textW = ScreenWidth - textX * 2 - iconPaddingLeft;
    CGFloat textH = [[comment commentStringWithColor:comment.color] heightWithConstraintWidth:textW];
    _textF = CGRectMake(textX, textY, textW, textH);
    
    CGSize size = [upCount sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat upCountsW = size.width + 6;
    CGFloat upCountsH = size.height;
    CGFloat upCountsX = ScreenWidth - upCountsW - iconPaddingLeft - padding * 2;
    CGFloat upCountsY = 0;
    _upCountF = CGRectMake(upCountsX, upCountsY, upCountsW, upCountsH);
    
    CGFloat upButtonX = CGRectGetMinX(_upCountF) - upButtonWidth;
    CGFloat upButtonY =  0;
    _upButtonF = CGRectMake(upButtonX, upButtonY, upButtonWidth, upButtonHeight);
    
    _cellHeight = 18 + 8 + 16 + 16 + nameH + timeH + textH;
    
}

@end
