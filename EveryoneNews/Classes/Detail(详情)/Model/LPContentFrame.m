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
#import "LPConcern.h"

@implementation LPContentFrame

- (void)setContent:(LPContent *)content
{
    _content = content;
    

    if (!self.content.isPhoto) { // 普通类型(非图)
        CGFloat bodyX = BodyPadding;
        CGFloat bodyY = BodyPadding;
        CGFloat bodyW = DetailCellWidth - 2 * BodyPadding;
        //    CGFloat bodyH = [self.content.bodyString heightWithConstraintWidth:bodyW] - BodyLineSpacing;
        CGFloat bodyH = [self.content.bodyString heightWithConstraintWidth:bodyW];
        _bodyLabelF = CGRectMake(bodyX, bodyY, bodyW, bodyH);
        
        _cellHeight = CGRectGetMaxY(_bodyLabelF) + BodyPadding;
        
        if (content.isOpinion) {
            NSMutableAttributedString *opinionStr = content.opinionString;
            
            CGFloat supplementX = 0;
            CGFloat supplementY = CGRectGetMaxY(_bodyLabelF) + BodyPadding + 5;
            CGFloat supplementW = DetailCellWidth;
            
            CGFloat dividerX = BodyPadding;
            CGFloat dividerY = 0;
            CGFloat dividerW = DetailCellWidth - 2 * BodyPadding;
            CGFloat dividerH = 1;
            _dividerViewF = CGRectMake(dividerX, dividerY, dividerW, dividerH);
            
            CGFloat arrowX = CGRectGetMinX(_dividerViewF) + BodyPadding;
            CGFloat arrowY = CGRectGetMaxY(_dividerViewF) - 0.5;
            CGFloat arrowW = 16;
            CGFloat arrowH = 8;
            _arrowViewF = CGRectMake(arrowX, arrowY, arrowW, arrowH);
            
            CGFloat pointerW = 8;
            CGFloat pointerH = 14;
            CGFloat pointerX = DetailCellWidth - BodyPadding - pointerW;
            CGFloat pointerY = BodyPadding + 4;
            _pointerViewF = CGRectMake(pointerX, pointerY, pointerW, pointerH);
            
            CGFloat iconH = 18;
            CGFloat iconW = iconH;
            CGFloat iconY = CGRectGetMidY(_pointerViewF) - iconH / 2;
            CGFloat iconX = CGRectGetMidX(_arrowViewF) - iconW / 2;
            _iconViewF = CGRectMake(iconX, iconY, iconW, iconH);
            
            CGFloat urlX = CGRectGetMaxX(_iconViewF) + BodyPadding;
            CGFloat urlW = CGRectGetMinX(_pointerViewF) - urlX - BodyPadding;
            CGFloat urlH = [opinionStr heightWithConstraintWidth:urlW];
            CGFloat urlY = CGRectGetMidY(_iconViewF) - (opinionStr.lineHeight - 3) / 2;
            _sourceViewF = CGRectMake(urlX, urlY, urlW, urlH);
            
            CGFloat supplementH = MAX(CGRectGetMaxY(_sourceViewF), CGRectGetMaxY(_iconViewF)) + BodyPadding;
            _supplementViewF = CGRectMake(supplementX, supplementY, supplementW, supplementH);
            
            _cellHeight = CGRectGetMaxY(_supplementViewF) + DetailCellHeightBorder;
            return;
        }
        
        
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
                [self setupCommentFrameWithContent:content];
            }
        }
        
        // 加上每个cell缩进的高度值！
    } else { // 图像类型
        CGFloat photoX = 0;
        CGFloat photoY = 0;
        CGFloat photoW = DetailCellWidth;
        CGFloat photoH = photoW * 9 / 11;
        _photoViewF = CGRectMake(photoX, photoY, photoW, photoH);
        
//        CGFloat commentViewX = 0;
//        CGFloat commentViewY = CGRectGetMaxY(_photoViewF) + BodyCommentPadding;
//        CGFloat commentViewW = DetailCellWidth;
//
//        CGFloat plusH = [@"123" sizeWithFont:[UIFont systemFontOfSize:CommentCountFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height + CommentCountTopPadding + CommentCountBottomPadding;
//        CGFloat plusW = plusH;
//        CGFloat plusY = 0;
//        CGFloat plusX = DetailCellWidth - BodyPadding - 2 - plusW;
//        _plusBtnF = CGRectMake(plusX, plusY, plusW, plusH);
//        
//        CGFloat commentViewH = CGRectGetMaxY(_plusBtnF) + BodyPadding;
//        _commentViewF = CGRectMake(commentViewX, commentViewY, commentViewW, commentViewH);
        
        if (content.photoDesc.length) {
            
            CGFloat commentViewX = 0;
            CGFloat commentViewY = CGRectGetMaxY(_photoViewF) + BodyCommentPadding;
            CGFloat commentViewW = DetailCellWidth;
            
            CGFloat plusH = [@"123" sizeWithFont:[UIFont systemFontOfSize:CommentCountFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height + CommentCountTopPadding + CommentCountBottomPadding;
            CGFloat plusW = plusH;
            CGFloat plusY = 0;
            CGFloat plusX = DetailCellWidth - BodyPadding - 2 - plusW;
            _plusBtnF = CGRectMake(plusX, plusY, plusW, plusH);
            
            CGFloat commentViewH = CGRectGetMaxY(_plusBtnF) + BodyPadding;
            _commentViewF = CGRectMake(commentViewX, commentViewY, commentViewW, commentViewH);

            CGFloat photoDescX = BodyPadding;
            CGFloat photoDescY = CGRectGetMaxY(_photoViewF) + BodyPadding;
            CGFloat photoDescW = DetailCellWidth - 2 * BodyPadding;
            CGFloat photoDescH = [self.content.photoDescString heightWithConstraintWidth:photoDescW];
            _photoDescViewF = CGRectMake(photoDescX, photoDescY, photoDescW, photoDescH);
            
            _commentViewF.origin.y = CGRectGetMaxY(_photoDescViewF) + BodyCommentPadding;
        }
        
        _cellHeight = CGRectGetMaxY(_commentViewF);
        
        if (content.hasComment) {
            [self setupCommentFrameWithContent:content];
        }
        
        if (!content.photoDesc.length || !content.photoDesc) {
            _cellHeight = CGRectGetMaxY(_photoViewF);
        }
    }
    _cellHeight += DetailCellHeightBorder;
}

- (void)setupCommentFrameWithContent:(LPContent *)content {
    LPComment *comment = self.content.displayingComment;
    NSString *commentCount = [NSString stringFromIntValue:(int)content.comments.count];
    CGSize commentCountSize = [commentCount sizeWithFont:[UIFont systemFontOfSize:CommentCountFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat commentsCountW = commentCountSize.width + CommentCountLeftPadding + CommentCountRightPadding ;
    CGFloat commentsCountH = _plusBtnF.size.height;
    CGFloat commentsCountX = CGRectGetMinX(_plusBtnF) - 12 - commentsCountW;
    CGFloat commentsCountY = _plusBtnF.origin.y;
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
    CGFloat commentH = 0.0;
//    if (content.concern) {
//        commentH = [[comment commentStringWithConcern:content.concern] heightWithConstraintWidth:commentW];
//    } else {
//        commentH = [[comment commentStringWithCategory:content.category] heightWithConstraintWidth:commentW];
//    }
    commentH = [[comment commentStringWithColor:content.color] heightWithConstraintWidth:commentW];
    CGFloat commentY = CGRectGetMidY(_userIconF) -  [comment commentTextLineHeight] / 2 + 1;
    _commentLabelF = CGRectMake(commentX, commentY, commentW, commentH);
    
    CGFloat commentViewH = MAX(CGRectGetMaxY(_commentLabelF), CGRectGetMaxY(_userIconF)) + BodyPadding;
    _commentViewF.size.height = commentViewH;
    
    _cellHeight = CGRectGetMaxY(_commentViewF);
}


@end
