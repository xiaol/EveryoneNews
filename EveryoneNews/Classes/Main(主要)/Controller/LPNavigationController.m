//
//  LPNavigationController.m
//  EveryoneNews
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPNavigationController.h"
#import "LPHomeViewController.h"
#import "LPDetailViewController.h"
#import "LPTabBar.h"
#import "LPTabBarController.h"

@interface LPNavigationController ()

@end

@implementation LPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

/**
 *  拦截push操作，隐藏navBar
 *
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
//    if (self.viewControllers.count > 0) {
//        self.cusTabBar.hidden = YES;
//    }
    [super pushViewController:viewController animated:animated];
    if (self.viewControllers.count > 1) {
        self.tabVc.customTabBar.hidden = YES;
        UIPageViewController *pageVc = self.tabVc.pageViewController;
        UIScrollView *scrollView = (UIScrollView *)[pageVc.view.subviews objectAtIndex:0];
        scrollView.scrollEnabled = NO;
    }
    viewController.navigationController.navigationBarHidden = YES;
//    viewController.hidesBottomBarWhenPushed = YES;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [super popViewControllerAnimated:animated];
    if (self.viewControllers.count == 1) {
        self.tabVc.customTabBar.hidden = NO;
        UIPageViewController *pageVc = self.tabVc.pageViewController;
        UIScrollView *scrollView = (UIScrollView *)[pageVc.view.subviews objectAtIndex:0];
        scrollView.scrollEnabled = YES;
    }
    return vc;
}


@end
