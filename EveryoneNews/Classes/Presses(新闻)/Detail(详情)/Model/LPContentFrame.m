//
//  LPContentFrame.m
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPContentFrame.h"
#import "LPContent.h"
#import "LPComment.h"

@implementation LPContentFrame

- (void)setContent:(LPContent *)content
{
    _content = content;
    
    CGFloat bodyX = BodyPadding;
    CGFloat bodyY = BodyPadding;
    CGFloat bodyW = DetailCellWidth - 2 * BodyPadding;
//    CGFloat bodyH = [self.content.bodyString heightWithConstraintWidth:bodyW] - BodyLineSpacing;
    CGFloat bodyH = [self.content.bodyString heightWithConstraintWidth:bodyW];
    _bodyLabelF = CGRectMake(bodyX, bodyY, bodyW, bodyH);
    
    _cellHeight = CGRectGetMaxY(_bodyLabelF) + BodyPadding;
    
    if (self.content.hasComment) {
        CGFloat commentViewX = 0;
        CGFloat commentViewY = CGRectGetMaxY(_bodyLabelF) + BodyPadding + 4;
        CGFloat commentViewW = DetailCellWidth;
        
        LPComment *comment = self.content.displayingComment;
        NSString *commentCount = comment.comments_count;
        CGSize commentCountSize = [commentCount sizeWithFont:[UIFont systemFontOfSize:CommentCountFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGFloat commentsCountW = commentCountSize.width + CommentCountLeftPadding + CommentCountRightPadding ;
        CGFloat commentsCountH = commentCountSize.height + CommentCountTopPadding + CommentCountBottomPadding;
        
        CGFloat plusH = commentsCountH;
        CGFloat plusW = plusH;
        CGFloat plusY = 2;
        CGFloat plusX = DetailCellWidth - BodyPadding - 2 - plusW;
        _plusBtnF = CGRectMake(plusX, plusY, plusW, plusH);
        
        CGFloat commentsCountX = CGRectGetMinX(_plusBtnF) - 15 - commentsCountW;
        CGFloat commentsCountY = plusY;
        _commentsCountBtnF = CGRectMake(commentsCountX, commentsCountY, commentsCountW, commentsCountH);
        
        CGFloat userIconX = BodyPadding;
        CGFloat userIconY = CGRectGetMaxY(_commentsCountBtnF) + 10;
        CGFloat userIconW = UserIconWidth;
        CGFloat userIconH = userIconW;
        _userIconF = CGRectMake(userIconX, userIconY, userIconW, userIconH);
        
        NSString *upCount = comment.up;
        CGSize upCountSize = [upCount sizeWithFont:[UIFont systemFontOfSize:UpCountFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//        CGFloat upW = upCountSize.width + UpCountLeftPadding + UpCountRightPadding;
        CGFloat upH = upCountSize.height + UpCountTopPadding + UpCountBottomPadding;
        CGFloat upW = upCountSize.width + UpCountLeftPadding + UpCountRightPadding;
        CGFloat upX = BodyPadding;
        CGFloat upY = userIconY - upH;
        _upBtnF = CGRectMake(upX, upY, upW, upH);
        
        CGFloat commentX = CGRectGetMaxX(_userIconF) + 11;
        CGFloat commentY = userIconY;
        CGFloat commentW = DetailCellWidth - commentX - BodyPadding;
        CGFloat commentH = [[comment commentStringWithCategory:content.category] heightWithConstraintWidth:commentW];
        _commentLabelF = CGRectMake(commentX, commentY, commentW, commentH);
        
        CGFloat commentViewH = MAX(CGRectGetMaxY(_commentLabelF), CGRectGetMaxY(_userIconF)) + BodyPadding;
        _commentViewF = CGRectMake(commentViewX, commentViewY, commentViewW, commentViewH);
        
        _cellHeight = CGRectGetMaxY(_commentViewF);
    }
    
    _cellHeight += DetailCellHeightBorder;
}
@end
