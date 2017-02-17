//
//  LPHomeViewController+ChannelItemMenu.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewController+ChannelItemMenu.h"
#import "LPHomeViewController+ContentView.h"
#import "LPPagingView.h"
#import "LPMenuView.h"
#import "LPChannelItemTool.h"
#import "LPChannelItem.h"
#import "LPMenuButton.h"
#import "LPMenuCollectionViewCell.h"
#import "LPPagingViewPage.h"
#import "LPPagingViewConcernPage.h"
#import "LPPagingViewVideoPage.h"

static NSString *reuseIdentifierFirst = @"reuseIdentifierFirst";
static NSString *reuseIdentifierSecond = @"reuseIdentifierSecond";
static NSString *menuCellIdentifier = @"menuCollectionViewCell";
static NSString *cellIdentifier = @"sortCollectionViewCell";
static NSString *cardCellIdentifier = @"CardCellIdentifier";

@implementation LPHomeViewController (ChannelItemMenu)

#pragma mark - 设置所有频道唯一标识
- (void)setCellIdentifierOfAllChannelItems {
    for (int i = 0; i < self.selectedArray.count; i++) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"%@%d",cardCellIdentifier,i];
        [self.cardCellIdentifierDictionary setObject:cellIdentifier forKey:@(i)];
    }
}


#pragma mark -  设置频道和页码的映射关系
- (void)updatePageindexMapToChannelItemDictionary {
    [self.pageindexMapToChannelItemDictionary removeAllObjects];
    for (int i = 0; i < self.selectedArray.count; i++) {
        LPChannelItem *channelItem = self.selectedArray[i];
        [self.pageindexMapToChannelItemDictionary setObject:channelItem forKey:@(i)];
    }
}

#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.selectedArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LPMenuCollectionViewCell *cell = (LPMenuCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:menuCellIdentifier forIndexPath:indexPath];
    LPChannelItem *channelItem = [self.selectedArray objectAtIndex:indexPath.item];
    cell.channelItem = channelItem;
    return cell;
    
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LPMenuCollectionViewCell *currentCell = (LPMenuCollectionViewCell *)[self.menuView cellForItemAtIndexPath:indexPath];
    LPMenuButton *currentButton = currentCell.menuButton;
    
    if (self.selectedChannelTitle == currentButton.text){ return; }
    
    self.selectedChannelTitle = currentButton.text;
    
    [self.pagingView setCurrentPageIndex:indexPath.item animated:NO];
    [self.menuView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    // 超过5分钟自动刷新 第一次调用则加载
    
    NSString *title = self.selectedChannelTitle;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (currentButton.text != self.selectedChannelTitle) { return; }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self requestMethod:currentCell didSelectIndexPath:indexPath button:currentButton];
        });
    });
}

-(void) requestMethod:(LPMenuCollectionViewCell *)currentCell didSelectIndexPath :(NSIndexPath *) indexPath button :(LPMenuButton *) currentButton {
    
    if (currentButton.text == self.selectedChannelTitle) {
        
        LPChannelItem *channelItem = [currentCell channelItem];
        NSDate *currentDate = [NSDate date];
        NSDate *lastAccessDate = channelItem.lastAccessDate;
        
        if (lastAccessDate == nil) {
            channelItem.lastAccessDate = currentDate;
        }
        
        // 终止视频播放
        if (![channelItem.channelID isEqualToString:videoChannelID]) {
            [self.playerView removePlayerObserver];
        }
        
        if ([channelItem.channelID isEqualToString:focusChannelID]) {
            LPPagingViewConcernPage *page = (LPPagingViewConcernPage *)[self.pagingView visiblePageAtIndex:indexPath.item];
            if (lastAccessDate != nil) {
                int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate] / 60;
                // 每10分钟做一次刷新操作
                if (interval > 10) {
                    [page autotomaticLoadNewData];
                    channelItem.lastAccessDate = currentDate;
                }
            }
        } else if ([channelItem.channelID isEqualToString:videoChannelID]) {
            LPPagingViewVideoPage *page = (LPPagingViewVideoPage *)[self.pagingView visiblePageAtIndex:indexPath.item];
            if (lastAccessDate != nil) {
                int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate] / 60;
                // 每10分钟做一次刷新操作
                if (interval > 10) {
                    [page autotomaticLoadNewData];
                    channelItem.lastAccessDate = currentDate;
                }
            }
        } else {
            LPPagingViewPage *page = (LPPagingViewPage *)[self.pagingView visiblePageAtIndex:indexPath.item];
            if (lastAccessDate != nil) {
                int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate] / 60;
                // 每10分钟做一次刷新操作
                if (interval > 10) {
                    [page autotomaticLoadNewData];
                    channelItem.lastAccessDate = currentDate;
                }
            }
        }
    }
    
}


#pragma mark - UICollectionView Style
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 40;
    
    if (iPhone6) {
        height = 48;
    }
    
    CGFloat width = 54;
    
    return CGSizeMake(width, height);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}


@end
