//
//  LPTabBarController.h
//  EveryoneNews
//
//  Created by apple on 15/5/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPTabBar;
@interface LPTabBarController : UIViewController

//@property (nonatomic, weak) LPNavigationController *selectedViewController;
@property (nonatomic, weak) LPTabBar *customTabBar;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@end
