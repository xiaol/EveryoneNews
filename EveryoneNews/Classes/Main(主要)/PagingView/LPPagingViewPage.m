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
#import <objc/runtime.h>

@interface LPPagingViewPage () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LPPagingViewPage

- (void)prepareForReuse {
    [self.tableView setContentOffset:CGPointZero];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.backgroundColor =  [UIColor colorFromHexString:@"#edefef"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        [self addSubview:tableView];
        self.tableView = tableView;
        
        // 下拉刷新功能
        __weak typeof(self) weakSelf = self;
        self.tableView.header = [LPDiggerHeader headerWithRefreshingBlock:^{
            [weakSelf loadNewData];
        }];
        
        LPDiggerHeader *header = (LPDiggerHeader *)self.tableView.header;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header.autoChangeAlpha = YES;
        [self.tableView.header beginRefreshing];
        
        self.tableView.footer = [LPDiggerFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
    }
    return self;
}

- (void)layoutSubviews {
    self.tableView.frame = self.bounds;
}

- (void)setCardFrames:(NSMutableArray *)cardFrames {
    _cardFrames = cardFrames;
    [self.tableView reloadData];
}

#pragma - mark 下拉刷新
- (void)loadNewData{
//    NSLog(@"index--%@", self.selectedChannelID);
    if (self.cardFrames.count != 0) {
        CardFrame *cardFrame = self.cardFrames[0];
        Card *card = cardFrame.card;
        CardParam *param = [[CardParam alloc] init];
        param.type = HomeCardsFetchTypeNew;
        param.channelID = [NSString stringWithFormat:@"%@", card.channelId];
        param.count = @20;
        param.startTime = cardFrame.card.updateTime;
        NSMutableArray *newCardFrames = self.cardFrames;
        __weak typeof(self) weakSelf = self;
        [CardTool cardsWithParam:param success:^(NSArray *cards) {
            for (Card *card in cards) {
                CardFrame *cardFrame = [[CardFrame alloc] init];
                cardFrame.card = card;
                [weakSelf.cardFrames addObject:cardFrame];
//                NSLog(@"%@", card.title);
            }
            self.cardFrames = newCardFrames;
            [weakSelf.tableView.header endRefreshing];
        } failure:^(NSError *error) {
            [weakSelf.tableView.header endRefreshing];
            NSLog(@"failure!");
        }];
    }
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
    
    NSMutableArray *newCardFrames = self.cardFrames;
//    NSLog(@"%@", card.updateTime);
    [CardTool cardsWithParam:param success:^(NSArray *cards) {
        for (Card *card in cards) {
            CardFrame *cardFrame = [[CardFrame alloc] init];
            cardFrame.card = card;
            [newCardFrames addObject:cardFrame];
        }
        self.cardFrames = newCardFrames;
    
    [self.tableView.footer endRefreshing];
    if (!cards.count) {
        [self.tableView.footer noticeNoMoreData];
    }
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
        NSLog(@"failure!");
    }];

}


#pragma mark - tableView  数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *cellIdentifier = @"cardCellIdentifier";
    NSString *cellIdentifier = self.cellIdentifier;
//    NSLog(@"%@", cellIdentifier);
    LPHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LPHomeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.homeViewFrame = self.cardFrames[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardFrame *cardFrame = self.cardFrames[indexPath.row];
    return cardFrame.cellHeight;
}


#pragma mark - scroll view delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%s %.f", class_getName(scrollView.class), scrollView.contentOffset.y);
//}
// 

@end
