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
//#import "WeiboSDK.h"
#import "WXApi.h"
#import "MainNavigationController.h"
#import "MainViewController.h"
#import "LaunchViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "AppDelegate+MOC.h"
#import "CoreDataHelper.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "WXApiObject.h"

////for mac
//#include <sys/socket.h>
//#include <sys/sysctl.h>
//#include <net/if.h>
//#include <net/if_dl.h>
//
////for idfa
//#import <AdSupport/AdSupport.h>

#define LaunchingDelay 4.5



NSString * const NetworkReachabilityDidChangeToReachableNotification = @"com.everyonenews.networkchangedtoreachable";

NSString * const AppDidReceiveReviewNotification = @"com.everyonenews.receive.a.review.notification";

NSString * const AppDidReceiveReviewUserDefaultKey = @"com.everyonenews.receive.a.review";

@interface AppDelegate () <WXApiDelegate>
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;
@end

@implementation AppDelegate

#define debug 1
#pragma mark - core data helper
// 获取CoreDataHelper实例
- (CoreDataHelper*)cdh {
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    if (!_coreDataHelper) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _coreDataHelper = [[CoreDataHelper alloc] init];
        });
        [_coreDataHelper setupCoreData];
    }
    return _coreDataHelper;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"pasteboard : %@", pasteboard.string);
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    //  UMeng login & share
    [UMSocialData setAppKey:@"558b2ec267e58e64a00009db"];
    
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"987333155" appKey:@"558b2ec267e58e64a00009db" url:@"http://www.umeng.com/social"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxdc962221a58b59a5" appSecret:@"f60087313b3d5c42115d6bd0c89abfb6" url:@"http://www.umeng.com/social"];
    
    //    打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.////whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
    
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    NSString *versionKey = (__bridge NSString *) kCFBundleVersionKey;
//    NSString *lastVersion = [userDefaults objectForKey:versionKey];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    // Mob statics
#warning 发布时删除此句 setLogEnabled:
//    [MobClick setLogEnabled:YES];
    [MobClick setVersion:currentVersion];
    [MobClick startWithAppkey:@"558b2ec267e58e64a00009db" reportPolicy:BATCH channelId:@"pb"];
    
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
    if (!iPhone4 && !iPhone5 && !iPhone6 && !iPhone6Plus) {
        MainViewController *mainVc = [[MainViewController alloc] init];
        MainNavigationController *mainNavVc = [[MainNavigationController alloc] initWithRootViewController:mainVc];
        self.window.rootViewController = mainNavVc;
    } else {
        if (userInfo[LPPushNotificationURL]) { // 如有推送 迅速处理推送
            MainViewController *mainVc = [[MainViewController alloc] init];
            MainNavigationController *mainNavVc = [[MainNavigationController alloc] initWithRootViewController:mainVc];
            self.window.rootViewController = mainNavVc;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [noteCenter postNotificationName:LPPushNotificationFromLaunching object:self userInfo:userInfo];
            });
        } else {
//            if ([currentVersion isEqualToString:lastVersion]) { // 版本未更新
//                self.window.rootViewController = launchVc;
                MainViewController *mainVc = [[MainViewController alloc] init];
                MainNavigationController *mainNavVc = [[MainNavigationController alloc] initWithRootViewController:mainVc];
                self.window.rootViewController = mainNavVc;
//            }else { // 版本更新
//                self.window.rootViewController = [[LPNewfeatureViewController alloc] init];
//                [userDefaults setObject:currentVersion forKey:versionKey];
//                [userDefaults synchronize];
//            }
        }
    }
    
    // 4. 显示窗口（成为主窗口）
    [self.window makeKeyAndVisible];
    
    // 5. 监控网络状态
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _networkStatus = status;
        });
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                [MBProgressHUD showError:@"网络连接中断"];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
            default:
                break;
        }
    }];
    [noteCenter addObserver:self selector:@selector(networkChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [mgr startMonitoring];
    
    // 6. 判断是否要弹出真实头像框, 如需, 发通知
    [self checkoutAppReview];
    return YES;
}

- (void)networkChange:(NSNotification *)note {
    NSDictionary *info = note.userInfo;
    NSNumber *changeItem = info[AFNetworkingReachabilityNotificationStatusItem];
    AFNetworkReachabilityStatus changedStatus = [changeItem integerValue];
    // 根据先前状态_networkStatus和当前状态changedStatus 发送通知
    if (_networkStatus <= 0 && changedStatus > 0) {
        [noteCenter postNotificationName:NetworkReachabilityDidChangeToReachableNotification object:nil];
    }
    _networkStatus = changedStatus;
}

- (void)checkoutAppReview {
    NSNumber *review = [userDefaults objectForKey:AppDidReceiveReviewUserDefaultKey];
    if (review && !review.boolValue) {
        [userDefaults setObject:@(YES) forKey:AppDidReceiveReviewUserDefaultKey];
        [userDefaults synchronize];
        [noteCenter postNotificationName:AppDidReceiveReviewNotification object:nil];
    }
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
//    return [ShareSDK handleOpenURL:url
//                        wxDelegate:nil];
    return [UMSocialSnsService handleOpenURL:url];
}
/**sharesdk 登录和分享 需要*/
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{

    return [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [[self cdh] saveBackgroundContext];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [[self cdh] saveBackgroundContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self checkoutAppReview];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self cdh];
}

@end
