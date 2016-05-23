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
#import "LPNewsNavigationController.h"
#import "SSKeychainQuery.h"
#import "SSKeychain.h"
#import "AppDelegate.h"

NSString * const firstChannelName = @"奇点";
NSString * const menuCellIdentifier = @"menuCollectionViewCell";
NSString * const cellIdentifier = @"sortCollectionViewCell";
NSString * const reuseIdentifierFirst = @"reuseIdentifierFirst";
NSString * const reuseIdentifierSecond = @"reuseIdentifierSecond";

const static CGFloat cellPadding = 15;

@implementation LPHomeViewController (SubviewsManager) 


#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
}

#pragma mark - 显示状态栏
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
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
    [self setupHomeViewLoginButton];
    [self.loginBtn addTarget:self action:@selector(toUserCenter) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.loginBtn];
    
    
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
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundImage:[UIImage imageNamed:@"添加频道"] forState:UIControlStateNormal];
    addButton.frame = CGRectMake(addBtnX, addBtnY, addBtnW, addBtnH);
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    addButton.enlargedEdge = 5;
    [headerView addSubview:addButton];
    
    // 底部分割线
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight + menuViewHeight - 1, ScreenWidth, 1)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:@"#0091fa"];
    [headerView addSubview:seperatorView];
    
    // 频道栏
    CGFloat menuViewX = 46;
    CGFloat menuViewPaddingRight = 35.5;
    CGFloat menuViewPaddingTop = 30;
    
    CGFloat menuViewY = menuViewPaddingTop;
    CGFloat menuViewW = ScreenWidth - menuViewX - menuViewPaddingRight;
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
    [self.view addSubview:pagingView];
    self.pagingView = pagingView;
    
    // 频道管理
    UIView *blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    blurView.backgroundColor = [UIColor whiteColor];
    blurView.alpha = 0.0f;
    [self.view addSubview:blurView];
    self.blurView = blurView;
    
    // 频道管理
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.sortCollectionView = [[LPSortCollectionView alloc] initWithFrame:CGRectMake(0, statusBarHeight + menuViewHeight, ScreenWidth - cellPadding, ScreenHeight - statusBarHeight- menuViewHeight) collectionViewLayout:layout];
    self.sortCollectionView.delegate = self;
    self.sortCollectionView.dataSource = self;
    self.sortCollectionView.backgroundColor = [UIColor whiteColor];
    self.sortCollectionView.scrollsToTop = NO;
    [self.sortCollectionView registerClass:[LPSortCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.sortCollectionView registerClass:[LPSortCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierFirst];
    [self.sortCollectionView registerClass:[LPSortCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierSecond];
    [blurView addSubview:self.sortCollectionView];
    
    CGFloat menuImageWidth = 11;
    CGFloat menuImageHeight = 6;
    UIImage *upImage = [UIImage imageNamed:@"首页向上箭头"];
    self.hideChannelItemButton = [[UIButton alloc] init];
    [self.hideChannelItemButton  setBackgroundImage:upImage forState:UIControlStateNormal];
    self.hideChannelItemButton.userInteractionEnabled = YES;
    self.hideChannelItemButton.frame = CGRectMake(addButton.frame.origin.x ,addButton.frame.origin.y, menuImageWidth, menuImageHeight);
    [self.hideChannelItemButton addTarget:self action:@selector(hideChannelItemButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.hideChannelItemButton.enlargedEdge = 5;
    [blurView addSubview:self.hideChannelItemButton];
  
    // 首次安装提示信息
    if (![userDefaults objectForKey:@"isVersion3FirstLoad"]) {
        // 添加黑色透明功能
        UIView *homeBlackBlurView = [[UIView alloc] initWithFrame:self.view.bounds];
        homeBlackBlurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        homeBlackBlurView.hidden = YES;
    
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeBlurViewPressed)];
        [homeBlackBlurView addGestureRecognizer:tapGesture];
        [self.view addSubview:homeBlackBlurView];
        self.homeBlackBlurView = homeBlackBlurView;

        // 点击添加频道
        CGFloat changeBarImageViewY = CGRectGetMaxY(addButton.frame);
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
    }
    
    // 存储用户的UUID
    if (![userDefaults objectForKey:@"uniqueDeviceID"]) {
        NSString *uuid = [self getDeviceId];
        // 去除“-”字符 Base64加密 移除末尾等号"="
        uuid = [[[uuid stringByTrimmingHyphen] stringByBase64Encoding] stringByTrimmingString:@"="];
        [userDefaults setObject:uuid forKey:@"uniqueDeviceID"];
        [userDefaults synchronize];
    }
}

#pragma mark - 点击Status Bar
- (void)tapStatusBarView {
    LPPagingViewPage *page = (LPPagingViewPage *)self.pagingView.currentPage;
    [page tapStatusBarScrollToTop];
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


- (void)toUserCenter{
    
    Account *account = [AccountTool account];
    if (account == nil) {// 用户未登录直接显示未登录图标
        LPNewsLoginViewController *loginView = [[LPNewsLoginViewController alloc] initWithCustom];
        LPNewsNavigationController *loginNavVc = [[LPNewsNavigationController alloc] initWithRootViewControllerInOtherPopStyle:loginView];
        [self presentViewController:loginNavVc animated:YES completion:nil];
    } else {    //用户已登录
        LPNewsMineViewController *mineView = [[LPNewsMineViewController alloc] initWithCustom];
        LPNewsNavigationController *mineNavVc = [[LPNewsNavigationController alloc] initWithRootViewControllerInOtherPopStyle:mineView];
        [self presentViewController:mineNavVc animated:YES completion:nil];
    
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

#pragma mark - 展开我的频道
- (void)addButtonClick {
    __weak __typeof(self)weakSelf = self;
    // 选中某个按钮后需要刷新频道
    [self.sortCollectionView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.blurView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 折叠我的频道
- (void)hideChannelItemButtonClick {
    __weak __typeof(self)weakSelf = self;
    self.isSort = NO;
    [self.menuView reloadData];
    // 当前选中频道索引值
    int index = 0;
    for (int i = 0; i < self.selectedArray.count; i++) {
        LPChannelItem *channelItem = self.selectedArray[i];
        if([channelItem.channelName isEqualToString:self.selectedChannelTitle]) {
            index = i;
            break;
        }
    }
    if(index == 0) {
        self.selectedChannelTitle = firstChannelName;
    }
    NSIndexPath *menuIndexPath = [NSIndexPath indexPathForItem:index
                                                     inSection:0];
    [self.menuView selectItemAtIndexPath:menuIndexPath
                                animated:NO
                          scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self.pagingView reloadData];
    [self.pagingView setCurrentPageIndex:index animated:NO];
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.blurView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
}

@end
