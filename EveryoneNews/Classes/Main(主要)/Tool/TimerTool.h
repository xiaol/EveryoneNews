//
//  TimerTool.h
//  EveryoneNews
//
//  Created by apple on 15/10/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//  倒计时

#import <Foundation/Foundation.h>

@interface TimerTool : NSObject
@property (nonatomic, assign) NSInteger time;

+ (instancetype)timerWithCountdown:(NSUInteger)countdown;
- (void)start;
- (void)stop;
- (BOOL)timeover;
@end
