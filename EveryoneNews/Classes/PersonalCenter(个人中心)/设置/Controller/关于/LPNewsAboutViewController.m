//
//  LPNewsAboutViewController.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsAboutViewController.h"
#import "LPNewsMineViewController.h"

@interface LPNewsAboutViewController()

@end

@implementation LPNewsAboutViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupSubViews];

}

#pragma mark - setupSubViews
- (void)setupSubViews {
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text = @"关于";
    titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
    titleLabel.font = [UIFont  boldSystemFontOfSize:LPFont8];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerX = topView.centerX;
    titleLabel.centerY = backButton.centerY;
    [topView addSubview:titleLabel];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenWidth , 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor10];
    [self.view addSubview:seperatorView];
    
    // 奇点资讯图标
    UIImageView *iconImage = [[UIImageView alloc] init];
    [iconImage setImage:[UIImage imageNamed:@"个人中心奇点资讯"]];
    CGFloat iconImageW = 87;
    CGFloat iconImageH = 87;
    CGFloat iconImageX = (ScreenWidth - iconImageW) / 2;
    CGFloat iconImageY = CGRectGetMaxY(seperatorView.frame) + 74;
    iconImage.frame = CGRectMake(iconImageX, iconImageY, iconImageW, iconImageH);
    [self.view addSubview:iconImage];
    
    // 奇点资讯
    NSString *appName = @"奇点资讯";
    CGFloat appNameLabelW = [appName sizeWithFont:[UIFont systemFontOfSize:LPFont2] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    CGFloat appNameLabelH = [appName sizeWithFont:[UIFont systemFontOfSize:LPFont2] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat appNameLabelX = (ScreenWidth - appNameLabelW) / 2;
    CGFloat appNameLabelY = CGRectGetMaxY(iconImage.frame) + 12;
    
    UILabel *appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(appNameLabelX, appNameLabelY, appNameLabelW, appNameLabelH)];
    appNameLabel.text = @"奇点资讯";
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    appNameLabel.textColor = [UIColor colorFromHexString:LPColor1];
    appNameLabel.font = [UIFont systemFontOfSize:LPFont2];
    [self.view addSubview:appNameLabel];
 
    // 版本
    NSString *versionText = [NSString stringWithFormat:@"V%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    CGFloat versionLabelW = [versionText sizeWithFont:[UIFont systemFontOfSize:LPFont2] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    CGFloat versionLabelH = [versionText sizeWithFont:[UIFont systemFontOfSize:LPFont2] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat versionLabelX = (ScreenWidth - versionLabelW) / 2;
    CGFloat versionLabelY = CGRectGetMaxY(appNameLabel.frame) + 27;
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(versionLabelX, versionLabelY, versionLabelW, versionLabelH)];
    versionLabel.text = versionText;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor colorFromHexString:LPColor2];
    versionLabel.font = [UIFont systemFontOfSize:LPFont2];
    [self.view addSubview:versionLabel];
    
    NSString *copyRightStr = @"Copyright ©2016 lieying.All Rights Reserved";
    CGFloat copyRightLabelW = [copyRightStr sizeWithFont:[UIFont systemFontOfSize:LPFont6] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    CGFloat copyRightLabelH = [copyRightStr sizeWithFont:[UIFont systemFontOfSize:LPFont6] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat copyRightLabelX = (ScreenWidth - copyRightLabelW) / 2;
    CGFloat copyRightLabelY = ScreenHeight - 16 - copyRightLabelH;
    
    
    UILabel *copyRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(copyRightLabelX, copyRightLabelY, copyRightLabelW, copyRightLabelH)];
    copyRightLabel.text = copyRightStr;
    copyRightLabel.textAlignment = NSTextAlignmentCenter;
    copyRightLabel.textColor = [UIColor colorFromHexString:LPColor4];
    copyRightLabel.font = [UIFont systemFontOfSize:LPFont6];
    [self.view addSubview:copyRightLabel];
    
    CGFloat lieyinImageW = 64;
    CGFloat lieyinImageH = 15;
    CGFloat lieyinImageX = (ScreenWidth - lieyinImageW) / 2;
    CGFloat lieyinImageY = CGRectGetMinY(copyRightLabel.frame) - 18 - lieyinImageH;
    UIImageView *lieyinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(lieyinImageX, lieyinImageY, lieyinImageW, lieyinImageH)];
    lieyinImageView.image = [UIImage imageNamed:@"个人中心猎鹰网络"];
    [self.view addSubview:lieyinImageView];
}

#pragma mark - backButtonDidClick
- (void)backButtonDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
