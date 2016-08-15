//
//  LPHomeViewController+HomeViewLoginManager.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPHomeViewController+LaunchLoginManager.h"
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

@implementation LPHomeViewController (LaunchLoginManager)

#pragma mark - viewDidAppear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    Account *account = [AccountTool account];
    [self displayLoginBtnIconWithAccount:account];
  
}

#pragma mark - 设置登录页面
- (void)setupHomeViewLoginButton {
    // 登录按钮
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.enlargedEdge = 5.0;
}



#pragma mark - 用户退出登录
- (void)userLogin:(UIButton *)loginBtn {
    if ([AccountTool account]!= nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"退出登录后无法进行评论哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    } else {
        [AccountTool accountLoginWithViewController:self success:^(Account *account) {
            [MBProgressHUD showSuccess:@"登录成功"];
        } failure:^{
            [MBProgressHUD showError:@"登录失败"];
        } cancel:^{

        }];
    }
}

#pragma mark - LPLaunchLoginView Delegate

// 随便看看
- (void)didCloseLoginView:(LPLaunchLoginView *)loginView {
    
    self.loginView.hidden = YES;
    self.homeBlackBlurView.hidden = NO;
}

// 微信登录
- (void)didWeixinLoginWithLoginView:(LPLaunchLoginView *)loginView {
    
    [self loginWithPlatformName:UMShareToWechatSession];
 
}

// 新浪登录
- (void)didSinaLoginWithLoginView:(LPLaunchLoginView *)loginView {
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
          
            // 隐藏登录视图
            self.loginView.hidden = YES;
            self.homeBlackBlurView.hidden = NO;
            
            //将用户授权信息上传到服务器
            NSMutableDictionary *paramsUser = [LPLoginTool registeredUserParamsWithAccountEntity:accountEntity];
            [LPLoginTool registeredUserPostToServerAndGetConcernList:paramsUser];
            
        } else {
            [MBProgressHUD showError:@"登录失败"];
        }
    });
}

@end
