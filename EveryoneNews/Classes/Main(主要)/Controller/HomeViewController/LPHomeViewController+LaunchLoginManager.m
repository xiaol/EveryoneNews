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

@implementation LPHomeViewController (LaunchLoginManager)

#pragma mark - 设置登录页面
- (void)setupHomeViewLoginButton {
    CGFloat statusBarHeight = 20.0f;
    CGFloat menuViewHeight = 44.0f;
    if (iPhone6Plus) {
        menuViewHeight = 51;
    }
    // 登录按钮
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.enlargedEdge = 5.0;
    //如果用户已经登录则在右下角显示用户图像
    Account *account = [AccountTool account];

    CGFloat unloginBtnX = 18;
    CGFloat unloginBtnW = 18;
    CGFloat unloginBtnH = 18;
    CGFloat unloginBtnY = (menuViewHeight - unloginBtnH) / 2 + statusBarHeight;

    // 用户未登录直接显示未登录图标
    if (account == nil) {
        self.loginBtn.layer.cornerRadius = 0;
        self.loginBtn.layer.borderWidth = 0;
        self.loginBtn.layer.masksToBounds = NO;

        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"home_login"] forState:UIControlStateNormal];
         self.loginBtn.frame = CGRectMake(unloginBtnX , unloginBtnY , unloginBtnW, unloginBtnH);
    } else {
        [self displayLoginBtnIconWithAccount:account];
    }

    //[self.loginBtn addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 设置用户头像
- (void)displayLoginBtnIconWithAccount:(Account *)account
{
    __weak typeof(self) weakSelf = self;
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:account.userIcon] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image && finished) {
            CGFloat statusBarHeight = 20.0f;
            CGFloat menuViewHeight = 44.0f;
            if (iPhone6Plus) {
                menuViewHeight = 51;
            }
            CGFloat loginBtnX = 12;
            CGFloat loginBtnW = 29;
            CGFloat loginBtnH = 29;
            CGFloat loginBtnY = (menuViewHeight - loginBtnH) / 2 + statusBarHeight;
            [weakSelf.loginBtn setBackgroundImage:image forState:UIControlStateNormal];
            weakSelf.loginBtn.frame = CGRectMake(loginBtnX , loginBtnY , loginBtnW, loginBtnH);
            weakSelf.loginBtn.layer.cornerRadius = loginBtnH / 2;
            weakSelf.loginBtn.layer.borderWidth = 1;
            weakSelf.loginBtn.layer.masksToBounds = YES;
            weakSelf.loginBtn.layer.borderColor = [UIColor colorFromHexString:@"#e4e4e4"].CGColor;
        }
    }];
}

#pragma mark - 用户登录
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
- (void)didCloseLoginView:(LPLaunchLoginView *)loginView {
    self.loginView.hidden = YES;
    [self setHomeBlurViewFrame];
}

// 微信登录
- (void)didWeixinLoginWithLoginView:(LPLaunchLoginView *)loginView {

    [self loginWithPlatformName:UMShareToWechatSession];
     [self setHomeBlurViewFrame];
}

// 新浪登录
- (void)didSinaLoginWithLoginView:(LPLaunchLoginView *)loginView {
    [self loginWithPlatformName:UMShareToSina];
    [self setHomeBlurViewFrame];
}


- (void)setHomeBlurViewFrame {
    CGFloat changeFontSizeViewH = 150;
    self.homeBlurView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - changeFontSizeViewH);
  
}


#pragma mark - 登录微信微博平台
- (void)loginWithPlatformName:(NSString *)type {
    
    UMSocialSnsPlatform *platform = [UMSocialSnsPlatformManager getSocialPlatformWithName:type];
    UMSocialControllerService *service = [UMSocialControllerService defaultControllerService];
    service.socialUIDelegate = self;
    platform.loginClickHandler(self, service , YES ,^(UMSocialResponseEntity *response) {
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *accountEntity = [[UMSocialAccountManager socialAccountDictionary] valueForKey:type];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"userId"] = accountEntity.usid;
            dict[@"userGender"] = @(0);
            dict[@"userName"] = accountEntity.userName;
            dict[@"userIcon"] = accountEntity.iconURL;
            dict[@"platformType"] = accountEntity.platformName;
            dict[@"deviceType"] = @"ios";
            dict[@"token"] = accountEntity.accessToken;
            dict[@"expiresTime"] = @([NSDate dateToMilliSeconds:accountEntity.expirationDate]);
            Account *account = [Account objectWithKeyValues:dict];
            [AccountTool saveAccount:account];
            //将用户授权信息上传到服务器
            NSDictionary *params = [NSDictionary dictionary];
            params = account.keyValues;
            [LPHttpTool getWithURL:AccountLoginUrl params:params success:^(id json) {
                [AccountTool saveAccount:account];
                self.loginView.hidden = YES;
                [self displayLoginBtnIconWithAccount:[AccountTool account]];
                
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"登录失败"];
            }];
        } else {
            [MBProgressHUD showError:@"登录失败"];
        }
    });
}

@end
