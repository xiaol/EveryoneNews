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
  #import "UIButton+WebCache.h"


@implementation LPHomeViewController (LaunchLoginManager)


- (void)viewDidAppear:(BOOL)animated{
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

#pragma mark - 设置用户头像
- (void)displayLoginBtnIconWithAccount:(Account *)account
{
    CGFloat statusBarHeight = 20.0f;
    CGFloat menuViewHeight = 44.0;
    
    CGFloat unloginBtnX = 15.0;
    CGFloat unloginBtnW = 16.0;
    CGFloat unloginBtnH = 16.0;
    if (iPhone6Plus) {
        unloginBtnX = 15.7f;
        unloginBtnW = 17.3f;
        unloginBtnH = 18.6f;
    } else if (iPhone5) {
        unloginBtnX = 15.0f;
        unloginBtnW = 16.0f;
        unloginBtnH = 16.0f;
    } else if (iPhone6) {
        menuViewHeight = 52;
        unloginBtnW = 18.0f;
        unloginBtnH = 18.0f;
        unloginBtnX = 17.0f;
    }
    
    
    CGFloat unloginBtnY = (menuViewHeight - unloginBtnH) / 2 + statusBarHeight;
    
    if (iPhone6) {
        unloginBtnY = unloginBtnY - 0.5;
    }
    
    // 用户未登录直接显示未登录图标
    if (account == nil) {
        self.loginBtn.layer.cornerRadius = 0;
        self.loginBtn.layer.borderWidth = 0;
        self.loginBtn.layer.masksToBounds = NO;
        
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"home_login"] forState:UIControlStateNormal];
        self.loginBtn.frame = CGRectMake(unloginBtnX , unloginBtnY , unloginBtnW, unloginBtnH);
    } else {
        CGFloat statusBarHeight = 20.0f;
        CGFloat menuViewHeight = 44.0;
        CGFloat loginBtnX = 10;
        CGFloat loginBtnW = 29;
        CGFloat loginBtnH = 29;
        
        if (iPhone6Plus) {
            loginBtnX = 10.0f;
        } else if (iPhone5) {
            loginBtnX = 10.0f;
            loginBtnW = 25;
            loginBtnH = 25;
        } else if (iPhone6) {
            loginBtnX = 12.0f;
            loginBtnW = 29;
            loginBtnH = 29;
            menuViewHeight = 52;
        }
        CGFloat loginBtnY = (menuViewHeight - loginBtnH) / 2 + statusBarHeight;
        
        [self.loginBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:account.userIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"登录icon"]];
        self.loginBtn.frame = CGRectMake(loginBtnX , loginBtnY , loginBtnW, loginBtnH);
        self.loginBtn.layer.cornerRadius = loginBtnH / 2;
        self.loginBtn.layer.borderWidth = 1;
        self.loginBtn.layer.masksToBounds = YES;
        self.loginBtn.layer.borderColor = [UIColor colorFromHexString:@"#e4e4e4"].CGColor;
      
    }
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
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"userId"] = accountEntity.usid;
            dict[@"userGender"] = @(0);
            dict[@"userName"] = accountEntity.userName;
            dict[@"userIcon"] = accountEntity.iconURL;
            dict[@"platformType"] = accountEntity.platformName;
            dict[@"deviceType"] = @"ios";
            dict[@"token"] = accountEntity.accessToken;
            dict[@"expiresTime"] = @([NSDate dateToMilliSeconds:accountEntity.expirationDate]);
            dict[@"uniqueDeviceID"] = [userDefaults objectForKey:@"uniqueDeviceID"];
            Account *account = [Account objectWithKeyValues:dict];
            [AccountTool saveAccount:account];
            
            // 显示头像
            [userDefaults setObject:@"1" forKey:@"uIconDisplay"];
            [userDefaults synchronize];
            
            self.loginView.hidden = YES;
            self.homeBlackBlurView.hidden = NO;
          
            //将用户授权信息上传到服务器
            NSMutableDictionary *paramsUser = [NSMutableDictionary dictionary];
            paramsUser[@"muid"] = ![userDefaults objectForKey:@"uid"] ? @(0):[userDefaults objectForKey:@"uid"];
            paramsUser[@"msuid"] = accountEntity.usid;
            
            // 3 微博  4 微信 (wxsession    sina)
            if([accountEntity.platformName isEqualToString:@"wxsession"]) {
                paramsUser[@"utype"] = @(4);
            } else if ([accountEntity.platformName isEqualToString:@"sina"]) {
                paramsUser[@"utype"] = @(3);
            }
            paramsUser[@"platform"] = @(1);
            paramsUser[@"suid"] =[NSString stringWithFormat:@"%@", accountEntity.usid ] ;
            paramsUser[@"stoken"] = accountEntity.accessToken;
            
            //用于格式化NSDate对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设置格式：zzz表示时区
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //NSDate转NSString
            NSString *currentDateString = [dateFormatter stringFromDate:accountEntity.expirationDate];
            paramsUser[@"sexpires"] = currentDateString;
            paramsUser[@"uname"] = accountEntity.userName;
            paramsUser[@"gender"] = @(0);
            paramsUser[@"avatar"] =  accountEntity.iconURL;
            paramsUser[@"province"] = @"";
            paramsUser[@"city"] = @"";
            paramsUser[@"district"] = @"";
         
            // 第三方注册
            NSString *url = [NSString stringWithFormat:@"%@/v2/au/sin/s", ServerUrlVersion2];
         
            [self displayLoginBtnIconWithAccount:[AccountTool account]];
            [LPHttpTool postJSONResponseAuthorizationWithURL:url params:paramsUser success:^(id json, NSString *authorization) {
                if ([json[@"code"] integerValue] == 2000) {
                    NSDictionary *dictData = (NSDictionary *)json[@"data"];
                    if ([[dictData[@"utype"] stringValue] isEqualToString:@"3"] || [[dictData[@"utype"] stringValue] isEqualToString:@"4"]) {
                        if (![userDefaults objectForKey:@"uid"]) {
                            [userDefaults setObject:dictData[@"uid"] forKey:@"uid"];
                        }
                    } else {
                        [userDefaults setObject:dictData[@"uid"] forKey:@"uid"];
                    }
                    [userDefaults setObject:@"1" forKey:@"uIconDisplay"];
                    
                    [userDefaults setObject:dictData[@"utype"] forKey:@"utype"];
                    [userDefaults setObject:authorization forKey:@"uauthorization"];
                    [userDefaults synchronize];
                 
                }
            } failure:^(NSError *error) {
                  NSLog(@"%@", error);
            }];
        } else {
            [MBProgressHUD showError:@"登录失败"];
        }
    });
}

@end
