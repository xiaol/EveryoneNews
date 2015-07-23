//
//  LPConcernPressFrame.m
//  EveryoneNews
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPConcernPressFrame.h"
#import "LPConcernPress.h"

@implementation LPConcernPressFrame
- (void)setConcernPress:(LPConcernPress *)concernPress {
    _concernPress = concernPress;
    
    CGFloat padding = 10;
    
    CGFloat imageX = padding;
    CGFloat imageY = padding;
    CGFloat imageW = 110;
    CGFloat imageH = 90;
    _imageViewF = CGRectMake(imageX, imageY, imageW, imageH);
    
    NSString *title = concernPress.title;
    CGFloat titleX = CGRectGetMaxX(_imageViewF) + padding;
    CGFloat titleY = CGRectGetMinY(_imageViewF) + padding + 5;
    CGFloat titleW = ScreenWidth - CGRectGetMaxX(_imageViewF) - padding * 2;
    CGFloat titleH = [title sizeWithFont:[UIFont systemFontOfSize:ConcernPressTitleFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
    _titleLabelF = CGRectMake(titleX, titleY, titleW, titleH);
    
    _cellHeight = MAX(CGRectGetMaxY(_imageViewF), CGRectGetMaxY(_titleLabelF));
    NSString *tags = concernPress.tags;
    if (tags.length) {
        CGFloat tagX = CGRectGetMinX(_titleLabelF);
        CGFloat tagW = CGRectGetWidth(_titleLabelF);
        CGFloat tagH = [tags sizeWithFont:[UIFont systemFontOfSize:ConcernPressTagFontSize] maxSize:CGSizeMake(tagW, MAXFLOAT)].height;
        CGFloat tagY = CGRectGetMaxY(_imageViewF) - padding - tagH - 5;
        if (CGRectGetMaxY(_titleLabelF) + padding * 2 + tagH > CGRectGetMaxY(_imageViewF)) {
            tagY = CGRectGetMaxY(_titleLabelF) + padding * 2;
            _cellHeight = tagY + tagH;
        }
        _tagLabelF = CGRectMake(tagX, tagY, tagW, tagH);
    }
    _cellHeight += padding;
}
@end
