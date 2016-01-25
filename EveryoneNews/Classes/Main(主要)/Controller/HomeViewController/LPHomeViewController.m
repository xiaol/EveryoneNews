//
//  LPHomeViewController.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewController.h"
#import "LPMenuView.h"
#import "LPMenuButton.h"
#import "LPPagingView.h"
#import "UIImageView+WebCache.h"
#import "LPChannelItem.h"
#import "LPSortCollectionViewCell.h"
#import "LPSortCollectionReusableView.h"
#import "LPChannelItemTool.h"
#import "LPMenuCollectionViewCell.h"
#import "LPSortCollectionView.h"
#import "LPHomeViewCell.h"
#import "LPPagingViewPage.h"
#import "LPHomeViewController+ChannelItemMenu.h"
#import "LPHomeViewController+ContentView.h"
#import "LPDetailViewController.h"
#import "LPHomeViewController+NewFeature.h"

// 挖掘机
#import "Account.h"
#import "AccountTool.h"
#import "UIImageView+WebCache.h"
#import "CategoryView.h"
#import "LPTagCloudView.h"
#import "LPPressTool.h"
#import "LPCategory.h"
#import "LPPressFrame.h"
#import "LPPress.h"
#import "MJExtension.h"
#import "LPPressCell.h"
#import "LPDetailViewController.h"
#import "MBProgressHUD+MJ.h"
#import "LPConcern.h"
#import "LPConcernCell.h"
#import "LPHttpTool.h"
#import "ConcernViewController.h"
#import "LPFeaturedViewController.h"
#import "LPSpringLayout.h"
#import "LPDigViewController.h"
#import "GenieTransition.h"
#import "MainNavigationController.h"
#import "DigButton.h"
#import "AppDelegate.h"
#import <StoreKit/StoreKit.h>


typedef void (^completionBlock)();

NSString * const HomeCellReuseIdentifier = @"homeCell";
NSString * const ConcernCellReuseIdentifier = @"concernCell";
const NSInteger HotwordPageCapacity = 8;
NSString * const HotwordsURL = @"http://api.deeporiginalx.com/news/baijia/fetchElementary";
NSString * const cellIdentifier = @"sortCollectionViewCell";

NSString * const reuseIdentifierFirst = @"reuseIdentifierFirst";
NSString * const reuseIdentifierSecond = @"reuseIdentifierSecond";
NSString * const menuCellIdentifier = @"menuCollectionViewCell";
NSString * const reusePageID = @"reusePageID";
NSString * const firstChannelName = @"社会";

const static CGFloat menuViewHeight = 44;
const static CGFloat statusBarHeight = 20;
const static CGFloat cellPadding = 15;

@interface LPHomeViewController () <LPTagCloudViewDelegate, UIGestureRecognizerDelegate>

@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;
// 向下箭头
@property (nonatomic, strong) UIButton *downButton;
// 向上箭头
@property (nonatomic, strong) UIButton *upButton;
//自定义的顶部导航
@property (nonatomic,strong) LPTabBar *customTabBar;
//主界面右下角的登录按钮
@property (nonatomic,strong) UIButton *loginBtn;

@property (nonatomic, strong) UIButton *digBtn;
//所有内容展示的ScrollView
@property (nonatomic,strong) UIScrollView *containerView;
//左边分类对应的ScrollView
@property (nonatomic, strong) UICollectionView *homeView;
@property (nonatomic, assign) NSUInteger timeRow;
@property (nonatomic, assign) NSUInteger anyDisplayingCellRow;
@property (nonatomic, assign) BOOL isScrolled;
@property (nonatomic, assign) NSUInteger selectedRow;
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, strong) NSMutableArray *pressFrames;

@property (nonatomic, strong) UICollectionView *concernView;

@property (nonatomic, strong) NSMutableArray *concerns;

@property (nonatomic, strong) NSMutableSet *shimmeringOffIndexes;

@property (nonatomic, strong) LPTagCloudView *tagCloudView;


@property (nonatomic, strong) NSMutableArray *digTags;

@property (nonatomic, copy) NSString *pasteURL;

@property (nonatomic, strong) UIView *digAlertView;

@end

@implementation LPHomeViewController

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubViews];
    if ([userDefaults objectForKey:@"isFirstLoadMark"]) {
        [self  setInitialChannelItemDictionary];
    }
    [self scrollToFirstChannelItem];
    [self setupLoginButton];
    [self setupDigButton];
    [self setupNoteObserver];
}

#pragma mark - 显示状态栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - 默认选中第一项
- (void)scrollToFirstChannelItem {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0
                                                 inSection:0];
    LPMenuButton *menuButton = ((LPMenuCollectionViewCell *)[self.menuView cellForItemAtIndexPath:indexPath]).menuButton;
    if(menuButton != nil) {
        self.selectedChannelTitle = menuButton.text;
    }
    [self.menuView selectItemAtIndexPath:indexPath
                                animated:NO
                          scrollPosition:UICollectionViewScrollPositionNone];
}



#pragma mark - 懒加载
- (NSMutableDictionary *)channelItemDictionary {
    if (_channelItemDictionary == nil) {
        _channelItemDictionary = [[NSMutableDictionary alloc] init];
    }
    return _channelItemDictionary;
}

- (NSMutableArray *)channelItemsArray {
    if(_channelItemsArray == nil) {
        _channelItemsArray = [[NSMutableArray alloc] init];
    }
    return _channelItemsArray;
}

- (NSMutableArray *)selectedArray {
    if(_selectedArray == nil) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return  _selectedArray;
}

- (NSMutableArray *)optionalArray {
    if(_optionalArray == nil) {
        _optionalArray = [[NSMutableArray alloc] init];
    }
    return _optionalArray;
}

- (NSMutableArray *)cellAttributesArray {
    if (_cellAttributesArray == nil) {
        _cellAttributesArray = [[NSMutableArray alloc] init];
    }
    return _cellAttributesArray;
}

- (NSMutableDictionary *)pageindexMapToChannelItemDictionary {
    if (_pageindexMapToChannelItemDictionary == nil) {
        _pageindexMapToChannelItemDictionary = [[NSMutableDictionary alloc] init];
    }
    return _pageindexMapToChannelItemDictionary;
}

- (NSMutableDictionary *)cardCellIdentifierDictionary {
    if (_cardCellIdentifierDictionary == nil) {
        _cardCellIdentifierDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return _cardCellIdentifierDictionary;
}

- (NSMutableDictionary *)pageContentOffsetDictionary {
    if (_pageContentOffsetDictionary == nil) {
        _pageContentOffsetDictionary = [[NSMutableDictionary alloc] init];
    }
    return _pageContentOffsetDictionary;
}


#pragma mark - 初始化界面
- (void)setupSubViews {
    [self initAllChannelItems];
    [self setCellIdentifierOfAllChannelItems];
    [self updatePageindexMapToChannelItemDictionary];
    
    // 添加背景色
    UIView *topBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, statusBarHeight + menuViewHeight)];
    topBackgroundView.backgroundColor = [UIColor colorFromHexString:@"0087d1"];
    [self.view addSubview:topBackgroundView];
    self.topBackgroundView = topBackgroundView;
    
    // 展开折叠图片宽度
    CGFloat menuPaddingRight = 9;
    CGFloat menuImageWidth = 11;
    CGFloat menuImageHeight = 6;
    
    CGFloat seperatorW = 0.5f;
    CGFloat seperatorPaddingTop = 32;
    CGFloat seperatorH = 20;
    if (iPhone6Plus) {
         menuImageWidth = 16.5;
         menuImageHeight = 9;
         seperatorPaddingTop = 30;
         seperatorH = 25;
    }
    
    CGFloat rightViewWidth = 2 * cellPadding + menuImageWidth + seperatorW + menuPaddingRight + menuPaddingRight;
    // 菜单栏
    UICollectionViewFlowLayout *menuViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    menuViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    LPMenuView *menuView = [[LPMenuView alloc] initWithFrame:CGRectMake(cellPadding, 0 , ScreenWidth - rightViewWidth - cellPadding,statusBarHeight + menuViewHeight) collectionViewLayout:menuViewFlowLayout];
    menuView.backgroundColor = [UIColor colorFromHexString:@"0087d1"];
    menuView.showsHorizontalScrollIndicator = NO;
    menuView.delegate = self;
    menuView.dataSource = self;
    [menuView registerClass:[LPMenuCollectionViewCell class] forCellWithReuseIdentifier:menuCellIdentifier];
    self.menuView = menuView;
    [topBackgroundView addSubview:menuView];

    // 内容页面
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
    
    // 添加加载中提示信息
    [self setupBackgroundView];
    
    
    // 分割线
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.menuView.frame) + menuPaddingRight, seperatorPaddingTop, seperatorW, seperatorH)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:@"#dedbdb"];
    [self.view addSubview:seperatorView];
    
    CGFloat imageFrameX = CGRectGetMaxX(seperatorView.frame) + cellPadding;
    
    CGFloat imageFrameY = 40.0f;
    if (iPhone6Plus) {
        imageFrameY = 40.0f;
    }
    // 向下箭头
    UIImage *downImage = [UIImage imageNamed:@"首页向下箭头"];
    self.downButton = [[UIButton alloc] init];
    [self.downButton  setBackgroundImage:downImage forState:UIControlStateNormal];
    self.downButton.frame = CGRectMake(imageFrameX, imageFrameY, menuImageWidth, menuImageHeight);
    [self.downButton addTarget:self action:@selector(downButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.downButton.enlargedEdge = 10;
    [topBackgroundView addSubview:self.downButton];
    
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
    self.sortCollectionView.alpha = 0.95;
    [self.sortCollectionView registerClass:[LPSortCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.sortCollectionView registerClass:[LPSortCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierFirst];
    [self.sortCollectionView registerClass:[LPSortCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierSecond];
    [blurView addSubview:self.sortCollectionView];

    UIImage *upImage = [UIImage imageNamed:@"首页向上箭头"];
    self.upButton = [[UIButton alloc] init];
    [self.upButton  setBackgroundImage:upImage forState:UIControlStateNormal];
    self.upButton.userInteractionEnabled = YES;
    self.upButton.frame = self.downButton.frame;
    [self.upButton addTarget:self action:@selector(upButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.upButton.enlargedEdge = 10;
    [blurView addSubview:self.upButton];
    // 挖掘机提示框
    [self setupDigAlterView];
    
    // 新特性展示
    if (![userDefaults objectForKey:@"isFirstLoadMark"]) {
        [self setupNewFeatureView];
    }
}

- (void)setupBackgroundView {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight + menuViewHeight, ScreenWidth, ScreenHeight - statusBarHeight - menuViewHeight)];
    UIActivityIndicatorView *indictorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indictorView.frame = CGRectMake((ScreenWidth - 22) / 2, 15, 22, 22);
    [backgroundView addSubview:indictorView];
    self.indictorView = indictorView;

    CGFloat loadLabelY = CGRectGetMaxY(self.indictorView.frame) + 8;
    CGFloat loadLabelX = (ScreenWidth - 40) / 2;
    UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(loadLabelX, loadLabelY, 40, 12)];
    loadLabel.font = [UIFont systemFontOfSize:10];
    loadLabel.textColor = [UIColor colorFromHexString:@"#969696"];
    loadLabel.text = @"正在推荐";
    [backgroundView addSubview:loadLabel];
    self.loadLabel = loadLabel;

    UIImage *backgroundImage = [UIImage imageNamed:@"头条百家字"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    backgroundImageView.center = CGPointMake(ScreenWidth / 2, (ScreenHeight - TabBarHeight) / 2);
    [backgroundView addSubview:backgroundImageView];
    
    // 正在加载提示
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadCurrentPage)];
    tapGestureRecognizer.delegate = self;
    UIImage *loadImage = [UIImage imageNamed:@"重新加载"];
    UIImageView *loadImageView = [[UIImageView alloc] initWithImage:loadImage];
    loadImageView.userInteractionEnabled = YES;
    [loadImageView addGestureRecognizer:tapGestureRecognizer];

    loadImageView.centerX = self.view.centerX;
    loadImageView.centerY = ScreenHeight / 3;

    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    noDataLabel.centerY = CGRectGetMaxY(loadImageView.frame) + 20;
    NSString *text = @"网络出错，轻触屏幕重新加载";
    NSMutableAttributedString *noDataString = [text attributedStringWithFont:[UIFont systemFontOfSize:12] color:[UIColor colorFromHexString:@"#c8c8c8"] lineSpacing:0];
    noDataLabel.attributedText = noDataString;
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:loadImageView];
    loadImageView.hidden = YES;
    self.loadImageView = loadImageView;
    
    [backgroundView addSubview:noDataLabel];
    noDataLabel.hidden = YES;
    self.noDataLabel = noDataLabel;
    
    backgroundView.hidden = YES;
    [self.view addSubview:backgroundView];
    self.backgroundView = backgroundView;
    
 
    
}

#pragma mark - 加载更多
- (void)loadCurrentPage {
    [self channelItemDidAddToCoreData:self.pagingView.currentPageIndex];
}

#pragma mark - 挖掘机悬浮框
- (void)setupDigAlterView {
   
    NSString *latestSearch = pasteboard.string;
    if (latestSearch.length > 0) {

    CGFloat cancelButtonWidth = 14;
    CGFloat cancelButtonHeight = 14;
    CGFloat confirmButtonWidth = 21;
    CGFloat confirmButtonHeight = 14;
        
    CGFloat buttonPaddingLeft = 8;
    CGFloat buttonPaddingRight = 8;
    
    CGFloat seperatorPaddingLeft = 10;
    CGFloat seperatorPaddingRight = 10;
    CGFloat seperatorHeight = 24;
    CGFloat seperatorWidth = 0.5;
    
    CGFloat labelPadding = 6;
    CGFloat digAlertViewPadding = 13;
    CGFloat digAlertViewHeight = 52;
    
    CGFloat fontSize = 12;
    if (iPhone6Plus) {
        fontSize = 15;
        digAlertViewHeight = 60;
        cancelButtonWidth = 21;
        cancelButtonHeight = 21;
        
        confirmButtonWidth = 31.5f;
        confirmButtonHeight = 21;
        
        seperatorPaddingLeft = 13;
        seperatorPaddingRight = 13;
        seperatorHeight = 30;
        
        buttonPaddingLeft = 15;
        buttonPaddingRight = 15;
        labelPadding = 9;
    }
    
    self.pagingView.userInteractionEnabled = NO;
        
    UIView *digAlertView = [[UIView alloc] initWithFrame:CGRectMake(digAlertViewPadding , ScreenHeight, ScreenWidth - digAlertViewPadding * 2, digAlertViewHeight)];
    
    digAlertView.backgroundColor = [UIColor colorFromHexString:@"#00010c"];
    digAlertView.alpha = 0.88f;

    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonPaddingLeft, (digAlertViewHeight - cancelButtonHeight) / 2, cancelButtonWidth, cancelButtonHeight)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"提示取消"] forState:UIControlStateNormal];
        
    [closeButton addTarget:self action:@selector(digAlertViewDidClose:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setEnlargedEdgeWithTop:(digAlertViewHeight - cancelButtonHeight) / 2 left:buttonPaddingLeft bottom:(digAlertViewHeight - cancelButtonHeight) / 2 right:buttonPaddingRight];
    [digAlertView addSubview:closeButton];

    UILabel *leftSeperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(closeButton.frame) + seperatorPaddingLeft, (digAlertViewHeight - seperatorHeight) / 2, seperatorWidth, seperatorHeight)];
    leftSeperatorLabel.backgroundColor = [UIColor colorFromHexString:@"#cfcfd1"];
    [digAlertView addSubview:leftSeperatorLabel];

    
    CGFloat tipLabelX = CGRectGetMaxX(leftSeperatorLabel.frame) + seperatorPaddingRight;
    CGFloat tipLabelW = digAlertView.size.width - tipLabelX * 2 - 10;
    NSString *tipString = @"是否要使用剪切板中的数据进行挖掘?";
    CGFloat tipLabelH = [tipString sizeWithFont:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(tipLabelW, MAXFLOAT)].height;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelX, (digAlertViewHeight - tipLabelH * 2 - labelPadding) / 2, tipLabelW , tipLabelH)];
    tipLabel.text = tipString;
    tipLabel.font = [UIFont systemFontOfSize:fontSize];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.textColor = [UIColor colorFromHexString:@"#ffffff"];
    [digAlertView addSubview:tipLabel];
    
    UILabel *pasteLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelX, CGRectGetMaxY(tipLabel.frame) + labelPadding, tipLabelW, tipLabelH)];
    pasteLabel.text = latestSearch;
    pasteLabel.font = [UIFont systemFontOfSize:fontSize];
    pasteLabel.textAlignment = NSTextAlignmentLeft;
    pasteLabel.textColor = [UIColor colorFromHexString:@"#ffffff"];
    [digAlertView addSubview:pasteLabel];
    
    
    UILabel *rightSeperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tipLabel.frame) + seperatorPaddingLeft, (digAlertViewHeight - seperatorHeight) / 2, seperatorWidth, seperatorHeight)];
    rightSeperatorLabel.backgroundColor = [UIColor colorFromHexString:@"#cfcfd1"];
    [digAlertView addSubview:rightSeperatorLabel];
    
    
    UIButton *digConfirmButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rightSeperatorLabel.frame) + seperatorPaddingRight, (digAlertViewHeight - confirmButtonHeight) / 2, confirmButtonWidth, confirmButtonHeight)];
    [digConfirmButton setBackgroundImage:[UIImage imageNamed:@"提示对号"] forState:UIControlStateNormal];
    [digConfirmButton addTarget:self action:@selector(digAlertViewDidConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [digConfirmButton setEnlargedEdgeWithTop:(digAlertViewHeight - confirmButtonHeight) / 2 left:seperatorPaddingLeft bottom:(digAlertViewHeight - confirmButtonHeight) / 2 right:seperatorPaddingRight];
    
    [digAlertView addSubview:digConfirmButton];
    [self.view addSubview:digAlertView];
    self.digAlertView = digAlertView;
    
    [UIView animateWithDuration:1 animations:^{
        self.digAlertView.frame = CGRectMake(digAlertViewPadding , ScreenHeight - digAlertViewHeight * 2 - 30, ScreenWidth - digAlertViewPadding * 2, digAlertViewHeight);
    } completion:^(BOOL finished) {
            }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:0.3 animations:^{
//            self.digAlertView.alpha = 0.0f;
//        }  completion:^(BOOL finished) {
//            self.pagingView.userInteractionEnabled = YES;
//        }];
//    });

    }
}

- (void)digAlertViewDidClose:(UIButton *)sender {
    [self.digAlertView removeFromSuperview];
    self.pagingView.userInteractionEnabled = YES;

}

- (void)digAlertViewDidConfirm:(UIButton *)sender {
    LPDigViewController *diggerVc = [[LPDigViewController alloc] init];
    if (pasteboard.string.length > 0) {
        diggerVc.pasteString = pasteboard.string;
    }
    diggerVc.presented = YES;
    //    diggerVc.pasteURL = self.pasteURL;
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:diggerVc];
    self.genieTransition = [[GenieTransition alloc] init];
    nav.transitioningDelegate = self.genieTransition;
    nav.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 展开我的频道
- (void)downButtonClick {
    __weak __typeof(self)weakSelf = self;
    // 选中某个按钮后需要刷新频道
    [self.sortCollectionView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.blurView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 折叠我的频道
- (void)upButtonClick {
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

#pragma mark - 添加挖掘机
- (void)setupDigButton {
    DigButton *btn = [[DigButton alloc] init];
    [self.view addSubview:btn];
    btn.x = DigButtonPadding;
    btn.y = ScreenHeight - DigButtonPadding - DigButtonHeight;
    
    if (iPhone6Plus) {
         btn.y = ScreenHeight - 3 * DigButtonPadding - DigButtonHeight;
    }
    
    btn.width = DigButtonWidth;
    btn.height = DigButtonHeight;
    btn.layer.cornerRadius = btn.width / 2;
    [btn addTarget:self action:@selector(modalDigger) forControlEvents:UIControlEventTouchUpInside];
    self.digBtn = btn;
}

- (void)modalDigger {
    LPDigViewController *diggerVc = [[LPDigViewController alloc] init];
    //    diggerVc.hotwords = self.digTags;
    diggerVc.presented = YES;
    //    diggerVc.pasteURL = self.pasteURL;
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:diggerVc];
    //    _genieTransition = [[GenieTransition alloc] initWithToViewController:nav];
    self.genieTransition = [[GenieTransition alloc] init];
    nav.transitioningDelegate = self.genieTransition;
    nav.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - lazy loading
- (NSMutableArray *)digTags {
    if (_digTags == nil) {
        _digTags = [NSMutableArray array];
    }
    return _digTags;
}

- (NSMutableArray *)pressFrames
{
    if (_pressFrames == nil) {
        _pressFrames = [NSMutableArray array];
    }
    return _pressFrames;
}

- (NSMutableArray *)concerns
{
    if (_concerns == nil) {
        _concerns = [NSMutableArray array];
    }
    return _concerns;
}

- (NSMutableSet *)shimmeringOffIndexes {
    if (_shimmeringOffIndexes == nil) {
        _shimmeringOffIndexes = [NSMutableSet set];
    }
    return _shimmeringOffIndexes;
}

#pragma mark - 添加登录按钮
- (void)setupLoginButton {
    //添加右下角的登录按钮
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //如果用户已经登录则在右下角显示用户图像
    Account *account = [AccountTool account];
    if (self.userIcon) {
        [self.loginBtn setBackgroundImage:self.userIcon forState:UIControlStateNormal];
    } else {
        if (account == nil) {
            [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"登录icon"] forState:UIControlStateNormal];
        } else {
            [self displayLoginBtnIconWithAccount:account];
        }
    }
    
    CGFloat loginBtnWidth = 34;
    CGFloat loginBtnHeight = 34;
    CGFloat loginBtnY = ScreenHeight - 15 - loginBtnHeight;
    if (iPhone6Plus){
        loginBtnWidth += 2;
        loginBtnHeight += 2;
        loginBtnY = ScreenHeight - 45 - loginBtnHeight;
    }
    CGFloat loginBtnX = ScreenWidth - 15 - loginBtnWidth;

    
    self.loginBtn.frame = CGRectMake(loginBtnX, loginBtnY, loginBtnWidth, loginBtnHeight);
    self.loginBtn.layer.cornerRadius = self.loginBtn.frame.size.height / 2;
    self.loginBtn.layer.borderWidth = 1.5;
    //    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.loginBtn.layer.shadowRadius = 1;
    self.loginBtn.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.loginBtn.layer.shadowOffset = CGSizeMake(0, 0);
    self.loginBtn.layer.shadowOpacity = 0.8;
    [self.loginBtn addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panLoginView:)];
    [self.loginBtn addGestureRecognizer:pan];
    [self.view addSubview:self.loginBtn];
//    self.loginBtn.hidden = YES;
}

- (void)panLoginView:(UIPanGestureRecognizer *)pan
{
    CGFloat minX = pan.view.width / 2;
    CGFloat maxX = ScreenWidth - pan.view.width / 2;
    CGFloat minY = pan.view.height / 2;
    CGFloat maxY = ScreenHeight - pan.view.height / 2;
    CGPoint center = pan.view.center;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
            
        case UIGestureRecognizerStateEnded:
            if (center.x <= minX) {
                center.x = minX;
            }
            if (center.x >= maxX) {
                center.x = maxX;
            }
            if (center.y <= minY) {
                center.y = minY;
            }
            if (center.y >= maxY) {
                center.y = maxY;
            }
            
            break;
            
        default:
            break;
    }
    
    // 1.在view上面挪动的距离
    CGPoint translation = [pan translationInView:pan.view];
    center.x += translation.x;
    center.y += translation.y;
    if (center.x <= minX) {
        center.x = minX;
    }
    if (center.x >= maxX) {
        center.x = maxX;
    }
    if (center.y <= minY) {
        center.y = minY;
    }
    if (center.y >= maxY) {
        center.y = maxY;
    }
    pan.view.center = center;
    // 2.清空移动的距离
    [pan setTranslation:CGPointZero inView:pan.view];
}

#pragma mark - setup note observer
- (void)setupNoteObserver
{
    [noteCenter addObserver:self selector:@selector(accountLogin:) name:AccountLoginNotification  object:nil];
    [noteCenter addObserver:self selector:@selector(loadWebWithNote:) name:LPWebViewWillLoadNotification object:nil];
    [noteCenter addObserver:self selector:@selector(receiveAppReview) name:AppDidReceiveReviewNotification object:nil];
}

#pragma mark - login selectors

/**
 *  显示右下角登录icon
 *
 *  @param account 用户信息对象
 */
- (void)displayLoginBtnIconWithAccount:(Account *)account
{
    __weak typeof(self) weakSelf = self;
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:account.userIcon] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image && finished) {
            [weakSelf.loginBtn setBackgroundImage:[UIImage circleImageWithImage:image] forState:UIControlStateNormal];
        }
    }];
}
/**
 *  用户登录点击事件
 *
 *  @param loginBtn 响应点击事件的button
 */
- (void)userLogin:(UIButton *)loginBtn {
    if ([AccountTool account] != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"退出登录后无法进行评论哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }else{
        [AccountTool accountLoginWithViewController:self success:^(Account *account) {
            [MBProgressHUD showSuccess:@"登录成功"];
        } failure:^{
            [MBProgressHUD showError:@"登录失败"];
        } cancel:^{
            
        }];
    }
}

- (void)accountLogin:(NSNotification *)notification {
    [self displayLoginBtnIconWithAccount:[AccountTool account]];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //1.删除用户信息
        [AccountTool deleteAccount];
        //2.修改主界面icon
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"登录icon"] forState:UIControlStateNormal];
    }
}

#pragma mark - tag cloud view delegate
- (void)tagCloudViewDidClickStartButton:(LPTagCloudView *)tagCloudView {
    [UIView animateWithDuration:0.8 animations:^{
        self.tagCloudView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.containerView.userInteractionEnabled = YES;
        [self.tagCloudView removeFromSuperview];
    }];
}


#pragma mark - hotwords initialize
- (void)setupHotword {
    // 加载挖掘机热词
    [LPHttpTool postWithURL:HotwordsURL params:nil success:^(id json) {
        NSArray *jsonArray = (NSArray *)json;
        
        NSInteger majority = [jsonArray count] / HotwordPageCapacity * HotwordPageCapacity;
        NSInteger residual = [jsonArray count] - majority;
        NSInteger count = majority + (residual == 7 ? residual : 0);
        NSMutableArray *tags = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            NSDictionary *dict = jsonArray[i];
            NSString *title = dict[@"title"];
            [tags addObject:title];
        }
        self.digTags = tags;
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - app review note
- (void)receiveAppReview {
    UIView *hud = [[UIView alloc] initWithFrame:self.view.bounds];
    hud.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    [hud addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHUD:)]];
    
    UIView *alert = [[UIView alloc] init];
    alert.backgroundColor = [UIColor whiteColor];
    alert.layer.cornerRadius = 5;
    CGFloat w = 250;
    CGFloat x = (ScreenWidth - w) / 2;
    CGFloat h = 80;
    CGFloat y = (ScreenHeight - h) / 2;
    alert.frame = CGRectMake(x, y, w, h);
    [hud addSubview:alert];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"产品经理头像"]];
    icon.frame = CGRectMake(15, -26, 53, 53);
    [alert addSubview:icon];
    
    UILabel *title = [[UILabel alloc] init];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:15];
    CGFloat titleX = CGRectGetMaxX(icon.frame) + 10;
    CGFloat titleW = CGRectGetWidth(alert.frame) - titleX;
    title.frame = CGRectMake(titleX, 5, titleW, 25);
    title.text = @"我是产品经理Iirs";
    [alert addSubview:title];
    
    UILabel *tip = [[UILabel alloc] init];
    tip.textAlignment = NSTextAlignmentCenter;
    tip.textColor = [UIColor colorFromHexString:@"939393"];
    tip.text = @"谢谢您的评价, 请继续支持我们!";
    tip.font = [UIFont systemFontOfSize:14];
    tip.x = 0;
    tip.y = CGRectGetMaxY(title.frame) + 10;
    tip.width = CGRectGetWidth(alert.frame);
    tip.height = 20;
    [alert addSubview:tip];
    
    [self.view addSubview:hud];
    [self.view bringSubviewToFront:hud];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (hud) {
            [hud removeFromSuperview];
        }
    });
}

- (void)tapHUD:(UITapGestureRecognizer *)recognizer {
    UIView *hud = recognizer.view;
    [hud removeFromSuperview];
    hud = nil;
}

#pragma mark - setup app comment alert
- (void)setupAppCommentView {
    UIView *hud = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:hud];
    hud.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    hud.alpha = 0.0;
    
    UIView *commentAlert = [[UIView alloc] init];
    commentAlert.backgroundColor = [UIColor whiteColor];
    commentAlert.layer.cornerRadius = 5;
    CGFloat w = 250;
    CGFloat x = (ScreenWidth - w) / 2;
    CGFloat h = 200;
    CGFloat y = (ScreenHeight - h) / 2;
    commentAlert.frame = CGRectMake(x, ScreenHeight, w, h);
    [self.view addSubview:commentAlert];
    [self.view bringSubviewToFront:commentAlert];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"揭秘头像"]];
    icon.frame = CGRectMake(15, -26, 53, 53);
    [commentAlert addSubview:icon];
    
    UILabel *title = [[UILabel alloc] init];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:15];
    CGFloat titleX = CGRectGetMaxX(icon.frame) + 10;
    CGFloat titleW = CGRectGetWidth(commentAlert.frame) - titleX;
    title.frame = CGRectMake(titleX, 5, titleW, 25);
    title.text = @"评价看产品经理真容";
    [commentAlert addSubview:title];
    
    UILabel *tip = [[UILabel alloc] init];
    tip.textAlignment = NSTextAlignmentCenter;
    tip.textColor = [UIColor colorFromHexString:@"939393"];
    tip.text = @"您的鼓励和支持帮助我们做的更好";
    tip.font = [UIFont systemFontOfSize:14];
    tip.x = 0;
    tip.y = CGRectGetMaxY(title.frame) + 10;
    tip.width = CGRectGetWidth(commentAlert.frame);
    tip.height = 20;
    [commentAlert addSubview:tip];
    
    CGFloat btnX = CGRectGetMidX(icon.frame) - 5;
    CGFloat btnW = CGRectGetWidth(commentAlert.frame) - 2 * btnX;
    CGFloat btnH = 36;
    CGFloat commentY = CGRectGetMaxY(tip.frame) + 30;
    CGFloat cancelY = commentY + btnH + 16 - 0.5;
    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, commentY, btnW, btnH)];
    commentBtn.layer.cornerRadius = 4;
    commentBtn.backgroundColor = [UIColor colorFromHexString:@"53adf0"];
    [commentBtn setTitle:@"评价并围观" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [commentAlert addSubview:commentBtn];
    
    __weak typeof(commentAlert) wAlert = commentAlert;
    __weak typeof(hud) wHUD = hud;
    [commentBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        // 将相关偏好置NO, 表示点击了评价尚未完成
        [userDefaults setObject:@(NO) forKey:AppDidReceiveReviewUserDefaultKey];
        [userDefaults synchronize];
        // 移除蒙版和弹框
        [wAlert removeFromSuperview];
        [wHUD removeFromSuperview];
        // 跳转到AppStore评价页面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id987333155"]];
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, cancelY, btnW, btnH)];
    [cancelBtn setTitle:@"下次心情好再说" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor grayColor].CGColor;
    layer.borderWidth = 0.5;
    layer.fillColor = nil;
    layer.path = [UIBezierPath bezierPathWithRoundedRect:cancelBtn.bounds cornerRadius:4.0].CGPath;
    [cancelBtn.layer addSublayer:layer];
    [commentAlert addSubview:cancelBtn];
    [cancelBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:0 animations:^{
            wAlert.transform = CGAffineTransformMakeScale(1.2, 1.2);
            wAlert.alpha = 0.0;
            wHUD.alpha = 0.0;
        } completion:^(BOOL finished) {
            [wAlert removeFromSuperview];
            [wHUD removeFromSuperview];
        }];
    }];
    
    [UIView animateWithDuration:1.2 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:0 animations:^{
        commentAlert.y = y;
        hud.alpha = 1.0;
    } completion:nil];
}

#pragma mark - notification selector load web view
- (void)loadWebWithNote:(NSNotification *)note
{
    NSString *url = note.userInfo[LPWebURL];
    [LPPressTool loadWebViewWithURL:url viewController:self];
}

- (void)dealloc
{
    [noteCenter removeObserver:self];
}

@end
