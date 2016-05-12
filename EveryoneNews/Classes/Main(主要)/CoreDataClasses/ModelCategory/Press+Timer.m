//
//  Press+Timer.m
//  EveryoneNews
//
//  Created by apple on 15/10/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Press+Timer.h"
#import "TimerTool.h"
#import <objc/runtime.h>

@implementation Press (Timer)
static char countdownTimerKey;

- (void)setTimer:(TimerTool *)timer {
    objc_setAssociatedObject(self, &countdownTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TimerTool *)timer {
    return (TimerTool *)objc_getAssociatedObject(self, &countdownTimerKey);
}

- (void)startTimer {
    [self.timer start];
}

- (void)stopTimer {
    if (self.timer != nil) {
        [self.timer stop];
        self.timer = nil;
    }
}

- (BOOL)timeover {
    return self.timer.timeover;
}

- (void)dealloc {
    if (self.timer) {
        [self stopTimer];
    }
}
@end
