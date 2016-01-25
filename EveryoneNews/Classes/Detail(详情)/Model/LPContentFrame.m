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
    if (!self.content.isPhoto) { // 普通类型(非图)g
        CGFloat bodyX = BodyPadding;
        CGFloat bodyY = BodyPadding - 5;
        CGFloat bodyW = DetailCellWidth - 2 * BodyPadding;
        CGFloat bodyH = [self.content.bodyString heightWithConstraintWidth:bodyW];
        _bodyLabelF = CGRectMake(bodyX, bodyY, bodyW, bodyH);
        if (_content.isAbstract) {
            _abstractSeperatorViewF = CGRectMake(0, CGRectGetMaxY(_bodyLabelF) + DetailCellHeightBorder, ScreenWidth, DetailCellHeightBorder);
            _cellHeight = CGRectGetMaxY(_abstractSeperatorViewF) + BodyPadding - 5;
        } else {
            _cellHeight = CGRectGetMaxY(_bodyLabelF) + BodyPadding - 5;
        }
    } else { // 图像类型
        CGFloat photoX = 0;
        CGFloat photoY = 0;
        CGFloat photoW = DetailCellWidth;
        CGFloat photoH = photoW * 9 / 11;
        _photoViewF = CGRectMake(photoX, photoY, photoW, photoH);
        _cellHeight = CGRectGetMaxY(_photoViewF);
    }
    _cellHeight += DetailCellHeightBorder;
    
}

@end
