//
//  LPOneBookController.m
//  EveryoneNews
//
//  Created by dongdan on 16/9/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPOneBookController.h"

@implementation LPOneBookController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubView];
}

#pragma mark - setup SubView
- (void)setupSubView {
    self.view.backgroundColor = [UIColor colorFromHexString:LPColor9];
    // 导航栏
    double topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
    double padding = 15;
    
    double returnButtonWidth = 13;
    double returnButtonHeight = 22;
    
    if (iPhone6Plus) {
        returnButtonWidth = 12;
        returnButtonHeight = 21;
    }
    if (iPhone6) {
        topViewHeight = 72;
    }
    double returnButtonPaddingTop = (topViewHeight - returnButtonHeight + StatusBarHeight) / 2;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topViewHeight)];
    topView.backgroundColor = [UIColor colorFromHexString:@"#ffffff" alpha:0.0f];
    [self.view addSubview:topView];
    
    // 返回button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, returnButtonPaddingTop, returnButtonWidth, returnButtonHeight)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"消息中心返回"] forState:UIControlStateNormal];
    backButton.enlargedEdge = 15;
    [backButton addTarget:self action:@selector(backButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, 40)];
    titleLabel.text = @"一订";
    titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
    titleLabel.font = [UIFont  boldSystemFontOfSize:LPFont8];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerX = topView.centerX;
    titleLabel.centerY = backButton.centerY;
    [topView addSubview:titleLabel];
    
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenWidth , 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor10];
    [self.view addSubview:seperatorView];
    
    // 无消息
    CGFloat noMessageImageViewW = 90;
    CGFloat noMessageImageViewH = 83;
    CGFloat noMessageImageViewX = (ScreenWidth - noMessageImageViewW) / 2;
    CGFloat noMessageImageViewY = (ScreenHeight - noMessageImageViewH - topViewHeight) / 2;
    UIImageView *noMessageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(noMessageImageViewX, noMessageImageViewY, noMessageImageViewW, noMessageImageViewH)];
    noMessageImageView.image = [UIImage imageNamed:@"wuxiaoxi"];
    [self.view addSubview:noMessageImageView];
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(noMessageImageView.frame), ScreenWidth, 20)];
    noticeLabel.text = @"正在建设中";
    noticeLabel.font = [UIFont systemFontOfSize:16];
    noticeLabel.textColor = [UIColor colorFromHexString:@"#d4d4d4"];
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noticeLabel];
}

#pragma mark - backButtonDidClick
- (void)backButtonDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
