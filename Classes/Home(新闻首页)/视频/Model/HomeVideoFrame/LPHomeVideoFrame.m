//
//  LPHomeVideoFrame.m
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/6.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import "LPHomeVideoFrame.h"
#import "Card.h"
#import "NSString+LP.h"
#import "LPFontSizeManager.h"
#import "LPFontSize.h"

@implementation LPHomeVideoFrame

- (void)setCard:(Card *)card  {
    _card = card;
    NSString *title = card.title;
    CGFloat paddingLeft = 12;
    CGFloat paddingTop = 10;
    
    self.homeViewFontSize = [LPFontSizeManager sharedManager].lpFontSize.currentHomeViewFontSize;
    self.fontSizeType =  [LPFontSizeManager sharedManager].lpFontSize.fontSizeType;
    
    
    // 评论数量
    NSInteger commentsCount = [card.commentsCount intValue];
    NSString *commentStr = @"";
    
    // 评论字体大小
    CGFloat commentsFontSize = 13;
    
    CGFloat commentLabelW = 0.0f;
    CGFloat commentLabelH = 0.0f;
    if (commentsCount > 0) {
        if (commentsCount > 10000) {
            commentStr = [NSString stringWithFormat:@"%.1f万评", (floor)(commentsCount)/ 10000];
        } else {
            commentStr = [NSString stringWithFormat:@"%d评", commentsCount];
        }
        
        commentLabelH = [commentStr sizeWithFont:[UIFont systemFontOfSize:commentsFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
        commentLabelW = [commentStr sizeWithFont:[UIFont systemFontOfSize:commentsFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    }
    CGFloat lineSpacing = 2.0;
    
    CGFloat titleFontSize =  self.homeViewFontSize;
    CGFloat titleX = paddingLeft;
    CGFloat titleY = paddingTop;
    CGFloat titleW = ScreenWidth - paddingLeft * 2;
    
    // 计算单行文字高度
    NSMutableAttributedString *singleLineAttrStr =  [@"单行文本" attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
    CGRect singleLineRect = [singleLineAttrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGFloat singleTitleH = singleLineRect.size.height;
    
    
    NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGFloat titleH = rect.size.height + 2.0f;
    if (titleH > 2 * singleTitleH) {
        titleH = 2 * singleTitleH;
    }
    
    _titleF = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat coverImageX = 0;
    CGFloat coverImageW = ScreenWidth;
    CGFloat coverImageH = (211 * coverImageW / 375) ;
    CGFloat coverImageY = CGRectGetMaxY(_titleF) + paddingTop;
    _coverImageF = CGRectMake(coverImageX, coverImageY, coverImageW, coverImageH);
    
    CGFloat playButtonW = 50;
    CGFloat playButtonH = 50;
    CGFloat playButtonX = (ScreenWidth - playButtonW) / 2;
    CGFloat playButtonY = (coverImageH - playButtonH) / 2.0f;
    _playButtonF = CGRectMake(playButtonX, playButtonY, playButtonW, playButtonH);

    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = CGRectGetMaxY(_coverImageF);
    CGFloat bottomViewW = ScreenWidth;
    CGFloat bottomViewH = 32;
    _bottomViewF = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
    
    CGFloat shareButtonW = 20;
    CGFloat shareButtonH = 20;
    CGFloat shareButtonX = ScreenWidth - paddingLeft - shareButtonW;
    CGFloat shareButtonY = (bottomViewH - shareButtonH) / 2.0f;
    _shareButtonF = CGRectMake(shareButtonX, shareButtonY, shareButtonW, shareButtonH);
    
    CGFloat commentLabelX = CGRectGetMinX(_shareButtonF) - commentLabelW - 5;
    CGFloat commentLabelY =  (bottomViewH - commentLabelH) / 2.0f;
    _commentLabelF = CGRectMake(commentLabelX, commentLabelY, commentLabelW, commentLabelH);
    
//    CGFloat commentImageViewW = 20;
//    CGFloat commentImageViewH = 20;
//    CGFloat commentImageViewX = CGRectGetMinX(_commentLabelF) - commentImageViewW - 5;
//    CGFloat commentImageViewY = (bottomViewH - commentImageViewH) / 2.0f;
//    _commentImageViewF = CGRectMake(commentImageViewX, commentImageViewY, commentImageViewW, commentImageViewH);
    
    CGFloat seperatorViewX = 0;
    CGFloat seperatorViewY = CGRectGetMaxY(_bottomViewF);
    CGFloat seperatorViewW = ScreenWidth;
    CGFloat seperatorViewH = 4;
    _seperatorViewF = CGRectMake(seperatorViewX, seperatorViewY, seperatorViewW, seperatorViewH);
    
    _cellHeight = CGRectGetMaxY(_seperatorViewF);
}




@end
