//
//  HomeViewController.m
//  EveryoneNews
//
//  Created by Feng on 15/7/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MainViewController.h"
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

typedef void (^completionBlock)();


NSString * const HomeCellReuseIdentifier = @"homeCell";
NSString * const ConcernCellReuseIdentifier = @"concernCell";
const NSInteger HotwordPageCapacity = 8;
NSString * const HotwordsURL = @"http://api.deeporiginalx.com/news/baijia/fetchElementary";

@interface MainViewController ()  <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LPTagCloudViewDelegate>

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

@property (nonatomic, weak) LPDigViewController *digVc;
@end

@implementation MainViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContainerScrollerView];
    [self setupConcernView];
    [self setupHomeView];
    [self setupTabBar];
    [self setupLoginButton];
    [self setupDigButton];
    [self setupDataWithCategory:[LPCategory categoryWithURL:HomeUrl] completion:nil];
    [self setupConcernData];
    [self setupNoteObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    self.digVc = diggerVc;
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

#pragma mark - setup subviews
- (void)setupContainerScrollerView{
    self.containerView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.containerView.contentSize = CGSizeMake(ScreenWidth * 2.0, 0);
    self.containerView.scrollEnabled = YES;
    self.containerView.pagingEnabled = YES;
    self.containerView.bounces = NO;
    self.containerView.showsHorizontalScrollIndicator = NO;
    self.containerView.showsVerticalScrollIndicator = NO;
    self.containerView.backgroundColor = [UIColor colorFromHexString:@"#ebeded"];
    self.containerView.contentOffset = CGPointMake(ScreenWidth, 0);
    self.containerView.delegate = self;
    self.containerView.userInteractionEnabled = NO;
    [self.view addSubview:self.containerView];
}

- (void)setupConcernView{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = -0.5;
    //    layout.springDamping = 0.75;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(TabBarHeight, 0, 0, 0);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[LPConcernCell class] forCellWithReuseIdentifier:ConcernCellReuseIdentifier];
    collectionView.dataSource = self;
    collectionView.delegate = self;
//    collectionView.bounces = NO;
    [self.containerView addSubview:collectionView];
    self.concernView = collectionView;
}

- (void)setupHomeView{
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.minimumLineSpacing = CellHeightBorder;
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    LPSpringLayout *layout = [[LPSpringLayout alloc] init];
    layout.minimumLineSpacing = CellHeightBorder;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(TabBarHeight, 0, 0, 0);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[LPPressCell class] forCellWithReuseIdentifier:HomeCellReuseIdentifier];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.decelerationRate = 0.7;
    [self.containerView addSubview:collectionView];
    self.homeView = collectionView;
    
    // 菊花
    sharedIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    sharedIndicator.center = self.view.center;
    sharedIndicator.color = [UIColor lightGrayColor];
    [self.view addSubview:sharedIndicator];
}

- (void)setupTabBar
{
    self.customTabBar = [[LPTabBar alloc] init];
    self.customTabBar.frame = CGRectMake(0, 0, ScreenWidth, TabBarHeight);
    self.customTabBar.backgroundColor = [UIColor colorFromHexString:@"00051c"];
    UITabBarItem *firstTabBarItem = [[UITabBarItem alloc] initWithTitle:@"关注" image:nil tag:0];
    UITabBarItem *secondTabBarItem = [[UITabBarItem alloc] initWithTitle:@"今日" image:nil tag:1];
    [self.customTabBar addTabBarButtonWithItem:firstTabBarItem tag:0];
    [self.customTabBar addTabBarButtonWithItem:secondTabBarItem tag:1];
    __weak typeof(self) weakSelf = self;
    [self.customTabBar setBabBarDidClickBlock:^(int from, int to) {
        CGPoint offSetPoint;
        if (from < to) {
            offSetPoint = CGPointMake(ScreenWidth, 0);
        }else{
            offSetPoint = CGPointMake(0, 0);
        }
        weakSelf.customTabBar.sliderView.x = (from < to) ? TabBarButtonWidth:0;
        [UIView animateWithDuration:0.5f animations:^{
            weakSelf.containerView.contentOffset = offSetPoint;
        }];
    }];
    [self.view addSubview:self.customTabBar];
    self.selectedIndex = 1;
}

- (void)setupLoginButton{
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
    self.loginBtn.hidden = YES;
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
                [self setupConcernData];
            });
        }
    }];
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
//    [imageView sd_setImageWithURL:[NSURL URLWithString:account.userIcon] placeholderImage:[UIImage imageNamed:@"登录icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (!error) {
//            UIImage *icon = [UIImage circleImageWithImage:image];
//            [weakSelf.loginBtn setBackgroundImage:icon forState:UIControlStateNormal];
//        }
//    }];
    
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
//            if ([account.platformType isEqualToString:@"sina"]) {
//                self.containerView.userInteractionEnabled = NO;
//                NSMutableDictionary *params = [NSMutableDictionary dictionary];
//                params[@"userId"] = account.userId;
//                params[@"token"] = account.token;
//                params[@"platformType"] = @"sina";
//                NSString *url = [NSString stringWithFormat:@"%@/news/baijia/fetchTags", ServerUrl];
//                [LPHttpTool getWithURL:url params:params success:^(id json) {
////                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        NSArray *tags = json[@"tags"];
//                        if (!tags || !tags.count) {
//                            [MBProgressHUD showSuccess:@"登录成功"];
//                            self.containerView.userInteractionEnabled = YES;
//                        } else {
//                            LPTagCloudView *tagCloudView = [[LPTagCloudView alloc] init];
//                            tagCloudView.delegate = self;
//                            tagCloudView.alpha = 0;
//                            [self.navigationController.topViewController.view addSubview:tagCloudView];
//                            [self.navigationController.topViewController.view bringSubviewToFront:tagCloudView];
//                            tagCloudView.frame = self.view.bounds;
//                            tagCloudView.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.95];
//                            tagCloudView.pageCapacity = 8;
//                            tagCloudView.tags = tags;
//                            
//                            self.tagCloudView = tagCloudView;
//                            [UIView animateWithDuration:0.5 animations:^{
//                                tagCloudView.alpha = 1.0;
//                            } completion:^(BOOL finished) {
//                                self.containerView.userInteractionEnabled = YES;
//                            }];
//                        }
////                    });
//                } failure:^(NSError *error) {
//                    self.containerView.userInteractionEnabled = YES;
//                    NSLog(@"error");
//                }];
//            } else {
//                NSLog(@"platform type : %@", account.platformType);
//                [MBProgressHUD showSuccess:@"登录成功"];
//            }
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


#pragma mark - setup concern view data
- (void)setupConcernData
{
    [self.concerns  removeAllObjects];
    NSString *url = [NSString stringWithFormat:@"%@%@", ServerUrl, ConcernsUrl];
    [LPHttpTool getWithURL:url params:nil success:^(id json) {
        NSArray *concerns = [LPConcern objectArrayWithKeyValuesArray:json];
        __block NSMutableArray *concernArray = [NSMutableArray arrayWithArray:concerns];
        [concernArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LPConcern *concern = (LPConcern *)obj;
            if ([concern.channel_name isEqualToString:@"谷歌今日焦点"]) {
                [concernArray removeObject:concern];
            }
            self.concerns = concernArray;
        }];
        [self.concernView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.homeView) {
        return self.pressFrames.count;
    } else {
        return self.concerns.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.homeView) {
        LPPressCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCellReuseIdentifier forIndexPath:indexPath];
        cell.pressFrame = self.pressFrames[indexPath.item];
        return cell;
    } else {
        LPConcernCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ConcernCellReuseIdentifier forIndexPath:indexPath];
        
        cell.concern = self.concerns[indexPath.row];
        
        [self.shimmeringOffIndexes enumerateObjectsUsingBlock:^(NSIndexPath *eIndexPath, BOOL *stop) {
            if (eIndexPath.item == indexPath.item) {
                cell.shimmering = NO;
            }
        }];
        
        return cell;
    }
}

#pragma mark - Collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.homeView) {
        self.selectedRow = indexPath.row;
        LPPressFrame *pressFrame = self.pressFrames[indexPath.row];
        LPPress *press = pressFrame.press;
        LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
        detailVc.isConcernDetail = NO;
        detailVc.press = press;
        [self.navigationController pushViewController:detailVc animated:YES];
    } else {
        ConcernViewController *concernVc = [[ConcernViewController alloc] init];
        concernVc.concern = self.concerns[indexPath.item];
        LPConcernCell *cell = (LPConcernCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.shimmering = NO;
        [self.shimmeringOffIndexes addObject:indexPath];
        [self.navigationController pushViewController:concernVc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.homeView) {
        LPPressFrame *pressFrame = self.pressFrames[indexPath.item];
        return CGSizeMake(ScreenWidth, pressFrame.cellHeight);
    } else {
        return CGSizeMake(ScreenWidth, ScreenWidth * 6 / 25);
    }
}




#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.isScrolled == NO) {
//        return;
//    }
//    
//    CATransform3D translation;
//    
//    if (indexPath.row > self.anyDisplayingCellRow) {
//        translation = CATransform3DMakeTranslation(0, ScreenHeight, 0);
//    } else if (indexPath.row < self.anyDisplayingCellRow) {
//        translation = CATransform3DMakeTranslation(0, - ScreenHeight, 0);
//    } else {
//        return;
//    }
//    self.anyDisplayingCellRow = indexPath.row;
//    
//    cell.layer.transform = translation;
//    
//    [UIView beginAnimations:@"translation" context:NULL];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    cell.layer.transform = CATransform3DIdentity;
//    
//    [UIView commitAnimations];
//}

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
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.containerView) {
        self.customTabBar.sliderView.x = TabBarButtonWidth * (scrollView.contentOffset.x / ScreenWidth);
    }
}

- (void)receiveJPushNotification:(NSNotification *)note
{
    NSLog(@"--receiveJPushNotification-%s",__func__);
    LPTabBarButton *btn = self.customTabBar.tabBarButtons[1];
    [btn setTitle:@"今日" forState:UIControlStateNormal];
    self.selectedIndex = 1;
    
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