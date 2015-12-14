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
@end
