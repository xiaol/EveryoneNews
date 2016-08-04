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
#import "CardConcern.h"
#import "AccountTool.h"



#define debug 1
NSString *const reusePageID = @"reusePageID";
NSString *const reuseConcernPageID = @"reuseConcernPageID";

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
           // 如果本地数据存在则加载到内存中
           if (cards.count > 0) {
               if (![channelItem.channelID isEqualToString:focusChannelID]) {
                   for (Card *card in cards) {
                       CardFrame *cf = [[CardFrame alloc] init];
                       cf.card = card;
                       [cfs addObject:cf];
                   }
               } else {
                   // 关注
                   for (Card *card in cards) {
                       LPCardConcernFrame *cf = [[LPCardConcernFrame alloc] init];
                       cf.card = card;
                       [cfs addObject:cf];
                   }
               }
               [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
           }
           // 加载完数据后刷新页面
           if (i == self.selectedArray.count - 1) {
               [self.pagingView reloadData];
           }
        }];
        }
   
}

#pragma mark - 频道栏发生变化更新相应数据
- (void)handleDataAfterChannelItemChanged:(NSInteger)index {

        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *menuIndexPath = [NSIndexPath indexPathForItem:index
                                                             inSection:0];
            [self.menuView reloadData];
            [self.menuView selectItemAtIndexPath:menuIndexPath
                                        animated:NO
                                  scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        });
    
        // 添加频道时如果本地数据库中数据已经存在则直接加载到内存中
        for (int i = 0; i < self.selectedArray.count; i++) {
            
            LPChannelItem *channelItem = (LPChannelItem *)[self.selectedArray objectAtIndex:i];
            // 当前频道数据不存在
            if (!self.channelItemDictionary[channelItem.channelName]) {
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
                        if (![channelItem.channelID isEqualToString:focusChannelID]) {
                            for (Card *card in cards) {
                                CardFrame *cf = [[CardFrame alloc] init];
                                cf.card = card;
                                [cfs addObject:cf];
                            }
                        } else {
                            for (Card *card in cards) {
                                LPCardConcernFrame *cf = [[LPCardConcernFrame alloc] init];
                                cf.card = card;
                                [cfs addObject:cf];
                            }
                        }
                        
                        [self.channelItemDictionary setObject:cfs forKey:channelItem.channelName];
                    }
                    if (i == self.selectedArray.count - 1) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                          
                            
                            [self.pagingView reloadData];
                            [self.pagingView setCurrentPageIndex:index animated:NO];
                            [self loadMoreDataInPageAtPageIndex:index];
                        });
                    }
                }];
                
            } else {
                
                if (i == self.selectedArray.count - 1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.pagingView reloadData];
                        [self.pagingView setCurrentPageIndex:index animated:NO];
                        [self loadMoreDataInPageAtPageIndex:index];
                        
                    });
                }
            }
        }
}

#pragma mark - LPPagingView DataSource
- (NSInteger)numberOfPagesInPagingView:(LPPagingView *)pagingView {
    return self.selectedArray.count;
}

- (UIView *)pagingView:(LPPagingView *)pagingView pageForPageIndex:(NSInteger)pageIndex {
    
    LPChannelItem *channelItem = self.pageindexMapToChannelItemDictionary[@(pageIndex)];
    
    if (![channelItem.channelID isEqualToString:focusChannelID]) {
        LPPagingViewPage *page = (LPPagingViewPage *)[pagingView dequeueReusablePageWithIdentifier:reusePageID];
        page.delegate = self;
        page.cardFrames = self.channelItemDictionary[channelItem.channelName];
        
        if (page.cardFrames.count > 0 ) {
            page.contentLoadingView.hidden = YES;
        }
        
        page.cellIdentifier = self.cardCellIdentifierDictionary[@(pageIndex)];
        page.pageChannelName = channelItem.channelName;
        return page;
    } else {
        LPPagingViewConcernPage *page = (LPPagingViewConcernPage *)[pagingView dequeueReusablePageWithIdentifier:reuseConcernPageID];
        page.delegate = self;
        page.cellIdentifier = self.cardCellIdentifierDictionary[@(pageIndex)];
        page.pageChannelName = channelItem.channelName;
        page.cardFrames =  self.channelItemDictionary[channelItem.channelName];
        
        return page;
    }
 
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
    
    if (![channelItem.channelID isEqualToString:focusChannelID]) {
        LPPagingViewPage *page = (LPPagingViewPage *)[pagingView currentPage];
        if (page.cardFrames.count > 0) {
            [self hideLoadingView];
        } else {
            [self showLoadingView];
        }
        // 每隔5分钟执行自动刷新
        if (lastAccessDate != nil) {
            int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate] / 60;
            // 每5分钟做一次刷新操作
            if (interval > 5) {
                [page autotomaticLoadNewData];
                channelItem.lastAccessDate = currentDate;
            }
        }
    } else {
        LPPagingViewConcernPage *page = (LPPagingViewConcernPage *)[pagingView currentPage];
        // 每隔5分钟执行自动刷新
        if (lastAccessDate != nil) {
            int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate] / 60;
            // 每5分钟做一次刷新操作
            if (interval > 5) {
                [page autotomaticLoadNewData];
                channelItem.lastAccessDate = currentDate;
            }
        }

    }
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
}

#pragma mark - 首页显示正在加载提示
- (void)showLoadingView {
    LPPagingViewPage *page =  (LPPagingViewPage*)self.pagingView.currentPage;
    [page.animationImageView startAnimating];
    page.contentLoadingView.hidden = NO;
    page.reloadPage.hidden = YES;
  
}


#pragma mark - 首页隐藏正在加载提示
- (void)hideLoadingView {
    LPPagingViewPage *page =  (LPPagingViewPage*)self.pagingView.currentPage;
    [page.animationImageView stopAnimating];
    page.contentLoadingView.hidden = YES;
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
        // 本地没有数据
        if (cards.count == 0) {
            [self loadMoreDataInPageAtPageIndex:pageIndex];
        }
    }];
}

#pragma mark reloadPage Delegate
- (void)didClickReloadPage:(LPPagingViewPage *)page {
    [self channelItemDidAddToCoreData:self.pagingView.currentPageIndex];
}

#pragma mark - 加载更多
- (void)loadMoreDataInPageAtPageIndex:(NSInteger)pageIndex {
    LPChannelItem *channelItem = self.pageindexMapToChannelItemDictionary[@(pageIndex)];
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
            [self.pagingView reloadPageAtPageIndex:pageIndex];
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
            [self.pagingView reloadPageAtPageIndex:pageIndex];
            if (cfs.count > 0) {
                if (![channelItem.channelID isEqualToString:focusChannelID]) {
                    [self hideLoadingView];
                }
                
            }
            
        } failure:^(NSError *error) {

        }];
    }
}

#pragma mark - 选中菜单按钮状态变化
- (void)buttonSelectedStatusChangedWithIndex:(NSInteger)index {
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
- (void)page:(LPPagingViewPage *)page didSelectCellWithCardID:(NSManagedObjectID *)cardID cardFrame:(CardFrame *)cardFrame{
    LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
    detailVc.sourceViewController = homeSource;
    detailVc.cardID = cardID;
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Card *card = (Card *)[cdh.importContext existingObjectWithID:cardID error:nil];
    detailVc.isRead = card.isRead;
    if (!card.isRead) {
        [page updateCardFramesWithCardFrame:cardFrame];
  
    }
    detailVc.statusWindow = self.statusWindow;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)page:(LPPagingViewPage *)page didClickSearchImageView:(UIImageView *)imageView {
    LPSearchViewController *searchVc = [[LPSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVc animated:NO];
}

- (void)page:(LPPagingViewPage *)page didSaveOffsetY:(CGFloat)offsetY {
//    [self.pageContentOffsetDictionary setObject:@(offsetY) forKey:page.pageChannelName];
}

- (void)page:(LPPagingViewPage *)page updateCardFrames:(NSArray *)cardFrames {
    [self.channelItemDictionary setObject:cardFrames forKey:page.pageChannelName];
}

#pragma mark - LPPagingViewConcernPage Delegate
- (void)concernPage:(LPPagingViewConcernPage *)concernPage didSelectCellWithCardID:(NSManagedObjectID *)cardID {
    LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
    detailVc.sourceViewController = concernSource;
    detailVc.cardID = cardID;
    detailVc.statusWindow = self.statusWindow;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)concernPage:(LPPagingViewConcernPage *)concernPage didClickSearchImageView:(UIImageView *)imageView {
    LPSearchViewController *searchVc = [[LPSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVc animated:NO];
}

#pragma mark - 弹出删除提示框
- (void)page:(LPPagingViewPage *)page didClickDeleteButtonWithCardFrame:(CardFrame *)cardFrame  deleteButton:(UIButton *)deleteButton {
    self.currentPage = page;
    self.currentCardFrame = cardFrame;
    
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
    [notLikeButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    notLikeButton.layer.borderColor = [UIColor colorWithHexString:@"#e4e4e4"].CGColor;
    notLikeButton.layer.borderWidth = 0.5;
    notLikeButton.layer.cornerRadius = 6;
    [notLikeButton addTarget:self action:@selector(deleteCurrentRow:) forControlEvents:UIControlEventTouchUpInside];
    notLikeButton.enlargedEdge = 5;
    [notInterestedView addSubview:notLikeButton];
    
    
    // 低质量
    UIButton *lowQualityButton = [[UIButton alloc] initWithFrame:CGRectMake(paddingLeft + CGRectGetMaxX(notLikeButton.frame), firstRowY, lowQualityButtonW, notInterestedContentH)];
    lowQualityButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [lowQualityButton setTitle:lowQualityStr forState:UIControlStateNormal];
    lowQualityButton.titleLabel.font = [UIFont systemFontOfSize:contentFontSize];
    [lowQualityButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    lowQualityButton.layer.borderColor = [UIColor colorWithHexString:@"#e4e4e4"].CGColor;
    lowQualityButton.layer.borderWidth = 0.5;
    lowQualityButton.layer.cornerRadius = 6;
    [lowQualityButton addTarget:self action:@selector(deleteCurrentRow:) forControlEvents:UIControlEventTouchUpInside];
    lowQualityButton.enlargedEdge = 5;
    [notInterestedView addSubview:lowQualityButton];
    
    // 重复 旧闻
    UIButton *repeatButton = [[UIButton alloc] initWithFrame:CGRectMake(paddingLeft + CGRectGetMaxX(lowQualityButton.frame), firstRowY, repeatButtonW, notInterestedContentH)];
    repeatButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [repeatButton setTitle:repeatStr forState:UIControlStateNormal];
    repeatButton.titleLabel.font = [UIFont systemFontOfSize:contentFontSize];
    [repeatButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    repeatButton.layer.borderColor = [UIColor colorWithHexString:@"#e4e4e4"].CGColor;
    repeatButton.layer.borderWidth = 0.5;
    repeatButton.layer.cornerRadius = 6;
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
    [sourceButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    sourceButton.layer.borderColor = [UIColor colorWithHexString:@"#e4e4e4"].CGColor;
    sourceButton.layer.borderWidth = 0.5;
    sourceButton.layer.cornerRadius = 6;
    [sourceButton addTarget:self action:@selector(deleteCurrentRow:) forControlEvents:UIControlEventTouchUpInside];
    sourceButton.enlargedEdge = 5;
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
    [self.currentPage deleteRowAtIndexPath:self.currentCardFrame];
    [self deleteCardFromCoreData:self.currentCardFrame];
    
}

#pragma mark - 删除本地新闻
- (void)deleteCardFromCoreData:(CardFrame *)cardFrame {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Card *card = (Card *)[cdh.importContext existingObjectWithID:cardFrame.card.objectID error:nil];
    [card setValue:@(1) forKey:@"isCardDeleted"];
    [Card updateCard:card];
}

@end
