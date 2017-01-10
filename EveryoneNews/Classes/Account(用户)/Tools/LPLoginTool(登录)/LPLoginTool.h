//
//  LPLoginTool.h
//  EveryoneNews
//
//  Created by dongdan on 16/6/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;
@class UMSocialUserInfoResponse;
@interface LPLoginTool : NSObject

// 验证当前用户token是否过期
+ (void)loginVerify;

// 保存注册用户信息
+ (void)saveRegisteredUserInfo:(id)json authorization:(NSString *)authorization;

// 保存游客信息
+ (void)saveTouristInfo:(id)json authorization:(NSString *)authorization;

// 返回游客登录参数
+ (NSMutableDictionary *)touristParams;

// 返回注册用户参数
+ (NSMutableDictionary *)registeredUserParamsWithAccount:(Account *)account;

// 将友盟返回的信息保存在本地
+ (void)saveAccountWithAccountEntity:(UMSocialUserInfoResponse *)accountEntity;

// 将友盟返回的信息保存在本地并返回本地存储对象
+ (Account *)returnAccountAndSaveAccountWithAccountEntity:(UMSocialUserInfoResponse *)accountEntity;

// 根据友盟用户实体返回本地注册用户参数
+ (NSMutableDictionary *)registeredUserParamsWithAccountEntity:(UMSocialUserInfoResponse *)accountEntity;

// 请求第三方注册接口，更新本地第三方用户信息，获取关注频道列表信息
+ (void)registeredUserPostToServerAndGetConcernList:(NSMutableDictionary *)paramsUser;

// 保存注册用户信息，发送关注通知
+ (void)saveRegisteredUserInfoAndSendConcernNotification:(id)json authorization:(NSString *)authorization;

@end
