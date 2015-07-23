//
//  AppDelegate.m
//  EveryoneNews
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import "UIImageView+WebCache.h"
#import "LPNewfeatureViewController.h"
#import "MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import "MainNavigationController.h"
#import "MainViewController.h"
#import "LaunchViewController.h"

#define LaunchingDelay 4.5
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"%@", pasteboard.string);
    
    NSString *versionKey = (__bridge NSString *) kCFBundleVersionKey;
    NSString *lastVersion = [userDefaults objectForKey:versionKey];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    /** sharesdk 登录和分享相关*/
    [ShareSDK registerApp:@"838a81f341f0"];//字符串api20为您的ShareSDK的AppKey
    [ShareSDK ssoEnabled:YES];
    //    //添加新浪微博应用 注册网址 http://open.weibo.com
    //    [ShareSDK connectSinaWeiboWithAppKey:@"104745354"
    //                               appSecret:@"e0c793deeb71942132d76b985e3b45c4"
    //                             redirectUri:@"http://sns.whalecloud.com/sina2/callback"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台 （注意：2个方法只用写其中一个就可以）
    [ShareSDK connectSinaWeiboWithAppKey:@"104745354"
                               appSecret:@"e0c793deeb71942132d76b985e3b45c4"
                             redirectUri:@"http://sns.whalecloud.com/sina2/callback"];
        weiboSDKCls:[WeiboSDK class];
    //添加微信应用  http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wxc52863aa86154991"
                           appSecret:@"9fdec381aa4cf819acdb17ebea64bd70"
                           wechatCls:[WXApi class]];
    
    // 0. Umeng setup
#warning 发布时删除此句 setLogEnabled:
//    [MobClick setLogEnabled:YES];
    [MobClick setVersion:currentVersion];
    [MobClick startWithAppkey:@"558b2ec267e58e64a00009db" reportPolicy:BATCH channelId:@""];
    
    // 1. 注册APNs
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categorie
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }
#else
        //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
#endif
    [APService setupWithOption:launchOptions];
    
    // 2. 创建窗口
    [application setApplicationIconBadgeNumber:0];
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    [APService handleRemoteNotification:userInfo];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    LaunchViewController *launchVc = [[LaunchViewController alloc] init];
    
    //3. 设置根控制器
    if (userInfo[LPPushNotificationURL]) { // 如有推送 迅速处理推送
        MainViewController *mainVc = [[MainViewController alloc] init];
        MainNavigationController *mainNavVc = [[MainNavigationController alloc] initWithRootViewController:mainVc];
        self.window.rootViewController = mainNavVc;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [noteCenter postNotificationName:LPPushNotificationFromLaunching object:self userInfo:userInfo];
        });
    } else {
        if ([currentVersion isEqualToString:lastVersion]) { // 版本未更新
            self.window.rootViewController = launchVc;
        }else { // 版本更新
            self.window.rootViewController = [[LPNewfeatureViewController alloc] init];
            [userDefaults setObject:currentVersion forKey:versionKey];
            [userDefaults synchronize];
        }
    }
    
    // 4. 显示窗口（成为主窗口）
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 1.将token传给极光服务器
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [APService handleRemoteNotification:userInfo];
    /**
     *  处理推送
     */
    if (application.applicationState == UIApplicationStateBackground) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [noteCenter postNotificationName:LPPushNotificationFromBack object:self userInfo:userInfo];
        });
    }
    [application setApplicationIconBadgeNumber:0];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

/**sharesdk 登录和分享 需要*/
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}
/**sharesdk 登录和分享 需要*/
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}


@end
