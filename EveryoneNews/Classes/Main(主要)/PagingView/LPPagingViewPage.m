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

@interface LPPagingViewPage () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;

@property (nonatomic, assign) CGFloat contentOffsetY;
@end

@implementation LPPagingViewPage

- (NSMutableDictionary *)contentOffsetDictionary {
    if (_contentOffsetDictionary == nil) {
        _contentOffsetDictionary = [[NSMutableDictionary alloc] init];
    }
    return _contentOffsetDictionary;
}

- (void)prepareForReuse {
//    [self.tableView setContentOffset:CGPointZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor =  [UIColor colorFromHexString:@"#edefef"];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.showsVerticalScrollIndicator = NO;
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
}

- (void)setCardFrames:(NSMutableArray *)cardFrames {
    _cardFrames = cardFrames;
    [self.tableView reloadData];
}

#pragma mark - 自动加载最新数据
- (void)autotomaticLoadNewData {
    [self.tableView.header beginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.header endRefreshing];
    });
    
}

#pragma mark － 下拉刷新 如果超过24小时始终返回最新数据
- (void)loadNewData{
    if (self.cardFrames.count != 0) {
        CardFrame *cardFrame = self.cardFrames[0];
        Card *card = cardFrame.card;
        CardParam *param = [[CardParam alloc] init];
        param.type = HomeCardsFetchTypeNew;
        param.channelID = [NSString stringWithFormat:@"%@", card.channelId];
        param.count = @20;
        param.startTime = cardFrame.card.updateTime;
//        NSLog(@"%@", param.startTime);
        __weak typeof(self) weakSelf = self;
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        [CardTool cardsWithParam:param success:^(NSArray *cards) {
            if (cards.count > 0) {
                for (int i = cards.count; i > 0; i --) {
                    CardFrame *cardFrame = [[CardFrame alloc] init];
                    cardFrame.card = cards[i - 1];
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
            NSLog(@"failure!");
        }];
    }
}

- (void)showNewCount:(NSInteger)count {
    UILabel *label = [[UILabel alloc] init];
    [self insertSubview:label belowSubview:self];
    
    label.height = 30;
    if (iPhone6Plus) {
        label.height = 35;
    }
    label.x = 0;
    label.y = -15;
    label.width = ScreenWidth;
    
    label.backgroundColor = [UIColor colorFromHexString:@"#fafafa"];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:14];
    if (iPhone6Plus) {
        label.font = [UIFont systemFontOfSize:16];
    }
    label.alpha = 0.9;
    
    if (count) {
        label.text = [NSString stringWithFormat:@"有%d条更新", count];
    } else {
        label.text = @"已经是最新啦~";
    }
    
    [UIView animateWithDuration:0.8 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
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


#pragma mark - tableView  datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *cellIdentifier = @"cardCellIdentifier";
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




@end
