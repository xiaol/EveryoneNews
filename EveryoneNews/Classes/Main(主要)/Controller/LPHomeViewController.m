//
//  LPHomeViewController.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewController.h"
#import "LPPagingView.h"
#import "LPMenuView.h"

@interface LPHomeViewController ()

@property (nonatomic, strong) NSArray *tabArray;

@end

@implementation LPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubViews];
}

- (BOOL)prefersStatusBarHidden {
    return  YES;
}

- (void)setupSubViews {
    [self setupTopView];
    [self setupTabs];
}

- (void)setupTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    topView.backgroundColor = [UIColor redColor];
    [self.view addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    titleLabel.center = CGPointMake(topView.center.x, topView.center.y);
    titleLabel.text = @"头条百家";
    titleLabel.font = [UIFont fontWithName:@"Arial" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [topView addSubview:titleLabel];
}

- (void)setupTabs {
    self.tabArray = @[@"推荐",@"热点",@"精选",@"社会",@"外媒",@"娱乐",@"科技",@"体育",@"财经",@"时尚",@"搞笑",@"重口味"];
    LPMenuView *menuView = [[LPMenuView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, TabBarHeight)];
    [menuView loadMenuViewTitles:self.tabArray];
    [self.view addSubview:menuView];
}

@end
