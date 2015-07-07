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
#import "CategoryScrollView.h"
#import "MobClick.h"
#import "LPPressTool.h"
#import "LPCategory.h"
#import "LPPressFrame.h"
#import "LPPress.h"
#import "MJExtension.h"
#import "LPPressCell.h"
#import "LPDetailViewController.h"
#import "MBProgressHUD+MJ.h"
#import "CustomLoaddingView.h"
typedef void (^completionBlock)();


@interface MainViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

//自定义的顶部导航
@property (nonatomic,strong) LPTabBar *customTabBar;
//主界面右下角的登录按钮
@property (nonatomic,strong) UIButton *loginBtn;
//所有内容展示的ScrollView
@property (nonatomic,strong) UIScrollView *containerScrollView;
//左边分类对应的ScrollView
@property (nonatomic,strong) CategoryScrollView *categoryScrollView;
//右边展示内容的TableView
@property (nonatomic,strong) UITableView *homeTableView;
@property (nonatomic, strong) NSMutableArray *pressFrames;
@property (nonatomic, assign) NSUInteger timeRow;
@property (nonatomic, assign) NSUInteger anyDisplayingCellRow;
@property (nonatomic, assign) BOOL isScrolled;
@property (nonatomic, assign) NSUInteger selectedRow;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic,strong) MBProgressHUD *progressView;
@property (nonatomic,strong) CustomLoaddingView *loaddingView;

@end

@implementation MainViewController

- (NSMutableArray *)pressFrames
{
    if (_pressFrames == nil) {
        _pressFrames = [NSMutableArray array];
    }
    return _pressFrames;
}
//影藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark - 友盟统计
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%.1f---%.1f", ScreenHeight,ScreenWidth);
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"HomePage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"HomePage"];
}
#pragma mark - 初始化子view
- (void)setupContainerScrollerView{
    self.containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.containerScrollView.contentSize = CGSizeMake(ScreenWidth * 2.0, 0);
    self.containerScrollView.scrollEnabled = YES;
    self.containerScrollView.pagingEnabled = YES;
    self.containerScrollView.bounces = NO;
    self.containerScrollView.showsHorizontalScrollIndicator = NO;
    self.containerScrollView.showsVerticalScrollIndicator = NO;
    self.containerScrollView.backgroundColor = [UIColor colorFromHexString:@"#EBEDED"];
    self.containerScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    self.containerScrollView.delegate = self;
    [self.view addSubview:self.containerScrollView];
}

- (void)setupCategoryScrollView{
    self.categoryScrollView = [[CategoryScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    //设置分类点击回调block
    [self.categoryScrollView didCategoryBtnClick:^(LPCategory *from, LPCategory *to) {
        LPTabBarButton *button = self.customTabBar.tabBarButtons[1];
        self.customTabBar.selectedButton = button;
        //点击的不是同一个category 就执行该动画
        if (from != to) {
            [UIView transitionWithView:button duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                [button setTitle:to.title forState:UIControlStateNormal];
            } completion:^(BOOL finished) {
                
            }];
            
        }
        [button setTitle:to.title forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.containerScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
        }];
        if (from != to) {
            [self setupDataWithCategory:to completion:nil];
        }
        
    }];
    [self.containerScrollView addSubview:self.categoryScrollView];
}

- (void)setupHomeTableView{
    self.homeTableView  = [[UITableView alloc] init];
    self.homeTableView.x = ScreenWidth;
    self.homeTableView.y = 0;
    self.homeTableView.width = ScreenWidth;
    self.homeTableView.height = ScreenHeight;
    self.homeTableView.contentInset = UIEdgeInsetsMake(TabBarHeight, 0, 0, 0);
    self.homeTableView.backgroundColor = [UIColor colorFromHexString:@"#EBEDED"];
    self.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.homeTableView.delegate = self;
    self.homeTableView.dataSource = self;
    [self.containerScrollView addSubview:self.homeTableView];
}

- (void)setupTabBar
{
    self.customTabBar = [[LPTabBar alloc] init];
    self.customTabBar.frame = CGRectMake(0, 0, ScreenWidth, TabBarHeight);
    self.customTabBar.backgroundColor = [UIColor colorFromHexString:TabBarColor alpha:1.0];
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
            weakSelf.containerScrollView.contentOffset = offSetPoint;
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
    
    CGFloat loginBtnWidth = 32;
    CGFloat loginBtnHeight = 32;
    if (iPhone6) {
        loginBtnWidth -= 2;
        loginBtnHeight -= 2;
    } else if (iPhone6Plus){
        loginBtnWidth += 2;
        loginBtnHeight += 2;
    }
    self.loginBtn.frame = CGRectMake(ScreenWidth-20-32, ScreenHeight-20-32, loginBtnWidth, loginBtnHeight);
    self.loginBtn.layer.cornerRadius = self.loginBtn.frame.size.height / 2;
    self.loginBtn.layer.borderWidth = 1.5;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [self.loginBtn addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.loginBtn];
}
#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [noteCenter addObserver:self selector:@selector(receiveJPushNotification:) name:LPPushNotificationFromLaunching object:nil];
    [noteCenter addObserver:self selector:@selector(receiveJPushNotification:) name:LPPushNotificationFromBack object:nil];
    [noteCenter addObserver:self selector:@selector(accountLogin:) name:AccountLoginNotification  object:nil];
    [noteCenter addObserver:self selector:@selector(commentSuccess) name:LPCommentDidComposeSuccessNotification object:nil];

    [self setupContainerScrollerView];
    [self setupCategoryScrollView];
    [self setupHomeTableView];
    [self setupTabBar];
    [self setupLoginButton];
    [self setupDataWithCategory:[LPCategory categoryWithURL:HomeUrl] completion:nil];
    
}
#pragma mark - 设置tabbar索引
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    
    self.customTabBar.sliderView.x = (selectedIndex == 0) ? 0 : TabBarButtonWidth;
    self.customTabBar.selectedButton = [self.customTabBar.tabBarButtons objectAtIndex:selectedIndex];
    _selectedIndex = selectedIndex;
}
#pragma mark - 用户登录相关

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
            [weakSelf.loginBtn setBackgroundImage:imageView.image forState:UIControlStateNormal];
        }
        
    }];
}
/**
 *  用户登录点击事件
 *
 *  @param loginBtn 响应点击事件的button
 */
- (void)userLogin:(UIButton *)loginBtn{
    if ([AccountTool account] != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"退出登录后无法进行评论哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }else{
        [AccountTool accountLoginWithViewController:self success:^{
            NSLog(@"---授权成功");
            [self displayLoginBtnIconWithAccount:[AccountTool account]];
        } failure:^{
            NSLog(@"---授权失败");
        } cancel:^{
            NSLog(@"---授权取消");
        }];
    }
}

- (void)accountLogin:(NSNotification *)notification{
        [self displayLoginBtnIconWithAccount:[AccountTool account]];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //1.删除用户信息
        [AccountTool deleteAccount];
        //2.修改主界面icon
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"登录icon"] forState:UIControlStateNormal];
    }
}
#pragma mark - 网络获取数据
- (void)setupDataWithCategory:(LPCategory *)category completion:(completionBlock)block
{
    self.loaddingView = [CustomLoaddingView showMessage:@"正在加载..." toView:self.view];
    self.homeTableView.hidden = YES;
    // 清空数据
    [self.pressFrames removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [LPPressTool homePressesWithCategory:category success:^(id json) {
        [self.loaddingView dismissMessage];
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
        [weakSelf.homeTableView reloadData];
        if (block) {
            block();
        } else {
            [weakSelf.homeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.timeRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            weakSelf.isScrolled = NO;
            [weakSelf performSelector:@selector(homeDisplay) withObject:weakSelf afterDelay:0.3];
        }
    } failure:^(NSError *error) {
        [self.loaddingView dismissMessage];
        
        [MBProgressHUD showError:@"网络不给力 :(" toView:self.view];
    }];
    
}
- (void)homeDisplay
{
    self.homeTableView.hidden = NO;
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
    
    if ([scrollView class] == [self.containerScrollView class]) {
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
    //    if ([scrollView class] == [self.containerScrollView class]) {
    if (scrollView == self.containerScrollView) {
        
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
                [weakSelf.homeTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                [weakSelf tableView:weakSelf.homeTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                break;
            }
        }
        weakSelf.homeTableView.hidden = NO;
    }];
}

- (void)dealloc
{
    [noteCenter removeObserver:self];
}

// 评论成功后，若原来没有评论图标，就显示
- (void)commentSuccess
{
    LPPressFrame *pressFrame = self.pressFrames[self.selectedRow];
    LPPress *press = pressFrame.press;
    if (press.isCommentsFlag.intValue == 0) {
        press.isCommentsFlag = @"1";
        self.isScrolled = NO;
        [self.homeTableView reloadData];
    }
}
@end