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
#define UpImageW 17
#define UpImageH 15
@implementation LPParaCommentFrame

- (void)setComment:(LPComment *)comment
{
    _comment = comment;
    NSString *upCount = comment.up;
    CGFloat iconX = padding;
    CGFloat iconY = padding;
    CGFloat iconW = UserIconWidth;
    CGFloat iconH = iconW;
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat nameX = CGRectGetMaxX(_iconF) + padding;
    CGFloat nameY = CGRectGetMinY(_iconF);
    CGFloat nameW = ScreenWidth - padding * 2 - iconW;
    CGFloat nameH = iconH / 2;
    _nameLabelF = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat timeX = CGRectGetMaxX(_iconF) + padding;
    CGFloat timeY = CGRectGetMaxY(_nameLabelF);
    CGFloat timeW = nameW;
    CGFloat timeH = nameH;
    _timeLabelF = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat textX = CGRectGetMinX(_nameLabelF);
    CGFloat textY = MAX(CGRectGetMaxY(_iconF), CGRectGetMaxY(_timeLabelF)) + padding + 2;
    CGFloat textW = ScreenWidth - textX * 2 - padding;
    CGFloat textH = [[comment commentStringWithCategory:comment.category] heightWithConstraintWidth:textW];
    _commentLabelF = CGRectMake(textX, textY, textW, textH);
    
    
    CGSize size = [upCount sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat upCountsW = size.width;
    CGFloat upCountsH = size.height;
    CGFloat dividerX = ScreenWidth - CGRectGetMinX(_nameLabelF);
    CGFloat dividerH = UpImageH + upCountsH + 5;
    CGFloat dividerW = 0.5;
    
    CGFloat upViewX = dividerX + dividerW;
    CGFloat upViewY = CGRectGetMaxY(_timeLabelF);
    if ([[comment commentStringWithCategory:comment.category] isMoreThanOneLineConstraintToWidth:textW]) {
        // 若评论超过一行，心的位置下移，与评论文字平齐
        upViewY = CGRectGetMinY(_commentLabelF);
    }
    CGFloat upViewW = ScreenWidth - upViewX;
    CGFloat upViewH = dividerH;
    _upViewF = CGRectMake(upViewX, upViewY, upViewW, upViewH);
    
    CGFloat dividerY = upViewY;
    _dividerViewF = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    
    CGFloat upImageY = 0;
    CGFloat upImageX = (upViewW - UpImageW) / 2;
    _upImageViewF = CGRectMake(upImageX, upImageY, UpImageW, UpImageH);
    
    CGFloat upCountsX = CGRectGetMidX(_upImageViewF) - upCountsW / 2;
    CGFloat upCountsY = CGRectGetMaxY(_upImageViewF) + 3;
    _upCountsLabelF = CGRectMake(upCountsX, upCountsY, upCountsW, upCountsH);
    
    if (upCountsW > ScreenWidth - dividerX - 5) {
        _upViewF.origin.x = ScreenWidth - padding - upCountsW - dividerW;
        _upViewF.size.width = upCountsW + padding;
        
        _upImageViewF.origin.x = (_upViewF.size.width - UpImageW) / 2;
        
        _upCountsLabelF.origin.x = padding / 2;
        
        dividerX = CGRectGetMinX(_upViewF) - dividerW;
        _dividerViewF.origin.x = dividerX;
        
        textW = dividerX - textX - padding;
        textH = [[comment commentStringWithCategory:comment.category] heightWithConstraintWidth:textW];
        _commentLabelF.size = CGSizeMake(textW, textH);
    }
    
    _cellHeight = MAX(CGRectGetMaxY(_commentLabelF), CGRectGetMaxY(_upViewF)) + padding;
    
}

@end
