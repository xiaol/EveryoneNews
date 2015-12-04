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
#import "LPPagingView.h"

@interface LPHomeViewController () <LPPagingViewDataSource, LPPagingViewDelegate, LPMenuViewDelegate>

@property (nonatomic, strong) NSArray *tabArray;
@property (nonatomic, strong) LPPagingView *detailPagingView;
@property (nonatomic, strong) LPMenuView *menuView;

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
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    topView.backgroundColor = [UIColor redColor];
    [self.view addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    titleLabel.center = CGPointMake(topView.center.x, topView.center.y);
    titleLabel.text = @"头条百家";
    titleLabel.font = [UIFont fontWithName:@"Arial" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [topView addSubview:titleLabel];
    
    self.tabArray = @[@"推荐",@"热点",@"精选",@"社会",@"外媒",@"娱乐",@"科技",@"体育",@"财经",@"时尚",@"搞笑",@"重口味"];
    LPMenuView *menuView = [[LPMenuView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, TabBarHeight)];
    menuView.delegate = self;
    [menuView loadMenuViewTitles:self.tabArray];
    [self.view addSubview:menuView];
    self.menuView = menuView;
    
    self.detailPagingView = [[LPPagingView alloc] init];
    self.detailPagingView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.detailPagingView];
    self.detailPagingView.frame = CGRectMake(0, 60 + TabBarHeight, ScreenWidth, ScreenHeight - 60 -TabBarHeight);
    self.detailPagingView.contentSize = CGSizeMake(self.tabArray.count * self.detailPagingView.width, 0);
    self.detailPagingView.delegate = self;
    self.detailPagingView.dataSource = self;
}

- (NSInteger)numberOfPagesInPagingView:(LPPagingView *)pagingView {
    return self.tabArray.count;
}

- (UIView *)pagingView:(LPPagingView *)pagingView pageForPageIndex:(NSInteger)pageIndex {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, ScreenWidth, 20)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    label.text = [NSString stringWithFormat:@"%d",pageIndex];
    label.textColor = [UIColor redColor];
    [view addSubview:label];
    return view;
}

- (void)pagingView:(LPPagingView *)pagingView didScrollWithRatio:(CGFloat)ratio {
    // 获取当前页
   // NSLog(@"%@", NSStringFromSelector(_cmd));
    int pageIndex = floor(ratio);
    if(pageIndex == 0) {
        [self.menuView selectedButtonWithIndex:pageIndex otherIndex:pageIndex + 1];
    } else if(pageIndex == self.tabArray.count - 1) {
        [self.menuView selectedButtonWithIndex:pageIndex otherIndex:pageIndex - 1];
    } else {
        [self.menuView selectedButtonWithIndex:pageIndex otherIndex:pageIndex - 1];
        [self.menuView selectedButtonWithIndex:pageIndex otherIndex:pageIndex + 1];
    }
    CGFloat rate = ratio - pageIndex;
    [self.menuView changeSelectedButtonRateWithIndex:pageIndex rate:rate];
}

- (void)pagingView:(LPPagingView *)pagingView didScrollToPageIndex:(NSInteger)pageIndex {
    [self.menuView selectedButtonMoveToCenterWithIndex:pageIndex];
}

#pragma 菜单栏选中某个按钮代理方法
- (void)menuViewDelegate:(LPMenuView *)menuView index:(int)index {
    
    [self.detailPagingView setCurrentPageIndex:index animated:NO];
}
@end
