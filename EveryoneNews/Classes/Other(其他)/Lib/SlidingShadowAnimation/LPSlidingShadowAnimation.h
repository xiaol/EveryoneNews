//
//  LPSlidingShadowAnimation.h
//  EveryoneNews
//
//  Created by apple on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPSlidingShadowAnimation : NSObject

@property (weak, nonatomic) UIView *animatedView;
@property (strong, nonatomic) UIColor *shadowBackgroundColor;
@property (strong, nonatomic) UIColor *shadowForegroundColor;
@property (assign, nonatomic) CGFloat shadowWidth;
@property (assign, nonatomic) CGFloat repeatCount;
@property (assign, nonatomic) NSTimeInterval duration;

- (void)start;
- (void)stop;

@end
