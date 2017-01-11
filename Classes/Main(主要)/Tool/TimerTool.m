//
//  TimerTool.m
//  EveryoneNews
//
//  Created by apple on 15/10/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TimerTool.h"

@interface TimerTool ()
@property (nonatomic, strong) dispatch_source_t timerSource;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
@end

@implementation TimerTool

@synthesize time = _time;

+ (instancetype)timerWithCountdown:(NSUInteger)countdown {
    TimerTool *timer = [[TimerTool alloc] init];
    timer.concurrentQueue = dispatch_queue_create("com.timer.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    timer.time = countdown;
    return timer;
}

dispatch_source_t createTimer(double interval, dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_source_t timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timerSource) {
        dispatch_source_set_timer(timerSource, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0.0);
        dispatch_source_set_event_handler(timerSource, block);
        dispatch_resume(timerSource);
    }
    return timerSource;
}

- (void)start {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    double secondsToFire = 1.0f;
    _timerSource = createTimer(secondsToFire, queue, ^{
        // 定时刷新
        self.time --;
    });
}

- (void)stop {
    if (_timerSource) {
        dispatch_source_cancel(_timerSource);
        _timerSource = nil;
    }
}

- (BOOL)timeover {
    return self.time < 0;
}

- (void)setTime:(NSInteger)time {
    dispatch_barrier_async(self.concurrentQueue, ^{
        _time = time;
    });
}

- (NSInteger)time {
    __block NSInteger readTime;
    dispatch_sync(self.concurrentQueue, ^{
        readTime = _time;
    });
    return readTime;
}


@end
