//
//  LPSubscriberFrame.m
//  Test
//
//  Created by dongdan on 16/9/1.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import "LPSubscriberFrame.h"
#import "LPSubscriber.h"
#import <UIKit/UIKit.h>

@implementation LPSubscriberFrame

- (void)setSubscriber:(LPSubscriber *)subscriber {
    _subscriber = subscriber;
    CGFloat padding = 20;
    CGFloat gap = 30;
    
    // 图片
    CGFloat imageW = (ScreenWidth - padding * 2 - gap * 3) / 3;
    CGFloat imageH = imageW;
    _imageFrame = CGRectMake(0, 0, imageW, imageH);
    
    CGFloat titleW = imageW;
    NSString *subscriberStr = @"订阅号";
    CGFloat singleTitleH = [subscriberStr sizeWithFont:[UIFont systemFontOfSize:LPFont6] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat titleH = singleTitleH * 2;
    CGFloat titleX = 0;
    CGFloat titleY = CGRectGetMaxY(_imageFrame) + singleTitleH;
    _titleFrame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat subscriberButtonY = CGRectGetMaxY(_titleFrame);
    CGFloat subscriberButtonH = 19;
    CGFloat subscriberButtonW = imageW;
    _subscriberButtonFrame = CGRectMake(0, subscriberButtonY, subscriberButtonW, subscriberButtonH);
    
}




@end
