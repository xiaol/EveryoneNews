//
//  LPMainViewController.m
//  EveryoneNews
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPMainViewController.h"
#import "LPPageBar.h"

@interface LPMainViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *pageView;
@property (nonatomic, strong) UIScrollView *categoryView;
@property (nonatomic, strong) UITableView *homeView;
@end

@implementation LPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPageScrollView];
    
    [self setupPageBar];
}

/**
 *  设置主要的view
 */
- (void)setupPageScrollView {
    UIScrollView *pageView = [[UIScrollView alloc] init];
    pageView.frame = self.view.bounds;
    pageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pageView];
    
    
}

- (void)setupPageBar {
    
}

@end
