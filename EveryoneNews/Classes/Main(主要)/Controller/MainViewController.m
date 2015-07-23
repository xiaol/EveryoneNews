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
#import "MobClick.h"
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

typedef void (^completionBlock)();

#define ConcernCellReuseIdentifier @"concernCell"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

//自定义的顶部导航
@property (nonatomic,strong) LPTabBar *customTabBar;
//主界面右下角的登录按钮
@property (nonatomic,strong) UIButton *loginBtn;
//所有内容展示的ScrollView
@property (nonatomic,strong) UIScrollView *containerView;
//左边分类对应的ScrollView
//@property (nonatomic,strong) CategoryView *categoryView;
//右边展示内容的TableView
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger timeRow;
@property (nonatomic, assign) NSUInteger anyDisplayingCellRow;
@property (nonatomic, assign) BOOL isScrolled;
@property (nonatomic, assign) NSUInteger selectedRow;
@property (nonatomic, assign) NSUInteger selectedIndex;
//@property (nonatomic,strong) MBProgressHUD *progressView;
@property (nonatomic, strong) NSMutableArray *pressFrames;

@property (nonatomic, strong) UICollectionView *concernView;
//@property (nonatomic, strong) UIActivityIndicatorView *waitingIndicator;
@property (nonatomic, strong) NSArray *concerns;

@property (nonatomic, strong) NSMutableSet *shimmeringOffIndexes;
@end

@implementation MainViewController


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContainerScrollerView];
    [self setupConcernView];
    [self setupTableView];
    [self setupTabBar];
    [self setupLoginButton];
    [self setupDataWithCategory:[LPCategory categoryWithURL:HomeUrl] completion:nil];
    [self setupConcernData];
    [self setupNoteObserver];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MainViewController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MainViewController"];
}

#pragma mark - lazy loading
- (NSMutableArray *)pressFrames
{
    if (_pressFrames == nil) {
        _pressFrames = [NSMutableArray array];
    }
    return _pressFrames;
}

- (NSArray *)concerns
{
    if (_concerns == nil) {
        _concerns = [NSArray array];
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
    [self.view addSubview:self.containerView];
}

- (void)setupConcernView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ScreenWidth, ScreenWidth * 6 / 25);
    layout.sectionInset = UIEdgeInsetsMake(TabBarHeight, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = - 0.5;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *concernView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [concernView registerClass:[LPConcernCell class] forCellWithReuseIdentifier:ConcernCellReuseIdentifier];
     concernView.backgroundColor = [UIColor clearColor];

    concernView.dataSource = self;
    concernView.delegate = self;
    [self.containerView addSubview:concernView];
    self.concernView = concernView;
}

- (void)setupTableView{
    self.tableView  = [[UITableView alloc] init];
    self.tableView.x = ScreenWidth;
    self.tableView.y = 0;
    self.tableView.width = ScreenWidth;
    self.tableView.height = ScreenHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(TabBarHeight, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.containerView addSubview:self.tableView];
    
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
    if (account == nil) {
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"登录icon"] forState:UIControlStateNormal];
    } else {
        [self displayLoginBtnIconWithAccount:account];
    }
    
    CGFloat loginBtnWidth = 35;
    CGFloat loginBtnHeight = 35;
    if (iPhone6Plus){
        loginBtnWidth += 1;
        loginBtnHeight += 1;
    }
    CGFloat loginBtnX = ScreenWidth - 20 - loginBtnWidth;
    CGFloat loginBtnY = ScreenHeight - 20 - loginBtnHeight;
    if (iPhone6Plus) {
        loginBtnX -= 1;
        loginBtnY -= 1;
    }
    self.loginBtn.frame = CGRectMake(loginBtnX, loginBtnY, loginBtnWidth, loginBtnHeight);
    self.loginBtn.layer.cornerRadius = self.loginBtn.frame.size.height / 2;
    self.loginBtn.layer.borderWidth = 1.5;
//    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.loginBtn.layer.shadowRadius = 1;
    self.loginBtn.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.loginBtn.layer.shadowOffset = CGSizeMake(0, 0);
    self.loginBtn.layer.shadowOpacity = 0.75;
//    self.loginBtn.layer.masksToBounds = YES;
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(- shadowRadius, - shadowRadius, loginBtnWidth + 2 * shadowRadius, loginBtnHeight + 2 * shadowRadius)];
//    self.loginBtn.layer.shadowPath = path.CGPath;
    [self.loginBtn addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panLoginView:)];
    [self.loginBtn addGestureRecognizer:pan];
    [self.view addSubview:self.loginBtn];
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
    UIImageView *imageView = [[UIImageView alloc] init];
    __weak typeof(self) weakSelf = self;
    [imageView sd_setImageWithURL:[NSURL URLWithString:account.userIcon] placeholderImage:[UIImage imageNamed:@"登录icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            UIImage *icon = [imageView.image circleImage];
            [weakSelf.loginBtn setBackgroundImage:icon forState:UIControlStateNormal];
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
        [AccountTool accountLoginWithViewController:self success:^{
            NSLog(@"---授权成功");
            [MBProgressHUD showSuccess:@"登录成功"];
            [self displayLoginBtnIconWithAccount:[AccountTool account]];
        } failure:^{
            [MBProgressHUD showError:@"登录失败"];
        } cancel:nil];
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

#pragma mark - setup home data with JPush remote notification block
- (void)setupDataWithCategory:(LPCategory *)category completion:(completionBlock)block {
    sharedIndicator.hidden = NO;
    [sharedIndicator startAnimating];
    self.tableView.hidden = YES;
    // 清空数据
    [self.pressFrames removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [LPPressTool homePressesWithCategory:category success:^(id json) {
        NSMutableArray *pressFrameArray = [NSMutableArray array];
        // 字典转模型
        for (NSDictionary *dict in (NSArray *)json) {
            LPPress *press = [LPPress objectWithKeyValues:dict];
            if (press.special.intValue != 9) {
                LPPressFrame *pressFrame = [[LPPressFrame alloc] init];
                pressFrame.press = press;
                [pressFrameArray addObject:pressFrame];
            }
        }
        if (pressFrameArray.count == 0) {
            return;
        }
        // 插入时间栏
        int i = 0;
        for (; i < pressFrameArray.count; i++) {
            LPPressFrame *pressFrame = pressFrameArray[i];
            LPPress *press = pressFrame.press;
            if (press.special.integerValue == 400) {
                break;
            }
        }
        if (i == pressFrameArray.count) {
            i = 0;
        }
        weakSelf.timeRow = MAX(i - 1, 0);
        weakSelf.anyDisplayingCellRow = i;

        //        LPPressFrame *pressFrame = [LPPressFrame pressFrameWithTimeCell];
        //        [pressFrameArray insertObject:nil atIndex:self.timeRow];
        // 模型数组属性的赋值
        self.pressFrames = pressFrameArray;
        [weakSelf.tableView reloadData];
        if (block) {
            block();
        } else {
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.timeRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            weakSelf.isScrolled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tableView.hidden = NO;
            });
        }
        [sharedIndicator stopAnimating];
    } failure:^(NSError *error) {
        [sharedIndicator stopAnimating];
        [MBProgressHUD showError:@"网络不给力 :(" toView:self.view];
    }];
}

#pragma mark - setup concern view data
- (void)setupConcernData
{
    NSString *url = [NSString stringWithFormat:@"%@%@", ServerUrl, ConcernsUrl];
    [LPHttpTool getWithURL:url params:nil success:^(id json) {
        self.concerns = [LPConcern objectArrayWithKeyValuesArray:json];
        [self.concernView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.concerns.count - 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __block LPConcernCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ConcernCellReuseIdentifier forIndexPath:indexPath];
    
    cell.concern = self.concerns[indexPath.item];
    
    [self.shimmeringOffIndexes enumerateObjectsUsingBlock:^(NSIndexPath *eIndexPath, BOOL *stop) {
        if (eIndexPath.row == indexPath.row) {
            cell.shimmering = NO;
        }
    }];
    
    return cell;
}

#pragma mark - Collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ConcernViewController *concernVc = [[ConcernViewController alloc] init];
    concernVc.concern = self.concerns[indexPath.item];
    LPConcernCell *cell = (LPConcernCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.shimmering = NO;
    [self.shimmeringOffIndexes addObject:indexPath];
    [self.navigationController pushViewController:concernVc animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.pressFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPPressCell *cell = [LPPressCell cellWithTableView:tableView];
    cell.pressFrame = self.pressFrames[indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isScrolled == NO) {
        return;
    }
    
    CATransform3D translation;
    
    if (indexPath.row > self.anyDisplayingCellRow) {
        translation = CATransform3DMakeTranslation(0, ScreenHeight, 0);
    } else if (indexPath.row < self.anyDisplayingCellRow) {
        translation = CATransform3DMakeTranslation(0, - ScreenHeight, 0);
    } else {
        return;
    }
    self.anyDisplayingCellRow = indexPath.row;
    
    cell.layer.transform = translation;
    
    [UIView beginAnimations:@"translation" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    cell.layer.transform = CATransform3DIdentity;
    
    [UIView commitAnimations];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPPressFrame *pressFrame = self.pressFrames[indexPath.row];
    return pressFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
    LPPressFrame *pressFrame = self.pressFrames[indexPath.row];
    LPPress *press = pressFrame.press;
    LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
    detailVc.isConcernDetail = NO;
    detailVc.press = press;
    [self.navigationController pushViewController:detailVc animated:YES];
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
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    if ([scrollView class] == [self.containerView class]) {
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
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                [weakSelf tableView:weakSelf.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
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
        weakSelf.tableView.hidden = NO;
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
        [self.tableView reloadData];
    }
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