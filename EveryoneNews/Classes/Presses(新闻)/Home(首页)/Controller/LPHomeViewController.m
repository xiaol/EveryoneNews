//
//  LPHomeViewController.m
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//
#import "LPNavigationController.h"
#import "LPHomeViewController.h"
#import "LPTabBarController.h"
#import "LPPressFrame.h"
#import "LPPress.h"
#import "MJExtension.h"
#import "LPPressCell.h"
#import "LPPointview.h"
#import "LPDetailViewController.h"
#import "LPDetailViewController.h"
#import "LPCategory.h"
#import "LPPressTool.h"
#import "MobClick.h"
#import "AccountTool.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"

typedef void (^completionBlock)();

@interface LPHomeViewController () <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *pressFrames;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger timeRow;
@property (nonatomic, assign) NSUInteger anyDisplayingCellRow;
@property (nonatomic, assign) BOOL isScrolled;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, assign) NSUInteger selectedRow;
@end

@implementation LPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupDataWithCategory:[LPCategory categoryWithURL:HomeUrl] completion:nil];
    [noteCenter addObserver:self selector:@selector(receivePushNotification:) name:LPPushNotificationFromLaunching object:nil];
    [noteCenter addObserver:self selector:@selector(receivePushNotification:) name:LPPushNotificationFromBack object:nil];
    [noteCenter addObserver:self selector:@selector(changeCategory:) name:LPCategoryDidChangeNotification object:nil];
    [noteCenter addObserver:self selector:@selector(accountLogin:) name:AccountLoginNotification  object:nil];
    [noteCenter addObserver:self selector:@selector(commentSuccess) name:LPCommentDidComposeSuccessNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"HomePage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"HomePage"];
}


- (void)setupSubviews
{
    self.view.backgroundColor = [UIColor colorFromHexString:@"#EBEDED"];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    tableView.contentInset = UIEdgeInsetsMake(TabBarHeight, 0, 0, 0);
    tableView.backgroundColor = [UIColor colorFromHexString:@"#EBEDED"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    sharedIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    sharedIndicator.center = self.view.center;
    sharedIndicator.bounds = CGRectMake(0, 0, ScreenWidth / 4, ScreenWidth / 4);
    [self.view addSubview:sharedIndicator];
    
    //添加右下角的登录按钮
    self.loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //如果用户已经登录则在右下角显示用户图像
    Account *account=[AccountTool account];
    if (account == nil) {
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"登录icon"] forState:UIControlStateNormal];
    } else {
        [self displayLoginBtnIconWithAccount:account];
    }
    #warning 增加屏幕适配
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
//在右下角显示用户图像

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
        __weak typeof(self) weakSelf = self;
        [AccountTool accountLoginWithViewController:self success:^{
            NSLog(@"homeVc --- %@", [NSThread currentThread]);
            [MBProgressHUD showSuccess:@"登录成功"];
            [weakSelf displayLoginBtnIconWithAccount:[AccountTool account]];
        } failure:^{
            [MBProgressHUD showError:@"登录失败"];
        } cancel:^{
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

- (NSMutableArray *)pressFrames
{
    if (_pressFrames == nil) {
        _pressFrames = [NSMutableArray array];
    }
    return _pressFrames;
}

- (void)setupDataWithCategory:(LPCategory *)category completion:(completionBlock)block
{
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
            [weakSelf performSelector:@selector(homeDisplay) withObject:weakSelf afterDelay:0.3];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", [NSThread currentThread]);
        [MBProgressHUD showError:@"网络不给力:("];
        NSLog(@"Failure: %@", error);
    }];
        
}

- (void)homeDisplay
{
    self.tableView.hidden = NO;
}

# pragma mark - notification selector

- (void)changeCategory:(NSNotification *)note
{
    NSDictionary *info = note.userInfo;
    LPCategory *from = info[LPCategoryFrom];
    LPCategory *to = info[LPCategoryTo];
    if (from.ID != to.ID) {
        [self setupDataWithCategory:to completion:nil];
    }
}

- (void)receivePushNotification:(NSNotification *)note
{
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

- (void)dealloc
{
    [noteCenter removeObserver:self];
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
}


@end
