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
#import "LPNewsLonginViewFromSettingViewController.h"
#import "MainNavigationController.h"
#import "LPNewsPrivacyItemsController.h"
#import "LPNewsAboutViewController.h"
#import "AppDelegate.h"
#import "LPNewsMineViewController.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const kCellIdentify = @"JoySettingCell";

@interface LPNewsSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UIImageView *clearCacheView;
}
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong, nullable) NSArray *dataSource;
@property (nonatomic, strong)UIWindow * statusWindow;
@end

@implementation LPNewsSettingViewController

#pragma mark- Initialize

- (instancetype)initWithCustom{
    self = [super initWithCustom];
    if (self) {
                
    }
    return self;
}

- (void)dealloc{
  
}


#pragma mark-  ViewLife Cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setNavTitleView:@"设置"];
    [self backImageItem];
    
    CGRect lineLayerRect = CGRectMake(0.f, (self.navigationController.navigationBar.size.height-1.f), kApplecationScreenWidth, 1.f);
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = lineLayerRect;
    lineLayer.backgroundColor = [[UIColor colorWithDesignIndex:5] CGColor];
    [self.navigationController.navigationBar.layer addSublayer:lineLayer];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithDesignIndex:9];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.view addSubview:self.tableView];
    __weak typeof(self)weakSelf = self;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.top.equalTo(strongSelf.view);
        make.left.equalTo(strongSelf.view);
        make.size.mas_equalTo(CGSizeMake(strongSelf.view.frame.size.width, strongSelf.view.frame.size.height-kCustomNavigationBarHeight));
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationItem.hidesBackButton = YES;
 
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    if ([self.view window] == nil && [self isViewLoaded]) {
    }
}


#pragma mark- UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return self.dataSource.count;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSource.count > section) {
        NSArray *array = self.dataSource[section];
        return array.count;
    }
    return 0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    LPNewsSettingCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentify forIndexPath:indexPath];
    if(!cell){
        cell = [[LPNewsSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentify];
    }
    if (indexPath.section < self.dataSource.count) {
        NSArray *array = self.dataSource[indexPath.section];
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
    }else if (indexPath.section ==3){
        
        if ([AccountTool account]!= nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"退出登录后无法进行评论哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
        } else {
            
            LPNewsLonginViewFromSettingViewController *loginView = [[LPNewsLonginViewFromSettingViewController alloc] init];
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
            [AccountTool deleteAccount];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        
    }
}


#pragma mark- Event reponse

#pragma mark- Public methods

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


#pragma mark- Getters and Setters

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        _tableView = tableView;
        _tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.rowHeight = 51.f;
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor colorWithDesignIndex:9];
        _tableView.backgroundView = backgroundView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[LPNewsSettingCell class] forCellReuseIdentifier:kCellIdentify];
    }

    return _tableView;
}

- (NSArray *__nullable)dataSource{
    if (!_dataSource) {
        NSArray *array = @[@[@{@"FontSize":@"字体大小"},@{@"InfoPushSetting":@"推送设置"}],@[@{@"ClearCache":@"清理缓存"}],@[@{@"About":@"关于"},@{@"Privacy":@"隐私政策"},@{@"AppStoreComment":@"去App Store评分"}],@[@{@"SignOut":@"退出登录"}]];
        _dataSource = array;
    }
    return _dataSource;
}



@end

NS_ASSUME_NONNULL_END



