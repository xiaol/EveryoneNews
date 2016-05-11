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
    
    CGFloat paddingHor = 10;
    CGFloat paddingVer = 15;
    
    CGFloat imageX = paddingHor;
    CGFloat imageY = paddingVer;
    CGFloat imageW = 90;
    CGFloat imageH = 75;
    _imageViewF = CGRectMake(imageX, imageY, imageW, imageH);
    
//    NSString *title = concernPress.title;
//    CGFloat titleX = CGRectGetMaxX(_imageViewF) + padding;
//    CGFloat titleY = CGRectGetMinY(_imageViewF) + padding + 5;
//    CGFloat titleW = ScreenWidth - CGRectGetMaxX(_imageViewF) - padding * 2;
//    CGFloat titleH = [title sizeWithFont:[UIFont systemFontOfSize:ConcernPressTitleFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
//    _titleLabelF = CGRectMake(titleX, titleY, titleW, titleH);
//    
//    _cellHeight = MAX(CGRectGetMaxY(_imageViewF), CGRectGetMaxY(_titleLabelF));
//    NSString *tags = concernPress.tags;
//    if (tags.length) {
//        CGFloat tagX = CGRectGetMinX(_titleLabelF);
//        CGFloat tagW = CGRectGetWidth(_titleLabelF);
//        CGFloat tagH = [tags sizeWithFont:[UIFont systemFontOfSize:ConcernPressTagFontSize] maxSize:CGSizeMake(tagW, MAXFLOAT)].height;
//        CGFloat tagY = CGRectGetMaxY(_imageViewF) - padding - tagH - 5;
//        if (CGRectGetMaxY(_titleLabelF) + padding * 2 + tagH > CGRectGetMaxY(_imageViewF)) {
//            tagY = CGRectGetMaxY(_titleLabelF) + padding * 2;
//            _cellHeight = tagY + tagH;
//        }
//        _tagLabelF = CGRectMake(tagX, tagY, tagW, tagH);
//    } else {
//        titleY = (titleH < imageH) ? (imageH - titleH) / 2 : padding;
//        _titleLabelF = CGRectMake(titleX, titleY, titleW, titleH);
//        _cellHeight = MAX(CGRectGetMaxY(_imageViewF), CGRectGetMaxY(_titleLabelF));
//    }
    
    NSString *title = concernPress.title;
    CGFloat titleX = CGRectGetMaxX(_imageViewF) + paddingHor;
    CGFloat titleW = ScreenWidth - CGRectGetMaxX(_imageViewF) - paddingHor * 2;
    CGFloat titleH = [title sizeWithFont:[UIFont systemFontOfSize:ConcernPressTitleFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
    CGFloat titleY = (titleH < imageH) ? (paddingVer + (imageH - titleH) / 2) : paddingVer;
    
    _titleLabelF = CGRectMake(titleX, titleY, titleW, titleH);
    
    _cellHeight = MAX(CGRectGetMaxY(_imageViewF), CGRectGetMaxY(_titleLabelF));
}
@end
