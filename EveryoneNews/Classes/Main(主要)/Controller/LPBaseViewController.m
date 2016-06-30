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

//- (void)setIsBuiltInPop:(BOOL)isBuiltInPop {
//        MainNavigationController *nav = (MainNavigationController *)self.navigationController;
//        nav.popRecognizer.enabled = !isBuiltInPop;
//        nav.interactivePopGestureRecognizer.enabled = isBuiltInPop;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 根据runtime特性, -class返回子类类型
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@ will push", NSStringFromClass([self class])]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:[NSString stringWithFormat:@"%@ will pop", NSStringFromClass([self class])]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
