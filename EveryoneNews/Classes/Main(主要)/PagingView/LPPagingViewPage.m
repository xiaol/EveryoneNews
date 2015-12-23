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

@end

@implementation LPPagingViewPage
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.backgroundColor =  [UIColor colorFromHexString:@"#edefef"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        [self addSubview:tableView];
         self.tableView = tableView;
    }
    return self;
}

- (void)layoutSubviews {
    self.tableView.frame = self.bounds;
}

- (void)setCardFrames:(NSMutableArray *)cardFrames {
    _cardFrames = cardFrames;
}

//- (void)refreshTableView {
//   
//    [self.tableView setNeedsDisplay];
//}

#pragma - mark 下拉刷新
//- (void)loadNewDataWithCount{
////    NSLog(@"index--%@", self.selectedChannelID);
//    if (self.cardFrames.count == 0) {
//        CardParam *param = [[CardParam alloc] init];
//        param.type = HomeCardsFetchTypeMore;
//        param.channelID = self.selectedChannelID;
//        param.count = @20;
////        NSLog(@"starttime－－－%@", param.startTime);
////        NSLog(@"current time------%@",[NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)]);
//         __weak typeof(self) weakSelf = self;
//        [CardTool cardsWithParam:param success:^(NSArray *cards) {
//            for (Card *card in cards) {
//                LPHomeViewFrame *homeViewFrame = [[LPHomeViewFrame alloc] init];
//                homeViewFrame.card = card;
//                [weakSelf.cardFrames addObject:homeViewFrame];
//               // NSLog(@"%@", card.title);
//            }
//            [weakSelf.tableView reloadData];
//            [weakSelf.tableView.header endRefreshing];
//             weakSelf.tableView.footer = [LPDiggerFooter footerWithRefreshingBlock:^{
//            [weakSelf loadMoreDataWithCount];
//            }];
//        } failure:^(NSError *error) {
//            [weakSelf.tableView.header endRefreshing];
//            NSLog(@"failure!");
//        }];
//    } else {
//        LPHomeViewFrame *homeViewFrame = self.cardFrames[0];
//        CardParam *param = [[CardParam alloc] init];
//        param.type = HomeCardsFetchTypeNew;
//        param.channelID = self.selectedChannelID;
//        param.count = @20;
//        param.startTime = homeViewFrame.card.updateTime;
//        __weak typeof(self) weakSelf = self;
//        [CardTool cardsWithParam:param success:^(NSArray *cards) {
//            for (Card *card in cards) {
//                LPHomeViewFrame *homeViewFrame = [[LPHomeViewFrame alloc] init];
//                homeViewFrame.card = card;
//                [weakSelf.cardFrames addObject:homeViewFrame];
//                NSLog(@"%@", card.title);
//            }
//            [weakSelf.tableView reloadData];
//            [weakSelf.tableView.header endRefreshing];
//        } failure:^(NSError *error) {
//            [weakSelf.tableView.header endRefreshing];
//            NSLog(@"failure!");
//        }];
//    }
//}

//#pragma -mark 加载更多
//- (void)loadMoreDataWithCount {
//    if (self.cardFrames.count == 0) {
//        return;
//    }
//    __weak typeof(self) weakSelf = self;
//    LPHomeViewFrame *homeViewFrame = [self.cardFrames lastObject];
//    Card *card = homeViewFrame.card;
//    CardParam *param = [[CardParam alloc] init];
//    param.type = HomeCardsFetchTypeMore;
//    param.channelID = self.selectedChannelID;
//    param.count = @20;
//    param.startTime = card.updateTime;
//    NSLog(@"%@", card.updateTime);
//    [CardTool cardsWithParam:param success:^(NSArray *cards) {
//        for (Card *card in cards) {
//            LPHomeViewFrame *homeViewFrame = [[LPHomeViewFrame alloc] init];
//            homeViewFrame.card = card;
//            [weakSelf.cardFrames addObject:homeViewFrame];
////            NSLog(@"------------%@", card.title);
//        }
//        [self.tableView reloadData];
//        [self.tableView.footer endRefreshing];
//        if (!cards.count) {
//            [self.tableView.footer noticeNoMoreData];
//        }
//    } failure:^(NSError *error) {
//        [self.tableView.footer endRefreshing];
//        NSLog(@"failure!");
//    }];
//}
//- (void)prepareForReuse {
////    [_tableView setContentOffset:CGPointMake(0, 100)];
//}


#pragma -mark tableView  数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cardCellIdentifier";
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
