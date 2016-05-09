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

const static CGFloat padding = 13;
static const CGFloat iconPaddingTop = 21.0f;
static const CGFloat namePaddingLeft = 12.0f;
static const CGFloat namePaddingTop = 18;
static const CGFloat userIconWidth = 38.0f;


- (void)setComment:(LPComment *)comment {
    _comment = comment;
    NSString *upCount = [NSString stringWithFormat:@"%@", comment.up];
    
    CGFloat iconY = iconPaddingTop;
    CGFloat iconW = userIconWidth;
    CGFloat iconH = userIconWidth;
    _iconF = CGRectMake(0, iconY, iconW, iconH);
    
    CGFloat nameX = CGRectGetMaxX(_iconF) + namePaddingLeft;
    CGFloat nameY = iconPaddingTop;
    CGFloat nameW = 200;
    CGFloat nameH = [@"123" heightForLineWithFont:[UIFont systemFontOfSize:LPFont4]];
    _nameF = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(_nameF) + 8;
    CGFloat timeW = nameW;
    CGFloat timeH = [@"123" heightForLineWithFont:[UIFont systemFontOfSize:LPFont7]];
    _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat textX = nameX;
    CGFloat textY = CGRectGetMaxY(_timeF) + 12;
    CGFloat textW = ScreenWidth - textX - BodyPadding * 2;
    CGFloat textH = [[comment commentStringWithColor:comment.color] heightWithConstraintWidth:textW];
    _textF = CGRectMake(textX, textY, textW, textH);
    
    // 点赞位置
    
    CGFloat upButtonW = 17.0f;
    CGFloat upButtonH = 17.0f;
    CGFloat upButtonX = ScreenWidth - BodyPadding * 2 - upButtonW;
    CGFloat upButtonY =  nameY;
    _upButtonF = CGRectMake(upButtonX, upButtonY, upButtonW, upButtonH);
    
    
    CGSize size = [upCount sizeWithFont:[UIFont systemFontOfSize:LPFont5] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat upCountsW = size.width + 7;
    CGFloat upCountsH = size.height;
    CGFloat upCountsX = upButtonX - upButtonW;
    CGFloat upCountsY = 0;
    _upCountF = CGRectMake(upCountsX, upCountsY, upCountsW, upCountsH);
    
    _cellHeight = iconPaddingTop * 2 + 8 + 12 + nameH + timeH + textH;
    
}

@end
