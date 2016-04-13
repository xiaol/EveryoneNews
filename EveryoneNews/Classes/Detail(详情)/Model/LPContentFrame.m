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

- (void)setContent:(LPContent *)content {
    _content = content;
    if (!_content.isPhoto) { // 普通类型(非图)g
        CGFloat bodyX = 0;
        CGFloat bodyY = BodyPadding * 2;
        CGFloat bodyW = ScreenWidth - 2 * BodyPadding;
        CGFloat bodyH = [_content.bodyHtmlString heightWithConstraintWidth:bodyW];
        
//        CGFloat bodyH = [self.content.bodyString heightWithConstraintWidth:bodyW];
        
        _bodyLabelF = CGRectMake(bodyX, bodyY, bodyW, bodyH);
        _cellHeight = CGRectGetMaxY(_bodyLabelF) + BodyPadding - 5;
      
    }
    
    else { // 图像类型
        CGFloat photoX = 0;
        CGFloat photoY = BodyPadding * 2;
        CGFloat photoW = ScreenWidth - 2 * BodyPadding;
        CGFloat photoH = photoW * 9 / 11;
         _photoViewF = CGRectMake(photoX, photoY, photoW, photoH);
        _cellHeight = CGRectGetMaxY(_photoViewF);
    }    
}

@end
