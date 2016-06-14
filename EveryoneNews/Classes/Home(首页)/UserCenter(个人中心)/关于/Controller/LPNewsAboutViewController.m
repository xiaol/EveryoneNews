//
//  LPNewsAboutViewController.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsAboutViewController.h"
#import "LPNewsMineViewController.h"

@interface LPNewsAboutViewController(){
    UIImageView *iconImage;
    UILabel *appNameLabel;
    UILabel *versionLabel;
    UIImageView *LPNetImage;
    UILabel *copyRightLabel;
}

@end

@implementation LPNewsAboutViewController


#pragma mark-  ViewLife Cycle

- (void)viewDidLoad{
    [super viewDidLoad];
//    [self setNavTitleView:@"关于"];
//    
//    [self backImageItem];
    self.view.backgroundColor = [UIColor colorWithDesignIndex:9];
    self.view.backgroundColor = [UIColor colorWithDesignIndex:9];
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
    [backButton addTarget:self action:@selector(topViewBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
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
    
    [self addAboutWebView];

}

- (void)topViewBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark- private methods

-(void)addAboutWebView{
    
    double topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
    if (iPhone6) {
        topViewHeight = 72;
    }
    iconImage = [[UIImageView alloc] init];
    [iconImage setImage:[UIImage imageNamed:@"LP_icon"]];
    [self.view addSubview:iconImage];
    __weak __typeof(self)weakSelf = self;
    [iconImage mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.view);
        make.top.equalTo(strongSelf.view).with.offset(topViewHeight + 74);
    }];
    
    appNameLabel = [[UILabel alloc] init];
    appNameLabel.text = @"奇点资讯";
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    appNameLabel.textColor = [UIColor colorWithDesignIndex:1];
    appNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:38.f/fontSizePxToSystemMultiple];
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:appNameLabel.text attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:38.f/fontSizePxToSystemMultiple]}];
    [self.view addSubview:appNameLabel];
    [appNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr.size.width), ceilf(attStr.size.height)));
        make.centerX.equalTo(strongSelf.view);
        make.top.equalTo(iconImage.mas_bottom).with.offset(12);
    }];

    versionLabel = [[UILabel alloc] init];
    NSString *versionText = [NSString stringWithFormat:@"V%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    versionLabel.text = versionText;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor colorWithDesignIndex:2];
    versionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:38.f/fontSizePxToSystemMultiple];
    NSAttributedString *attStr1 = [[NSAttributedString alloc] initWithString:versionLabel.text attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:40.f/fontSizePxToSystemMultiple]}];
    [self.view addSubview:versionLabel];
    [versionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr1.size.width), ceilf(attStr.size.height)));
        make.centerX.equalTo(strongSelf.view);
        make.top.equalTo(appNameLabel.mas_bottom).with.offset(27);
    }];
    
    copyRightLabel = [[UILabel alloc] init];
    copyRightLabel.text = @"Copyright ©2016 lieying.All Rights Reserved";
    copyRightLabel.textAlignment = NSTextAlignmentCenter;
    copyRightLabel.textColor = [UIColor colorWithDesignIndex:4];
    copyRightLabel.font = [UIFont boldSystemFontOfSize:24.f/fontSizePxToSystemMultiple];
    NSAttributedString *attStr2 = [[NSAttributedString alloc] initWithString:copyRightLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:26.f/fontSizePxToSystemMultiple]}];
    [self.view addSubview:copyRightLabel];
    [copyRightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr2.size.width), ceilf(attStr.size.height)));
        make.centerX.equalTo(strongSelf.view);
        make.bottom.equalTo(strongSelf.view.mas_bottom).with.offset(-14);
    }];
    
    LPNetImage = [[UIImageView alloc] init];
    [LPNetImage setImage:[UIImage imageNamed:@"LP_net"]];
    [self.view addSubview:LPNetImage];
    [LPNetImage mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.view);
        make.bottom.equalTo(copyRightLabel.mas_top).with.offset(-16);
    }];
                              
}



@end
