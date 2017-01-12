//
//  LPHomeRowManager.m
//  EveryoneNews
//
//  Created by dongdan on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPHomeRowManager.h"

@implementation LPHomeRowManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static LPHomeRowManager *manager = nil;
    dispatch_once(&once, ^{
        manager = [[LPHomeRowManager alloc] init];
    });
    return manager;
}

- (id)init {
    if (self = [super init]) {
        self.currentRowIndex = 0;
    }
    return self;
}

@end
