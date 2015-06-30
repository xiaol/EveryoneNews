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
    
    
    if (!self.content.isAbstract) {
        // 不是摘要，有评论按钮，评论子view显示
        CGFloat commentViewX = 0;
        CGFloat commentViewY = CGRectGetMaxY(_bodyLabelF) + BodyCommentPadding;
        CGFloat commentViewW = DetailCellWidth;
        
        CGFloat plusH = [@"123" sizeWithFont:[UIFont systemFontOfSize:CommentCountFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height + CommentCountTopPadding + CommentCountBottomPadding;
        CGFloat plusW = plusH;
        CGFloat plusY = 0;
        CGFloat plusX = DetailCellWidth - BodyPadding - 2 - plusW;
        _plusBtnF = CGRectMake(plusX, plusY, plusW, plusH);
        
        CGFloat commentViewH = CGRectGetMaxY(_plusBtnF) + BodyPadding;
        _commentViewF = CGRectMake(commentViewX, commentViewY, commentViewW, commentViewH);
        
        _cellHeight = CGRectGetMaxY(_commentViewF);
        
        if (self.content.hasComment) {
            // 有评论列表
            LPComment *comment = self.content.displayingComment;
            NSString *commentCount = comment.comments_count;
            CGSize commentCountSize = [commentCount sizeWithFont:[UIFont systemFontOfSize:CommentCountFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            CGFloat commentsCountW = commentCountSize.width + CommentCountLeftPadding + CommentCountRightPadding ;
            CGFloat commentsCountH = plusH;
            CGFloat commentsCountX = CGRectGetMinX(_plusBtnF) - 12 - commentsCountW;
            CGFloat commentsCountY = plusY;
            _commentsCountBtnF = CGRectMake(commentsCountX, commentsCountY, commentsCountW, commentsCountH);
            
            CGFloat userIconX = BodyPadding;
            CGFloat userIconY = CGRectGetMaxY(_commentsCountBtnF) + 10;
            CGFloat userIconW = UserIconWidth;
            CGFloat userIconH = userIconW;
            _userIconF = CGRectMake(userIconX, userIconY, userIconW, userIconH);
            
            NSString *upCount = comment.up;
            CGSize upCountSize = [upCount sizeWithFont:[UIFont systemFontOfSize:UpCountFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            CGFloat upH = upCountSize.height + UpCountTopPadding + UpCountBottomPadding;
            CGFloat upW = upCountSize.width + UpCountLeftPadding + UpCountRightPadding;
            CGFloat upX = BodyPadding;
            CGFloat upY = userIconY - upH;
            _upBtnF = CGRectMake(upX, upY, upW, upH);
            
            CGFloat commentX = CGRectGetMaxX(_userIconF) + 11;
            CGFloat commentW = DetailCellWidth - commentX - BodyPadding;
            CGFloat commentH = [[comment commentStringWithCategory:content.category] heightWithConstraintWidth:commentW];
            CGFloat commentY = CGRectGetMidY(_userIconF) -  [[comment commentStringWithCategory:content.category] heightWithConstraintWidth: MAXFLOAT] / 2 + 1;
            _commentLabelF = CGRectMake(commentX, commentY, commentW, commentH);
            
            commentViewH = MAX(CGRectGetMaxY(_commentLabelF), CGRectGetMaxY(_userIconF)) + BodyPadding;
//            _commentViewF = CGRectMake(commentViewX, commentViewY, commentViewW, commentViewH);
            _commentViewF.size.height = commentViewH;
            
            _cellHeight = CGRectGetMaxY(_commentViewF);
        }
    }
    
    // 加上每个cell缩进的高度值！
    _cellHeight += DetailCellHeightBorder;
}
@end
