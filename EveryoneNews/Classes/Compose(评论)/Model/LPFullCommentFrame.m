//
//  LPParaCommentFrame.m
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPFullCommentFrame.h"
#import "LPComment.h"

static const CGFloat iconPaddingLeft = 18.0f;
static const CGFloat iconPaddingTop = 21.0;
static const CGFloat namePaddingLeft = 12.0;
static const CGFloat namePaddingTop = 18;

static const CGFloat userIconWidth = 38.0f;

@implementation LPFullCommentFrame

- (void)setComment:(LPComment *)comment
{
    _comment = comment;
    NSString *upCount = [NSString stringWithFormat:@"%@", comment.up];
    
    CGFloat iconX = iconPaddingLeft;
    CGFloat iconY = iconPaddingTop;
    CGFloat iconW = userIconWidth;
    CGFloat iconH = userIconWidth;
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);

    CGFloat nameX = CGRectGetMaxX(_iconF) + namePaddingLeft;
    CGFloat nameY = namePaddingTop;
    CGFloat nameW = 200;
    CGFloat nameH = [@"123" heightForLineWithFont:[UIFont systemFontOfSize:LPFont4]];;
    _nameLabelF = CGRectMake(nameX, nameY, nameW, nameH);

    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(_nameLabelF) + 5;
    CGFloat timeW = nameW;
    CGFloat timeH = [@"123" heightForLineWithFont:[UIFont systemFontOfSize:LPFont7]];;
    _timeLabelF = CGRectMake(timeX, timeY, timeW, timeH);

    CGFloat textX = nameX;
    CGFloat textY = CGRectGetMaxY(_timeLabelF) + 3;
    CGFloat textW = ScreenWidth - textX  - iconPaddingLeft;
    CGFloat textH = [[comment commentStringWithColor:comment.color] heightWithConstraintWidth:textW];
    
    _commentLabelF = CGRectMake(textX, textY, textW, textH);
    
    CGFloat upButtonW = 17.0f;
    CGFloat upButtonH = 17.0f;
    CGFloat upButtonX = ScreenWidth - iconPaddingLeft - upButtonW - 1;
    CGFloat upButtonY =  nameY;
    _upButtonF = CGRectMake(upButtonX, upButtonY, upButtonW, upButtonH);
    
    
    CGSize size = [upCount sizeWithFont:[UIFont systemFontOfSize:LPFont5] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat upCountsW = size.width + 7;
    
    CGFloat upCountsH = size.height;
    CGFloat upCountsX = upButtonX -  upCountsW;
    CGFloat upCountsY = upButtonY + 3;
    
    _upCountsLabelF = CGRectMake(upCountsX, upCountsY, upCountsW, upCountsH);
    
    _cellHeight =  iconPaddingTop * 2  + nameH + timeH + textH;
}

@end
