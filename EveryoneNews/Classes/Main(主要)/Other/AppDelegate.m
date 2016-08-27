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
#import "AccountTool.h"
#import "Account.h"
#import "NSDate+Extension.h"
#import "LPLoginTool.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "LPDetailViewController.h"
#import "LPSearchViewController.h"

////for mac
//#include <sys/socket.h>
//#include <sys/sysctl.h>
//#include <net/if.h>
//#include <net/if_dl.h>
//
////for idfa
//#import <AdSupport/AdSupport.h>


NSString * const NetworkReachabilityDidChangeToReachableNotification = @"com.everyonenews.networkchangedtoreachable";

NSString * const AppDidReceiveReviewNotification = @"com.everyonenews.receive.a.review.notification";

NSString * const AppDidReceiveReviewUserDefaultKey = @"com.everyonenews.receive.a.review";

@interface AppDelegate () <WXApiDelegate>
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;
@property (nonatomic, strong) MainNavigationController *mainNavVc;
@property (nonatomic, strong) NSDictionary *userInfo;

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


#pragma mark - didFinishLaunchingWithOptions
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    if ([userDefaults objectForKey:LPIsVersionFirstLoad] && [userDefaults objectForKey:@"uIconDisplay"]) {
        // 防止并发 延迟执行
        [LPLoginTool loginVerify];
    }
    // 崩溃日志
    [Fabric with:@[[Crashlytics class]]];
    
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    // 设置友盟相关参数
    [self setupUMengInfo:launchOptions];
    
    NSDictionary *remoteNotificationDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    LPHomeViewController *mainVc = [[LPHomeViewController alloc] init];
    MainNavigationController *mainNavVc = [[MainNavigationController alloc] initWithRootViewController:mainVc];

    // 推送成功直接跳转到详情页面
    if (remoteNotificationDict) {
        LPDetailViewController *detailVC = [[LPDetailViewController alloc] init];
        detailVC.sourceViewController = remoteNotificationSource;
        NSString *remotePushNid = [remoteNotificationDict objectForKey:@"nid"];
        detailVC.remotePushNid = remotePushNid;
        mainNavVc.viewControllers = @[mainVc, detailVC];
        self.window.rootViewController = mainNavVc;
        [mainNavVc.navigationController pushViewController:detailVC animated:YES];
    } else {
         self.window.rootViewController = mainNavVc;
    }
    
    
    [[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    //  显示窗口（成为主窗口）
    [self.window makeKeyAndVisible];
    
    // 监控网络状态
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
    
    // 判断是否要弹出真实头像框, 如需, 发通知
    [self checkoutAppReview];
    
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (kMainScreenHeight > 480) {
        myDelegate.autoSizeScaleX = kMainScreenWidth/320;
        myDelegate.autoSizeScaleY = kMainScreenHeight/568;
    }else{
        myDelegate.autoSizeScaleX = 1.0;
        myDelegate.autoSizeScaleY = 1.0;
    }
    
    // 设置启动动画
    [self setupLaunchAnimation];

    // 设置游客身份
    [self setupTourist];
    
    [self checkVersion:application];
     return YES;
}

#pragma mark - 检查版本信息
- (void)checkVersion:(UIApplication *)application {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/lookup?id=987333155"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!data || error) return;
        
        NSArray *array = [(NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] valueForKey:@"results"];
        NSDictionary *dict = array.firstObject;
        NSString *releaseNotes = dict[@"releaseNotes"];
        NSURL *trackViewURL = [NSURL URLWithString:dict[@"trackViewUrl"]];
        NSString *storeVersion = dict[@"version"];
        
        NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
        NSString *currentVersion = infoDict[@"CFBundleShortVersionString"];
        
        // 当前版本号比App Store上小
        if ([currentVersion floatValue] < [storeVersion floatValue] ) {
            NSString *title = [NSString stringWithFormat:@"新版本提示:%@", storeVersion];
            NSString *message = [NSString stringWithFormat:@"新特性:\n%@", releaseNotes];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController =
                [UIAlertController alertControllerWithTitle:title
                                                    message:message
                                             preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:nil];
                UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"升级"
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                                         if ([application canOpenURL:trackViewURL]) {
                                                                             [application openURL:trackViewURL];
                                                                         }
                                                                     }];
                [alertController addAction:cancelAction];
                [alertController addAction:updateAction];
                [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
            });
        }
    }];
    [dataTask resume];
}

#pragma mark - 友盟相关设置
- (void)setupUMengInfo:(NSDictionary *)launchOptions {
    //  UMeng login & share
    [UMSocialData setAppKey:@"558b2ec267e58e64a00009db"];
    
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"987333155" appKey:@"558b2ec267e58e64a00009db" url:@"http://www.umeng.com/social"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxdc962221a58b59a5" appSecret:@"f60087313b3d5c42115d6bd0c89abfb6" url:@"http://www.umeng.com/social"];
    
    // 打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.////whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
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
    
    // 添加友盟推送
    [UMessage startWithAppkey:@"558b2ec267e58e64a00009db" launchOptions:launchOptions];
    //1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
    [UMessage registerForRemoteNotifications];
}

#pragma mark - 设置启动动画
- (void)setupLaunchAnimation {
    CGSize viewSize = self.window.bounds.size;
    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
    NSString *launchImage = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    launchView.frame = self.window.bounds;
    launchView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.window addSubview:launchView];
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         launchView.alpha = 0.0f;
                         launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
                         
                     }
                     completion:^(BOOL finished) {
                         [launchView removeFromSuperview];
                         
                     }];
    
}

#pragma mark - 设置游客身份
- (void)setupTourist {
    // 头像  1显示  2不显示
    if (![userDefaults objectForKey:LPIsVersionFirstLoad] || ![userDefaults objectForKey:@"uauthorization"]) {
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
                [userDefaults setObject:@"2" forKey:@"uIconDisplay"];
                [userDefaults setObject:dict[@"utype"] forKey:@"utype"];
                [userDefaults setObject:dict[@"password"] forKey:@"password"];
                [userDefaults setObject:authorization forKey:@"uauthorization"];
                [userDefaults synchronize];
            }
        }  failure:^(NSError *error) {
            
        }];
    }
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSLog(@"push token:%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                  stringByReplacingOccurrencesOfString: @">" withString: @""]
//                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandlern {

//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //关闭友盟对话框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    self.userInfo = userInfo;
    // 自动跳转到详情页面
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        [self redirectToDetailController];
        
    } else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            [self redirectToDetailController];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"奇点资讯"
                                                         message:@"您收到一条消息"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:@"取消",nil];
        [alert show];
    }
 
}


#pragma mark - 弹出窗体
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [UMessage sendClickReportForRemoteNotification:self.userInfo];
        [self redirectToDetailController];
    } else {
        [alertView removeFromSuperview];
    }
  

}

#pragma mark - 自动跳转到详情页
- (void)redirectToDetailController {
    LPHomeViewController *mainVc = [[LPHomeViewController alloc] init];
    MainNavigationController *mainNavVc = [[MainNavigationController alloc] initWithRootViewController:mainVc];
    LPDetailViewController *detailVC = [[LPDetailViewController alloc] init];
    detailVC.sourceViewController = remoteNotificationSource;
    NSString *remotePushNid = [self.userInfo objectForKey:@"nid"];
    detailVC.remotePushNid = remotePushNid;
    
    mainNavVc.viewControllers = @[mainVc, detailVC];
    self.window.rootViewController = mainNavVc;
    [mainNavVc.navigationController pushViewController:detailVC animated:YES];
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
    if (![userDefaults objectForKey:LPIsVersionFirstLoad]) {
        [userDefaults setObject:@"NO" forKey:LPIsVersionFirstLoad];
        [userDefaults synchronize];
    }
    [[self cdh] saveBackgroundContext];
    [[LPFontSizeManager sharedManager] saveHomeViewFontSizeAndType];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (![userDefaults objectForKey:LPIsVersionFirstLoad]) {
        [userDefaults setObject:@"NO" forKey:LPIsVersionFirstLoad];
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
//    NSLog(@"%@ %ld", NSStringFromSelector(_cmd), application.applicationState);
    
}

@end
