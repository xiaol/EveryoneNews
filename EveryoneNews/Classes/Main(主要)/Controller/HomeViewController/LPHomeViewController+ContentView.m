//
//  LPHomeViewController+PagingView.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewController+ContentView.h"
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
#import "LPDetailViewController.h"
#import "Card+Fetch.h"
#import "CardParam.h"
#import "LPSearchViewController.h"

//static NSString *currentDateString = @"2016-01-14 00:08:08";
static NSString *reusePageID = @"reusePageID";
NSString *isFirstLoadMark = @"isFirstLoadMark";

@implementation LPHomeViewController (PagingView)

#pragma mark - 设置所有频道新闻数据
- (void)setInitialChannelItemDictionary {
    for (int i = 0; i < self.selectedArray.count; i++) {
        LPChannelItem *channelItem = (LPChannelItem *)[self.selectedArray objectAtIndex:i];
        NSDate *currentDate = [NSDate date];
        CardParam *param = [[CardParam alloc] init];
        param.type = HomeCardsFetchTypeMore;
        param.count = @(20);
        NSDate *lastAccessDate = channelItem.lastAccessDate;
        if (lastAccessDate == nil) {
            lastAccessDate = currentDate;
            channelItem.lastAccessDate = currentDate;
        }
        param.startTime = [NSString stringWithFormat:@"%lld", (long long)([lastAccessDate timeIntervalSince1970] * 1000)];
        NSString *channelID = [LPChannelItemTool channelID:channelItem.channelName];
        param.channelID = channelID;
        NSMutableArray *cfs = [NSMutableArray array];
        [CardTool cardsWithParam:param success:^(NSArray *cards) {
            for (Card *card in cards) {
                CardFrame *cf = [[CardFrame alloc] init];
                cf.card = card;
                [cfs addObject:cf];
                NSLog(@"%@, %@", card.title, card.updateTime);
            }
            [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
            if (i == self.selectedArray.count - 1) {
                [self.pagingView reloadData];
            }
        } failure:^(NSError *error) {
//            NSLog(@"%@", error);
            
        }];
    }
}

#pragma mark - LPPagingView DataSource
- (NSInteger)numberOfPagesInPagingView:(LPPagingView *)pagingView {
    return self.selectedArray.count;
}

- (UIView *)pagingView:(LPPagingView *)pagingView pageForPageIndex:(NSInteger)pageIndex {
    LPChannelItem *channelItem = self.pageindexMapToChannelItemDictionary[@(pageIndex)];
    LPPagingViewPage *page = (LPPagingViewPage *)[pagingView dequeueReusablePageWithIdentifier:reusePageID];
    page.delegate = self;
    page.cardFrames = self.channelItemDictionary[channelItem.channelName];
    page.cellIdentifier = self.cardCellIdentifierDictionary[@(pageIndex)];
    page.pageChannelName = channelItem.channelName;
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
    
    LPPagingViewPage *page = (LPPagingViewPage *)[pagingView currentPage];
    //第一次安装
    if (![userDefaults objectForKey:isFirstLoadMark]) {
        if (lastAccessDate == nil) {
            [self loadIndictorShow];
            [self loadMoreDataInPageAtPageIndex:pageIndex];
            channelItem.lastAccessDate = currentDate;
        }
    }
    else {
        
        [self channelItemDidAddToCoreData:pageIndex];
    }
    if (lastAccessDate != nil) {
            int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate] / 60;
            // 每5分钟做一次刷新操作
            if (interval > 5) {
                [page autotomaticLoadNewData];
                channelItem.lastAccessDate = currentDate;
            }
     }
    if (self.pageContentOffsetDictionary[page.pageChannelName]) {
        NSNumber *contentOffsetY= self.pageContentOffsetDictionary[page.pageChannelName];
        [page scrollToOffsetY:[contentOffsetY floatValue]];
    } else {
        [page scrollToOffsetY:TabBarHeight];
    }
    
}

#pragma mark - 加载中提示
- (void)loadIndictorShow {
    self.loadImageView.hidden = YES;
    self.noDataLabel.hidden = YES;
    
    self.loadLabel.hidden = NO;
    [self.indictorView startAnimating];
    self.backgroundView.hidden = NO;
}

#pragma mark - 重新加载提示
- (void)reloadIndictorShow {
    self.backgroundView.hidden = NO;
    
    [self.indictorView stopAnimating];
    self.loadLabel.hidden = YES;
    
    self.loadImageView.hidden = NO;
    self.noDataLabel.hidden = NO;
}

#pragma mark - 首次添加频道到数据库
- (void)channelItemDidAddToCoreData:(NSInteger)pageIndex {
    LPChannelItem *channelItem = self.pageindexMapToChannelItemDictionary[@(pageIndex)];
    CardParam *param = [[CardParam alloc] init];
    param.type = HomeCardsFetchTypeMore;
    param.count = @(20);
    param.startTime = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
    param.channelID = channelItem.channelID;
    NSArray *cards = [Card fetchCardsWithCardParam:param];
    if (cards.count == 0) {
        [self loadIndictorShow];
        [self loadMoreDataInPageAtPageIndex:pageIndex];
    }
}

#pragma mark - 加载更多
- (void)loadMoreDataInPageAtPageIndex:(NSInteger)pageIndex {
//    LPPagingViewPage *page = (LPPagingViewPage *)[self.pagingView currentPage];
    LPChannelItem *channelItem = self.pageindexMapToChannelItemDictionary[@(pageIndex)];
    CardParam *param = [[CardParam alloc] init];
    param.type = HomeCardsFetchTypeMore;
    param.count = @(20);
    
    //----------------测试-------------------------------------------------------
//        NSString *dateString = currentDateString;
//        //设置转换格式
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        //NSString转NSDate
//        NSDate *date=[formatter dateFromString:dateString];
//    
//        param.startTime = [NSString stringWithFormat:@"%lld", (long long)([date timeIntervalSince1970] * 1000)];
    //-----------------------------------------------------------------------
    
    param.startTime = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
    param.channelID = channelItem.channelID;
    NSMutableArray *cfs = [NSMutableArray array];
    [CardTool cardsWithParam:param success:^(NSArray *cards) {
        
        [self.indictorView stopAnimating];
        self.backgroundView.hidden = YES;
        
        for (Card *card in cards) {
            CardFrame *cf = [[CardFrame alloc] init];
            cf.card = card;
            [cfs addObject:cf];
        }
        
        [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
        [self.pagingView reloadData];
 
        
    } failure:^(NSError *error) {
        [self reloadIndictorShow];
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

#pragma mark - LPagingViewPage delegate
- (void)page:(LPPagingViewPage *)page didSelectCellWithCardID:(NSManagedObjectID *)cardID {
    LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
    detailVc.cardID = cardID;
    detailVc.isConcernDetail = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

- (void)page:(LPPagingViewPage *)page didClickSearchImageView:(UIImageView *)imageView {
    LPSearchViewController *searchVc = [[LPSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVc animated:NO];
}

- (void)page:(LPPagingViewPage *)page didSaveOffsetY:(CGFloat)offsetY {
    [self.pageContentOffsetDictionary setObject:@(offsetY) forKey:page.pageChannelName];
}
@end
