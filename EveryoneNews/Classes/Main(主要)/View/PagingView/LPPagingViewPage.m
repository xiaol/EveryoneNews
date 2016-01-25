//
//  LPPagingViewPage.m
//  EveryoneNews
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPPagingViewPage.h"
#import "UIView+LPReusePage.h"
#import "LPHomeViewCell.h"
#import "CardFrame.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "LPDiggerFooter.h"
#import "LPDiggerHeader.h"
#import "CardTool.h"
#import "CardParam.h"
#import "Card+CoreDataProperties.h"
#import "LPSearchViewController.h"

@interface LPPagingViewPage () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *searchView;

@end

@implementation LPPagingViewPage

- (void)prepareForReuse {
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        UIView *searchView = [[UIView alloc] initWithFrame: CGRectMake(BodyPadding, 0, ScreenWidth, TabBarHeight)];
        UIImageView *searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"首页搜索框"]];
        searchImageView.backgroundColor = [UIColor colorFromHexString:@"#edefef"];
        searchImageView.contentMode = UIViewContentModeScaleAspectFit;
        searchImageView.frame =  CGRectMake(BodyPadding, 0, ScreenWidth - 2 * BodyPadding, TabBarHeight);
        searchImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        tapGesture.delegate = self;
        [searchImageView addGestureRecognizer:tapGesture];
        [searchView addSubview:searchImageView];
        self.searchView = searchView;

        UITableView *tableView = [[UITableView alloc] init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor =  [UIColor colorFromHexString:@"#edefef"];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.tableHeaderView = searchView;
        [self addSubview:tableView];
        self.tableView = tableView;
        // 下拉刷新功能
        __weak typeof(self) weakSelf = self;
        self.tableView.header = [LPDiggerHeader headerWithRefreshingBlock:^{
            [weakSelf loadNewData];
        }];
        // 上拉加载更多
        self.tableView.footer = [LPDiggerFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
    
    }
    return self;
}

- (void)layoutSubviews {
    self.tableView.frame = self.bounds;
 
//    [self.tableView setContentOffset:CGPointMake(0, TabBarHeight)];
 
}

- (void)setCardFrames:(NSMutableArray *)cardFrames {
    _cardFrames = cardFrames;
    [self.tableView reloadData];
    
}

#pragma mark - 跳转到搜索栏
- (void)tapImageView:(UITapGestureRecognizer*)sender {
    UIImageView *imageView = (UIImageView *)sender.view;
    if ([self.delegate respondsToSelector:@selector(page:didClickSearchImageView:)]) {
        [self.delegate page:self didClickSearchImageView:imageView];
    }
}

#pragma mark - 自动加载最新数据
- (void)autotomaticLoadNewData {
    [self.tableView.header beginRefreshing];
}

#pragma mark － 下拉刷新 如果超过12小时始终返回最新数据
- (void)loadNewData{
    if (self.cardFrames.count != 0) {
        CardFrame *cardFrame = self.cardFrames[0];
        Card *card = cardFrame.card;
        CardParam *param = [[CardParam alloc] init];
        param.type = HomeCardsFetchTypeNew;
        param.channelID = [NSString stringWithFormat:@"%@", card.channelId];
        param.count = @20;
        param.startTime = cardFrame.card.updateTime;
        __weak typeof(self) weakSelf = self;
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        [CardTool cardsWithParam:param success:^(NSArray *cards) {
            if (cards.count > 0) {
            for (int i = 0; i < (int)cards.count; i ++) {
                CardFrame *cardFrame = [[CardFrame alloc] init];
                cardFrame.card = cards[i];
                [tempArray addObject:cardFrame];
            }
                NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                       NSMakeRange(0,[tempArray count])];
                [weakSelf.cardFrames insertObjects: tempArray atIndexes:indexes];
                [weakSelf.tableView reloadData];
            }
            [weakSelf showNewCount:tempArray.count];
            [weakSelf.tableView.header endRefreshing];
        } failure:^(NSError *error) {
            [weakSelf.tableView.header endRefreshing];
            [MBProgressHUD showError:@"网络连接中断"];
        }];
    } else {
     
        [self.tableView.header endRefreshing];
    }
}

- (void)showNewCount:(NSInteger)count {
    UILabel *label = [[UILabel alloc] init];
    [self insertSubview:label belowSubview:self];
    label.height = 30;
    label.x = 0;
    label.y = -15;
//    label.y =TabBarHeight  - label.height;
    label.width = ScreenWidth;
    
    label.backgroundColor = [UIColor colorFromHexString:@"#fafafa"];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorFromHexString:@"0087d1"];
    label.font = [UIFont systemFontOfSize:14];
    if (iPhone6Plus) {
        label.font = [UIFont systemFontOfSize:16];
    }
    label.alpha = 0.9;
    
    if (count) {
        label.text = [NSString stringWithFormat:@"已为您推荐%d条新内容", count];
    } else {
        label.text = @"已经是最新内容";
    }
    
    [UIView animateWithDuration:0.8 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, 15);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.8 animations:^{
                label.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        });
    }];
}
#pragma mark - 加载更多
- (void)loadMoreData {
    CardFrame *cardFrame = [self.cardFrames lastObject];
    Card *card = cardFrame.card;
    CardParam *param = [[CardParam alloc] init];
    param.channelID = [NSString stringWithFormat:@"%@", card.channelId];
    param.type = HomeCardsFetchTypeMore;
    param.count = @20;
    param.startTime = card.updateTime;
    
    NSMutableArray *tempCardFrames = self.cardFrames;
    [CardTool cardsWithParam:param success:^(NSArray *cards) {
        for (Card *card in cards) {
            CardFrame *cardFrame = [[CardFrame alloc] init];
            cardFrame.card = card;
            [tempCardFrames addObject:cardFrame];
        }
        self.cardFrames = tempCardFrames;
    
    [self.tableView.footer endRefreshing];
    if (!cards.count) {
        [self.tableView.footer noticeNoMoreData];
    }
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];

}


#pragma mark - tableView  datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = self.cellIdentifier;
    LPHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LPHomeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.cardFrame = self.cardFrames[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardFrame *cardFrame = self.cardFrames[indexPath.row];
    return cardFrame.cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CardFrame *cardFrame = self.cardFrames[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(page:didSelectCellWithCardID:)]) {
        [self.delegate page:self didSelectCellWithCardID:cardFrame.card.objectID];
    }
}

#pragma mark - scrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(page:didSaveOffsetY:)]) {
        offsetY = offsetY > TabBarHeight ? offsetY : TabBarHeight;
        [self.delegate page:self didSaveOffsetY:offsetY];
    }
}

#pragma mark - tableView contentOffsetY
- (void)scrollToOffsetY:(CGFloat)offsetY {
     [self.tableView setContentOffset:CGPointMake(0, offsetY)];
}

@end
