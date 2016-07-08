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
    
    //[MobClick beginLogPageView:@"HomePage"];
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInitialData];
    
    [self setupSubViews];

    [noteCenter addObserver:self selector:@selector(reloadCurrentPageIndexData) name:LPDeleteCoreDataNotification object:nil];
    
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
    
    LPPagingViewPage *page = (LPPagingViewPage *)[self.pagingView currentPage];
    [page scrollToCurrentRow:[LPHomeRowManager sharedManager].currentRowIndex];
}

#pragma mark - viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[MobClick endLogPageView:@"HomePage"];
}


#pragma mark - 移除通知
- (void)dealloc {
    [noteCenter removeObserver:self];
}



@end
