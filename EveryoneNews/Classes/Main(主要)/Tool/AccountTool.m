//
//  AccountTool.m
//  EveryoneNews
//
//  Created by Feng on 15/6/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AccountTool.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD.h"
#import "Account.h"
#import "MJExtension.h"
#import "LoginViewController.h"
#import "LPHttpTool.h"
#import "UIImage+LP.h"
#import "LPHomeViewController.h"
#import "LPTabBarController.h"
#import "AppDelegate.h"
#import "NSDate+Extension.h"

@implementation AccountTool 

+ (void)accountLoginWithViewController:(UIViewController *)viewVc success:(void (^)())success failure:(void (^)()) failure cancel:(void (^)()) cancel
{
    Account *account=[self account];
    LoginViewController *loginVc=[[LoginViewController alloc] init];
    [loginVc setCallBackBlocks:success :failure :cancel];
    if (account==nil) {
        if ([viewVc isKindOfClass:[LPHomeViewController class]]) {
            LPTabBarController *tabbarVc = ((LPHomeViewController *)viewVc).tabBarVc;
            loginVc.headerBackgroundImage = [UIImage captureWithView:(UIView*)tabbarVc.customTabBar];
            loginVc.footerBackgroundImage = [UIImage captureWithView:viewVc.view];
        }else{
            loginVc.headerBackgroundImage=[UIImage captureWithView:viewVc.view];
        }

        [viewVc.navigationController pushViewController:loginVc animated:NO];
    }else{
        //如果已经授权登录，则判断是否过期
        if ([NSDate dateToMilliSeconds:[NSDate date]] > account.expiresTime.unsignedIntegerValue) {
            [viewVc.navigationController pushViewController:loginVc animated:NO];
        }
    }
}

- (void)accountLoginWithType:(AccountType) accountType completion:(void (^)(BOOL result)) callBackBlock{
    [ShareSDK getUserInfoWithType:(ShareType)accountType
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
     {

         if(result){
             //平台授权凭证协议
            id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:(ShareType)accountType];//平台类型
             NSMutableDictionary *dict = [NSMutableDictionary dictionary];
             dict[@"userId"] = userInfo.uid;
             dict[@"userGender"] = @(userInfo.gender);
             dict[@"userName"] = userInfo.nickname;
             dict[@"userIcon"] = userInfo.profileImage;
             dict[@"platformType"] = @(userInfo.type);
             dict[@"deviceType"] = @"ios";
             dict[@"token"] =credential.token;
             dict[@"expiresTime"] = @([NSDate dateToMilliSeconds:credential.expired]);
             Account *account = [Account objectWithKeyValues:dict];
         
             
             //将用户授权信息上传到服务器
             NSDictionary *params = [NSDictionary dictionary];
             params = account.keyValues;
             [LPHttpTool getWithURL:AccountLoginUrl params:params success:^(id json) {
                 [AccountTool saveAccount:account];
                 callBackBlock(YES);
             } failure:^(NSError *error) {
                 callBackBlock(NO);
             }];

         }else{
             NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
             callBackBlock(NO);
         }
         
         
     }];
}

+ (Account *)account{
    
    Account *account = [NSKeyedUnarchiver unarchiveObjectWithFile:kAccountSavePath];
    if (account) {
        //如果已经授权登录，则判断是否过期
        if ([NSDate dateToMilliSeconds:[NSDate date]] > account.expiresTime.unsignedIntegerValue) {
            return nil;
        }
    }
    return account;
}

+ (void)saveAccount:(Account *)account{
    [NSKeyedArchiver archiveRootObject:account toFile:kAccountSavePath];
}

+(void)deleteAccount{
    //1.删除授权信息
    Account *account=[self account];
    [ShareSDK cancelAuthWithType:account.platformType.intValue];

    //2.删除本地信息文件
    NSFileManager *fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:kAccountSavePath error:nil];
}

@end
