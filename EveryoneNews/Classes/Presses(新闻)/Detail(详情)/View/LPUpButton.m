//
//  LPUpButton.m
//  EveryoneNews
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPUpButton.h"

@implementation LPUpButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat h = contentRect.size.height - UpCountTopPadding - UpCountBottomPadding;
    return CGRectMake(4, UpCountTopPadding, h + 1, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(UpCountLeftPadding, UpCountTopPadding - 1, contentRect.size.width - UpCountLeftPadding, contentRect.size.height - UpCountTopPadding - UpCountBottomPadding);
}

@end
