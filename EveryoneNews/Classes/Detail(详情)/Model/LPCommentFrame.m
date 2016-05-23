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
static const CGFloat namePaddingLeft = 12.0f;
static const CGFloat namePaddingTop = 18;
static const CGFloat userIconWidth = 38.0f;


- (void)setComment:(LPComment *)comment {

    CGFloat iconPaddingTop = 22.0f;
    CGFloat iconPaddingLeft = 18.0f;
    
    _comment = comment;
    NSString *upCount = [NSString stringWithFormat:@"%@", comment.up];
    
    CGFloat iconY = iconPaddingTop;
    CGFloat iconW = userIconWidth;
    CGFloat iconH = userIconWidth;
    _iconF = CGRectMake(iconPaddingLeft, iconY, iconW, iconH);
    
    CGFloat nameX = CGRectGetMaxX(_iconF) + namePaddingLeft;
    CGFloat nameY = iconPaddingTop - 2;
    CGFloat nameW = 200;
    CGFloat nameH = [@"123" heightForLineWithFont:[UIFont systemFontOfSize:LPFont4]];
    _nameF = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(_nameF) + 5;
    CGFloat timeW = nameW;
    CGFloat timeH = [@"123" heightForLineWithFont:[UIFont systemFontOfSize:LPFont7]];
    _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat textX = nameX;
    CGFloat textY = CGRectGetMaxY(_timeF) + 9;
    CGFloat textW = ScreenWidth - textX - iconPaddingLeft ;
    CGFloat textH = [[comment commentStringWithColor:comment.color] heightWithConstraintWidth:textW];
    _textF = CGRectMake(textX, textY, textW, textH);
    
    // 点赞位置
    
    CGFloat upButtonW = 17.0f;
    CGFloat upButtonH = 17.0f;
    CGFloat upButtonX = ScreenWidth - iconPaddingLeft  - upButtonW - 1;
        
    
    CGFloat upButtonY =  nameY;
    _upButtonF = CGRectMake(upButtonX, upButtonY, upButtonW, upButtonH);
    
    
    CGSize size = [upCount sizeWithFont:[UIFont systemFontOfSize:LPFont5] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat upCountsW = size.width + 7;
    CGFloat upCountsH = size.height;
    CGFloat upCountsX = CGRectGetMinX(_upButtonF) - upCountsW;
    CGFloat upCountsY = 0;
    _upCountF = CGRectMake(upCountsX, upCountsY, upCountsW, upCountsH);
    
    _cellHeight = iconPaddingTop * 2 + 4 + 9 + nameH + timeH + textH;
    
}

@end
