//
//  LPHomeViewController+SubviewsManager.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPHomeViewController+SubviewsManager.h"
#import "LPHomeViewController+LaunchLoginManager.h"
#import "LPMenuButton.h"
#import "Account.h"
#import "AccountTool.h"
#import "LPPagingViewPage.h"
#import "LPHomeViewController+ChannelItemMenu.h"
#import "LPHomeViewController+ContentView.h"
#import "LPSortCollectionViewCell.h"
#import "LPHomeViewController+LaunchFontSizeManager.h"
#import "LPChangeFontSizeView.h"
#import "LPFontSizeManager.h"
#import "MainNavigationController.h"
#import "LPNewsLoginViewController.h"
#import "SSKeychainQuery.h"
#import "SSKeychain.h"
#import "AppDelegate.h"
#import "LPHomeChannelItemController.h"
#import "MainNavigationController.h"
#import "CardParam.h"
#import "LPChannelItemTool.h"
#import "Card+Fetch.h"
#import "CardFrame.h"
#import "CardTool.h"
#import "LPCardConcernFrame.h"

NSString * const menuCellIdentifier = @"menuCollectionViewCell";
NSString * const cellIdentifier = @"sortCollectionViewCell";
NSString * const reuseIdentifierFirst = @"reuseIdentifierFirst";
NSString * const reuseIdentifierSecond = @"reuseIdentifierSecond";
NSString * const cardCellIdentifier = @"cardCellIdentifier";

@implementation LPHomeViewController (SubviewsManager) 

#pragma mark - 显示状态栏
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - setupSubViews
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
    
    // 添加首页登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn addTarget:self action:@selector(loginBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.enlargedEdge = 5.0;
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
    [channelItemManageButton setBackgroundImage:[UIImage imageNamed:@"添加频道"] forState:UIControlStateNormal];
    channelItemManageButton.frame = CGRectMake(addBtnX, addBtnY, addBtnW, addBtnH);
    [channelItemManageButton addTarget:self action:@selector(channelItemManageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    channelItemManageButton.enlargedEdge = 10;
    [headerView addSubview:channelItemManageButton];
    
    // 底部分割线
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight + menuViewHeight - 1, ScreenWidth, 1)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:@"#0091fa"];
    [headerView addSubview:seperatorView];
    
    // 频道栏
    CGFloat menuViewX = 46;
    CGFloat menuViewPaddingRight = 35.5;
    CGFloat menuViewPaddingTop = 30;
    
    CGFloat menuViewY = 0.0f;
    CGFloat menuViewW = 0.0f;
    CGFloat menuViewH = 24.0;
    if (iPhone6Plus) {
        menuViewX = 46;
        menuViewPaddingRight = 34;
        menuViewW = ScreenWidth - menuViewX - menuViewPaddingRight;
        menuViewH = 24.0;
        menuViewY = menuViewPaddingTop;
    } else if (iPhone5) {
        menuViewX = 46;
        menuViewPaddingRight = 35.5f;
        menuViewW = ScreenWidth - menuViewX - menuViewPaddingRight;
        menuViewH = 24.0;
        menuViewY = menuViewPaddingTop;
    } else {
        menuViewX = 54;
        menuViewPaddingRight = 41;
        menuViewW = ScreenWidth - menuViewX - menuViewPaddingRight;
        menuViewH = 28.0;
        menuViewY = (menuViewHeight - menuViewH) / 2 + statusBarHeight;
    }
    

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
    [self.view addSubview:pagingView];
    self.pagingView = pagingView;
    
    // 频道管理
    UIView *blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    blurView.backgroundColor = [UIColor whiteColor];
    blurView.alpha = 0.0f;
    [self.view addSubview:blurView];
    self.blurView = blurView;
    
    // 首次安装提示信息
    if (![userDefaults objectForKey:LPIsVersionFirstLoad]) {
        // 添加黑色透明功能
        UIView *homeBlackBlurView = [[UIView alloc] initWithFrame:self.view.bounds];
        homeBlackBlurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        homeBlackBlurView.hidden = YES;
    
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
        LPLaunchLoginView *loginView = [[LPLaunchLoginView alloc] init];
        loginView.delegate = self;
        [self.view addSubview:loginView];
        self.loginView = loginView;
        // 加载完后提示信息
        [userDefaults setObject:@"NO" forKey:LPIsVersionFirstLoad];
        [userDefaults synchronize];
    }
}

#pragma mark - 点击Status Bar
- (void)tapStatusBarView {
    if (![self.selectedChannelTitle isEqualToString:LPConcernChannelItemName]) {
        LPPagingViewPage *page = (LPPagingViewPage *)self.pagingView.currentPage;
        [page tapStatusBarScrollToTop];
    } else {
        LPPagingViewConcernPage *page = (LPPagingViewConcernPage *)self.pagingView.currentPage;
        [page tapStatusBarScrollToTop];
    }
}

#pragma mark - 获取机器唯一编号
- (NSString *)getDeviceId
{
    NSString * currentDeviceUUIDStr = [SSKeychain passwordForService:@" "account:@"uniqueDeviceID"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SSKeychain setPassword: currentDeviceUUIDStr forService:@" "account:@"uniqueDeviceID"];
    }
    return currentDeviceUUIDStr;
}

#pragma mark - 个人中心
- (void)loginBtnDidClick {
    
    Account *account = [AccountTool account];
    
    if (account == nil) {// 用户未登录直接显示未登录图标
        
        LPNewsLoginViewController *mineViewController = [[LPNewsLoginViewController alloc] init];
        MainNavigationController *mainNavigationController = [[MainNavigationController alloc] initWithRootViewController:mineViewController];
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
    
    CGFloat menuBackgroundViewX = attributes.frame.origin.x;
    CGFloat menuBackgroundViewY = attributes.frame.origin.y;
    CGFloat menuBackgroundViewW = attributes.frame.size.width + 1;
    CGFloat menuBackgroundViewH = attributes.frame.size.height;
    
    CGRect cellRect = CGRectMake(menuBackgroundViewX, menuBackgroundViewY, menuBackgroundViewW, menuBackgroundViewH);

    UIView *menuBackgroundView = [[UIView alloc] init];
    menuBackgroundView.frame = cellRect;
    menuBackgroundView.alpha = 0.15;
    menuBackgroundView.backgroundColor = [UIColor colorFromHexString:@"#0091fa"];
    menuBackgroundView.layer.cornerRadius = 12.0f;
    
    if(iPhone6) {
        menuBackgroundView.layer.cornerRadius = 14.0f;
    }
   
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
                    // 加载当前频道数据
                    [self loadMoreDataInPageAtPageIndex:currentIndex];
                    
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

@end
