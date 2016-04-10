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
#import "Content+PhotoDownloadCompletion.h"

static const CGFloat paddingY = 18.0f;
static const CGFloat paddingX = 13.0f;

@implementation ContentFrame
- (void)setContent:(Content *)content {
    _content = content;
    if (content.isPhotoType.boolValue) {
        
        CGFloat photoX = paddingX;
        CGFloat photoY = paddingY;
        CGFloat photoW = ScreenWidth - paddingX * 2;
        
//        CGFloat photoH = photoW * 0.8;

        // 获取图片宽度和高度
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:content.photoURL]];
//        UIImage *image = [UIImage imageWithData:imageData];
//        CGFloat photoH = photoW * (image.size.height / image.size.width);
        
        CGFloat photoH = photoW * (_content.image.size.height / _content.image.size.width);
        _photoF = CGRectMake(photoX, photoY, photoW, photoH);
        
//        NSLog(@"%f", content.image.size.height);
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
