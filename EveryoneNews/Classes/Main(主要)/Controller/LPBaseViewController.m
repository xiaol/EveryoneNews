//
//  LPBaseViewController.m
//  EveryoneNews
//
//  Created by apple on 15/7/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPBaseViewController.h"
#import "MainNavigationController.h"

@interface LPBaseViewController ()

@end

@implementation LPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [noteCenter addObserver:self selector:@selector(changeHomeViewFontSize) name:LPFontSizeChangedNotification object:nil];
}

// 根据runtime特性, -class返回子类类型
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle  {
    return UIStatusBarStyleDefault;
}

#pragma mark - 改变首页字体大小
- (void)changeHomeViewFontSize {
    // 用于子类继承
}

#pragma mark - dealloc
- (void)dealloc {
    [noteCenter removeObserver:self];
    NSLog(@"dealloc");
}


@end
