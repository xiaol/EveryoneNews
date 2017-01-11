//
//  AccountTool.h
//  EveryoneNews
// 用户登录管理的工具类
//  Created by Feng on 15/6/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
//#import "UMSocialSnsPlatformManager.h"

// 保存用户信息path
#define kAccountSavePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"account.data"]

typedef void (^LoginSuccessHandler)(Account *account);
typedef void (^LoginFailureHandler)();
typedef void (^LoginCancelHandler)();

@interface AccountTool : NSObject

//singleton_h(AccountTool);

// 判断当前用户是否登录
+ (void)accountLoginWithViewController:(UIViewController *)viewVc success:(LoginSuccessHandler)success failure:(LoginFailureHandler)failure cancel:(LoginCancelHandler)cancel;

// 保存用户信息到本地
+ (void)saveAccount:(Account *)account;

// 获取用户
+ (Account *)account;

// 删除已经保存的用户信息
+ (void)deleteAccount;
@end
