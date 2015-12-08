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

@interface LPHomeViewController () <LPPagingViewDataSource, LPPagingViewDelegate, LPMenuViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *tabArray;
@property (nonatomic, strong) LPPagingView *pagingView;
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
    LPMenuView *menuView = [[LPMenuView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth , TabBarHeight)];
    [menuView loadMenuViewTitles:self.tabArray];
    [self.view addSubview:menuView];
    self.menuView = menuView;
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"向下箭头"]];
//    imageView.userInteractionEnabled = YES;
//    imageView.frame = CGRectMake(ScreenWidth - 30, 72, 30, 20);
//    // 分享按钮移除动画
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(manageChannelItems)];
//    tapGesture.delegate = self;
//    [imageView addGestureRecognizer:tapGesture];
    
//    [self.view addSubview:imageView];
    
    LPPagingView *pagingView = [[LPPagingView alloc] init];
    pagingView.backgroundColor = [UIColor grayColor];
    pagingView.frame = CGRectMake(0, 60 + TabBarHeight, ScreenWidth, ScreenHeight - 60 -TabBarHeight);
    pagingView.contentSize = CGSizeMake(self.tabArray.count * pagingView.width, 0);
    pagingView.delegate = self;
    pagingView.dataSource = self;
    [self.view addSubview:pagingView];
    self.pagingView = pagingView;
}

//- (void)manageChannelItems {
//    NSLog(@"ss");
//}

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
    int pageIndex = floor(ratio);
    CGFloat rate = ratio - pageIndex;
    [self.menuView selectedButtonScaleWithRate:pageIndex rate:rate];
}

- (void)pagingView:(LPPagingView *)pagingView didScrollToPageIndex:(NSInteger)pageIndex {
    // 改变菜单栏按钮选中取消状态
    [self.menuView buttonSelectedStatusChangedWithIndex:pageIndex];
    // 按钮自动居中
    [self.menuView selectedButtonMoveToCenterWithIndex:pageIndex];
}

#pragma 菜单栏选中某个按钮代理方法
- (void)menuView:(LPMenuView *)menuView didSelectedButtonAtIndex:(int)index {
     [self.pagingView setCurrentPageIndex:index animated:NO];
}

@end
