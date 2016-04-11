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
#import "LPPagingViewPage.h"
#import "LPHomeViewController+ChannelItemMenu.h"
#import "LPHomeViewController+ContentView.h"
#import "LPSortCollectionViewCell.h"
#import "LPHomeViewController+LaunchFontSizeManager.h"
#import "LPChangeFontSizeView.h"
#import "LPFontSizeManager.h"


NSString * const firstChannelName = @"奇点";
NSString * const menuCellIdentifier = @"menuCollectionViewCell";
NSString * const cellIdentifier = @"sortCollectionViewCell";
NSString * const reuseIdentifierFirst = @"reuseIdentifierFirst";
NSString * const reuseIdentifierSecond = @"reuseIdentifierSecond";

const static CGFloat cellPadding = 15;

@implementation LPHomeViewController (SubviewsManager)

#pragma mark - 显示状态栏
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - 设置界面
- (void)setupSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat statusBarHeight = 20.0f;
    CGFloat menuViewHeight = 44.0f;
    if (iPhone6Plus) {
        menuViewHeight = 51;
    }

    // 导航视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, statusBarHeight + menuViewHeight)];
    [self.view addSubview:headerView];
    
    // 添加首页登录按钮
    [self setupHomeViewLoginButton];
    [self.loginBtn addTarget:self action:@selector(toUserCenter) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.loginBtn];
    
 
    // 右上角添加按钮
    CGFloat addBtnW = 19.0f;
    CGFloat addBtnH = 19.0f;
    CGFloat addBtnX = ScreenWidth - addBtnW - 11;
    CGFloat addBtnY = (menuViewHeight - addBtnH) / 2 + statusBarHeight;
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundImage:[UIImage imageNamed:@"添加频道"] forState:UIControlStateNormal];
    addButton.frame = CGRectMake(addBtnX, addBtnY, addBtnW, addBtnH);
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addButton];

    // 底部分割线
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight + menuViewHeight - 1, ScreenWidth, 1)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:@"#0091fa"];
    [headerView addSubview:seperatorView];
    
    // 频道栏
    CGFloat menuViewX = 53;
    CGFloat menuViewY = statusBarHeight;
    CGFloat menuViewW = ScreenWidth - 94;
    CGFloat menuViewH = menuViewHeight - 1;

    UICollectionViewFlowLayout *menuViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    menuViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    LPMenuView *menuView = [[LPMenuView alloc] initWithFrame:CGRectMake(menuViewX, menuViewY , menuViewW, menuViewH) collectionViewLayout:menuViewFlowLayout];
    menuView.backgroundColor = [UIColor whiteColor];
    menuView.showsHorizontalScrollIndicator = NO;
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
    pagingView.delegate = self;
    pagingView.dataSource = self;
    [pagingView registerClass:[LPPagingViewPage class] forPageWithReuseIdentifier:reusePageID];
    [self.view addSubview:pagingView];
    self.pagingView = pagingView;
    
    [self setupLoadingView];
    
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
    self.hideChannelItemButton.enlargedEdge = 10;
    [blurView addSubview:self.hideChannelItemButton];
    /*
    // 首次安装提示信息
    if (![userDefaults objectForKey:@"isVersion3FirstLoad"]) {
        
        // 点击添加频道
        CGFloat changeBarImageViewY = CGRectGetMaxY(addButton.frame);
        CGFloat changeBarImageViewW = 131;
        CGFloat changeBarImageViewH = 49;
        UIImageView *channelBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - changeBarImageViewW, changeBarImageViewY, changeBarImageViewW, changeBarImageViewH)];
        channelBarImageView.image = [UIImage imageNamed:@"点击频道管理"];
        [self.view addSubview:channelBarImageView];
        self.channelBarImageView = channelBarImageView;
       
        // 字体大小调整和新频道提示
        CGFloat changeFontSizeViewH = 150;
        CGFloat changeFontSizeTipW = 182;
        CGFloat changeFontSizeTipH = 38;
        
        UIImageView *changeFontSizeTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight - changeFontSizeViewH - changeFontSizeTipH - 10, changeFontSizeTipW, changeFontSizeTipH)];
        changeFontSizeTipImageView.image = [UIImage imageNamed:@"改变字体大小"];
        changeFontSizeTipImageView.centerX = self.view.centerX;
        [self.view addSubview:changeFontSizeTipImageView];
        self.changeFontSizeTipImageView = changeFontSizeTipImageView;
        
        // 添加蒙版
        UIView *homeBlurView = [[UIView alloc] init];
        homeBlurView.backgroundColor = [UIColor blackColor];
        homeBlurView.alpha = 0.5;
        homeBlurView.hidden =YES;
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeBlurViewPressed)];
        [homeBlurView addGestureRecognizer:tapGesture];
     
        [self.view addSubview:homeBlurView];
        self.homeBlurView = homeBlurView;
        
        // 改变字体大小
        LPChangeFontSizeView *changeFontSizeView = [[LPChangeFontSizeView alloc] initWithFrame:CGRectMake(0, ScreenHeight - changeFontSizeViewH, ScreenWidth, changeFontSizeViewH)];
        changeFontSizeView.delegate = self;
        [self.view addSubview:changeFontSizeView];
        self.changeFontSizeView = changeFontSizeView;
        
        // 登录提示
        LPLaunchLoginView *loginView = [[LPLaunchLoginView alloc] init];
        loginView.delegate = self;
        [self.view addSubview:loginView];
        self.loginView = loginView;
    }
     */
}

- (void)toUserCenter{
    
    LPNewsMineViewController *mineView = [[LPNewsMineViewController alloc] initWithCustom];
    [self.navigationController pushViewController:mineView animated:YES];
}


#pragma mark - 隐藏首页蒙版
- (void)homeBlurViewPressed {
    self.homeBlurView.hidden = YES;
    self.channelBarImageView.hidden = YES;
    self.changeFontSizeTipImageView.hidden = YES;
    self.changeFontSizeView.hidden = YES;
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
    CGRect cellRect = attributes.frame;
    UIView *menuBackgroundView = [[UIView alloc] init];
    menuBackgroundView.frame = cellRect;
    menuBackgroundView.alpha = 0.15;
    menuBackgroundView.backgroundColor = [UIColor colorFromHexString:@"#0091fa"];
    menuBackgroundView.layer.cornerRadius = 10.0f;
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

#pragma mark - 首页正在加载提示
- (void)setupLoadingView {
    CGFloat statusBarHeight = 20.0f;
    CGFloat menuViewHeight = 44.0f;
    if (iPhone6Plus) {
        menuViewHeight = 51;
    }
    UIView *contentLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight + menuViewHeight, ScreenWidth, ScreenHeight - statusBarHeight - menuViewHeight)];
 
    // Load images
    NSArray *imageNames = @[@"xl_1", @"xl_2", @"xl_3", @"xl_4"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    // Normal Animation
    UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 36) / 2, (ScreenHeight - statusBarHeight - menuViewHeight) / 3, 36 , 36)];
    animationImageView.animationImages = images;
    animationImageView.animationDuration = 1;
    [self.view addSubview:animationImageView];
    self.animationImageView = animationImageView;
    contentLoadingView.hidden = YES;
    [contentLoadingView addSubview:animationImageView];
    [self.view addSubview:contentLoadingView];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(animationImageView.frame), ScreenWidth, 40)];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"正在努力加载...";
    loadingLabel.font = [UIFont systemFontOfSize:12];
    loadingLabel.textColor = [UIColor colorFromHexString:@"#999999"];
    [contentLoadingView addSubview:loadingLabel];
    self.loadingLabel = loadingLabel;

    self.contentLoadingView = contentLoadingView;

}


@end
