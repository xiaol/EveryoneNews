//
//  LPDetailViewController+LPNewsDetailSDK.m
//  OcExample
//
//  Created by dongdan on 2017/1/16.
//  Copyright © 2017年 aimobier. All rights reserved.
//


#import <OddityOcUI/LPDetailViewController.h>
#import "LPDetailViewController+LPNewsDetailSDK.h"

@implementation LPDetailViewController (LPNewsDetailSDK)

// 详情页加载失败
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)newsDetailLoadFailed {
    // NSLog(@"加载详情页失败");
}
#pragma clang diagnostic pop

@end
