//
//  LPLoginTool.m
//  EveryoneNews
//
//  Created by dongdan on 16/6/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPLoginTool.h"
#import "AccountTool.h"
#import "Account.h"
#import "NSDate+Extension.h"
#import "LPHttpTool.h"
#import <UMSocialCore/UMSocialCore.h>
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation LPLoginTool

#pragma mark - 重新验证当前用户身份 防止Authorization过期
+ (void)loginVerify {
    // 如果是游客用户则重新注册
    if ([[[userDefaults objectForKey:@"utype"] stringValue] isEqualToString:@"2"]) {
        // 第一次进入存储游客Authorization
        NSString *url = [NSString stringWithFormat:@"%@/v2/au/sin/g", ServerUrlVersion2];
        NSMutableDictionary *paramUser = [LPLoginTool touristParams];
        [LPHttpTool postJSONResponseAuthorizationWithURL:url params:paramUser success:^(id json, NSString *authorization) {
            
            [LPLoginTool saveTouristInfo:json authorization:authorization];
        }  failure:^(NSError *error) {
            
        }];
    }
    // 如果是第三方用户则调用第三方注册接口
    else if ([[[userDefaults objectForKey:@"utype"] stringValue] isEqualToString:@"3"] || [[[userDefaults objectForKey:@"utype"] stringValue] isEqualToString:@"4"] ) {
        
        Account *account = [AccountTool account];
        NSMutableDictionary *paramsUser =  [LPLoginTool registeredUserParamsWithAccount:account];
        
        // 第三方注册
        NSString *url = [NSString stringWithFormat:@"%@/v2/au/sin/s", ServerUrlVersion2];
        
        [LPHttpTool postJSONResponseAuthorizationWithURL:url params:paramsUser success:^(id json, NSString *authorization) {
            [LPLoginTool saveRegisteredUserInfo:json authorization:authorization];
        } failure:^(NSError *error) {
            
        }];
        
    }
}

// 保存注册用户信息
+ (void)saveRegisteredUserInfo:(id)json  authorization:(NSString *)authorization {
    if ([json[@"code"] integerValue] == 2000) {
        NSDictionary *dictData = (NSDictionary *)json[@"data"];
        [userDefaults setObject:@"1" forKey:@"uIconDisplay"];
        [userDefaults setObject:dictData[@"uid"] forKey:@"uid"];
        [userDefaults setObject:dictData[@"utype"] forKey:@"utype"];
        [userDefaults setObject:authorization forKey:@"uauthorization"];
        [userDefaults synchronize];
    }
}

// 保存游客信息
+ (void)saveTouristInfo:(id)json authorization:(NSString *)authorization {
    if ([json[@"code"] integerValue] == 2000) {
        NSDictionary *dict = (NSDictionary *)json[@"data"];
        [userDefaults setObject:dict[@"uid"] forKey:@"uid"];
        [userDefaults setObject:@"2" forKey:@"uIconDisplay"];
        [userDefaults setObject:dict[@"utype"] forKey:@"utype"];
        [userDefaults setObject:dict[@"password"] forKey:@"password"];
        [userDefaults setObject:authorization forKey:@"uauthorization"];
        [userDefaults synchronize];
        
    }
}

// 返回游客登录参数
+ (NSMutableDictionary *)touristParams {
    NSMutableDictionary *paramUser = [NSMutableDictionary dictionary];
    // 游客用户
    paramUser[@"utype"] = @(2);
    // iOS 平台
    paramUser[@"platform"] = @(1);
    paramUser[@"province"]  = @"";
    paramUser[@"city"] = @"";
    paramUser[@"district"] = @"";
    return paramUser;
}

// 返回注册用户参数
+ (NSMutableDictionary *)registeredUserParamsWithAccount:(Account *)account {
    //将用户授权信息上传到服务器
    NSMutableDictionary *paramsUser = [NSMutableDictionary dictionary];
    paramsUser[@"muid"] = ![userDefaults objectForKey:@"uid"] ? @(0):[userDefaults objectForKey:@"uid"];
    paramsUser[@"msuid"] = account.userId;
    paramsUser[@"utype"] = [userDefaults objectForKey:@"utype"];
    paramsUser[@"platform"] = @(1);
    paramsUser[@"suid"] = [NSString stringWithFormat:@"%@", account.userId ] ;
    paramsUser[@"stoken"] = account.token;
    
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate getDateTimeFromMilliSeconds:account.expiresTime.unsignedIntegerValue]];
    paramsUser[@"sexpires"] = currentDateString;
    paramsUser[@"uname"] = account.userName;
    paramsUser[@"gender"] = @(0);
    paramsUser[@"avatar"] =  account.userIcon;
    paramsUser[@"province"] = @"";
    paramsUser[@"city"] = @"";
    paramsUser[@"district"] = @"";
    return paramsUser;
}

// 将友盟返回的信息保存在本地
+ (void)saveAccountWithAccountEntity:(UMSocialUserInfoResponse *)accountEntity {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"userId"] = accountEntity.uid;
    dict[@"userGender"] = @(0);
    dict[@"userName"] = accountEntity.name;
    dict[@"userIcon"] = accountEntity.iconurl;
    dict[@"platformType"] = @(accountEntity.platformType);
    dict[@"deviceType"] = @"ios";
    dict[@"token"] = accountEntity.accessToken;
    dict[@"expiresTime"] = @([NSDate dateToMilliSeconds:accountEntity.expiration]);
    
    // 保存用户信息到本地
    Account *account = [Account objectWithKeyValues:dict];
    [AccountTool saveAccount:account];
    
}

// 将友盟返回的信息保存在本地并返回本地存储对象
+ (Account *)returnAccountAndSaveAccountWithAccountEntity:(UMSocialUserInfoResponse *)accountEntity {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"userId"] = accountEntity.uid;
    dict[@"userGender"] = @(0);
    dict[@"userName"] = accountEntity.name;
    dict[@"userIcon"] = accountEntity.iconurl;
    dict[@"platformType"] = @(accountEntity.platformType);
    dict[@"deviceType"] = @"ios";
    dict[@"token"] = accountEntity.accessToken;
    dict[@"expiresTime"] = @([NSDate dateToMilliSeconds:accountEntity.expiration]);
    
    // 保存用户信息到本地
    Account *account = [Account objectWithKeyValues:dict];
    [AccountTool saveAccount:account];
    return account;
}

// 根据友盟用户实体返回本地注册用户参数
+ (NSMutableDictionary *)registeredUserParamsWithAccountEntity:(UMSocialUserInfoResponse *)accountEntity {
    NSMutableDictionary *paramsUser = [NSMutableDictionary dictionary];
    paramsUser[@"muid"] = [userDefaults objectForKey:@"uid"];
    paramsUser[@"msuid"] = accountEntity.uid;
    
    // 3 微博  4 微信 (wxsession    sina)
    if(accountEntity.platformType == UMSocialPlatformType_WechatSession) {
        paramsUser[@"utype"] = @(4);
    } else if (accountEntity.platformType == UMSocialPlatformType_Sina) {
        paramsUser[@"utype"] = @(3);
    }
    paramsUser[@"platform"] = @(1);
    paramsUser[@"suid"] =[NSString stringWithFormat:@"%@", accountEntity.uid ] ;
    paramsUser[@"stoken"] = accountEntity.accessToken;
    
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:accountEntity.expiration];
    paramsUser[@"sexpires"] = currentDateString;
    paramsUser[@"uname"] = accountEntity.name;
    paramsUser[@"gender"] = @(0);
    paramsUser[@"avatar"] =  accountEntity.iconurl;
    paramsUser[@"province"] = @"";
    paramsUser[@"city"] = @"";
    paramsUser[@"district"] = @"";
    return paramsUser;
}

// 请求第三方注册接口，更新本地第三方用户信息，获取关注频道列表信息
+ (void)registeredUserPostToServerAndGetConcernList:(NSMutableDictionary *)paramsUser {
    
    NSString *url = [NSString stringWithFormat:@"%@/v2/au/sin/s", ServerUrlVersion2];
    [LPHttpTool postJSONResponseAuthorizationWithURL:url params:paramsUser success:^(id json, NSString *authorization) {
        [LPLoginTool saveRegisteredUserInfoAndSendConcernNotification:json authorization:authorization];
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

// 保存注册用户信息，发送关注通知
+ (void)saveRegisteredUserInfoAndSendConcernNotification:(id)json authorization:(NSString *)authorization {
    if ([json[@"code"] integerValue] == 2000) {
        NSDictionary *dictData = (NSDictionary *)json[@"data"];
        [userDefaults setObject:dictData[@"uid"] forKey:@"uid"];
        [userDefaults setObject:@"1" forKey:@"uIconDisplay"];
        [userDefaults setObject:dictData[@"utype"] forKey:@"utype"];
        [userDefaults setObject:authorization forKey:@"uauthorization"];
        [userDefaults synchronize];
        [noteCenter postNotificationName:LPLoginNotification object:nil];
    } else {
        [MBProgressHUD showError:@"登录失败"];
    }
}

@end
