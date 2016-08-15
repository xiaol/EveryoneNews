//
//  LPLoginFromSettingViewController.m
//  EveryoneNews
//
//  Created by dongdan on 16/8/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPLoginFromSettingViewController.h"
#import "Account.h"
#import "AccountTool.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "UMSocialAccountManager.h"
#import "MainNavigationController.h"
#import "WXApi.h"
#import "MBProgressHUD.h"
#import "MJExtension.h"
#import "LPHttpTool.h"
#import "NSDate+Extension.h"
#import "UMSocialDataService.h"
#import "AFNetworking.h"
#import "LPLoginTool.h"



@implementation LPLoginFromSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubViews];
}

- (void)setupSubViews {
    
    // 导航栏
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, ScreenWidth, TabBarHeight)];
    // 取消按钮
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 0, 100, TabBarHeight - 0.5)];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:LPFont3];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorFromHexString:LPColor1] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview: cancelButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, TabBarHeight - 0.5)];
    titleLabel.centerX = topView.centerX;
    titleLabel.text = @"奇点资讯";
    titleLabel.font = [UIFont systemFontOfSize:LPFont8];
    titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, TabBarHeight - 0.5, ScreenWidth, 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
    
    [topView addSubview:titleLabel];
    [topView addSubview:seperatorView];
    [self.view addSubview:topView];
    
    // 微信
    CGFloat weixinBtnW = 75;
    CGFloat weixinBtnH = 75;
    CGFloat padding = 76;
    CGFloat weixinBtnX = (ScreenWidth - weixinBtnW * 2 - padding) / 2;
    CGFloat weixinBtnY = StatusBarHeight + TabBarHeight + 75;
    
    UIButton *weixinBtn = [[UIButton alloc] init];
    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"微信登录"] forState:UIControlStateNormal];
    weixinBtn.frame = CGRectMake(weixinBtnX,weixinBtnY, weixinBtnW, weixinBtnH);
    [weixinBtn addTarget:self action:@selector(weixinLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinBtn];
    
    CGFloat weixinLabelHeight = [@"您好" heightForLineWithFont:[UIFont systemFontOfSize:LPFont4]];
    UILabel *weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(weixinBtnX, CGRectGetMaxY(weixinBtn.frame) + 14 , weixinBtnW, weixinLabelHeight)];
    weixinLabel.textAlignment = NSTextAlignmentCenter;
    weixinLabel.text = @"微信登录";
    weixinLabel.font = [UIFont systemFontOfSize:LPFont4];
    weixinLabel.textColor = [UIColor colorFromHexString:LPColor1];
    [self.view addSubview:weixinLabel];
    
    // 微博
    UIButton *weiboBtn = [[UIButton alloc] init];
    [weiboBtn setBackgroundImage:[UIImage imageNamed:@"微博登录"] forState:UIControlStateNormal];
    weiboBtn.frame = CGRectMake(ScreenWidth - weixinBtnX - weixinBtnW,weixinBtnY, weixinBtnW, weixinBtnH);
    [weiboBtn addTarget:self action:@selector(weiboLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboBtn];
    
    UILabel *weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - weixinBtnX - weixinBtnW, CGRectGetMaxY(weiboBtn.frame) + 14 , weixinBtnW, weixinLabelHeight)];
    weiboLabel.text = @"微博登录";
    weiboLabel.font = [UIFont systemFontOfSize:LPFont4];
    weiboLabel.textColor = [UIColor colorFromHexString:LPColor1];
    weiboLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:weiboLabel];
}

- (void)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 微信登录
- (void)weixinLogin:(UIButton *)weixinBtn {
    [self loginWithPlatformName:UMShareToWechatSession];
}

#pragma mark - 微博登录
- (void)weiboLogin:(UIButton *)weiboBtn {
    [self loginWithPlatformName:UMShareToSina];
}

#pragma mark - 登录微信微博平台
- (void)loginWithPlatformName:(NSString *)type {
    
    UMSocialSnsPlatform *platform = [UMSocialSnsPlatformManager getSocialPlatformWithName:type];
    UMSocialControllerService *service = [UMSocialControllerService defaultControllerService];
    service.socialUIDelegate = self;
    
    platform.loginClickHandler(self, service , YES ,^(UMSocialResponseEntity *response) {
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *accountEntity = [[UMSocialAccountManager socialAccountDictionary] valueForKey:type];
            // 保存友盟信息到本地
            [LPLoginTool saveAccountWithAccountEntity:accountEntity];
            
            NSMutableDictionary *paramsUser = [LPLoginTool registeredUserParamsWithAccountEntity:accountEntity];
            
            NSString *url = [NSString stringWithFormat:@"%@/v2/au/sin/s", ServerUrlVersion2];
            
            [LPHttpTool postJSONResponseAuthorizationWithURL:url params:paramsUser success:^(id json, NSString *authorization) {
                [LPLoginTool saveRegisteredUserInfoAndSendConcernNotification:json authorization:authorization];
                
                if ([json[@"code"] integerValue] == 2000) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            } failure:^(NSError *error) {
               
            }];
        }
    });
}

@end
