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
#import "LPHomeViewController.h"
#import "NSMutableAttributedString+LP.h"
#import "UMessage.h"
#import "LPFontSizeManager.h"

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

#define debug 0

#pragma mark - core data helper

// 获取CoreDataHelper实例
- (CoreDataHelper*)cdh {
    if (!_coreDataHelper) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _coreDataHelper = [[CoreDataHelper alloc] init];
        });
        [_coreDataHelper setupCoreData];
    }
    return _coreDataHelper;
}
//-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//    [UIView animateWithDuration:0.2
//                          delay:0
//                        options: UIViewAnimationCurveEaseIn // change effect here.
//                     animations:^{
//                         self.window.viewForBaselineLayout.alpha = 0; // and at this alpha
//                     }
//                     completion:^(BOOL finished){
//                     }];
//    
//    return YES;
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    //  UMeng login & share
    [UMSocialData setAppKey:@"558b2ec267e58e64a00009db"];
    
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"987333155" appKey:@"558b2ec267e58e64a00009db" url:@"http://www.umeng.com/social"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxdc962221a58b59a5" appSecret:@"f60087313b3d5c42115d6bd0c89abfb6" url:@"http://www.umeng.com/social"];
    
    // 打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.////whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
    
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
//    
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"
//secret:@"04b48b094faeb16683c32669824ebdad"
//RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    

    NSString *versionKey = (__bridge NSString *) kCFBundleVersionKey;
//    NSString *lastVersion = [userDefaults objectForKey:versionKey];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    // Mob statics
#warning 发布时删除此句 setLogEnabled:
//    [MobClick setLogEnabled:YES];
    
    [MobClick setVersion:(NSInteger)currentVersion];
    
    // 将channelId:@"Web" 中的Web 替换为您应用的推广渠道。channelId为nil或@""时，默认会被当作@"App Store"渠道。
    // iOS平台数据发送策略包括BATCH（启动时发送）和SEND_INTERVAL（按间隔发送）两种，友盟默认使用启动时发送（更省流量），您可以在代码reportPolicy:BATCH中更改发送策略。
    [MobClick startWithAppkey:@"558b2ec267e58e64a00009db" reportPolicy:BATCH channelId:@""];
    
//    // 添加友盟推送
//    [UMessage startWithAppkey:@"558b2ec267e58e64a00009db" launchOptions:launchOptions];
//    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
//    action1.identifier = @"action1_identifier";
//    action1.title = @"Accept";
//    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
//    
//    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
//    action2.identifier = @"action2_identifier";
//    action2.title = @"Reject";
//    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//    action2.destructive = YES;
//    
//    UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
//    categorys.identifier = @"category1";//这组动作的唯一标示
//    [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    
//    UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
//                                                                                 categories:[NSSet setWithObject:categorys]];
//    [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    
  
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //3. 设置根控制器
    LPHomeViewController *mainVc = [[LPHomeViewController alloc] init];
    MainNavigationController *mainNavVc = [[MainNavigationController alloc] initWithRootViewController:mainVc];
    self.window.rootViewController = mainNavVc;
    
    [[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
//        UIView *blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//        blurView.backgroundColor = [UIColor redColor];
//        [self.window addSubview:blurView];
    // 4. 显示窗口（成为主窗口）
    [self.window makeKeyAndVisible];
    
    

//    
    
//    [UIView animateWithDuration:0.3f animations:^{
//        
//    } completion:^(BOOL finished) {
//        [blurView removeFromSuperview];
//    }];
//    
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
    
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (kMainScreenHeight > 480) {
        myDelegate.autoSizeScaleX = kMainScreenWidth/320;
        myDelegate.autoSizeScaleY = kMainScreenHeight/568;
    }else{
        myDelegate.autoSizeScaleX = 1.0;
        myDelegate.autoSizeScaleY = 1.0;
    }
    
    


    if (![userDefaults objectForKey:@"uauthorization"]) {
        // 第一次进入存储游客Authorization
        NSString *url = @"http://bdp.deeporiginalx.com/v2/au/sin/g";
        NSMutableDictionary *paramUser = [NSMutableDictionary dictionary];
        // 2 游客用户
        paramUser[@"utype"] = @(2);
        // 1 iOS 平台
        paramUser[@"platform"] = @(1);
        paramUser[@"province"]  = @"";
        paramUser[@"city"] = @"";
        paramUser[@"district"] = @"";
        [LPHttpTool postJSONResponseAuthorizationWithURL:url params:paramUser success:^(id json, NSString *authorization) {
            if ([json[@"code"] integerValue] == 2000) {
                NSDictionary *dict = (NSDictionary *)json[@"data"];
                [userDefaults setObject:dict[@"uid"] forKey:@"uid"];
                [userDefaults setObject:dict[@"utype"] forKey:@"utype"];
                [userDefaults setObject:authorization forKey:@"uauthorization"];
                [userDefaults synchronize];
                
            
            }
        }  failure:^(NSError *error) {
            NSString *authorization = @"Basic YWlxZXZ+d35wcSdvNmR3amw0NHh1eGpycnZwNnZ0M2tpcXh2NDl1eHluc2M0KWlzZjByKmJqajR6KH4uJ242Kg";
            [userDefaults setObject:@"383" forKey:@"uid"];
            [userDefaults setObject:@"2" forKey:@"utype"];
            [userDefaults setObject:authorization forKey:@"uauthorization"];
            [userDefaults synchronize];
            NSLog(@"%@", error);
        }];
    }

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

- (void)application:(UIApplication*)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings{
    
    
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                  stringByReplacingOccurrencesOfString: @">" withString: @""]
//                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
    
//    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册推送服务时，发生以下错误： %@",error);
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
    if (![userDefaults objectForKey:@"isVersion3FirstLoad"]) {
        [userDefaults setObject:@"NO" forKey:@"isVersion3FirstLoad"];
        [userDefaults synchronize];
    }
    [[self cdh] saveBackgroundContext];
    [[LPFontSizeManager sharedManager] saveHomeViewFontSizeAndType];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (![userDefaults objectForKey:@"isVersion3FirstLoad"]) {
        [userDefaults setObject:@"NO" forKey:@"isVersion3FirstLoad"];
        [userDefaults synchronize];
    }
    [[self cdh] saveBackgroundContext];
    [[LPFontSizeManager sharedManager] saveHomeViewFontSizeAndType];
    
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

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"%@ %ld", NSStringFromSelector(_cmd), application.applicationState);
    
}

@end
