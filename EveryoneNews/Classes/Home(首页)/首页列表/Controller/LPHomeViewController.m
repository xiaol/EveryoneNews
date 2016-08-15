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

@interface LPHomeViewController ()

@end

@implementation LPHomeViewController

#pragma mark - 懒加载
// 已选频道
- (NSMutableArray *)selectedArray {
    if(_selectedArray == nil) {
        _selectedArray = [[NSMutableArray alloc] init];
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

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    // 第一次订阅后“关注”频道自动显示在第5个位置
    [noteCenter addObserver:self selector:@selector(concernChannelItemAtFirstTime) name:LPConcernChannelItemAtFirstTime object:nil];
    // 登录
    [noteCenter addObserver:self selector:@selector(login) name:LPLoginNotification object:nil];
    // 退出登录
    [noteCenter addObserver:self selector:@selector(loginout) name:LPLoginOutNotification object:nil];
}


#pragma mark - 登录
- (void)login {
    Account *account = [AccountTool account];
    [self displayLoginBtnIconWithAccount:account];

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
        [self channelItemDidAddToCoreData:pageIndex];
    }
    

}

#pragma mark - 退出登录
- (void)loginout {
    Account *account = [AccountTool account];
     [AccountTool deleteAccount];
    [self displayLoginBtnIconWithAccount:account];

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
        self.channelItemDictionary[LPConcernChannelItemName]  =  nil;
        [self.pagingView reloadPageAtPageIndex:pageIndex];
    }
}

#pragma mark - 设置用户头像
- (void)displayLoginBtnIconWithAccount:(Account *)account
{
    CGFloat statusBarHeight = 20.0f;
    CGFloat menuViewHeight = 44.0;
    
    CGFloat unloginBtnX = 15.0;
    CGFloat unloginBtnW = 16.0;
    CGFloat unloginBtnH = 16.0;
    if (iPhone6Plus) {
        unloginBtnX = 15.7f;
        unloginBtnW = 17.3f;
        unloginBtnH = 18.6f;
    } else if (iPhone5) {
        unloginBtnX = 15.0f;
        unloginBtnW = 16.0f;
        unloginBtnH = 16.0f;
    } else if (iPhone6) {
        menuViewHeight = 52;
        unloginBtnW = 18.0f;
        unloginBtnH = 18.0f;
        unloginBtnX = 17.0f;
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
        
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"home_login"] forState:UIControlStateNormal];
        self.loginBtn.frame = CGRectMake(unloginBtnX , unloginBtnY , unloginBtnW, unloginBtnH);
    } else {
        CGFloat statusBarHeight = 20.0f;
        CGFloat menuViewHeight = 44.0;
        CGFloat loginBtnX = 10;
        CGFloat loginBtnW = 29;
        CGFloat loginBtnH = 29;
        
        if (iPhone6Plus) {
            loginBtnX = 10.0f;
        } else if (iPhone5) {
            loginBtnX = 10.0f;
            loginBtnW = 25;
            loginBtnH = 25;
        } else if (iPhone6) {
            loginBtnX = 12.0f;
            loginBtnW = 29;
            loginBtnH = 29;
            menuViewHeight = 52;
        }
        CGFloat loginBtnY = (menuViewHeight - loginBtnH) / 2 + statusBarHeight;
        
        [self.loginBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:account.userIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"登录icon"]];
        self.loginBtn.frame = CGRectMake(loginBtnX , loginBtnY , loginBtnW, loginBtnH);
        self.loginBtn.layer.cornerRadius = loginBtnH / 2;
        self.loginBtn.layer.borderWidth = 1;
        self.loginBtn.layer.masksToBounds = YES;
        self.loginBtn.layer.borderColor = [UIColor colorFromHexString:@"#e4e4e4"].CGColor;
        
    }
}
#pragma mark - 第一次订阅“关注”频道 
- (void)concernChannelItemAtFirstTime {
    LPChannelItem *channelItem = [[LPChannelItem alloc] init];
    LPChannelItem *concernChannelItem = [[LPChannelItem alloc] init];
    
    
//    for (int i = 0; i < self.optionalArray.count; i++) {
//        if ([channelItem.channelName isEqualToString:LPConcernChannelItemName]) {
//            channelItem = (LPChannelItem *)self.optionalArray[i];
//            concernChannelItem = channelItem;
//            [self.optionalArray removeObject:channelItem];
//            break;
//        }
//    }
//    NSInteger index = 0;
//    int selectedCount = self.selectedArray.count;
//    concernChannelItem.channelIsSelected = @"1";
//    if (selectedCount >= 4) {
//      [self.selectedArray insertObject:concernChannelItem atIndex:4];
//        index = 4;
//    } else {
//      [self.selectedArray insertObject:concernChannelItem atIndex:selectedCount];
//        index = selectedCount;
//    }
//
//    
//    for (LPChannelItem *channelItem in <#collection#>) {
//        <#statements#>
//    }
    
    
    // 重新加载本地数据库数据, 请求“关注”频道接口数据
    // 设置所有频道唯一标识符
//    [self setCellIdentifierOfAllChannelItems];
//    
//    // 频道切换时频道和页码的对应关系
//    [self updatePageindexMapToChannelItemDictionary];
//    
//    CardParam *param = [[CardParam alloc] init];
//    param.type = HomeCardsFetchTypeMore;
//    param.count = @(20);
//    param.startTime = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
//    param.channelID = focusChannelID;
 
    
    
    
    
    // 请求关注频道数据
//    [CardTool cardsConcernWithParam:param channelID:channelItem.channelID success:^(NSArray *concernCards) {
//        for (int i = 0; i < self.selectedArray.count; i++) {
//            LPChannelItem *channelItem = (LPChannelItem *)[self.selectedArray objectAtIndex:i];
//            NSDate *currentDate = [NSDate date];
//            CardParam *param = [[CardParam alloc] init];
//            param.type = HomeCardsFetchTypeMore;
//            param.count = @(20);
//            NSDate *lastAccessDate = channelItem.lastAccessDate;
//            if (lastAccessDate == nil) {
//                lastAccessDate = currentDate;
//            }
//            param.startTime = [NSString stringWithFormat:@"%lld", (long long)([lastAccessDate timeIntervalSince1970] * 1000)];
//            NSString *channelID = [LPChannelItemTool channelID:channelItem.channelName];
//            param.channelID = channelID;
//            
//            NSMutableArray *cfs = [NSMutableArray array];
//            [Card fetchCardsWithCardParam:param cardsArrayBlock:^(NSArray *cardsArray) {
//                NSArray *cards = cardsArray;
//                // 如果本地数据存在则加载到内存中
//                if (cards.count > 0) {
//                    if (![channelItem.channelID isEqualToString:focusChannelID]) {
//                        for (Card *card in cards) {
//                            CardFrame *cf = [[CardFrame alloc] init];
//                            cf.card = card;
//                            [cfs addObject:cf];
//                        }
//                    } else {
//                        // 关注
//                        for (Card *card in cards) {
//                            LPCardConcernFrame *cf = [[LPCardConcernFrame alloc] init];
//                            cf.card = card;
//                            [cfs addObject:cf];
//                        }
//                    }
//                    [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
//                }
//                // 加载完数据后刷新页面
//                if (i == self.selectedArray.count - 1) {
//                  
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSIndexPath *menuIndexPath = [NSIndexPath indexPathForItem:index
//                                                                         inSection:0];
//                        [self.menuView reloadData];
//                        [self.menuView selectItemAtIndexPath:menuIndexPath
//                                                    animated:NO
//                                              scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
//                        
//                        [self.pagingView reloadData];
//                        [self.pagingView setCurrentPageIndex:index animated:NO];
//                        [self loadMoreDataInPageAtPageIndex:index];
//                        
//                        [LPChannelItemTool saveChannelItems:self.channelItemsArray];
//                    });
//              
//                }
//            }];
//        }
//    } failure:^(NSError *error) {
//    }];
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

#pragma mark - 添加关注重新请求网络数据存入数据库
- (void)addConcernAndReloadPage {
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

#pragma mark - setupInitialData
- (void)setupInitialData {
    // 设置频道名称
    [self initializeChannelItemName];
    
    // 设置已选频道栏数据
    [self setupInitialPagingViewData];
    
    // 设置所有频道唯一标识符
    [self setCellIdentifierOfAllChannelItems];
    
    // 频道切换时频道和页码的对应关系
    [self updatePageindexMapToChannelItemDictionary];
    
    if (![AccountTool account]) {
        self.isTourist = YES;
    }
    
}

#pragma mark - 清理缓存后重新加载页面
- (void)reloadCurrentPageIndexData {
    // 清理缓存更新上次访问日期为空
    for (int i = 0; i < self.selectedArray.count; i++) {
        LPChannelItem *channelItem = self.selectedArray[i];
        channelItem.lastAccessDate = nil;
    }
    [self.channelItemDictionary removeAllObjects];
    
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
    [self channelItemDidAddToCoreData:pageIndex];
    
    [self.pagingView reloadData];
}

#pragma mark - 改变首页字体大小(继承自父类)
- (void)changeHomeViewFontSize {
    
    // 遍历所有页面
    for (int i = 0; i < self.selectedArray.count; i++) {
        
        LPChannelItem *channelItem = (LPChannelItem *)self.selectedArray[i];
        if ([channelItem.channelID isEqualToString:focusChannelID]) {
            LPPagingViewConcernPage *page = (LPPagingViewConcernPage *)[self.pagingView pageAtPageIndex:i];
            if (page != nil) {
                NSArray *cardFrames = page.cardFrames;
                NSMutableArray *newCardFrames = [NSMutableArray array];
                for (LPCardConcernFrame *cardFrame in cardFrames) {
                    LPCardConcernFrame *cf = [[LPCardConcernFrame alloc] init];
                    cf.card = cardFrame.card;
                    [newCardFrames addObject:cf];
                }
                NSString *channelName = page.pageChannelName;
                [self.channelItemDictionary setObject:newCardFrames forKey:channelName];
                [self.pagingView reloadPageAtPageIndex:i];
            }
        } else {
            LPPagingViewPage *page = (LPPagingViewPage *)[self.pagingView pageAtPageIndex:i];
            if (page != nil) {
                NSArray *cardFrames = page.cardFrames;
                NSMutableArray *newCardFrames = [NSMutableArray array];
                for (CardFrame *cardFrame in cardFrames) {
                    CardFrame *cf = [[CardFrame alloc] init];
                    cf.card = cardFrame.card;
                    [newCardFrames addObject:cf];
                }
                NSString *channelName = page.pageChannelName;
                [self.channelItemDictionary setObject:newCardFrames forKey:channelName];
                [self.pagingView reloadPageAtPageIndex:i];
            }
        }
    }
    if (![self.selectedChannelTitle isEqualToString:@"关注"]) {
        LPPagingViewPage *page = (LPPagingViewPage *)[self.pagingView currentPage];
        [page scrollToCurrentRow:[LPHomeRowManager sharedManager].currentRowIndex];
    }
}

#pragma mark - viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


#pragma mark - 移除通知
- (void)dealloc {
    [noteCenter removeObserver:self];
}



@end
