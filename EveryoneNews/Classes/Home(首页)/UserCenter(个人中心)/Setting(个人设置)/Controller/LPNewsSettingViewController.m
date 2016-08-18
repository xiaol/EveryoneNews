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
#import "LPLoginFromSettingViewController.h"
#import "MainNavigationController.h"
#import "LPNewsPrivacyItemsController.h"
#import "LPNewsAboutViewController.h"
#import "AppDelegate.h"
#import "LPNewsMineViewController.h"
#import "CoreDataHelper.h"
#import "LPChannelItemTool.h"


NS_ASSUME_NONNULL_BEGIN

static NSString * const kCellIdentify = @"JoySettingCell";

@interface LPNewsSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UIImageView *clearCacheView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *settingArray;

//@property (nonatomic, strong, nullable) NSArray *dataSource;
@property (nonatomic, strong)UIWindow * statusWindow;

@end

@implementation LPNewsSettingViewController

#pragma mark - 懒加载
- (NSArray *)settingArray {
    if (_settingArray == nil) {
        _settingArray = [[NSArray alloc] init];
    }
    return _settingArray;
}



#pragma mark - ViewDidLoad
- (void)viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithDesignIndex:9];
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
    [backButton setBackgroundImage:[UIImage imageNamed:@"消息中心返回"] forState:UIControlStateNormal];
    backButton.enlargedEdge = 15;
    [backButton addTarget:self action:@selector(topViewBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text = @"设置";
    titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
    titleLabel.font = [UIFont  boldSystemFontOfSize:LPFont8];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerX = topView.centerX;
    titleLabel.centerY = backButton.centerY;
    [topView addSubview:titleLabel];
    
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenWidth , 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor10];
    [self.view addSubview:seperatorView];
    
    CGFloat tableViewY = CGRectGetMaxY(topView.frame) + 7;
    CGFloat tableViewH = ScreenHeight - tableViewY;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, ScreenWidth, tableViewH)];
    tableView.backgroundColor = [UIColor colorWithDesignIndex:9];
    [tableView registerClass:[LPNewsSettingCell class] forCellReuseIdentifier:kCellIdentify];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    NSArray *array = @[@[@{@"FontSize":@"字体大小"},@{@"InfoPushSetting":@"推送设置"}],@[@{@"ClearCache":@"清理缓存"}],@[@{@"About":@"关于"},@{@"Privacy":@"隐私政策"},@{@"AppStoreComment":@"去App Store评分"}],@[@{@"SignOut":@"退出登录"}]];
    self.settingArray = array;
    
}

- (void)topViewBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView {
    return self.settingArray.count;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.settingArray.count > section) {
        NSArray *array = self.settingArray[section];
        return array.count;
    }
    return 0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    LPNewsSettingCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentify forIndexPath:indexPath];
    if(!cell){
        cell = [[LPNewsSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentify];
    }
    if (indexPath.section < self.settingArray.count) {
        NSArray *array = self.settingArray[indexPath.section];
        if (indexPath.row < array.count) {
            NSDictionary *dict = [array objectAtIndex:indexPath.row];
            [cell setModel:dict IndexPath:indexPath];
            
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat kSetingCellHeight = 44.0f;
    
    if (iPhone6) {
        kSetingCellHeight = 51.0f;
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
       
        return kSetingCellHeight+22.f;
    }else{
        
        return kSetingCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 18.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *view = [[UIImageView alloc] init];
    view.frame = CGRectMake(0, 0, kApplecationScreenWidth, 18.f);
    view.backgroundColor = [UIColor colorWithDesignIndex:9];
    
    UIImageView *separatorLineDown = [[UIImageView alloc] init];
    separatorLineDown.backgroundColor = [UIColor colorWithDesignIndex:5];
    [view addSubview:separatorLineDown];
    [separatorLineDown mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom).offset(0.8f);
        make.width.mas_equalTo(kApplecationScreenWidth);
        make.height.mas_equalTo(0.8f);
    }];
    
    return view;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section == 1) {

        [self clearSuccStatusBarNoticeAction];
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            
            LPNewsAboutViewController *aboutView = [[LPNewsAboutViewController alloc] init];
            [self.navigationController pushViewController:aboutView animated:YES];
            
        }else if (indexPath.row ==1){
            
            LPNewsPrivacyItemsController *priView = [[LPNewsPrivacyItemsController alloc] init];
            [self.navigationController pushViewController:priView animated:YES];
            
        }else{

            NSString *str = @"itms-apps://itunes.apple.com/cn/app/qi-dian-zi-xun/id987333155?l=en&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
        }
    }else if (indexPath.section == 3){
        
        if ([AccountTool account]!= nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"退出登录后无法进行评论哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
        } else {
            
            LPLoginFromSettingViewController *loginView = [[LPLoginFromSettingViewController alloc] init];
            [self.navigationController pushViewController:loginView animated:YES];
        }
    }
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


#pragma mark- private methods

- (void)clearSuccStatusBarNoticeAction{
    
    self.statusWindow = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    [self.statusWindow setWindowLevel:UIWindowLevelAlert + 1];
    [self.statusWindow setBackgroundColor:[UIColor clearColor]];
    
    clearCacheView = [[UIImageView alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    clearCacheView.backgroundColor = [UIColor blackColor];
    
    UIImageView *clearSucc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ClearSucc"]];
    [clearSucc setFrame:CGRectMake(12, 3, clearSucc.image.size.width, clearSucc.image.size.height)];
    [clearCacheView addSubview:clearSucc];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12+10+clearSucc.image.size.width, 0, 200, 20)];
    label.text = @"清理缓存成功";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:28.f/fontSizePxToSystemMultiple];
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
        CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        [cdh deleteCoreData];
        // 清除缓存后重新加载页面
        [noteCenter postNotificationName:LPDeleteCoreDataNotification object:self];
        
        NSLog(@"清理完毕");
        
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

@end

NS_ASSUME_NONNULL_END



