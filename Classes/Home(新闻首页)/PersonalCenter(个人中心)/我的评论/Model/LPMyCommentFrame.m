//
//  LPMyCommentFrame.m
//  EveryoneNews
//
//  Created by dongdan on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPMyCommentFrame.h"
#import "LPMyComment.h"

@implementation LPMyCommentFrame

- (void)setComment:(LPMyComment *)comment {
    
    _comment = comment;
    
    CGFloat paddingLeft = 18.0f;
    CGFloat paddingRight = 15;
    CGFloat upButtonPaddingRightWithNoCommend = 35;
    CGFloat upButtonPaddingLeftWithNoCommend = 20;
    
    if (iPhone5) {
        upButtonPaddingRightWithNoCommend = 20;
        upButtonPaddingLeftWithNoCommend = 15;
    }
   
    
    NSDate *currentDate = [NSDate date];
    NSDate *updateTime = [NSDate dateWithTimeIntervalSince1970:comment.commentTime.longLongValue / 1000.0];
    NSString *publishTime = @"刚刚";
    int interval = (int)[currentDate timeIntervalSinceDate: updateTime] / 60;
    if (interval > 10 && interval < 60) {
        publishTime = [NSString stringWithFormat:@"%d分钟前",interval];
    } else if (interval > 60) {
        publishTime = [NSString stringWithFormat:@"%@", updateTime];
    }
    
    CGFloat timeLabelX = paddingLeft;
    CGFloat timeLabelW = [publishTime sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    CGFloat timeLabelH = [publishTime sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat timeHeight = timeLabelH + 22;
    
    CGFloat timeLabelY = (timeHeight - timeLabelH) / 2;
    self.timeLabeF = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    CGFloat upButtonW = 17;
    CGFloat upButtonH = 17;
    
    CGFloat deleteButtonW = 13;
    CGFloat deleteButtonH = 16;
    CGFloat deleteButtonX = ScreenWidth - deleteButtonW - 21;
    CGFloat deleteButtonY = (timeHeight - deleteButtonH) / 2;
    self.deleteButtonF = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
    
    NSString *commentContent = comment.comment;
    CGFloat commentLabelX = paddingLeft;
    CGFloat commentLabelW = ScreenWidth - (2 * paddingLeft + + paddingRight + upButtonW + upButtonPaddingRightWithNoCommend + upButtonPaddingLeftWithNoCommend );
    CGFloat commentLabelH = [commentContent sizeWithFont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(commentLabelW, CGFLOAT_MAX)].height;
    CGFloat commentLabelY = 11;
    self.commentLabelF = CGRectMake(commentLabelX, commentLabelY, commentLabelW, commentLabelH);
    
    CGFloat commentImageViewX = paddingLeft;
    CGFloat commentImageViewY = timeHeight;
    CGFloat commentImageViewW = ScreenWidth - paddingLeft - paddingRight;
    CGFloat commentImageViewH = commentLabelH + 30;
    self.commentImageViewF = CGRectMake(commentImageViewX, commentImageViewY, commentImageViewW, commentImageViewH);
    
 
    CGFloat upButtonX = commentImageViewW - upButtonPaddingRightWithNoCommend - upButtonW;
    
    CGFloat upButtonY = 11;
    self.upButtonF = CGRectMake(upButtonX, upButtonY, upButtonW, upButtonH);
    
    CGFloat titleViewW = ScreenWidth - 40;
    CGFloat titleViewH = 40.0f;
    CGFloat titleViewY = CGRectGetMaxY(self.commentImageViewF);
    CGFloat titleViewX = 0;
    self.titleViewF= CGRectMake(titleViewX, titleViewY, titleViewW, titleViewH);
    
    CGFloat spreadImageViewW = 8.5f;
    CGFloat spreadImageViewH = 14.0f;
    CGFloat spreadImageViewX = ScreenWidth - spreadImageViewW - 22;
    CGFloat spreadImageViewY = (titleViewH - spreadImageViewH) / 2;
    self.spreadImageViewF = CGRectMake(spreadImageViewX, spreadImageViewY, spreadImageViewW, spreadImageViewH);
    
    CGFloat titleLabelX= paddingLeft;
    CGFloat titleLabelH = 18;
    CGFloat titleLabelY = 9;
    CGFloat titleLabelW = ScreenWidth - paddingLeft - 45 - spreadImageViewW;
    
    self.titleLabelF = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    self.seperatorViewF = CGRectMake(0, CGRectGetMaxY( self.titleViewF), ScreenWidth, 9);
    
    _cellHeight = CGRectGetMaxY(self.seperatorViewF);
}

@end
