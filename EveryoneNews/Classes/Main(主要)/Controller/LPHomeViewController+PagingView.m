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

//static NSString *currentDateString = @"2015-12-29 08:08:08";
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
            }
            [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
            if (i == self.selectedArray.count - 1) {
                [self.pagingView reloadData];
            }
        } failure:^(NSError *error) {
            
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
            [self loadMoreDataInPageAtPageIndex:pageIndex];
            channelItem.lastAccessDate = currentDate;
        }
    }
    if (lastAccessDate != nil) {
        if (page.cardFrames.count == 0) {
            [self loadMoreDataInPageAtPageIndex:pageIndex];
        } else {
            int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate] / 60;
            // 每5分钟做一次刷新操作
            if (interval > 5) {
                [page autotomaticLoadNewData];
                channelItem.lastAccessDate = currentDate;
            }
        }
    }
}

#pragma mark - 加载更多
- (void)loadMoreDataInPageAtPageIndex:(NSInteger)pageIndex{
    sharedIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    sharedIndicator.color = [UIColor lightGrayColor];
    sharedIndicator.center = CGPointMake(ScreenWidth / 2, 100 );
    [self.view addSubview:sharedIndicator];
    [sharedIndicator startAnimating];
    LPChannelItem *channelItem = self.pageindexMapToChannelItemDictionary[@(pageIndex)];
    CardParam *param = [[CardParam alloc] init];
    param.type = HomeCardsFetchTypeMore;
    param.count = @(20);
    param.startTime = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
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
        [sharedIndicator stopAnimating];
    } failure:^(NSError *error) {
        [sharedIndicator stopAnimating];
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
