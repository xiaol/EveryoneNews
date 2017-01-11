//
//  CardParam.m
//  EveryoneNews
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CardParam.h"

@implementation CardParam
- (NSNumber *)count {
    if (_count == nil) {
        return @(20);
    }
    return _count;
}

- (NSString *)startTime {
    if (_startTime == nil) {
        
        
       return [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
    }
    return _startTime;
}

- (NSNumber *)pageIndex {
    if (_pageIndex == nil) {
        return @(1);
    }
    return _pageIndex;
}
@end
