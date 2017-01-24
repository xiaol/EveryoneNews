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
#import "NSString+LP.h"
#import "UIButton+LP.h"
#import "AppDelegate.h"
#import "CardImage.h"
#import "Card.h"
#import "Card+Create.h"
#import "LPHomeRowManager.h"
#import "LPCardConcernFrame.h"
#import "LPHomeVideoFrame.h"
#import "CardConcern.h"
#import "AccountTool.h"
#import "LPSpecialTopicHomeViewController.h"
#import "LPConcernDetailViewController.h"
#import "LPAdsDetailViewController.h"
#import "LPVideoDetailViewController.h"
#import "CardTool.h"



NSString * const reusePageID = @"reusePageID";
NSString * const reuseConcernPageID = @"reuseConcernPageID";
NSString * const reuseVideoPageID = @"reuseVideoPageID";
 

 

@implementation LPHomeViewController (PagingView)



#pragma mark - LPPagingView DataSource
- (NSInteger)numberOfPagesInPagingView:(LPPagingView *)pagingView {
    return self.selectedArray.count;
}

- (UIView *)pagingView:(LPPagingView *)pagingView pageForPageIndex:(NSInteger)pageIndex {
    
    LPChannelItem *channelItem = self.pageindexMapToChannelItemDictionary[@(pageIndex)];
    NSMutableArray *cardFramesArray = self.channelItemDictionary[channelItem.channelName];

    LPPagingViewBasePage *page = nil;
    if ([channelItem.channelID isEqualToString:focusChannelID]) {
         page = (LPPagingViewConcernPage *)[pagingView dequeueReusablePageWithIdentifier:reuseConcernPageID];
       
    } else if([channelItem.channelID isEqualToString:videoChannelID]) {
        page = (LPPagingViewVideoPage *)[pagingView dequeueReusablePageWithIdentifier:reuseVideoPageID];
        
    } else {
        page = (LPPagingViewPage *)[pagingView dequeueReusablePageWithIdentifier:reusePageID];
    }
    page.cardFrames = self.channelItemDictionary[channelItem.channelName];
    if (cardFramesArray.count == 0) {
        [self loadDataAtPageIndex:pageIndex basePage:page];
    }
    
    page.pageChannelID = channelItem.channelID;
    page.pageChannelName = channelItem.channelName;
    page.cellIdentifier = self.cardCellIdentifierDictionary[@(pageIndex)];
    page.delegate = self;
  
    CGPoint offsetZero = CGPointZero;
    if (!CGPointEqualToPoint(channelItem.offset , offsetZero)) {
         page.offset = channelItem.offset;
    } else {
        page.offset = offsetZero;
    }
    
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
        [currentButton titleSizeColorDidChangedWithRate:rate];
        [nextButton titleSizeColorDidChangedWithRate:(1 - rate)];
    
    
        UICollectionViewLayoutAttributes *attributes = [self.menuView layoutAttributesForItemAtIndexPath:currentIndexPath];
        CGFloat menuBackgroundViewW = attributes.frame.size.width + 1;
        // 切换频道栏变更频道栏背景蓝色位置
 
        CGFloat menuBackgroundViewX = ratio * menuBackgroundViewW + 5;
        CGFloat menuBackgroundViewY = self.menuBackgroundView.frame.origin.y;
        CGFloat menuBackgroundViewH = self.menuBackgroundView.frame.size.height;
        self.menuBackgroundView.frame = CGRectMake(menuBackgroundViewX, menuBackgroundViewY,  self.menuBackgroundView.frame.size.width, menuBackgroundViewH);
}

- (void)pagingView:(LPPagingView *)pagingView didScrollToPageIndex:(NSInteger)pageIndex {

    // 获取频道相关信息
    LPChannelItem *channelItem = self.selectedArray[pageIndex];
    
    // 设置选中频道名称
    self.selectedChannelTitle = channelItem.channelName;
    
    // 改变菜单栏按钮选中取消状态
    [self menuSelectedStatusChangedWithIndex:(int)pageIndex];
    
    // 设置本次访问时间
    NSDate *currentDate = [NSDate date];
    NSDate *lastAccessDate = channelItem.lastAccessDate;
    
    if (lastAccessDate == nil) {
        channelItem.lastAccessDate = currentDate;
    }
    // 终止视频播放
    if (![channelItem.channelID isEqualToString:videoChannelID]) {
        if (self.playerView.state == LPPlayerStatePlaying) {
                [self.playerView removePlayerObserver];
        }
    }
    
    if ([channelItem.channelID isEqualToString:focusChannelID]) {
        
        LPPagingViewConcernPage *page = (LPPagingViewConcernPage *)[pagingView visiblePageAtIndex:pageIndex];
        // 每隔10分钟执行自动刷新
        if (lastAccessDate != nil) {
            int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate] / 60;
            // 每10分钟做一次刷新操作
            if (interval > 10) {
                if (page.cardFrames.count > 0) {
                    channelItem.lastAccessDate = currentDate;
                    [page autotomaticLoadNewData];
                    
                }
            }
        }
    } else if([channelItem.channelID isEqualToString:videoChannelID]) {
        LPPagingViewVideoPage *page = (LPPagingViewVideoPage *)[pagingView visiblePageAtIndex:pageIndex];
        // 每隔10分钟执行自动刷新
        if (lastAccessDate != nil) {
            int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate] / 60;
            // 每10分钟做一次刷新操作
            if (interval > 10) {
                if (page.cardFrames.count > 0) {
                    channelItem.lastAccessDate = currentDate;
                    [page autotomaticLoadNewData];
                    
                }
                
            }
        }
    } else {
        LPPagingViewPage *page = (LPPagingViewPage *)[pagingView visiblePageAtIndex:pageIndex];
        // 每隔10分钟执行自动刷新
        if (lastAccessDate != nil) {
            int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate] / 60;
            // 每10分钟做一次刷新操作
            if (interval > 10) {
                if (page.cardFrames.count > 0) {
                    channelItem.lastAccessDate = currentDate;
                    [page autotomaticLoadNewData];
                    
                }
                
            }
        }

    }
}

- (void)pagingView:(LPPagingView *)pagingView didEndDisplayPage:(UIView *)page atIndex:(NSInteger)pageIndex {
    if (self.selectedArray.count <= pageIndex ){ return; }
    LPPagingViewBasePage *basePage = (LPPagingViewBasePage *)page;
    LPChannelItem *channelItem = [self.selectedArray objectAtIndex:pageIndex];    
    channelItem.offset = basePage.offset;
}

#pragma mark - 请求数据
- (void)loadDataAtPageIndex:(NSInteger)pageIndex basePage:(LPPagingViewBasePage *)basePage {
    LPChannelItem *channelItem = self.pageindexMapToChannelItemDictionary[@(pageIndex)];
    CardParam *param = [[CardParam alloc] init];
    param.type = HomeCardsFetchTypeMore;
    param.count = @(20);
    param.startTime = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
    param.channelID = channelItem.channelID;
    if (!([[[userDefaults objectForKey:@"utype"] stringValue] isEqualToString:@"2"] && [channelItem.channelID isEqualToString:focusChannelID])) {
    NSArray *cardFramesArray = self.channelItemDictionary[channelItem.channelName];
        if (cardFramesArray.count == 0) {
            [Card fetchCardsWithCardParam:param cardsArrayBlock:^(NSArray *cardsArray) {
                NSArray *cards = cardsArray;
                // 本地数据库没有数据，请求网络数据
                if (cards.count == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self loadMoreDataInPageAtPageIndex:pageIndex basePage:basePage];
                    });
                   
                } else {
     
                        NSMutableArray *cfs = [NSMutableArray array];
                        // 关注
                        if ([channelItem.channelID isEqualToString:focusChannelID]) {
                            
                            for (Card *card in cards) {
                                LPCardConcernFrame *cf = [[LPCardConcernFrame alloc] init];
                                cf.card = card;
                                [cfs addObject:cf];
                            }
                        } else if ([channelItem.channelID isEqualToString:videoChannelID]) {
                            for (Card *card in cards) {
                                LPHomeVideoFrame *cf = [[LPHomeVideoFrame alloc] init];
                                cf.card = card;
                                [cfs addObject:cf];
                            }
                        }
                        else {
                          
                            
                            for (Card *card in cards) {
                                CardFrame *cf = [[CardFrame alloc] init];
                                cf.card = card;
                                [cfs addObject:cf];
                            }

                       
                        }
                        [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
                        basePage.cardFrames = self.channelItemDictionary[channelItem.channelName];
                        if (pageIndex == 0 && !self.iSAutoRefreshAtFirstTimeFinished) {
                            NSDate *lastAccessDate = channelItem.lastAccessDate;
                            NSDate *currentDate = [NSDate date];
                            if (lastAccessDate != nil) {
                                int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate] / 60;
                                // 首次打开2超过20分钟自动刷新
                                if (interval > 20) {
                                    if (basePage.cardFrames.count > 0) {
                                        [(LPPagingViewPage *)basePage autotomaticLoadNewData];
                                        channelItem.lastAccessDate = currentDate;
                                    }
                                }
                            }
                            self.autoRefreshAtFirstTimeFinished = YES;
                        }
                    
                }
            }];
        }
    } else {
        [self.channelItemDictionary setObject:[NSMutableArray array] forKey:LPConcernChannelItemName];
        basePage.cardFrames = self.channelItemDictionary[LPConcernChannelItemName];
    }
}

#pragma mark - 加载更多
- (void)loadMoreDataInPageAtPageIndex:(NSInteger)pageIndex basePage:(LPPagingViewBasePage *)basePage {
    LPChannelItem *channelItem = self.pageindexMapToChannelItemDictionary[@(pageIndex)];
    CardParam *param = [[CardParam alloc] init];
    param.type = HomeCardsFetchTypeMore;
    param.count = @(20);
    param.startTime = [NSString stringWithFormat:@"%lld", (long long)([[[NSDate date] dateByAddingTimeInterval:(-12 * 60 * 60)] timeIntervalSince1970] * 1000)];
    param.channelID = channelItem.channelID;
    
    if (!([[[userDefaults objectForKey:@"utype"] stringValue] isEqualToString:@"2"] && [channelItem.channelID isEqualToString:focusChannelID])) {
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
                basePage.cardFrames = self.channelItemDictionary[channelItem.channelName];
            } failure:^(NSError *error) {
            }];
        } else if ([channelItem.channelID isEqual:videoChannelID]) {
            [CardTool cardsWithParam:param channelID:channelItem.channelID success:^(NSArray *cards) {
                for (Card *card in cards) {
                    LPHomeVideoFrame *cf = [[LPHomeVideoFrame alloc] init];
                    cf.card = card;
                    [cfs addObject:cf];
                }
                [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
                basePage.cardFrames = self.channelItemDictionary[channelItem.channelName];
            } failure:^(NSError *error) {
                
            }];

        } else {
            [CardTool cardsWithParam:param channelID:channelItem.channelID success:^(NSArray *cards) {
                for (Card *card in cards) {
                    CardFrame *cf = [[CardFrame alloc] init];
                    cf.card = card;
                    [cfs addObject:cf];
                }
                [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
                basePage.cardFrames = self.channelItemDictionary[channelItem.channelName];
            } failure:^(NSError *error) {

            }];
        }
    } else {
        [self.channelItemDictionary setObject:[NSMutableArray array] forKey:LPConcernChannelItemName];
        basePage.cardFrames = self.channelItemDictionary[LPConcernChannelItemName];
    }
}

- (void)loadMoreDataInPageAtPageIndex:(NSInteger)pageIndex {
    LPChannelItem *channelItem = self.pageindexMapToChannelItemDictionary[@(pageIndex)];
    CardParam *param = [[CardParam alloc] init];
    param.type = HomeCardsFetchTypeMore;
    param.count = @(20);
    param.startTime = [NSString stringWithFormat:@"%lld", (long long)([[[NSDate date] dateByAddingTimeInterval:(-12 * 60 * 60)] timeIntervalSince1970] * 1000)];
    param.channelID = channelItem.channelID;
    NSMutableArray *cfs = [NSMutableArray array];
    if (!([[[userDefaults objectForKey:@"utype"] stringValue] isEqualToString:@"2"] && [channelItem.channelID isEqualToString:focusChannelID])) {
        // 判断当前是否为关注频道
        if ([channelItem.channelID isEqual:focusChannelID]) {
            [CardTool cardsConcernWithParam:param channelID:channelItem.channelID success:^(NSArray *cards) {
                for (Card *card in cards) {
                    LPCardConcernFrame *cf = [[LPCardConcernFrame alloc] init];
                    cf.card = card;
                    [cfs addObject:cf];
                }
                [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pagingView reloadPageAtPageIndex:pageIndex];
                });
            } failure:^(NSError *error) {
            }];
        } else if ([channelItem.channelID isEqual:videoChannelID]) {
            [CardTool cardsWithParam:param channelID:channelItem.channelID success:^(NSArray *cards) {
                for (Card *card in cards) {
                    LPHomeVideoFrame *cf = [[LPHomeVideoFrame alloc] init];
                    cf.card = card;
                    [cfs addObject:cf];
                }
                [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pagingView reloadPageAtPageIndex:pageIndex];
                });
            } failure:^(NSError *error) {
                
            }];
 
        } else {
            [CardTool cardsWithParam:param channelID:channelItem.channelID success:^(NSArray *cards) {
                for (Card *card in cards) {
                    CardFrame *cf = [[CardFrame alloc] init];
                    cf.card = card;
                    [cfs addObject:cf];
                }
                [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pagingView reloadPageAtPageIndex:pageIndex];
                });
            } failure:^(NSError *error) {
                
            }];
        }
    } 
}

#pragma mark - 频道栏颜色变化
- (void)menuSelectedStatusChangedWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index
                                                 inSection:0];
    
    NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:index - 1
                                                 inSection:0];
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:index + 1
                                                         inSection:0];
    
    
    [self.menuView deselectItemAtIndexPath:previousIndexPath animated:NO];
    [self.menuView deselectItemAtIndexPath:nextIndexPath animated:NO];
    
    [self.menuView selectItemAtIndexPath:indexPath
                                animated:YES
                          scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
 
}

#pragma mark - LPagingViewPage delegate
- (void)page:(LPPagingViewPage *)page didSelectCellWithCardID:(NSManagedObjectID *)cardID cardFrame:(CardFrame *)cardFrame {
    
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Card *card = (Card *)[cdh.importContext existingObjectWithID:cardID error:nil];
    if ([card.rtype isEqual:@(4)]) {
        LPSpecialTopicHomeViewController *specialTopicVc = [[LPSpecialTopicHomeViewController alloc] init];
        specialTopicVc.tid = card.nid;
        [self.navigationController pushViewController:specialTopicVc animated:NO];
        
    } else if([card.rtype isEqual:@(3)]) {
        LPAdsDetailViewController *adsViewController = [[LPAdsDetailViewController alloc] init];
        adsViewController.publishURL = card.sourceSiteURL;
        [self.navigationController pushViewController:adsViewController animated:YES];
        
    } else if ([card.rtype isEqual:@(6)]) {
      // 视频跳转到视频频道播放
        LPVideoDetailViewController *videoDetailViewController = [[LPVideoDetailViewController alloc] init];
        videoDetailViewController.qidianChannel = YES;
        videoDetailViewController.card = card;
        [self.navigationController pushViewController:videoDetailViewController animated:NO];
        
    }
    else {
        LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
        detailVc.sourceViewController = homeSource;
        detailVc.cardID = cardID;
        detailVc.sourceImageURL = card.sourceSiteImageUrl;
        
        detailVc.isRead = card.isRead;
        if (!card.isRead) {
            [page updateCardFramesWithCardFrame:cardFrame];
            
        }
        detailVc.statusWindow = self.statusWindow;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

- (void)page:(LPPagingViewPage *)page didClickSearchImageView:(UIImageView *)imageView {
    LPSearchViewController *searchVc = [[LPSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVc animated:NO];
}

- (void)page:(LPPagingViewPage *)page updateCardFrames:(NSArray *)cardFrames {
    [self.channelItemDictionary setObject:cardFrames forKey:page.pageChannelName];
}

- (void)didClickReloadPage:(LPPagingViewPage *)page {
    [self loadMoreDataInPageAtPageIndex:self.pagingView.currentPageIndex];
}

#pragma mark - LPPagingViewConcernPage Delegate
- (void)concernPage:(LPPagingViewConcernPage *)concernPage didSelectCellWithCardID:(NSManagedObjectID *)cardID {
    // 视频
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Card *card = (Card *)[cdh.importContext existingObjectWithID:cardID error:nil];
    
    if ([card.rtype isEqual:@(6)]) {
        // 视频跳转到视频频道播放
        LPVideoDetailViewController *videoDetailViewController = [[LPVideoDetailViewController alloc] init];
        videoDetailViewController.qidianChannel = YES;
        videoDetailViewController.card = card;
        [self.navigationController pushViewController:videoDetailViewController animated:NO];
        
    } else {
        LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
        detailVc.sourceViewController = concernSource;
        detailVc.cardID = cardID;
        detailVc.statusWindow = self.statusWindow;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

- (void)concernPage:(LPPagingViewConcernPage *)concernPage didClickSearchImageView:(UIImageView *)imageView {
    LPSearchViewController *searchVc = [[LPSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVc animated:NO];
}

#pragma mark - videoPage Delegate
- (void)videoPage:(LPPagingViewVideoPage *)videoPage pushViewController:(LPVideoDetailViewController *)videoDetailController {
    [self.navigationController pushViewController:videoDetailController animated:NO];
}

- (void)videoPage:(LPPagingViewVideoPage *)videoPage card:(Card *)card {
    LPAdsDetailViewController *adsViewController = [[LPAdsDetailViewController alloc] init];
    adsViewController.publishURL = card.sourceSiteURL;
    [self.navigationController pushViewController:adsViewController animated:NO];
    
}




#pragma mark - 弹出删除提示
- (void)page:(LPPagingViewPage *)page didClickDeleteButtonWithCardFrame:(CardFrame *)cardFrame  deleteButton:(UIButton *)deleteButton {
    self.currentPage = page;
    self.currentCardFrame = cardFrame;
    
    self.deleteNid = [NSString stringWithFormat:@"%@", cardFrame.card.nid] ;
    
    UIView *blackBackgroundView = [[UIView alloc] init];
    blackBackgroundView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    blackBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

    [self.view addSubview:blackBackgroundView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlackbackgroundView:)];
    [blackBackgroundView addGestureRecognizer:tapGesture];
 
    self.blackBackgroundView = blackBackgroundView;
    
    CGRect deleteButtonFrame = [deleteButton.superview convertRect:deleteButton.frame toView:self.view];
    
    CGFloat centerYInPagingView = (ScreenHeight + HomeTopViewHeight) / 2;
    CGFloat deleteButtonY = deleteButtonFrame.origin.y;
    
    CGFloat imageViewW = 30.5f;
    CGFloat imageViewH = 13.5f;
    CGRect imageViewFrame;
    CGFloat imageViewX = CGRectGetMidX(deleteButtonFrame) - imageViewW;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    UIView *notInterestedView = [[UIView alloc] init];
    notInterestedView.backgroundColor = [UIColor whiteColor];
    notInterestedView.layer.cornerRadius = 10;
    
    CGFloat titleSize = 16;
    UILabel *notInterestedTitleLabel = [[UILabel alloc] init];
    notInterestedTitleLabel.text = @"请选择不感兴趣的原因:";
    notInterestedTitleLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
    notInterestedTitleLabel.font = [UIFont systemFontOfSize:titleSize];
    
    NSString *str = @"请";
    CGFloat notInterestedTitleLabelH = [str sizeWithFont:[UIFont systemFontOfSize:titleSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    
    CGFloat contentFontSize = 14;
    
    CGFloat buttonPadding = 10;
    CGFloat notInterestedContentH = [str sizeWithFont:[UIFont systemFontOfSize:contentFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height + buttonPadding;
    
    CGFloat notInterestedViewH = 20 + notInterestedTitleLabelH + 16 + 1 + 18 * 3 + notInterestedContentH * 2;
    CGFloat notInterestedViewX = BodyPadding;
    CGFloat notInterestedViewW = ScreenWidth - BodyPadding * 2;
    CGFloat notInterestedViewY;
    
    
    CGFloat paddingLeft = 20;
    // 不感兴趣标题
    notInterestedTitleLabel.frame = CGRectMake(paddingLeft, paddingLeft, notInterestedViewW - paddingLeft * 2, notInterestedTitleLabelH);
    [notInterestedView addSubview:notInterestedTitleLabel];
    
    // 分割线
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(paddingLeft, 16 + CGRectGetMaxY(notInterestedTitleLabel.frame), notInterestedViewW - paddingLeft * 2, 1)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:@"#e4e4e4"];
    [notInterestedView addSubview:seperatorView];
    
    // 不喜欢原因
    CGFloat firstRowY = CGRectGetMaxY(seperatorView.frame) + 18;
    
    NSString *notLikeStr = @"不喜欢";
    NSString *lowQualityStr = @"低质量";
    NSString *repeatStr = @"重复、旧闻";
    
   
    
    CGFloat notLikeButtonW = [notLikeStr sizeWithFont:[UIFont systemFontOfSize:contentFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + buttonPadding;
    CGFloat lowQualityButtonW = [lowQualityStr sizeWithFont:[UIFont systemFontOfSize:contentFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + buttonPadding ;
    CGFloat repeatButtonW = [repeatStr sizeWithFont:[UIFont systemFontOfSize:contentFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + buttonPadding;
    
    // 不喜欢
    UIButton *notLikeButton = [[UIButton alloc] initWithFrame:CGRectMake(paddingLeft, firstRowY, notLikeButtonW, notInterestedContentH)];
    notLikeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [notLikeButton setTitle:notLikeStr forState:UIControlStateNormal];
    notLikeButton.titleLabel.font = [UIFont systemFontOfSize:contentFontSize];
    [notLikeButton setTitleColor:[UIColor colorFromHexString:@"#666666"] forState:UIControlStateNormal];
    notLikeButton.layer.borderColor = [UIColor colorFromHexString:@"#e4e4e4"].CGColor;
    notLikeButton.layer.borderWidth = 0.5;
    notLikeButton.layer.cornerRadius = 6;
    notLikeButton.tag = 100;
    [notLikeButton addTarget:self action:@selector(deleteCurrentRow:) forControlEvents:UIControlEventTouchUpInside];
    notLikeButton.enlargedEdge = 5;
    [notInterestedView addSubview:notLikeButton];
    
    
    // 低质量
    UIButton *lowQualityButton = [[UIButton alloc] initWithFrame:CGRectMake(paddingLeft + CGRectGetMaxX(notLikeButton.frame), firstRowY, lowQualityButtonW, notInterestedContentH)];
    lowQualityButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [lowQualityButton setTitle:lowQualityStr forState:UIControlStateNormal];
    lowQualityButton.titleLabel.font = [UIFont systemFontOfSize:contentFontSize];
    [lowQualityButton setTitleColor:[UIColor colorFromHexString:@"#666666"] forState:UIControlStateNormal];
    lowQualityButton.layer.borderColor = [UIColor colorFromHexString:@"#e4e4e4"].CGColor;
    lowQualityButton.layer.borderWidth = 0.5;
    lowQualityButton.layer.cornerRadius = 6;
    [lowQualityButton addTarget:self action:@selector(deleteCurrentRow:) forControlEvents:UIControlEventTouchUpInside];
    lowQualityButton.enlargedEdge = 5;
    lowQualityButton.tag = 101;
    [notInterestedView addSubview:lowQualityButton];
    
    // 重复 旧闻
    UIButton *repeatButton = [[UIButton alloc] initWithFrame:CGRectMake(paddingLeft + CGRectGetMaxX(lowQualityButton.frame), firstRowY, repeatButtonW, notInterestedContentH)];
    repeatButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [repeatButton setTitle:repeatStr forState:UIControlStateNormal];
    repeatButton.titleLabel.font = [UIFont systemFontOfSize:contentFontSize];
    [repeatButton setTitleColor:[UIColor colorFromHexString:@"#666666"] forState:UIControlStateNormal];
    repeatButton.layer.borderColor = [UIColor colorFromHexString:@"#e4e4e4"].CGColor;
    repeatButton.layer.borderWidth = 0.5;
    repeatButton.layer.cornerRadius = 6;
    repeatButton.tag = 102;
    [repeatButton addTarget:self action:@selector(deleteCurrentRow:) forControlEvents:UIControlEventTouchUpInside];
    repeatButton.enlargedEdge = 5;
    [notInterestedView addSubview:repeatButton];
    
    CGFloat secondRowY = CGRectGetMaxY(notLikeButton.frame) + 18;
    
    // 来源
    NSString *sourceStr = [NSString stringWithFormat:@"来源: %@", cardFrame.card.sourceSiteName] ;
    CGFloat sourceButtonW = [sourceStr sizeWithFont:[UIFont systemFontOfSize:contentFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + buttonPadding;
    UIButton *sourceButton = [[UIButton alloc] initWithFrame:CGRectMake(paddingLeft, secondRowY, sourceButtonW, notInterestedContentH)];
    sourceButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [sourceButton setTitle:sourceStr forState:UIControlStateNormal];
    sourceButton.titleLabel.font = [UIFont systemFontOfSize:contentFontSize];
    [sourceButton setTitleColor:[UIColor colorFromHexString:@"#666666"] forState:UIControlStateNormal];
    sourceButton.layer.borderColor = [UIColor colorFromHexString:@"#e4e4e4"].CGColor;
    sourceButton.layer.borderWidth = 0.5;
    sourceButton.layer.cornerRadius = 6;
    [sourceButton addTarget:self action:@selector(deleteCurrentRow:) forControlEvents:UIControlEventTouchUpInside];
    sourceButton.enlargedEdge = 5;
    sourceButton.tag = 103;
    [notInterestedView addSubview:sourceButton];
    
    if (deleteButtonY < centerYInPagingView) {
        imageView.image = [UIImage imageNamed:@"不感兴趣向下"];
        imageViewFrame = CGRectMake(imageViewX, CGRectGetMaxY(deleteButtonFrame) + 2, imageViewW, imageViewH);
        notInterestedViewY = CGRectGetMaxY(imageViewFrame) - 1;
     
    } else {
        imageView.image = [UIImage imageNamed:@"不感兴趣向上"];
        imageViewFrame = CGRectMake(imageViewX, CGRectGetMinY(deleteButtonFrame) - imageViewH - 2, imageViewW, imageViewH);
        notInterestedViewY = CGRectGetMinY(imageViewFrame) + 1 - notInterestedViewH ;
    }
    imageView.frame = imageViewFrame;
    
    notInterestedView.frame = CGRectMake(notInterestedViewX, notInterestedViewY, notInterestedViewW, notInterestedViewH);
    
    [self.blackBackgroundView addSubview:imageView];
    [self.blackBackgroundView addSubview:notInterestedView];
}

- (void)tapBlackbackgroundView:(UITapGestureRecognizer *)tapGesture {
     [self.blackBackgroundView removeFromSuperview];
}

- (void)deleteCurrentRow:(UIButton *)button {
    [self.blackBackgroundView removeFromSuperview];
    
    NSString *deleteReason = @"0";
    switch (button.tag) {
            // 不喜欢
        case 100:
            deleteReason = @"1";
            break;
            // 低质量
        case 101:
            deleteReason = @"2";
            break;
            // 重复 旧闻
        case 102:
            deleteReason = @"3";
            break;
            // 来源
        case 103:
            deleteReason = @"4";
            break;
        default:
            break;
    }
    
    [CardTool postHateReasonWithType:deleteReason nid:self.deleteNid];
    [self.currentPage deleteRowAtIndexPath:self.currentCardFrame];
    [self deleteCardFromCoreData:self.currentCardFrame];
        
}

// 文章列表
- (void)page:(LPPagingViewPage *)page didTapListViewWithSourceName:(NSString *)sourceName sourceImage:(NSString *)sourceImageURL isAds:(BOOL)isAds{
    if (isAds) {
        LPAdsDetailViewController *adsViewController = [[LPAdsDetailViewController alloc] init];
        adsViewController.publishURL = sourceImageURL;
        [self.navigationController pushViewController:adsViewController animated:YES];
    } else {
        LPConcernDetailViewController *concernDetailViewController = [[LPConcernDetailViewController alloc] init];
        concernDetailViewController.sourceName = sourceName;
        concernDetailViewController.conpubFlag = @"0";
        concernDetailViewController.sourceImageURL = sourceImageURL;
        [self.navigationController pushViewController:concernDetailViewController animated:YES];
    }
}

// 文章列表
- (void)concernPage:(LPPagingViewConcernPage *)concernPage didTapListViewWithSourceName:(NSString *)sourceName {
    LPConcernDetailViewController *concernDetailViewController = [[LPConcernDetailViewController alloc] init];
    concernDetailViewController.sourceName = sourceName;
    concernDetailViewController.conpubFlag = @"0";
    [self.navigationController pushViewController:concernDetailViewController animated:YES];
}

#pragma mark - 删除本地新闻
- (void)deleteCardFromCoreData:(CardFrame *)cardFrame {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Card *card = (Card *)[cdh.importContext existingObjectWithID:cardFrame.card.objectID error:nil];
    [card setValue:@(1) forKey:@"isCardDeleted"];
    [Card updateCard:card];
}




@end
