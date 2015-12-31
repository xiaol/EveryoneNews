//
//  LPHomeViewController.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewController.h"
#import "LPMenuView.h"
#import "LPPagingView.h"
#import "UIImageView+WebCache.h"
//#import "LPChannelItemTool.h"
#import "LPChannelItem.h"
//#import "LPMenuButton.h"
#import "LPSortCollectionViewCell.h"
#import "LPSortCollectionReusableView.h"
#import "LPChannelItemTool.h"
#import "LPMenuCollectionViewCell.h"
#import "LPSortCollectionView.h"
//#import "CardTool.h"
//#import "CardParam.h"
//#import "Card+CoreDataProperties.h"
#import "LPHomeViewCell.h"
//#import "CardFrame.h"
#import "LPPagingViewPage.h"
#import "LPHomeViewController+ChannelItemMenu.h"
#import "LPHomeViewController+PagingView.h"

#import "LPDetailViewController.h"


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



const static CGFloat menuViewHeight = 44;
const static CGFloat statusBarHeight = 20;
static NSString *cellIdentifier = @"sortCollectionViewCell";
static NSString *reuseIdentifierFirst = @"reuseIdentifierFirst";
static NSString *reuseIdentifierSecond = @"reuseIdentifierSecond";
static NSString *menuCellIdentifier = @"menuCollectionViewCell";
static NSString *reusePageID = @"reusePageID";
static NSString *firstChannelName = @"社会";

// 展开折叠图片宽度
const static float menuImageViewWidth= 44;

@interface LPHomeViewController () <LPTagCloudViewDelegate>

@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;
// 向下箭头
@property (nonatomic, strong) UIImageView *downImageView;
// 向上箭头
@property (nonatomic, strong) UIImageView *upImageView;


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
//@property (nonatomic,strong) MBProgressHUD *progressView;
@property (nonatomic, strong) NSMutableArray *pressFrames;

@property (nonatomic, strong) UICollectionView *concernView;
//@property (nonatomic, strong) UIActivityIndicatorView *waitingIndicator;
@property (nonatomic, strong) NSMutableArray *concerns;

@property (nonatomic, strong) NSMutableSet *shimmeringOffIndexes;

@property (nonatomic, strong) LPTagCloudView *tagCloudView;


@property (nonatomic, strong) NSMutableArray *digTags;

@property (nonatomic, copy) NSString *pasteURL;

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
    [self setupLoginButton];
    [self setupDigButton];
    [self setupNoteObserver];
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
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

- (NSMutableDictionary *)contentOffsetDictionary {
    if (_contentOffsetDictionary == nil) {
        _contentOffsetDictionary = [[NSMutableDictionary alloc] init];
    }
    return _contentOffsetDictionary;
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
    
    // 菜单栏
    UICollectionViewFlowLayout *menuViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    menuViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    menuViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    LPMenuView *menuView = [[LPMenuView alloc] initWithFrame:CGRectMake(0, 0 , ScreenWidth - menuImageViewWidth,statusBarHeight + menuViewHeight) collectionViewLayout:menuViewFlowLayout];
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
    
    // 向下箭头
    UIImage *downImage = [UIImage imageNamed:@"首页向下箭头"];
    self.downImageView = [[UIImageView alloc] initWithImage:downImage];
    self.downImageView.contentMode = UIViewContentModeCenter;
    self.downImageView.userInteractionEnabled = YES;
    self.downImageView.frame = CGRectMake(ScreenWidth - menuImageViewWidth, statusBarHeight, menuImageViewWidth, menuImageViewWidth);
    
    UITapGestureRecognizer *tapDownGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDownImageView)];
    tapDownGesture.delegate = self;
    [self.downImageView addGestureRecognizer:tapDownGesture];
    [topBackgroundView addSubview:self.downImageView];
    
    
    UIView *blurView = [[UIView alloc] initWithFrame:CGRectMake(0,  - ScreenHeight, ScreenWidth, ScreenHeight)];
    blurView.backgroundColor = [UIColor whiteColor];
    blurView.alpha = 0.95;
    [self.view addSubview:blurView];
    self.blurView = blurView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.sortCollectionView = [[LPSortCollectionView alloc] initWithFrame:CGRectMake(0, statusBarHeight + menuViewHeight, ScreenWidth, ScreenHeight - statusBarHeight- menuViewHeight) collectionViewLayout:layout];
    self.sortCollectionView.delegate = self;
    self.sortCollectionView.dataSource = self;
    self.sortCollectionView.backgroundColor = [UIColor whiteColor];
    self.sortCollectionView.alpha = 0.95;
    [self.sortCollectionView registerClass:[LPSortCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.sortCollectionView registerClass:[LPSortCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierFirst];
    [self.sortCollectionView registerClass:[LPSortCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierSecond];
    [blurView addSubview:self.sortCollectionView];


    UIImage *upImage = [UIImage imageNamed:@"首页向上箭头"];
    self.upImageView = [[UIImageView alloc] initWithImage:upImage];
    self.upImageView.contentMode = UIViewContentModeCenter;
    self.upImageView.userInteractionEnabled = YES;
    self.upImageView.frame = CGRectMake(ScreenWidth - menuImageViewWidth, statusBarHeight, menuImageViewWidth, menuImageViewWidth);
    
    UITapGestureRecognizer *tapUpGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUpImageView)];
    tapUpGesture.delegate = self;
    [self.upImageView addGestureRecognizer:tapUpGesture];
    [blurView addSubview:self.upImageView];
    
}

#pragma mark - 点击向下箭头
- (void)tapDownImageView {
    __weak __typeof(self)weakSelf = self;
    // 选中某个按钮后需要刷新频道
    [self.sortCollectionView reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.blurView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 点击向上箭头
- (void)tapUpImageView {
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
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.blurView.frame = CGRectMake(0, - ScreenHeight, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        
    }];

}


- (void)setupDigButton {
    DigButton *btn = [[DigButton alloc] init];
    [self.view addSubview:btn];
    btn.x = DigButtonPadding;
    btn.y = ScreenHeight - DigButtonPadding - DigButtonHeight;
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
    if (iPhone6Plus){
        loginBtnWidth += 2;
        loginBtnHeight += 2;
    }
    CGFloat loginBtnX = ScreenWidth - 15 - loginBtnWidth;
    CGFloat loginBtnY = ScreenHeight - 15 - loginBtnHeight;
    
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
    [noteCenter addObserver:self selector:@selector(receiveJPushNotification:) name:LPPushNotificationFromLaunching object:nil];
    [noteCenter addObserver:self selector:@selector(receiveJPushNotification:) name:LPPushNotificationFromBack object:nil];
    [noteCenter addObserver:self selector:@selector(accountLogin:) name:AccountLoginNotification  object:nil];
    [noteCenter addObserver:self selector:@selector(commentSuccess) name:LPCommentDidComposeSuccessNotification object:nil];
    [noteCenter addObserver:self selector:@selector(loadWebWithNote:) name:LPWebViewWillLoadNotification object:nil];
    [noteCenter addObserverForName:NetworkReachabilityDidChangeToReachableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (!self.pressFrames.count) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setupDataWithCategory:[LPCategory categoryWithURL:HomeUrl] completion:nil];
            });
        }
    }];
    [noteCenter addObserver:self selector:@selector(receiveAppReview) name:AppDidReceiveReviewNotification object:nil];
}

#pragma mark - setup tabbar index
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    
    self.customTabBar.sliderView.x = (selectedIndex == 0) ? 0 : TabBarButtonWidth;
    self.customTabBar.selectedButton = [self.customTabBar.tabBarButtons objectAtIndex:selectedIndex];
    CGPoint offset = CGPointMake(ScreenWidth * selectedIndex, 0);
    self.containerView.contentOffset = offset;
    _selectedIndex = selectedIndex;
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
#pragma mark - setup home data with JPush remote notification block
- (void)setupDataWithCategory:(LPCategory *)category completion:(completionBlock)block {
    sharedIndicator.hidden = NO;
    [sharedIndicator startAnimating];
    self.homeView.hidden = YES;
    // 清空数据
    [self.pressFrames removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [LPPressTool homePressesWithCategory:category success:^(id json) {
        //        NSMutableArray *pressFrameArray = [NSMutableArray array];
        // 字典转模型
        for (NSDictionary *dict in (NSArray *)json) {
            LPPress *press = [LPPress objectWithKeyValues:dict];
            if (press.special.intValue != 9) {
                LPPressFrame *pressFrame = [[LPPressFrame alloc] init];
                pressFrame.press = press;
                [self.pressFrames addObject:pressFrame];
            }
        }
        if (self.pressFrames.count == 0) {
            return;
        }
        // 插入时间栏
        int i = 0;
        for (; i < self.pressFrames.count; i++) {
            LPPressFrame *pressFrame = self.pressFrames[i];
            LPPress *press = pressFrame.press;
            if (press.special.integerValue == 400) {
                break;
            }
        }
        if (i == self.pressFrames.count) {
            i = 0;
        }
        weakSelf.timeRow = MAX(i - 1, 0);
        //插入时间栏LPPressFrame
        //        LPPressFrame *timePressFrame = [[LPPressFrame alloc] init];
        //        LPPress *timePress = [[LPPress alloc] init];
        //        timePress.special = @"1000";
        //        timePressFrame.press = timePress;
        //        NSInteger insertPosition = (weakSelf.timeRow == 0)? 0:weakSelf.timeRow +1;
        //        [pressFrameArray insertObject:timePressFrame atIndex:insertPosition];
        weakSelf.anyDisplayingCellRow = i;
        
        // 模型数组属性的赋值
        //        self.pressFrames = pressFrameArray;
        LPSpringLayout *layout = (LPSpringLayout *)weakSelf.homeView.collectionViewLayout;
        layout.springinessEnabled = YES;
        [layout reset];
        [weakSelf.homeView reloadData];
        self.containerView.userInteractionEnabled = YES;
        self.loginBtn.hidden = NO;
        self.digBtn.hidden = NO;
        if (block) {
            block();
            //            [weakSelf setupHotword];
        } else {
            //            [weakSelf setupHotword];
            
            CGPoint initialOffset = CGPointMake(0, weakSelf.timeRow * (PhotoCellHeight + CellHeightBorder));
            [weakSelf.homeView setContentOffset:initialOffset animated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.homeView.hidden = NO;
                [sharedIndicator stopAnimating];
            });
        }
        
    } failure:^(NSError *error) {
        [sharedIndicator stopAnimating];
        self.containerView.userInteractionEnabled = YES;
        [MBProgressHUD showError:@"网络不给力 :(" toView:self.view];
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

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isScrolled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isScrolled = NO;
    
    if ([scrollView class] == [self.containerView class]) {
        CGFloat x = scrollView.contentOffset.x;
        if (x == ScreenWidth) {
            self.selectedIndex = 1;
        }else{
            self.selectedIndex = 0;
        }
    } else if (scrollView == self.homeView) {
        if ((int)(scrollView.contentSize.height - scrollView.contentOffset.y - ScreenHeight) == 0 && self.pressFrames.count > 0) {
            // 弹出评价框 (once_token)
            NSNumber *review = [userDefaults objectForKey:AppDidReceiveReviewUserDefaultKey];
            if (!review) {
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    [self setupAppCommentView];
                });
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.containerView) {
        self.customTabBar.sliderView.x = TabBarButtonWidth * (scrollView.contentOffset.x / ScreenWidth);
    }
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


#pragma mark - jpush notification handler
- (void)receiveJPushNotification:(NSNotification *)note
{
    NSLog(@"--receiveJPushNotification-%s",__func__);
    
    self.selectedIndex = 1;
    if (self.presentedViewController != nil) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    NSDictionary *info = note.userInfo;
    NSString *url = info[LPPushNotificationURL];
    [self.navigationController popToRootViewControllerAnimated:NO];
    __weak typeof(self) weakSelf = self;
    [self setupDataWithCategory:[LPCategory categoryWithURL:HomeUrl] completion:^{
        for (int row = 0; row < self.pressFrames.count; row ++) {
            LPPressFrame *pressFrame = self.pressFrames[row];
            if ([pressFrame.press.sourceUrl isEqualToString:url]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:0];
                if (row > 0) {
                    [weakSelf.homeView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
                }
                [weakSelf collectionView:weakSelf.homeView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0]];
#pragma warning - 重复代码 及时抽取
                //                self.selectedRow = row;
                //                LPPressFrame *pressFrame = self.pressFrames[row];
                //                LPPress *press = pressFrame.press;
                //                LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
                //                detailVc.isConcernDetail = NO;
                //                detailVc.press = press;
                //                [self.navigationController pushViewController:detailVc animated:NO];
                break;
            }
        }
        weakSelf.homeView.hidden = NO;
    }];
}



// 评论成功后，若原来没有评论图标，就显示
- (void)commentSuccess
{
    LPPressFrame *pressFrame = self.pressFrames[self.selectedRow];
    LPPress *press = pressFrame.press;
    if (press.isCommentsFlag.intValue == 0) {
        press.isCommentsFlag = @"1";
        self.isScrolled = NO;
        [self.homeView reloadData];
    }
}

#pragma mark - notification selector load web view
- (void)loadWebWithNote:(NSNotification *)note
{
    NSString *url = note.userInfo[LPWebURL];
    [LPPressTool loadWebViewWithURL:url viewController:self];
}

#pragma mark - push featured vc with presses
- (void)pushFeaturedViewContollerAtRow:(NSInteger)row animation:(BOOL)animation {
    LPFeaturedViewController *featuredVc = [[LPFeaturedViewController alloc] init];
    featuredVc.item = row;
    NSMutableArray *presses = [NSMutableArray array];
    for (LPPressFrame *pressFrame in self.pressFrames) {
        LPPress *press = pressFrame.press;
        [presses addObject:press];
    }
    featuredVc.presses = presses;
    [self.navigationController pushViewController:featuredVc animated:animation];
    self.containerView.hidden = NO;
}

- (void)dealloc
{
    [noteCenter removeObserver:self];
}

@end
