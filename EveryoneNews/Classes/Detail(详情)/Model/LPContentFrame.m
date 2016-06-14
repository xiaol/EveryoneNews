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
#import "UIImageView+WebCache.h"

@implementation LPContentFrame

- (void)setContent:(LPContent *)content {
    
    CGFloat bodyPadding = 13;
    if (iPhone6Plus) {
        bodyPadding = 15;
    } else if (iPhone5) {
        bodyPadding = 10;
    } else if (iPhone6) {
        bodyPadding = 13;
    }
    _content = content;
    
    if ( _content.contentType == 2) {
        CGFloat bodyX = bodyPadding;
        CGFloat bodyY = 0;
        CGFloat bodyW = ScreenWidth - 2 * bodyPadding;
        CGFloat bodyH = [_content.bodyHtmlString textViewHeightWithConstraintWidth:bodyW];
        _bodyLabelF = CGRectMake(bodyX, bodyY, bodyW, bodyH);
        _cellHeight = CGRectGetMaxY(_bodyLabelF) + 3.5f;
    }
    else if(_content.contentType == 1){ // 图像类型
        CGFloat bodyPadding = 13;
        if (iPhone6Plus) {
            bodyPadding = 19;
        } else if (iPhone5) {
            bodyPadding = 15;
        } else if (iPhone6) {
            bodyPadding = 18;
        }
        CGFloat photoX = bodyPadding;
        CGFloat photoY = 0;
        CGFloat photoW = ScreenWidth - 2 * bodyPadding;
        CGFloat photoH = (3.0f / 4) * photoW;
        NSString *photo = _content.photo;
        NSInteger lastUnderLineIndex = [photo rangeOfString:@"_" options:NSBackwardsSearch].location;
        NSInteger lastMutipleIndex = [photo rangeOfString:@"X" options:NSBackwardsSearch].location;
        NSInteger lastDotIndex = [photo rangeOfString:@"." options:NSBackwardsSearch].location;
        
        if (lastUnderLineIndex != NSNotFound && lastMutipleIndex != NSNotFound && lastDotIndex != NSNotFound) {
            
            CGFloat photoWidth = [[photo substringWithRange:NSMakeRange(lastUnderLineIndex + 1, lastMutipleIndex - lastUnderLineIndex - 1)] floatValue];
            CGFloat photoHeight = [[photo substringWithRange:NSMakeRange(lastMutipleIndex + 1, lastDotIndex - lastMutipleIndex - 1)] floatValue];
            photoH =  photoW * (photoHeight * 1.0f / photoWidth);
        }
        _photoViewF = CGRectMake(photoX, photoY, photoW, photoH);
        _cellHeight = CGRectGetMaxY(_photoViewF) + 3.5f;
        
        
    } else if (_content.contentType == 3) {
        
        CGFloat width = ScreenWidth - 2 * bodyPadding;
        CGFloat height = 3 * width / 4;
        _webViewF = CGRectMake(bodyPadding, 0, width , height);
        _cellHeight = CGRectGetMaxY(_webViewF) + 3.5f;
    }
}

- (void)setContentWhenFontSizeChanged:(LPContentFrame *)contentFrame {
    self.content = contentFrame.content;
}

@end
