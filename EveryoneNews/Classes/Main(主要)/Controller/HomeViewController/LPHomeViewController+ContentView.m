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

NSString *const reusePageID = @"reusePageID";

@implementation LPHomeViewController (PagingView)

#pragma mark - 加载Core Data中已选频道的数据
- (void)setupInitialPagingViewData {
    
    for (int i = 0; i < self.selectedArray.count; i++) {
        LPChannelItem *channelItem = (LPChannelItem *)[self.selectedArray objectAtIndex:i];
        NSDate *currentDate = [NSDate date];
        CardParam *param = [[CardParam alloc] init];
        param.type = HomeCardsFetchTypeMore;
        param.count = @(20);
        NSDate *lastAccessDate = channelItem.lastAccessDate;
        if (lastAccessDate == nil) {
            lastAccessDate = currentDate;
        }
        param.startTime = [NSString stringWithFormat:@"%lld", (long long)([lastAccessDate timeIntervalSince1970] * 1000)];
        NSString *channelID = [LPChannelItemTool channelID:channelItem.channelName];
        param.channelID = channelID;
        NSMutableArray *cfs = [NSMutableArray array];

        [Card fetchCardsWithCardParam:param cardsArrayBlock:^(NSArray *cardsArray) {
            NSArray *cards = cardsArray;
            if (cards.count > 0) {
                for (Card *card in cards) {
                    CardFrame *cf = [[CardFrame alloc] init];
                    cf.card = card;
                    [cfs addObject:cf];                    
                }
                [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
            }
            if (i == self.selectedArray.count - 1) {
                [self.pagingView reloadData];
            }
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
    
    // 切换频道栏变更频道栏背景蓝色位置
    CGFloat menuBackgroundViewW = self.menuBackgroundView.frame.size.width;
    CGFloat menuBackgroundViewX = ratio * menuBackgroundViewW;
    CGFloat menuBackgroundViewY = self.menuBackgroundView.frame.origin.y;
    CGFloat menuBackgroundViewH = self.menuBackgroundView.frame.size.height;
    self.menuBackgroundView.frame = CGRectMake(menuBackgroundViewX, menuBackgroundViewY, menuBackgroundViewW, menuBackgroundViewH);
}


- (void)pagingView:(LPPagingView *)pagingView didScrollToPageIndex:(NSInteger)pageIndex {

    // 获取频道相关信息
    LPChannelItem *channelItem = self.selectedArray[pageIndex];
    // 设置选中频道名称
    self.selectedChannelTitle = channelItem.channelName;
    // 改变菜单栏按钮选中取消状态
    [self buttonSelectedStatusChangedWithIndex:(int)pageIndex];
    
    // 设置本次访问时间
    NSDate *currentDate = [NSDate date];
    NSDate *lastAccessDate = channelItem.lastAccessDate;
    
    if (lastAccessDate == nil) {
        channelItem.lastAccessDate = currentDate;
    }
    // 加载当前频道数据
    [self channelItemDidAddToCoreData:pageIndex];
    
    LPPagingViewPage *page = (LPPagingViewPage *)[pagingView currentPage];
    // 每隔5分钟执行自动刷新
    if (lastAccessDate != nil) {
         int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate] / 60;
            // 每5分钟做一次刷新操作
            if (interval > 5) {
                [page autotomaticLoadNewData];
                channelItem.lastAccessDate = currentDate;
            }
     }
    
//    // 记录上次滚动的位置
//    if (self.pageContentOffsetDictionary[page.pageChannelName]) {
//        NSNumber *contentOffsetY = self.pageContentOffsetDictionary[page.pageChannelName];
//        [page scrollToOffsetY:[contentOffsetY floatValue]];
//    } else {
//        [page scrollToOffsetY:TabBarHeight];
////        NSLog(@"%@", page.pageChannelName);
////        
////        NSLog(@"%@", self.pageContentOffsetDictionary[page.pageChannelName]);
//    }
    
 
    
}

#pragma mark - 首页显示正在加载提示
- (void)showLoadingView {
    [self.animationImageView startAnimating];
    self.loadingLabel.hidden = NO;
    self.contentLoadingView.hidden = NO;
  
}


#pragma mark - 首页隐藏正在加载提示
- (void)hideLoadingView {

    [self.animationImageView stopAnimating];
    self.loadingLabel.hidden = YES;
    self.contentLoadingView.hidden = YES;
}

#pragma mark - 判断本地是否有数据 没有就请求网络 然后存入数据库
- (void)channelItemDidAddToCoreData:(NSInteger)pageIndex {
    LPChannelItem *channelItem = self.pageindexMapToChannelItemDictionary[@(pageIndex)];
    CardParam *param = [[CardParam alloc] init];
    param.type = HomeCardsFetchTypeMore;
    param.count = @(20);
    param.startTime = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
    param.channelID = channelItem.channelID;
    [Card fetchCardsWithCardParam:param cardsArrayBlock:^(NSArray *cardsArray) {
        NSArray *cards = cardsArray;
        if (cards.count == 0) {
            [self showLoadingView];
            [self loadMoreDataInPageAtPageIndex:pageIndex];
        } else {
            [self hideLoadingView];
        }
    }];
    
}

#pragma mark - 加载更多
- (void)loadMoreDataInPageAtPageIndex:(NSInteger)pageIndex {
    LPChannelItem *channelItem = self.pageindexMapToChannelItemDictionary[@(pageIndex)];
    CardParam *param = [[CardParam alloc] init];
    param.type = HomeCardsFetchTypeMore;
    param.count = @(20);
    param.startTime = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
    param.channelID = channelItem.channelID;
    NSMutableArray *cfs = [NSMutableArray array];
    [CardTool cardsWithParam:param channelID:channelItem.channelID success:^(NSArray *cards) {
        for (Card *card in cards) {
            CardFrame *cf = [[CardFrame alloc] init];
            cf.card = card;
            [cfs addObject:cf];
        }
        if (cfs.count > 0) {
            [self hideLoadingView];
        }
        [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
        [self.pagingView reloadData];
    } failure:^(NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideLoadingView];
        });
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
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

- (void)page:(LPPagingViewPage *)page didClickSearchImageView:(UIImageView *)imageView {
    LPSearchViewController *searchVc = [[LPSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVc animated:NO];
}

- (void)page:(LPPagingViewPage *)page didSaveOffsetY:(CGFloat)offsetY {
//    [self.pageContentOffsetDictionary setObject:@(offsetY) forKey:page.pageChannelName];
}
@end
