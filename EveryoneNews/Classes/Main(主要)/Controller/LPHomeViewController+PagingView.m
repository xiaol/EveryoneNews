//
//  LPHomeViewController+PagingView.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewController+PagingView.h"
#import "CardTool.h"
#import "CardParam.h"
#import "Card+CoreDataProperties.h"
#import "LPChannelItem.h"
#import "LPChannelItemTool.h"
#import "CardFrame.h"
#import "LPPagingViewPage.h"
#import "LPMenuButton.h"
#import "LPDiggerFooter.h"
#import "LPDiggerHeader.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"

static NSString *currentDateString = @"2015-12-29 08:08:08";
static NSString *reusePageID = @"reusePageID";
NSString *isFirstLoadMark = @"isFirstLoadMark";

@implementation LPHomeViewController (PagingView)

#pragma mark - 设置所有频道新闻数据
- (void)setInitialChannelItemDictionary {
    for (int i = 0; i < self.selectedArray.count; i++) {
        CardParam *param = [[CardParam alloc] init];
        param.type = HomeCardsFetchTypeMore;
        param.count = @(20);
        
        //需要转换的字符串
        NSString *dateString = currentDateString;
        //设置转换格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //NSString转NSDate
        NSDate *date=[formatter dateFromString:dateString];
        
        param.startTime = [NSString stringWithFormat:@"%lld", (long long)([date timeIntervalSince1970] * 1000)];
        
        //        param.startTime = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
        LPChannelItem *channelItem = (LPChannelItem *)[self.selectedArray objectAtIndex:i];
        NSString *channelID = [LPChannelItemTool channelID:channelItem.channelName];
        param.channelID = channelID;
        NSMutableArray *cfs = [NSMutableArray array];
        [CardTool cardsWithParam:param success:^(NSArray *cards) {
            for (Card *card in cards) {
                CardFrame *cf = [[CardFrame alloc] init];
                cf.card = card;
                [cfs addObject:cf];
            }
            [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
            if (i == self.selectedArray.count - 1) {
                [self.pagingView reloadData];
            }
        } failure:^(NSError *error) {
            // // NSLog(@"failure!");
            
        }];
    }
    
}

#pragma mark - LPPagingView DataSource
- (NSInteger)numberOfPagesInPagingView:(LPPagingView *)pagingView {
    return self.selectedArray.count;
}

- (UIView *)pagingView:(LPPagingView *)pagingView pageForPageIndex:(NSInteger)pageIndex {
    LPChannelItem *channelItem = self.pageindexMapToChannelItemDictionary[@(pageIndex)];
    // NSLog(@"%@", channelItem.channelName);
    LPPagingViewPage *page = (LPPagingViewPage *)[pagingView dequeueReusablePageWithIdentifier:reusePageID];
    //    page.delegate = self;
    page.cardFrames = self.channelItemDictionary[channelItem.channelName];
    page.cellIdentifier = self.cardCellIdentifierDictionary[@(pageIndex)];
    page.pageChannelName = channelItem.channelName;
    //    [page scrollToContentOffsetY:[self.contentOffsetDictionary[channelItem.channelName] floatValue]];
    //    NSLog(@"%@",self.contentOffsetDictionary[channelItem.channelName] );
    return page;
}

#pragma mark - LPPagingView Delegate
- (void)pagingView:(LPPagingView *)pagingView didScrollWithRatio:(CGFloat)ratio {
    int index = floor(ratio);
    CGFloat rate = ratio - index;
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:index
                                                        inSection:0];
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:index + 1
                                                     inSection:0];
    LPMenuCollectionViewCell *currentCell = (LPMenuCollectionViewCell *)[self.menuView cellForItemAtIndexPath:currentIndexPath];
    LPMenuCollectionViewCell *nextCell = (LPMenuCollectionViewCell *)[self.menuView cellForItemAtIndexPath:nextIndexPath];
    LPMenuButton *currentButton = currentCell.menuButton;
    LPMenuButton *nextButton = nextCell.menuButton;
    [currentButton titleSizeAndColorDidChangedWithRate:rate];
    [nextButton titleSizeAndColorDidChangedWithRate:(1 - rate)];
}


- (void)pagingView:(LPPagingView *)pagingView didScrollToPageIndex:(NSInteger)pageIndex {
    
    LPChannelItem *channelItem = self.selectedArray[pageIndex];
    self.selectedChannelTitle = channelItem.channelName;
    // 改变菜单栏按钮选中取消状态
    [self buttonSelectedStatusChangedWithIndex:(int)pageIndex];
    
    NSDate *currentDate = [NSDate date];
    NSDate *lastAccessDate = channelItem.lastAccessDate;
    
//    LPPagingViewPage *page = (LPPagingViewPage *)[self pagingView:pagingView pageForPageIndex:pageIndex];
    //第一次安装
    if (![userDefaults objectForKey:isFirstLoadMark]) {
        if (lastAccessDate == nil) {
            [self loadMoreDataInPageAtPageIndex:pageIndex];
            channelItem.lastAccessDate = currentDate;
        } else {
            int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate];
//            int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate] / 60;
            // 每5分钟做一次刷新操作
            if (interval > 1) {
//                [page.tableView.header beginRefreshing];
//                [page autotomaticLoadNewData];
//                [self.pagingView reloadPageAtPageIndex:pageIndex];
                channelItem.lastAccessDate = currentDate;
            }
        }
    }
//     [page autotomaticLoadNewData];
}
#pragma mark - 加载更多
- (void)loadMoreDataInPageAtPageIndex:(NSInteger)pageIndex{
    LPChannelItem *channelItem = self.pageindexMapToChannelItemDictionary[@(pageIndex)];
    CardParam *param = [[CardParam alloc] init];
    param.type = HomeCardsFetchTypeMore;
    param.count = @(20);
    
    //需要转换的字符串
    NSString *dateString = currentDateString;
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:dateString];
    
    param.startTime = [NSString stringWithFormat:@"%lld", (long long)([date timeIntervalSince1970] * 1000)];
    //    NSLog(@"%@", param.startTime);
    // param.startTime = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
    param.channelID = channelItem.channelID;
    NSMutableArray *cfs = [NSMutableArray array];
    [CardTool cardsWithParam:param success:^(NSArray *cards) {
        for (Card *card in cards) {
            CardFrame *cf = [[CardFrame alloc] init];
            cf.card = card;
            [cfs addObject:cf];
        }
        [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
        [self.pagingView reloadData];
//        [self.pagingView reloadPageAtPageIndex:pageIndex];
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 选中菜单按钮状态变化
- (void)buttonSelectedStatusChangedWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index
                                                 inSection:0];
    [self.menuView selectItemAtIndexPath:indexPath
                                animated:YES
                          scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}
@end
