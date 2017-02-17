//
//  LPHomeViewController.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewController.h"
#import "LPHomeViewController+SubviewsManager.h"
#import "LPHomeViewController+ChannelItemName.h"
#import "LPHomeViewController+ContentView.h"
#import "LPHomeViewController+ChannelItemMenu.h"
#import "AccountTool.h"
#import "LPHomeRowManager.h"
#import "CardParam.h"
#import "LPChannelItemTool.h"
#import "Card+Fetch.h"
#import "CardFrame.h"
#import "LPCardConcernFrame.h"
#import "CardTool.h"
#import "Card+Create.h"
#import "UIButton+WebCache.h"
#import "LPPagingViewConcernPage.h"
#import "LPPagingViewVideoPage.h"
#import <CoreLocation/CoreLocation.h>
 

@interface LPHomeViewController ()



@end

@implementation LPHomeViewController

-(UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleDefault;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInitialData];
    
    [self setupSubViews];

    [noteCenter addObserver:self selector:@selector(reloadCurrentPageIndexData) name:LPDeleteCoreDataNotification object:nil];
    // 取消关注重新请求本地数据
    [noteCenter addObserver:self selector:@selector(cancelConcernAndReloadPage:) name:LPReloadCancelConcernPageNotification object:nil];
    // 添加关注重新请求接口
    [noteCenter addObserver:self selector:@selector(addConcernAndReloadPage) name:LPReloadAddConcernPageNotification object:nil];
    // 登录
    [noteCenter addObserver:self selector:@selector(login) name:LPLoginNotification object:nil];
    // 退出登录
    [noteCenter addObserver:self selector:@selector(loginout) name:LPLoginOutNotification object:nil];
    // 进入后台
    [noteCenter addObserver:self selector:@selector(resignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    // 从后台激活
    [noteCenter addObserver:self selector:@selector(becomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self getLocation];
}

- (void)getLocation {
    //检测定位功能是否开启
    if([CLLocationManager locationServicesEnabled]){
        
        if(!_locationManager){
            
            self.locationManager = [[CLLocationManager alloc] init];
            
            if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager requestAlwaysAuthorization];
                
            }
            
            //设置代理
            [self.locationManager setDelegate:self];
            //设置定位精度
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //设置距离筛选
            [self.locationManager setDistanceFilter:100];
            //开始定位
            [self.locationManager startUpdatingLocation];
        }
        
    }
}

#pragma mark - CLLocationManangerDelegate
//定位成功以后调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    CLLocation* location = locations.lastObject;
    [self reverseGeocoder:location];
}

#pragma mark Geocoder
//反地理编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error || placemarks.count == 0){
            // NSLog(@"error = %@",error);
        } else {
            
            CLPlacemark *placemark = placemarks.firstObject;
            if (currentLocation.coordinate.latitude) {
                
                NSString *province = [[placemark addressDictionary] objectForKey:@"State"];
                NSString *city = [[placemark addressDictionary] objectForKey:@"City"];
                [userDefaults setObject:@(currentLocation.coordinate.latitude) forKey:currentLatitude];
                [userDefaults setObject:@(currentLocation.coordinate.longitude) forKey:currentLongitude];
                [userDefaults setObject:province forKey:currentProvince];
                [userDefaults setObject:city forKey:currentCity];
            }
        }  
        
    }];  
}

#pragma mark - 进入后台
- (void)resignActiveNotification {
    [self.channelItemsArray removeAllObjects];
    for (LPChannelItem *channelItem in self.selectedArray) {
        channelItem.channelIsSelected = @"1";
        [self.channelItemsArray addObject:channelItem];
    }
    for (LPChannelItem *channelItem in self.optionalArray) {
        channelItem.channelIsSelected = @"0";
        [self.channelItemsArray addObject:channelItem];
    }
    [LPChannelItemTool saveChannelItems:self.channelItemsArray];
}

#pragma mark - 重新打开应用
- (void)becomeActiveNotification {
    for (LPChannelItem *channelItem in self.selectedArray) {
        if ([channelItem.channelName isEqualToString:self.selectedChannelTitle]) {
            // 设置本次访问时间
            NSDate *currentDate = [NSDate date];
            NSDate *lastAccessDate = channelItem.lastAccessDate;
            // 每隔5分钟执行自动刷新
            if (lastAccessDate != nil) {
                int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate] / 60;
                if (interval > 20) {
                    if ([channelItem.channelID isEqualToString:focusChannelID]) {
                        LPPagingViewConcernPage *page = (LPPagingViewConcernPage *)[self.pagingView visiblePageAtIndex:self.pagingView.currentPageIndex];
                        [page autotomaticLoadNewData];
                        channelItem.lastAccessDate = currentDate;
                    } else if([channelItem.channelID isEqualToString:videoChannelID]) {
                        LPPagingViewVideoPage *page = (LPPagingViewVideoPage *)[self.pagingView visiblePageAtIndex:self.pagingView.currentPageIndex];
                        [page autotomaticLoadNewData];
                        channelItem.lastAccessDate = currentDate;
                    }
                    else {
                        LPPagingViewPage *page = (LPPagingViewPage *)[self.pagingView visiblePageAtIndex:self.pagingView.currentPageIndex];
                        [page autotomaticLoadNewData];
                        channelItem.lastAccessDate = currentDate;
                    }
                }
            }
            break;
        }
    }
}

#pragma mark - 登录
- (void)login {
    Account *account = [AccountTool account];
    [self displayLoginBtnIconWithAccount:account];
    // 如果频道栏关注频道存在则加载数据
    if ([userDefaults objectForKey:LPConcernChannelItemShowOrHide]) {
        BOOL concernFlag = false;
        NSInteger pageIndex = 0;
        for (int i = 0; i < self.selectedArray.count; i++) {
            LPChannelItem *channelItem = (LPChannelItem *)self.selectedArray[i];
            if ([channelItem.channelID isEqualToString:focusChannelID]) {
                concernFlag = true;
                pageIndex = i;
                break;
            }
        }
        if (concernFlag) {
            [self loadMoreDataInPageAtPageIndex:pageIndex];
        }
    }
}

#pragma mark - 退出登录
- (void)loginout {
    [AccountTool deleteAccount];
    Account *account = [AccountTool account];
    [self displayLoginBtnIconWithAccount:account];
 
    // 如果频道栏关注频道存在则加载数据
    if ([userDefaults objectForKey:LPConcernChannelItemShowOrHide]) {
        BOOL concernFlag = false;
        NSInteger pageIndex = 0;
        for (int i = 0; i < self.selectedArray.count; i++) {
            LPChannelItem *channelItem = (LPChannelItem *)self.selectedArray[i];
            if ([channelItem.channelID isEqualToString:focusChannelID]) {
                concernFlag = true;
                pageIndex = i;
                break;
            }
        }
        if (concernFlag) {
            self.channelItemDictionary[LPConcernChannelItemName]  =  [NSMutableArray array];
            [self.pagingView reloadPageAtPageIndex:pageIndex];
        }
    }
}

#pragma mark - 设置用户头像
- (void)displayLoginBtnIconWithAccount:(Account *)account
{
    CGFloat statusBarHeight = 20.0f;
    CGFloat menuViewHeight = 44.0;
    
    CGFloat unloginBtnX = 12.0;
    CGFloat unloginBtnW = 28.0;
    CGFloat unloginBtnH = 28.0;
    if (iPhone6) {
         menuViewHeight = 52;
    }
    
    CGFloat unloginBtnY = (menuViewHeight - unloginBtnH) / 2 + statusBarHeight;
    
    if (iPhone6) {
        unloginBtnY = unloginBtnY - 0.5;
    }
    // 用户未登录直接显示未登录图标
    if (account == nil) {
        self.loginBtn.layer.cornerRadius = 0;
        self.loginBtn.layer.borderWidth = 0;
        self.loginBtn.layer.masksToBounds = NO;
        [self.loginBtn setBackgroundImage:[UIImage oddityImage:@"home_user"] forState:UIControlStateNormal];
        self.loginBtn.frame = CGRectMake(unloginBtnX , unloginBtnY , unloginBtnW, unloginBtnH);
    } else {
        CGFloat statusBarHeight = 20.0f;
        CGFloat menuViewHeight = 44.0;
        CGFloat loginBtnX = 10;
        CGFloat loginBtnW = 28;
        CGFloat loginBtnH = 28;
        if (iPhone6Plus) {
            loginBtnX = 10.0f;
        } else if (iPhone5) {
            loginBtnX = 10.0f;
        } else if (iPhone6) {
            loginBtnX = 12.0f;
            menuViewHeight = 52;
        }
        CGFloat loginBtnY = (menuViewHeight - loginBtnH) / 2 + statusBarHeight;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loginBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:account.userIcon] forState:UIControlStateNormal placeholderImage:[UIImage oddityImage:@"home_user"]];
            self.loginBtn.frame = CGRectMake(loginBtnX , loginBtnY , loginBtnW, loginBtnH);
            self.loginBtn.layer.cornerRadius = loginBtnH / 2;
            self.loginBtn.layer.borderWidth = 1;
            self.loginBtn.layer.masksToBounds = YES;
            self.loginBtn.layer.borderColor = [UIColor colorFromHexString:@"#e4e4e4"].CGColor;
        });
    }
}
#pragma mark - 重新加载关注页面
- (void)cancelConcernAndReloadPage:(NSNotification *)notification {
    for (int i = 0; i < self.selectedArray.count; i++) {
        LPChannelItem *channelItem = self.selectedArray[i];
        if ([channelItem.channelID isEqualToString:focusChannelID]) {
            // 加载当前频道数据
            CardParam *param = [[CardParam alloc] init];
            param.type = HomeCardsFetchTypeMore;
            param.count = @(20);
            param.startTime = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
            param.channelID = focusChannelID;
            NSMutableArray *cfs = [NSMutableArray array];
            NSString *sourceName = [notification.userInfo objectForKey:@"sourceName"];
            [CardTool cancelCardsConcernWithParam:param channelID:channelItem.channelID sourceName:sourceName success:^(NSArray *cards) {
                for (Card *card in cards) {
                    LPCardConcernFrame *cf = [[LPCardConcernFrame alloc] init];
                    cf.card = card;
                    [cfs addObject:cf];
                }
                [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pagingView reloadPageAtPageIndex:i];
                });
            } failure:^(NSError *error) {
                
            }];
            break;
        }
    }
}

#pragma mark - 加载关注频道数据
- (void)loadDataOfConcernChannelItemWithIndex:(NSInteger) index {
    self.channelItemDictionary[LPConcernChannelItemName] = [NSMutableArray array];
    [self.pagingView insertPageAtIndex:index];
    [self.menuView reloadData];
    
    LPChannelItem *channelItem = self.pageindexMapToChannelItemDictionary[@(index)];
    CardParam *param = [[CardParam alloc] init];
    param.type = HomeCardsFetchTypeMore;
    param.count = @(20);
    param.startTime = [NSString stringWithFormat:@"%lld", (long long)([[[NSDate date] dateByAddingTimeInterval:(-12 * 60 * 60)] timeIntervalSince1970] * 1000)];
    param.channelID = channelItem.channelID;
    NSMutableArray *cfs = [NSMutableArray array];
    // 判断当前是否为关注频道
    if ([channelItem.channelID isEqual:focusChannelID]) {
        [CardTool cardsConcernWithParam:param channelID:channelItem.channelID success:^(NSArray *cards) {
            for (Card *card in cards) {
                LPCardConcernFrame *cf = [[LPCardConcernFrame alloc] init];
                cf.card = card;
                [cfs addObject:cf];
            }
            [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
        } failure:^(NSError *error) {
        }];
    }
}



#pragma mark - 添加关注重新请求网络数据存入数据库
- (void)addConcernAndReloadPage {
    
    if(![userDefaults objectForKey:LPConcernChannelItemShowOrHide]) {
        
        // 判断当前关注频道是否隐藏，隐藏则显示
        [self showConcernChannelItem];        
        // 当前选中频道索引值
        int index = 0;
        for (int i = 0; i < self.selectedArray.count; i++) {
            LPChannelItem *channelItem = self.selectedArray[i];
            if([channelItem.channelName isEqualToString:LPConcernChannelItemName]) {
                index = i;
            }
            static NSString *cardCellIdentifier = @"cardCellIdentifier";
            // 设置每个每页唯一标识
            [self.cardCellIdentifierDictionary setObject:[NSString stringWithFormat:@"%@%d",cardCellIdentifier,i] forKey:@(i)];
            
        }
        [self updatePageindexMapToChannelItemDictionary];
        
        [self.menuView reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        // 直接跳转至关注页面
        [self.menuView selectItemAtIndexPath:indexPath
                                    animated:YES
                              scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        
        [self.pagingView insertPageAtIndex:index];
        [self.pagingView setCurrentPageIndex:index];
        self.selectedChannelTitle = LPConcernChannelItemName;
        [userDefaults setObject:@"show" forKey:LPConcernChannelItemShowOrHide];
        [userDefaults synchronize];
    } else {
        for (int i = 0; i < self.selectedArray.count; i++) {
            LPChannelItem *channelItem = self.selectedArray[i];
            if ([channelItem.channelID isEqualToString:focusChannelID]) {
                // 加载当前频道数据
                CardParam *param = [[CardParam alloc] init];
                param.type = HomeCardsFetchTypeMore;
                param.count = @(20);
                param.startTime = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
                param.channelID = focusChannelID;
                NSMutableArray *cfs = [NSMutableArray array];
                [CardTool cardsConcernWithParam:param channelID:channelItem.channelID success:^(NSArray *cards) {
                    for (Card *card in cards) {
                        LPCardConcernFrame *cf = [[LPCardConcernFrame alloc] init];
                        cf.card = card;
                        [cfs addObject:cf];
                    }
                    [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.pagingView reloadPageAtPageIndex:i];
                    });
                } failure:^(NSError *error) {
                }];
                break;
            }
        }
    }
}

#pragma mark - setupInitialData
- (void)setupInitialData {
    // 设置频道名称
    [self initializeChannelItemName];

    // 设置所有频道唯一标识符
    [self setCellIdentifierOfAllChannelItems];
    
    // 频道切换时频道和页码的对应关系
    [self updatePageindexMapToChannelItemDictionary];
    
}

#pragma mark - 清理缓存后重新加载页面
- (void)reloadCurrentPageIndexData {
    // 清理缓存更新上次访问日期为空
    for (int i = 0; i < self.selectedArray.count; i++) {
        LPChannelItem *channelItem = self.selectedArray[i];
        channelItem.lastAccessDate = nil;
        self.channelItemDictionary[channelItem.channelName] = [NSMutableArray array];
    }

    
    NSInteger pageIndex = self.pagingView.currentPageIndex;
    // 获取频道相关信息
    LPChannelItem *channelItem = self.selectedArray[pageIndex];
    // 设置选中频道名称
    self.selectedChannelTitle = channelItem.channelName;
    // 设置本次访问时间
    NSDate *currentDate = [NSDate date];
    NSDate *lastAccessDate = channelItem.lastAccessDate;
    
    if (lastAccessDate == nil) {
        channelItem.lastAccessDate = currentDate;
    }
    // 加载当前频道数据
    [self loadMoreDataInPageAtPageIndex:pageIndex];
    [self.pagingView reloadData];
    
}

#pragma mark - 改变首页字体大小(继承自父类)
- (void)changeHomeViewFontSize {
    // 遍历所有页面
    for (int i = 0; i < self.selectedArray.count; i++) {
        LPChannelItem *channelItem = (LPChannelItem *)self.selectedArray[i];
        NSString *channelName = channelItem.channelName;
        NSMutableArray *cardFramesArray = self.channelItemDictionary[channelName];
        if (cardFramesArray.count > 0) {
            
            NSMutableArray *newCardFrames = [NSMutableArray array];
            if ([channelItem.channelID isEqualToString:focusChannelID]) {
                for (LPCardConcernFrame *cardFrame in cardFramesArray) {
                    LPCardConcernFrame *cf = [[LPCardConcernFrame alloc] init];
                    cf.card = cardFrame.card;
                    [newCardFrames addObject:cf];
                }
            } else {
                for (CardFrame *cardFrame in cardFramesArray) {
                    CardFrame *cf = [[CardFrame alloc] init];
                    cf.card = cardFrame.card;
                    [newCardFrames addObject:cf];
                }
            }
            [self.channelItemDictionary setObject:newCardFrames forKey:channelName];
            [self.pagingView reloadPageAtPageIndex:i];
        }
    }
    if (![self.selectedChannelTitle isEqualToString:LPConcernChannelItemName]) {
        LPPagingViewPage *page = (LPPagingViewPage *)[self.pagingView visiblePageAtIndex:self.pagingView.currentPageIndex];
        [page scrollToCurrentRow:[LPHomeRowManager sharedManager].currentRowIndex];
    }
}



#pragma mark - 懒加载
// 已选频道
- (NSMutableArray *)selectedArray {
    if(_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    return  _selectedArray;
}

// 可选频道
- (NSMutableArray *)optionalArray {
    if(_optionalArray == nil) {
        _optionalArray = [[NSMutableArray alloc] init];
    }
    return _optionalArray;
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


- (NSMutableArray *)cellAttributesArray {
    if (_cellAttributesArray == nil) {
        _cellAttributesArray = [[NSMutableArray alloc] init];
    }
    return _cellAttributesArray;
}

- (NSMutableArray *)subscriberFrameArray {
    if (_subscriberFrameArray == nil) {
        _subscriberFrameArray = [NSMutableArray array];
    }
    return _subscriberFrameArray;
}

- (LPPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [LPPlayerView sharedPlayerView];
//        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
    }
    return _playerView;
}


#pragma mark - 移除通知
- (void)dealloc {
    [noteCenter removeObserver:self];
}


@end
