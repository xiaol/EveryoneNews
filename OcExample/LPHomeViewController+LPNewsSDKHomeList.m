//
//  LPHomeViewController+LPNewsSDKHomeList.m
//  OcExample
//
//  Created by dongdan on 2017/1/15.
//  Copyright © 2017年 aimobier. All rights reserved.
//



#import <OddityOcUI/LPHomeViewController.h>
#import "LPHomeViewController+LPNewsSDKHomeList.h"

@implementation LPHomeViewController (LPNewsSDKHomeList)

// 首页滑动时调用
- (void)homeListDidScroll {
    NSLog(@"首页滑动");
}

// 进入详情页
- (void)pushDetailViewController {
    NSLog(@"进入详情页");
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)switchChannel {
    NSLog(@"切换频道栏");
}
#pragma clang diagnostic pop

@end
