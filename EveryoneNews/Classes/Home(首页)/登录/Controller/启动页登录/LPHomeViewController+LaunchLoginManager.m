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
#import "LPLoginTool.h"
#import "LPSubscribeView.h"
#import "LPSubscriber.h"
#import "LPSubscriberFrame.h"

@implementation LPHomeViewController (LaunchLoginManager)

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
            // 保存友盟信息到本地
            [LPLoginTool saveAccountWithAccountEntity:accountEntity];
          
            // 隐藏登录视图
            self.loginView.hidden = YES;
            self.homeBlackBlurView.hidden = NO;
            
            [self setupSubscriberData];
            
            // 动态添加首订，完成后移除
            LPSubscribeView *subscribeView = [[LPSubscribeView alloc] initWithFrame:self.view.bounds];
            subscribeView.subscriberFrames = self.subscriberFrameArray;
            [self.view addSubview:subscribeView];
            
            
            //将用户授权信息上传到服务器
            NSMutableDictionary *paramsUser = [LPLoginTool registeredUserParamsWithAccountEntity:accountEntity];
            [LPLoginTool registeredUserPostToServerAndGetConcernList:paramsUser];
            
        } else {
            [MBProgressHUD showError:@"登录失败"];
        }
    });
}

- (void)setupSubscriberData {
    LPSubscriber *subscriber1 = [[LPSubscriber alloc] initWithTitle:@"36氪" imageURL:@"36氪"];
    LPSubscriber *subscriber2 = [[LPSubscriber alloc] initWithTitle:@"爱范儿" imageURL:@"爱范儿"];
    LPSubscriber *subscriber3 = [[LPSubscriber alloc] initWithTitle:@"半糖" imageURL:@"半糖"];
    LPSubscriber *subscriber4 = [[LPSubscriber alloc] initWithTitle:@"北美省钱快报" imageURL:@"北美省钱快报"];
    LPSubscriber *subscriber5 = [[LPSubscriber alloc] initWithTitle:@"别致" imageURL:@"别致"];
    LPSubscriber *subscriber6 = [[LPSubscriber alloc] initWithTitle:@"财新周刊" imageURL:@"财新周刊"];
    LPSubscriber *subscriber7 = [[LPSubscriber alloc] initWithTitle:@"第一财经周刊" imageURL:@"第一财经周刊"];
    LPSubscriber *subscriber8 = [[LPSubscriber alloc] initWithTitle:@"豆瓣东西" imageURL:@"豆瓣东西"];
    LPSubscriber *subscriber9 = [[LPSubscriber alloc] initWithTitle:@"豆瓣一刻" imageURL:@"豆瓣一刻"];
    LPSubscriber *subscriber10 = [[LPSubscriber alloc] initWithTitle:@"毒舌指南" imageURL:@"毒舌指南"];
    LPSubscriber *subscriber11 = [[LPSubscriber alloc] initWithTitle:@"国家地理" imageURL:@"国家地理"];
    LPSubscriber *subscriber12 = [[LPSubscriber alloc] initWithTitle:@"果壳精选" imageURL:@"果壳精选"];
    LPSubscriber *subscriber13 = [[LPSubscriber alloc] initWithTitle:@"果库" imageURL:@"果库"];
    LPSubscriber *subscriber14 = [[LPSubscriber alloc] initWithTitle:@"好好住" imageURL:@"好好住"];
    LPSubscriber *subscriber15 = [[LPSubscriber alloc] initWithTitle:@"好物" imageURL:@"好物"];
    LPSubscriber *subscriber16 = [[LPSubscriber alloc] initWithTitle:@"和讯财经" imageURL:@"和讯财经"];
    LPSubscriber *subscriber17 = [[LPSubscriber alloc] initWithTitle:@"虎嗅" imageURL:@"虎嗅"];
    LPSubscriber *subscriber18 = [[LPSubscriber alloc] initWithTitle:@"华尔街见闻" imageURL:@"华尔街见闻"];
    LPSubscriber *subscriber19 = [[LPSubscriber alloc] initWithTitle:@"欢喜Fancy" imageURL:@"欢喜Fancy"];
    LPSubscriber *subscriber20 = [[LPSubscriber alloc] initWithTitle:@"机核" imageURL:@"机核"];
    
    LPSubscriber *subscriber21 = [[LPSubscriber alloc] initWithTitle:@"极客头条" imageURL:@"极客头条"];
    LPSubscriber *subscriber22 = [[LPSubscriber alloc] initWithTitle:@"煎蛋" imageURL:@"煎蛋"];
    LPSubscriber *subscriber23 = [[LPSubscriber alloc] initWithTitle:@"节操精选" imageURL:@"节操精选"];
    LPSubscriber *subscriber24 = [[LPSubscriber alloc] initWithTitle:@"界面" imageURL:@"界面"];
    LPSubscriber *subscriber25 = [[LPSubscriber alloc] initWithTitle:@"快科技" imageURL:@"快科技"];
    LPSubscriber *subscriber26 = [[LPSubscriber alloc] initWithTitle:@"雷锋网" imageURL:@"雷锋网"];
    LPSubscriber *subscriber27 = [[LPSubscriber alloc] initWithTitle:@"马蜂窝自由行" imageURL:@"马蜂窝自由行"];
    LPSubscriber *subscriber28 = [[LPSubscriber alloc] initWithTitle:@"面包猎人" imageURL:@"面包猎人"];
    LPSubscriber *subscriber29 = [[LPSubscriber alloc] initWithTitle:@"内涵段子" imageURL:@"内涵段子"];
    LPSubscriber *subscriber30 = [[LPSubscriber alloc] initWithTitle:@"企鹅吃喝指南" imageURL:@"企鹅吃喝指南"];
    LPSubscriber *subscriber31 = [[LPSubscriber alloc] initWithTitle:@"糗事百科" imageURL:@"糗事百科"];
    LPSubscriber *subscriber32 = [[LPSubscriber alloc] initWithTitle:@"去哪儿旅游" imageURL:@"去哪儿旅游"];
    LPSubscriber *subscriber33 = [[LPSubscriber alloc] initWithTitle:@"任玩堂" imageURL:@"任玩堂"];
    LPSubscriber *subscriber34 = [[LPSubscriber alloc] initWithTitle:@"三联生活周刊" imageURL:@"三联生活周刊"];
    LPSubscriber *subscriber35 = [[LPSubscriber alloc] initWithTitle:@"少数派" imageURL:@"少数派"];
    LPSubscriber *subscriber36 = [[LPSubscriber alloc] initWithTitle:@"手游那点事" imageURL:@"手游那点事"];
    LPSubscriber *subscriber37 = [[LPSubscriber alloc] initWithTitle:@"数字尾巴" imageURL:@"数字尾巴"];
    LPSubscriber *subscriber38 = [[LPSubscriber alloc] initWithTitle:@"太平洋电脑网" imageURL:@"太平洋电脑网"];
    LPSubscriber *subscriber39 = [[LPSubscriber alloc] initWithTitle:@"钛媒体" imageURL:@"钛媒体"];
    LPSubscriber *subscriber40 = [[LPSubscriber alloc] initWithTitle:@"体育疯" imageURL:@"体育疯"];
    
    LPSubscriber *subscriber41 = [[LPSubscriber alloc] initWithTitle:@"土巴兔装修" imageURL:@"土巴兔装修"];
    LPSubscriber *subscriber42 = [[LPSubscriber alloc] initWithTitle:@"网易财经" imageURL:@"网易财经"];
    LPSubscriber *subscriber43 = [[LPSubscriber alloc] initWithTitle:@"威锋" imageURL:@"威锋"];
    LPSubscriber *subscriber44 = [[LPSubscriber alloc] initWithTitle:@"无讼阅读" imageURL:@"无讼阅读"];
    LPSubscriber *subscriber45 = [[LPSubscriber alloc] initWithTitle:@"严肃八卦" imageURL:@"严肃八卦"];
    LPSubscriber *subscriber46 = [[LPSubscriber alloc] initWithTitle:@"一个" imageURL:@"一个"];
    LPSubscriber *subscriber47 = [[LPSubscriber alloc] initWithTitle:@"一人一城" imageURL:@"一人一城"];
    LPSubscriber *subscriber48 = [[LPSubscriber alloc] initWithTitle:@"悦食家" imageURL:@"悦食家"];
    LPSubscriber *subscriber49 = [[LPSubscriber alloc] initWithTitle:@"悦食中国" imageURL:@"悦食中国"];
    LPSubscriber *subscriber50 = [[LPSubscriber alloc] initWithTitle:@"AppSo" imageURL:@"AppSo"];
    LPSubscriber *subscriber51 = [[LPSubscriber alloc] initWithTitle:@"HOT男人" imageURL:@"HOT男人"];
    LPSubscriber *subscriber52 = [[LPSubscriber alloc] initWithTitle:@"IT之家" imageURL:@"IT之家"];
    LPSubscriber *subscriber53 = [[LPSubscriber alloc] initWithTitle:@"v电影" imageURL:@"v电影"];
    LPSubscriber *subscriber54 = [[LPSubscriber alloc] initWithTitle:@"ZEALER" imageURL:@"ZEALER哈"];
    
    NSArray *array = [[NSArray alloc] initWithObjects:subscriber1,subscriber2,subscriber3, subscriber4, subscriber5,subscriber6, subscriber7, subscriber8,subscriber9,
                                                      subscriber10,subscriber11,subscriber12, subscriber13, subscriber14,subscriber15, subscriber16, subscriber17,subscriber18,
                                                      subscriber19,subscriber20,subscriber21, subscriber22, subscriber23,subscriber24, subscriber25, subscriber26,subscriber27,
                                                      subscriber28,subscriber29,subscriber30, subscriber31, subscriber32,subscriber33, subscriber34, subscriber35,subscriber36,
                                                      subscriber37,subscriber38,subscriber39, subscriber40, subscriber41,subscriber42, subscriber43, subscriber44,subscriber45,
                                                      subscriber46,subscriber47,subscriber48, subscriber49, subscriber50,subscriber51, subscriber52, subscriber53,subscriber54,
                                                     nil];
    NSMutableSet *randomSet = [[NSMutableSet alloc] init];
    while ([randomSet count] < 9) {
        int r = arc4random() % [array count];
        [randomSet addObject:[array objectAtIndex:r]];
    }
    NSArray *randomArray = [randomSet allObjects];
    
    for (LPSubscriber *subscriber in randomArray) {
        
        NSLog(@"%@", subscriber.title);
        LPSubscriberFrame *subscribeFrame = [[LPSubscriberFrame alloc] init];
        subscribeFrame.subscriber = subscriber;
        [self.subscriberFrameArray addObject:subscribeFrame];
    }
    
    
 
}

@end
