//
//  LPNewsSettingViewController.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsSettingViewController.h"
#import "LPNewsSettingCell.h"
#import "Account.h"
#import "AccountTool.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "MainNavigationController.h"
#import "LPNewsPrivacyItemsController.h"
#import "LPNewsAboutViewController.h"
#import "LPNewsMineViewController.h"
#import "CoreDataHelper.h"
#import "LPChannelItemTool.h"
#import "LPPersonalSettingFrame.h"
#import "LPPersonalSetting.h"


static NSString *cellIdentifier = @"cellIdentifier";

@interface LPNewsSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *clearCacheView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIWindow *statusWindow;

@property (nonatomic, strong) NSMutableArray *firstSectionFrames;
@property (nonatomic, strong) NSMutableArray *secondSectionFrames;
@property (nonatomic, strong) NSMutableArray *thirdSectionFrames;
@property (nonatomic, strong) NSMutableArray *fourthSectionFrames;

@end

@implementation LPNewsSettingViewController

#pragma mark - 懒加载
- (NSMutableArray *)firstSectionFrames {
    if (_firstSectionFrames == nil) {
        _firstSectionFrames = [NSMutableArray array];
    }
    return _firstSectionFrames;
}

- (NSMutableArray *)secondSectionFrames {
    if (_secondSectionFrames == nil) {
        _secondSectionFrames = [NSMutableArray array];
    }
    return _secondSectionFrames;
}

- (NSMutableArray *)thirdSectionFrames {
    if (_thirdSectionFrames == nil) {
        _thirdSectionFrames = [NSMutableArray array];
    }
    return _thirdSectionFrames;
}

- (NSMutableArray *)fourthSectionFrames {
    if (_fourthSectionFrames == nil) {
        _fourthSectionFrames = [NSMutableArray array];
    }
    return _fourthSectionFrames;
}



#pragma mark - ViewDidLoad
- (void)viewDidLoad{
    [super viewDidLoad];

    [self setupData];
    [self setupSubViews];
}

#pragma mark - setupData
- (void)setupData {
    
    // Section 1
    LPPersonalSetting *fontSetting = [[LPPersonalSetting alloc] initWithIdentifier:@"fontSize" title:@"字体大小" imageName:@"个人中心字体大小"];
    LPPersonalSetting *pushSetting = [[LPPersonalSetting alloc] initWithIdentifier:@"pushSetting" title:@"推送设置" imageName:@"个人中心推送设置"];
    
    LPPersonalSettingFrame *fontSettingFrame = [[LPPersonalSettingFrame alloc] init];
    fontSettingFrame.personalSetting = fontSetting;
    
    LPPersonalSettingFrame *pushSettingFrame = [[LPPersonalSettingFrame alloc] init];
    pushSettingFrame.personalSetting = pushSetting;
    
    [self.firstSectionFrames addObject:fontSettingFrame];
    [self.firstSectionFrames addObject:pushSettingFrame];
    
    // Section 2
    LPPersonalSetting *clearCacheSetting = [[LPPersonalSetting alloc] initWithIdentifier:@"clearCache" title:@"清理缓存" imageName:@"个人中心清理缓存"];
    LPPersonalSettingFrame *clearCacheSettingFrame = [[LPPersonalSettingFrame alloc] init];
    clearCacheSettingFrame.personalSetting = clearCacheSetting;
    [self.secondSectionFrames addObject:clearCacheSettingFrame];
    
    // Section 3
    LPPersonalSetting *aboutSetting = [[LPPersonalSetting alloc] initWithIdentifier:@"about" title:@"关于" imageName:@"个人中心关于"];
    LPPersonalSetting *privacySetting = [[LPPersonalSetting alloc] initWithIdentifier:@"privacy" title:@"隐私政策" imageName:@"个人中心隐私政策"];
    LPPersonalSetting *appStoreSetting = [[LPPersonalSetting alloc] initWithIdentifier:@"appStore" title:@"去App Store评分" imageName:@"个人中心AppStore评分"];
    
    LPPersonalSettingFrame *aboutSettingFrame = [[LPPersonalSettingFrame alloc] init];
    aboutSettingFrame.personalSetting = aboutSetting;
    
    LPPersonalSettingFrame *privacySettingFrame = [[LPPersonalSettingFrame alloc] init];
    privacySettingFrame.personalSetting = privacySetting;
    
    LPPersonalSettingFrame *appStoreSettingFrame = [[LPPersonalSettingFrame alloc] init];
    appStoreSettingFrame.personalSetting = appStoreSetting;
    
    [self.thirdSectionFrames addObject:aboutSettingFrame];
    [self.thirdSectionFrames addObject:privacySettingFrame];
    [self.thirdSectionFrames addObject:appStoreSettingFrame];
    
    // Section 4
    LPPersonalSetting *signOutSetting = [[LPPersonalSetting alloc] initWithIdentifier:@"signOut" title:@"signOut" imageName:@"个人中心隐私政策"];
    LPPersonalSettingFrame *signOutSettingFrame = [[LPPersonalSettingFrame alloc] init];
    signOutSettingFrame.personalSetting = signOutSetting;
    [self.fourthSectionFrames addObject:signOutSettingFrame];
    
}

#pragma mark - setup SubViews
- (void)setupSubViews {
    self.view.backgroundColor = [UIColor colorFromHexString:LPColor9];
    // 导航栏
    double topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
    double padding = 15;
    
    double returnButtonWidth = 13;
    double returnButtonHeight = 22;
    
    if (iPhone6Plus) {
        returnButtonWidth = 12;
        returnButtonHeight = 21;
    }
    if (iPhone6) {
        topViewHeight = 72;
    }
    double returnButtonPaddingTop = (topViewHeight - returnButtonHeight + StatusBarHeight) / 2;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topViewHeight)];
    topView.backgroundColor = [UIColor colorFromHexString:@"#ffffff" alpha:0.0f];
    [self.view addSubview:topView];
    
    // 返回button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, returnButtonPaddingTop, returnButtonWidth, returnButtonHeight)];
    [backButton setBackgroundImage:[UIImage oddityImage:@"消息中心返回"] forState:UIControlStateNormal];
    backButton.enlargedEdge = 15;
    [backButton addTarget:self action:@selector(backButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text = @"设置";
    titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
    titleLabel.font = [UIFont  boldSystemFontOfSize:LPFont8];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerX = topView.centerX;
    titleLabel.centerY = backButton.centerY;
    [topView addSubview:titleLabel];
    
    CGFloat tableViewY = CGRectGetMaxY(topView.frame);
    CGFloat tableViewH = ScreenHeight - tableViewY;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, ScreenWidth, tableViewH)];
    tableView.backgroundColor = [UIColor colorFromHexString:LPColor9];
    [tableView registerClass:[LPNewsSettingCell class] forCellReuseIdentifier:cellIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - backButtonDidClick
- (void)backButtonDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.firstSectionFrames.count;
    } else if (section == 1) {
        return self.secondSectionFrames.count;
    } else if (section == 2) {
        return self.thirdSectionFrames.count;
    } else {
        return self.fourthSectionFrames.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPNewsSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil) {
        cell = [[LPNewsSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 0) {
        [cell setSettingFrame:self.firstSectionFrames[indexPath.row] indexPath:indexPath];
    } else if (indexPath.section == 1) {
        [cell setSettingFrame:self.secondSectionFrames[indexPath.row] indexPath:indexPath];
    } else if (indexPath.section == 2) {
        [cell setSettingFrame:self.thirdSectionFrames[indexPath.row] indexPath:indexPath];
    } else {
        [cell setSettingFrame:self.fourthSectionFrames[indexPath.row] indexPath:indexPath];
    }
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 44.0f;
    if (iPhone6) {
        cellHeight = 51.0f;
    }
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 18.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 18.0)];
    headerView.backgroundColor = [UIColor colorFromHexString:LPColor9];
    headerView.layer.borderWidth = 0.5f;
    headerView.layer.borderColor = [UIColor colorFromHexString:LPColor10].CGColor;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self clearCache];

    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            LPNewsAboutViewController *aboutView = [[LPNewsAboutViewController alloc] init];
            [self.navigationController pushViewController:aboutView animated:YES];
        } else if (indexPath.row ==1) {
            LPNewsPrivacyItemsController *priView = [[LPNewsPrivacyItemsController alloc] init];
            [self.navigationController pushViewController:priView animated:YES];
        } else {
            NSString *str = @"itms-apps://itunes.apple.com/cn/app/qi-dian-zi-xun/id987333155?l=en&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

        }
    } else if (indexPath.section == 3) {
        if ([AccountTool account] !=  nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"退出登录后无法进行评论哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
        }
    }
}

#pragma mark - clearCache
- (void)clearCache {
        self.statusWindow = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
        [self.statusWindow setWindowLevel:UIWindowLevelAlert + 1];
        [self.statusWindow setBackgroundColor:[UIColor clearColor]];
    
        UIImageView *clearCacheView = [[UIImageView alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
        clearCacheView.backgroundColor = [UIColor blackColor];
    
        UIImageView *clearSucc = [[UIImageView alloc] initWithImage:[UIImage oddityImage:@"个人中心清理成功"]];
        [clearSucc setFrame:CGRectMake(12, 3, clearSucc.image.size.width, clearSucc.image.size.height)];
        [clearCacheView addSubview:clearSucc];
    
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12+10+clearSucc.image.size.width, 0, 200, 20)];
        label.text = @"清理缓存成功";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:28.f/2.0f];
        label.textColor = [UIColor whiteColor];
        [clearCacheView addSubview:label];
        //动画
        CGRect startFrame = clearCacheView.frame;
        CGRect endFrame = startFrame;
        startFrame.origin.y = -startFrame.size.height;
        clearCacheView.frame = startFrame;
        [UIView animateWithDuration:0.6 delay:0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
            clearCacheView.frame = endFrame;
            // 清理缓存
            CoreDataHelper *cdh = [CoreDataHelper shareCoreDataHelper];
            [cdh deleteCoreData];
            // 清除缓存后重新加载页面
            [noteCenter postNotificationName:LPDeleteCoreDataNotification object:self];    
        } completion:^(BOOL finished) {
    
            dispatch_async(dispatch_get_global_queue
                           (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
                               [NSThread sleepForTimeInterval:2];
    
                               dispatch_async(dispatch_get_main_queue(), ^{
    
                                   [clearCacheView removeFromSuperview];
    
                               });
                           });
        }];
    
        [self.statusWindow setHidden:NO];
        [self.statusWindow setAlpha:1.0f];
        [self.statusWindow addSubview:clearCacheView];
        [self.statusWindow makeKeyAndVisible];
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [noteCenter postNotificationName:LPLoginOutNotification object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
    }
}


@end





