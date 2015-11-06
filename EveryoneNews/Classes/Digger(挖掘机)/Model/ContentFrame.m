//
//  ContentFrame.m
//  EveryoneNews
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ContentFrame.h"
#import "Content.h"
#import "Content+AttributedText.h"

static const CGFloat paddingY = 18.0f;
static const CGFloat paddingX = 13.0f;

@implementation ContentFrame
- (void)setContent:(Content *)content {
    _content = content;
    if (content.isPhotoType.boolValue) {
        CGFloat photoX = paddingX;
        CGFloat photoY = paddingY;
        CGFloat photoW = ScreenWidth - paddingX * 2;
        CGFloat photoH = photoW * 0.8;
        _photoF = CGRectMake(photoX, photoY, photoW, photoH);
        
        _cellHeight = photoH + paddingY;
    } else {
        CGFloat textW = ScreenWidth - paddingX * 2;
        CGFloat textH = [[content attributedBodyText] heightWithConstraintWidth:textW] + 2.0;
        CGFloat textX = paddingX;
        CGFloat textY = paddingY;
        _textF = CGRectMake(textX, textY, textW, textH);
        
        _cellHeight = textH + paddingY;
    }
}

@end
