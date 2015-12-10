//
//  Press+Timer.h
//  EveryoneNews
//
//  Created by apple on 15/10/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Press.h"

@class TimerTool;

@interface Press (Timer)
@property (nonatomic, strong) TimerTool *timer;

- (void)startTimer;
- (void)stopTimer;
- (BOOL)timeover;
@end
