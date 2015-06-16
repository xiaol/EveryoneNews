//
//  LPNavigationController.h
//  EveryoneNews
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//  自定义导航控制器，拦截所有push方法，使所有非根子控制器不显示导航栏

#import <UIKit/UIKit.h>
#import "LPTabBar.h"
#import "LPTabBarController.h"
@interface LPNavigationController : UINavigationController
@property (nonatomic, weak) LPTabBarController *tabVc;
@end
