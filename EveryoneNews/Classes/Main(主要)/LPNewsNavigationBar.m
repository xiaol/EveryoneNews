//
//  QDNewsNavigationBar.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LPNewsNavigationBar{
    BOOL isCustomBar;
}

- (instancetype)initWithFame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        isCustomBar = NO;
    }
    return self;
}

- (instancetype)initWithCustomFame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        isCustomBar = YES;
    }
    return  self;
}

- (void)layoutSubviews {
    
    CGFloat kNavigationBarHEIGHT = 51.f;
    if (iPhone6Plus) {
        kNavigationBarHEIGHT = 44.f;
    }
    
    [super layoutSubviews];
    CGRect barFrame = self.frame;
    if (isCustomBar) {
        if (iOS8) {
            barFrame.size.height = (kNavigationBarHEIGHT+20.f);
        }else{
            barFrame.size.height = kNavigationBarHEIGHT;
        }
    }else{
        barFrame.size.height = kNavigationBarHEIGHT;
    }
    
    self.frame = barFrame;
}
@end
NS_ASSUME_NONNULL_END