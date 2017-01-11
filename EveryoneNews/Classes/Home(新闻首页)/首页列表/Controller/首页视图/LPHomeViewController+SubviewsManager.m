//
//  LPHomeViewController+SubviewsManager.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPHomeViewController+SubviewsManager.h"
#import "LPMenuButton.h"
#import "Account.h"
#import "AccountTool.h"
#import "LPPagingViewPage.h"
#import "LPHomeViewController+ChannelItemMenu.h"
#import "LPHomeViewController+ContentView.h"
#import "LPHomeViewController+LaunchFontSizeManager.h"
#import "LPChangeFontSizeView.h"
#import "LPFontSizeManager.h"
#import "MainNavigationController.h"
#import "AppDelegate.h"
#import "LPHomeChannelItemController.h"
#import "MainNavigationController.h"
#import "CardParam.h"
#import "LPChannelItemTool.h"
#import "Card+Fetch.h"
#import "CardFrame.h"
#import "CardTool.h"
#import "LPCardConcernFrame.h"
#import "LPSubscribeView.h"
#import "LPSubscriber.h"
#import "LPSubscriberFrame.h"
#import "LPLoginViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "MainNavigationController.h"
#import "WXApi.h"
#import "MBProgressHUD.h"
#import "MJExtension.h"
#import "LPHttpTool.h"
#import "NSDate+Extension.h"
#import <UMSocialCore/UMSocialCore.h>
#import "AFNetworking.h"
#import "LPLoginTool.h"
#import "LPRegisterViewController.h"
#import "LPRetrievePasswordViewController.h"


NSString * const menuCellIdentifier = @"menuCollectionViewCell";
NSString * const cellIdentifier = @"sortCollectionViewCell";
NSString * const reuseIdentifierFirst = @"reuseIdentifierFirst";
NSString * const reuseIdentifierSecond = @"reuseIdentifierSecond";
NSString * const cardCellIdentifier = @"cardCellIdentifier";

@implementation LPHomeViewController (SubviewsManager) 


#pragma mark - 创建首页视图
- (void)setupSubViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat statusBarHeight = 20.0f;
    CGFloat menuViewHeight = 44.0f;

    if (iPhone6) {
        menuViewHeight = 52.0;
    }
    
    // 状态栏window
    UIWindow *statusWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, statusBarHeight)];
    statusWindow.windowLevel = UIWindowLevelStatusBar + 1;
    statusWindow.hidden = NO;
    self.statusWindow = statusWindow;
    UITapGestureRecognizer *tapStatusBarWindowGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStatusBarView)];
    
    [statusWindow addGestureRecognizer:tapStatusBarWindowGesture];
    
    // 导航视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, statusBarHeight + menuViewHeight)];
    [self.view addSubview:headerView];
    
    // 首页登录按钮
    CGFloat unloginBtnX = 12.0;
    CGFloat unloginBtnW = 24.0;
    CGFloat unloginBtnH = 24.0;
    if (iPhone6) {
        unloginBtnW = 26.0;
        unloginBtnH = 26.0;

    }
    
    CGFloat unloginBtnY = (menuViewHeight - unloginBtnH) / 2 + statusBarHeight;
    if (iPhone6) {
        unloginBtnY = unloginBtnY - 0.5;
    }
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(unloginBtnX , unloginBtnY , unloginBtnW, unloginBtnH)];
    loginBtn.layer.cornerRadius = 0;
    loginBtn.layer.borderWidth = 0;
    loginBtn.layer.masksToBounds = NO;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"home_user"] forState:UIControlStateNormal];
    loginBtn.enlargedEdge = 5.0;
    [loginBtn addTarget:self action:@selector(loginBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn = loginBtn;
    [self displayLoginBtnIconWithAccount:[AccountTool account]];
    [headerView addSubview:loginBtn];
    
    // 右上角添加按钮
    CGFloat addBtnW = 15.5f;
    CGFloat addBtnH = 15.5f;
    CGFloat addBtnPaddingRight = 10;
    
    if (iPhone6Plus) {
        addBtnW = 19.0f;
        addBtnH = 19.0f;
        addBtnPaddingRight = 8;
    } else if (iPhone5) {
         addBtnW = 15.5f;
         addBtnH = 15.5f;
         addBtnPaddingRight = 10;
    } else if (iPhone6) {
        addBtnW = 19.0f;
        addBtnH = 19.0f;
        addBtnPaddingRight = 11;
    }
    
    CGFloat addBtnX = ScreenWidth - addBtnW - addBtnPaddingRight;
    CGFloat addBtnY = (menuViewHeight - addBtnH) / 2 + statusBarHeight;
    UIButton *channelItemManageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [channelItemManageButton setBackgroundImage:[UIImage imageNamed:@"home_add"] forState:UIControlStateNormal];
    channelItemManageButton.frame = CGRectMake(addBtnX, addBtnY, addBtnW, addBtnH);
    [channelItemManageButton addTarget:self action:@selector(channelItemManageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    channelItemManageButton.enlargedEdge = 10;
    [headerView addSubview:channelItemManageButton];
    

 
    // 频道栏
    CGFloat menuViewX = 46;
    CGFloat menuViewPaddingRight = 35.5;
    
    CGFloat menuViewY = 30;
    CGFloat menuViewW = 0.0f;
    CGFloat menuViewH = 24.0;
    
    if (iPhone6Plus) {
        menuViewPaddingRight = 34;
    } else if (iPhone5) {
        menuViewPaddingRight = 35.5f;
    } else {
        menuViewX = 54;
        menuViewPaddingRight = 41;
    }
    menuViewW = ScreenWidth - menuViewX - menuViewPaddingRight;
    menuViewH = statusBarHeight + menuViewHeight - menuViewY - 0.5f;

    UICollectionViewFlowLayout *menuViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    menuViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    LPMenuView *menuView = [[LPMenuView alloc] initWithFrame:CGRectMake(menuViewX, menuViewY , menuViewW, menuViewH) collectionViewLayout:menuViewFlowLayout];
    menuView.backgroundColor = [UIColor whiteColor];
    menuView.showsHorizontalScrollIndicator = NO;
    menuView.scrollsToTop = NO;
    menuView.delegate = self;
    menuView.dataSource = self;
    [menuView registerClass:[LPMenuCollectionViewCell class] forCellWithReuseIdentifier:menuCellIdentifier];
    [headerView addSubview:menuView];
    self.menuView = menuView;
    
    // 底部分割线
    CALayer *seperatorLayer = [CALayer layer];
    seperatorLayer.frame = CGRectMake(0, statusBarHeight + menuViewHeight - 1.0f, ScreenWidth, 0.5f);
    seperatorLayer.backgroundColor = [UIColor colorFromHexString:LPColor21].CGColor;
    [headerView.layer addSublayer:seperatorLayer];
    // 默认选中第一个频道栏
    [self menuViewDidScrollToFirstChannelItem];
    
    // 首页内容页面
    LPPagingView *pagingView = [[LPPagingView alloc] init];
    pagingView.frame = CGRectMake(0, statusBarHeight + menuViewHeight, ScreenWidth, ScreenHeight - statusBarHeight - menuViewHeight);
    pagingView.contentSize = CGSizeMake(self.selectedArray.count * pagingView.width, 0);
    pagingView.alwaysBounceVertical = NO;
    pagingView.alwaysBounceHorizontal = NO;
    pagingView.showsHorizontalScrollIndicator = NO;
    pagingView.scrollsToTop = NO;
    pagingView.delegate = self;
    pagingView.dataSource = self;
    [pagingView registerClass:[LPPagingViewPage class] forPageWithReuseIdentifier:reusePageID];
    [pagingView registerClass:[LPPagingViewConcernPage class] forPageWithReuseIdentifier:reuseConcernPageID];
    [pagingView registerClass:[LPPagingViewVideoPage  class] forPageWithReuseIdentifier:reuseVideoPageID];
    [self.view addSubview:pagingView];
    self.pagingView = pagingView;
    
    // 首次安装提示信息
    if (![userDefaults objectForKey:LPIsVersionFirstLoad]) {
        // 添加黑色透明功能
    
        UIView *homeBlackBlurView = [[UIView alloc] initWithFrame:self.view.bounds];
        homeBlackBlurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeBlurViewPressed)];
        [homeBlackBlurView addGestureRecognizer:tapGesture];
        [self.view addSubview:homeBlackBlurView];
        self.homeBlackBlurView = homeBlackBlurView;

        // 点击添加频道
        CGFloat changeBarImageViewY = CGRectGetMaxY(channelItemManageButton.frame);
        CGFloat changeBarImageViewW = 131;
        CGFloat changeBarImageViewH = 49;
        UIImageView *channelBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - changeBarImageViewW, changeBarImageViewY, changeBarImageViewW, changeBarImageViewH)];
        channelBarImageView.image = [UIImage imageNamed:@"点击频道管理"];
        [self.homeBlackBlurView addSubview:channelBarImageView];
        self.channelBarImageView = channelBarImageView;

        // 字体大小调整和新频道提示
        CGFloat changeFontSizeViewH = 150;
        CGFloat changeFontSizeTipW = 182;
        CGFloat changeFontSizeTipH = 38;
        
        UIImageView *changeFontSizeTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight - changeFontSizeViewH - changeFontSizeTipH - 7, changeFontSizeTipW, changeFontSizeTipH)];
        changeFontSizeTipImageView.image = [UIImage imageNamed:@"改变字体大小"];
        changeFontSizeTipImageView.centerX = self.view.centerX;
        [self.homeBlackBlurView addSubview:changeFontSizeTipImageView];
        self.changeFontSizeTipImageView = changeFontSizeTipImageView;

        // 改变字体大小
        LPChangeFontSizeView *changeFontSizeView = [[LPChangeFontSizeView alloc] initWithFrame:CGRectMake(0, ScreenHeight - changeFontSizeViewH, ScreenWidth, changeFontSizeViewH)];
        changeFontSizeView.delegate = self;
        [self.homeBlackBlurView addSubview:changeFontSizeView];
        self.changeFontSizeView = changeFontSizeView;
    
        // 登录提示
        LPLaunchLoginView *loginView = [[LPLaunchLoginView alloc] initWithFrame:self.view.bounds];
        loginView.delegate = self;
        [self.view addSubview:loginView];
        self.loginView = loginView;
        // 加载完后提示信息
        [userDefaults setObject:@"NO" forKey:LPIsVersionFirstLoad];
        [userDefaults synchronize];
    }
}

#pragma mark - LPLaunchLoginView Delegate
- (void)didCloseLoginView:(LPLaunchLoginView *)loginView {
    
    self.loginView.hidden = YES;
}

// 微信登录
- (void)didWeixinLoginWithLoginView:(LPLaunchLoginView *)loginView {
    
    [self loginWithPlatformName:UMSocialPlatformType_WechatSession];
    
}

// 新浪登录
- (void)didSinaLoginWithLoginView:(LPLaunchLoginView *)loginView {
  [self loginWithPlatformName:UMSocialPlatformType_Sina];
}

// 忘记密码
- (void)didFindPassWordWithLoginView:(LPLaunchLoginView *)loginView {
    LPRetrievePasswordViewController *retrievePasswordVC = [[LPRetrievePasswordViewController alloc] init];
    [self.navigationController pushViewController:retrievePasswordVC animated:YES];
}

// 注册
- (void)didRegisterWithLoginView:(LPLaunchLoginView *)loginView {
    LPRegisterViewController *registerVC = [[LPRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
// 登录
- (void)didLoginWithLoginView:(LPLaunchLoginView *)loginView userName:(NSString *)userName password:(NSString *)password  {
    NSString *url = [NSString stringWithFormat:@"%@/v2/au/lin/g", ServerUrlVersion2];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"email"]  = userName;
    params[@"password"] = password;
    [LPHttpTool postJSONResponseAuthorizationWithURL:url params:params success:^(id json, NSString *authorization) {
        if ([json[@"code"] integerValue] == 2000) {
            
            NSDictionary *dict = (NSDictionary *)json[@"data"];
            NSMutableDictionary *accountDict = [NSMutableDictionary dictionary];
            accountDict[@"userId"] = dict[@"uid"];
            accountDict[@"userGender"] = @(0);
            accountDict[@"userName"] = dict[@"uname"];
            accountDict[@"userIcon"] = defaultUserIconUrl;
            accountDict[@"platformType"] = @"";
            accountDict[@"deviceType"] = @"ios";
            accountDict[@"token"] = @"";
            accountDict[@"expiresTime"] = @"";
            
            // 保存用户信息到本地
            Account *account = [Account objectWithKeyValues:accountDict];
            [AccountTool saveAccount:account];
            
            [userDefaults setObject:dict[@"uid"] forKey:@"uid"];
            [userDefaults setObject:@"1" forKey:@"uIconDisplay"];
            [userDefaults setObject:dict[@"utype"] forKey:@"utype"];
            [userDefaults setObject:authorization forKey:@"uauthorization"];
            [userDefaults synchronize];
            [noteCenter postNotificationName:LPLoginNotification object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [MBProgressHUD showError:@"用户名或密码错误"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];

}



#pragma mark - 登录微信微博平台

// 登录微信微博平台
- (void)loginWithPlatformName:(UMSocialPlatformType)type {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:type currentViewController:self completion:^(id result, NSError *error) {
        
        if (error == nil) {
            UMSocialUserInfoResponse *accountEntity = result;
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
    }];
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
    LPSubscriber *subscriber10 = [[LPSubscriber alloc] initWithTitle:@"网易体育" imageURL:@"网易体育"];
    LPSubscriber *subscriber11 = [[LPSubscriber alloc] initWithTitle:@"国家地理" imageURL:@"国家地理"];
    LPSubscriber *subscriber12 = [[LPSubscriber alloc] initWithTitle:@"果壳精选" imageURL:@"果壳精选"];
    LPSubscriber *subscriber13 = [[LPSubscriber alloc] initWithTitle:@"果库" imageURL:@"果库"];
    LPSubscriber *subscriber14 = [[LPSubscriber alloc] initWithTitle:@"好好住" imageURL:@"好好住"];
    LPSubscriber *subscriber15 = [[LPSubscriber alloc] initWithTitle:@"好物" imageURL:@"好物"];
    LPSubscriber *subscriber16 = [[LPSubscriber alloc] initWithTitle:@"和讯财经" imageURL:@"和讯财经"];
    LPSubscriber *subscriber17 = [[LPSubscriber alloc] initWithTitle:@"虎嗅" imageURL:@"虎嗅"];
    LPSubscriber *subscriber18 = [[LPSubscriber alloc] initWithTitle:@"华尔街见闻" imageURL:@"华尔街见闻"];
    LPSubscriber *subscriber19 = [[LPSubscriber alloc] initWithTitle:@"搜狐新闻" imageURL:@"搜狐新闻"];
    LPSubscriber *subscriber20 = [[LPSubscriber alloc] initWithTitle:@"机核" imageURL:@"机核"];
    
    LPSubscriber *subscriber21 = [[LPSubscriber alloc] initWithTitle:@"极客头条" imageURL:@"极客头条"];
    LPSubscriber *subscriber22 = [[LPSubscriber alloc] initWithTitle:@"煎蛋" imageURL:@"煎蛋"];
    LPSubscriber *subscriber23 = [[LPSubscriber alloc] initWithTitle:@"节操精选" imageURL:@"节操精选"];
    LPSubscriber *subscriber24 = [[LPSubscriber alloc] initWithTitle:@"界面" imageURL:@"界面"];
    LPSubscriber *subscriber25 = [[LPSubscriber alloc] initWithTitle:@"快科技" imageURL:@"快科技"];
    LPSubscriber *subscriber26 = [[LPSubscriber alloc] initWithTitle:@"雷锋网" imageURL:@"雷锋网"];
    LPSubscriber *subscriber27 = [[LPSubscriber alloc] initWithTitle:@"中国青年网" imageURL:@"中国青年网"];
    LPSubscriber *subscriber28 = [[LPSubscriber alloc] initWithTitle:@"面包猎人" imageURL:@"面包猎人"];
    LPSubscriber *subscriber29 = [[LPSubscriber alloc] initWithTitle:@"内涵段子" imageURL:@"内涵段子"];
    LPSubscriber *subscriber30 = [[LPSubscriber alloc] initWithTitle:@"企鹅吃喝指南" imageURL:@"企鹅吃喝指南"];
    LPSubscriber *subscriber31 = [[LPSubscriber alloc] initWithTitle:@"糗事百科" imageURL:@"糗事百科"];
    LPSubscriber *subscriber32 = [[LPSubscriber alloc] initWithTitle:@"法制晚报" imageURL:@"法制晚报"];
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
    LPSubscriber *subscriber48 = [[LPSubscriber alloc] initWithTitle:@"澎湃新闻" imageURL:@"澎湃新闻"];
    LPSubscriber *subscriber49 = [[LPSubscriber alloc] initWithTitle:@"悦食中国" imageURL:@"悦食中国"];
    LPSubscriber *subscriber50 = [[LPSubscriber alloc] initWithTitle:@"环球" imageURL:@"环球"];
    LPSubscriber *subscriber51 = [[LPSubscriber alloc] initWithTitle:@"成都商报" imageURL:@"成都商报"];
    LPSubscriber *subscriber52 = [[LPSubscriber alloc] initWithTitle:@"IT之家" imageURL:@"IT之家"];
    LPSubscriber *subscriber53 = [[LPSubscriber alloc] initWithTitle:@"网易娱乐" imageURL:@"网易娱乐"];
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
        LPSubscriberFrame *subscribeFrame = [[LPSubscriberFrame alloc] init];
        subscribeFrame.subscriber = subscriber;
        [self.subscriberFrameArray addObject:subscribeFrame];
    }
    
    
    
}

#pragma mark - 新闻置顶
- (void)tapStatusBarView {
    NSInteger currentPageIndex = 0;
    for (int i = 0; i < self.selectedArray.count; i++) {
        LPChannelItem *channelItem = self.selectedArray[i];
        if ([channelItem.channelName isEqualToString:self.selectedChannelTitle]) {
            currentPageIndex = i;
            break;
        }
    }

    if ([self.selectedChannelTitle isEqualToString:LPConcernChannelItemName]) {
        LPPagingViewConcernPage *page = (LPPagingViewConcernPage *)[self.pagingView visiblePageAtIndex:currentPageIndex];
        [page tapStatusBarScrollToTop];
        
    } else if([self.selectedChannelTitle isEqualToString:LPVideoChannelItemName]) {
        LPPagingViewVideoPage *page = (LPPagingViewVideoPage *)[self.pagingView visiblePageAtIndex:currentPageIndex];
        [page tapStatusBarScrollToTop];
    }
    
    else {
        LPPagingViewPage *page = (LPPagingViewPage *)[self.pagingView visiblePageAtIndex:currentPageIndex];
        [page tapStatusBarScrollToTop];
    }
}



#pragma mark - 个人中心
- (void)loginBtnDidClick {
    
    Account *account = [AccountTool account];
    if (account == nil) {// 用户未登录直接显示未登录图标
        LPLoginViewController *loginVC = [[LPLoginViewController alloc] init];
        MainNavigationController *mainNavigationController = [[MainNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:mainNavigationController animated:YES completion:^{
            self.statusWindow.hidden = YES;
        }];
        
    } else {    //用户已登录
        LPNewsMineViewController *mineViewController = [[LPNewsMineViewController alloc] init];
        mineViewController.statusWindow = self.statusWindow;
        MainNavigationController *mainNavigationController = [[MainNavigationController alloc] initWithRootViewController:mineViewController];
        [self presentViewController:mainNavigationController animated:YES completion:^{
            self.statusWindow.hidden = YES;
        }];
    }
}


#pragma mark - 隐藏首页蒙版
- (void)homeBlurViewPressed {
    [self.homeBlackBlurView removeFromSuperview];
    // 保存字体大小
    [[LPFontSizeManager sharedManager] saveHomeViewFontSizeAndType];
}

#pragma mark - 导航栏默认选中第一项
- (void)menuViewDidScrollToFirstChannelItem {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0
                                                 inSection:0];
    LPMenuButton *menuButton = ((LPMenuCollectionViewCell *)[self.menuView cellForItemAtIndexPath:indexPath]).menuButton;
    if(menuButton != nil) {
        self.selectedChannelTitle = menuButton.text;
    }
    [self.menuView selectItemAtIndexPath:indexPath
                                animated:NO
                          scrollPosition:UICollectionViewScrollPositionNone];
    // 导航栏滑动时添加背景颜色
    UICollectionViewLayoutAttributes *attributes = [self.menuView layoutAttributesForItemAtIndexPath:indexPath];
    
    CGFloat menuBackgroundViewX = attributes.frame.origin.x + 5;
    CGFloat menuBackgroundViewH = 2;
    CGFloat menuBackgroundViewY = CGRectGetMaxY(attributes.frame) + 2 ;
    CGFloat menuBackgroundViewW = attributes.frame.size.width - 10;
   
    CGRect cellRect = CGRectMake(menuBackgroundViewX, menuBackgroundViewY, menuBackgroundViewW, menuBackgroundViewH);
    UIView *menuBackgroundView = [[UIView alloc] init];
    menuBackgroundView.frame = cellRect;
    menuBackgroundView.backgroundColor = [UIColor colorFromHexString:LPColor15];

    [self.menuView addSubview:menuBackgroundView];
    self.menuBackgroundView = menuBackgroundView;
}

#pragma mark - 频道管理
- (void)channelItemManageButtonClick {

    LPHomeChannelItemController *homeChannelItemController = [[LPHomeChannelItemController alloc] init];
    homeChannelItemController.selectedArray = [self.selectedArray mutableCopy];
    homeChannelItemController.optionalArray = [self.optionalArray mutableCopy];
    homeChannelItemController.selectedChannelTitle = self.selectedChannelTitle;
    

    // 添加频道
    homeChannelItemController.addChannelItemBlock = ^(NSString *channelName, NSInteger insertIndex, NSMutableArray *selectedArray, NSMutableArray *optionalArray) {
        
        [self updateIdentifierIndexMapToChannelItemDictionaryWithSelectedArray:selectedArray optionalArray:optionalArray];
        
        self.channelItemDictionary[channelName] = [NSMutableArray array];
        [self.pagingView insertPageAtIndex:insertIndex];
        [self.menuView reloadData];

        
    };
    // 删除频道
    homeChannelItemController.removeChannelItemBlock = ^(NSString *channelName, NSInteger removeIndex, NSMutableArray *selectedArray, NSMutableArray *optionalArray) {
   [self updateIdentifierIndexMapToChannelItemDictionaryWithSelectedArray:selectedArray optionalArray:optionalArray];
        
        [self.channelItemDictionary removeObjectForKey:channelName];
        [self.pagingView deletePageAtIndex:removeIndex];
        [self.menuView reloadData];
    };
    // 交换频道
    homeChannelItemController.moveChannelItemBlock = ^(NSInteger fromIndex,  NSInteger toIndex, NSMutableArray *selectedArray, NSMutableArray *optionalArray) {
        [self updateIdentifierIndexMapToChannelItemDictionaryWithSelectedArray:selectedArray optionalArray:optionalArray];
        [self.pagingView movePageFromIndex:fromIndex toIndex:toIndex];
        [self.menuView reloadData];
    };
    // 更新首页
    homeChannelItemController.channelItemDidChangedBlock = ^(NSDictionary *dict) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *currentSelectedChannelTitle = [dict objectForKey:@"selectedChannelTitle"];
                // 当前页码
                int currentIndex = 0;
                for (int i = 0; i < self.selectedArray.count; i++) {
                    LPChannelItem *channelItem = self.selectedArray[i];
                    if([channelItem.channelName isEqualToString:currentSelectedChannelTitle]) {
                        currentIndex = i;
                        break;
                    }
                }
                if(currentIndex == 0) {
                    self.selectedChannelTitle = LPQiDianChannelItemName;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *menuIndexPath = [NSIndexPath indexPathForItem:currentIndex
                                                                     inSection:0];
                  
                    [self.menuView selectItemAtIndexPath:menuIndexPath
                                                animated:NO
                                          scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
                    [self.pagingView setCurrentPageIndex:currentIndex animated:NO];
                });
                // 先请求数据库，没有再请求网络
                if (![self.selectedChannelTitle isEqualToString:currentSelectedChannelTitle]) {                    
                    self.selectedChannelTitle = currentSelectedChannelTitle;
             
                }
            });
     };
    [self.navigationController pushViewController:homeChannelItemController animated:YES];
}

#pragma mark - 频道唯一标识，频道和页码映射关系
- (void)updateIdentifierIndexMapToChannelItemDictionaryWithSelectedArray:(NSMutableArray *)selectedArray optionalArray:(NSMutableArray *)optionalArray {
    
    self.selectedArray = selectedArray;
    self.optionalArray = optionalArray;
    for (int i = 0; i < self.selectedArray.count; i++) {
        // 设置每个每页唯一标识
        [self.cardCellIdentifierDictionary setObject:[NSString stringWithFormat:@"%@%d",cardCellIdentifier,i] forKey:@(i)];
    }
    [self updatePageindexMapToChannelItemDictionary];
}

#pragma mark -  频道和页码的映射关系
- (void)updatePageindexMapToChannelItemDictionary {
    [self.pageindexMapToChannelItemDictionary removeAllObjects];
    for (int i = 0; i < self.selectedArray.count; i++) {
        LPChannelItem *channelItem = self.selectedArray[i];
        [self.pageindexMapToChannelItemDictionary setObject:channelItem forKey:@(i)];
    }
}

#pragma mark - 显示状态栏
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


@end
