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
#import "CoreDataHelper.h"
#import "Card.h"
#import "CardImage.h"


@interface LPPagingViewPage () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, LPHomeViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *searchView;

@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) UIView *blackBackgroundView;

@end

@implementation LPPagingViewPage

- (void)prepareForReuse {
    self.searchView.hidden = YES;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        CGFloat searchViewHeight = 40;
        CGFloat cornerRadius = 10;
        CGFloat paddingTop = 9;
        CGFloat searchImageH = 12;
        CGFloat searchImageW = 12;
        CGFloat searchLabelFontSize = 13;
        CGFloat searchViewPadding = 9;
        
        if (iPhone6Plus) {
            searchViewHeight = 42;
            cornerRadius = 15;
            searchImageH = 15;
            searchImageW = 15;
            searchLabelFontSize = 16;
            paddingTop = 6;
            searchViewPadding = 13;
        }
        
        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, searchViewHeight)];
        searchView.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(searchViewPadding, paddingTop, ScreenWidth - searchViewPadding * 2, searchViewHeight - paddingTop * 2);
        layer.backgroundColor =[UIColor whiteColor].CGColor;
        layer.cornerRadius = cornerRadius;
        layer.borderColor = [UIColor colorFromHexString:@"e4e4e4"].CGColor;
        layer.borderWidth = 0.5;
        [searchView.layer addSublayer:layer];
        
        UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 0, searchImageW, searchImageH)];
        searchImageView.image = [UIImage imageNamed:@"首页搜索"];
        searchImageView.centerY = searchViewHeight / 2;
        [searchView addSubview:searchImageView];
        
        UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchImageView.frame) + 7, 0, 40, 29)];
        searchLabel.text = @"搜索";
        searchLabel.textAlignment = NSTextAlignmentLeft;
        searchLabel.textColor = [UIColor colorFromHexString:@"#cacaca"];
        searchLabel.font = [UIFont systemFontOfSize:searchLabelFontSize];
        searchLabel.centerY = searchViewHeight / 2;
        [searchView addSubview:searchLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        tapGesture.delegate = self;
        [searchView addGestureRecognizer:tapGesture];
        searchView.hidden = YES;
        self.searchView = searchView;
        
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, searchViewHeight - 0.5, ScreenWidth, 0.5)];
        seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
        [searchView addSubview:seperatorView];
        
        
        UITableView *tableView = [[UITableView alloc] init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor =  [UIColor colorFromHexString:@"#f6f6f6"];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:tableView];
         self.tableView = tableView;
        
        UILabel *label = [[UILabel alloc] init];
        label.hidden = YES;
        label.height = searchViewHeight;
        label.x = 0;
        label.y = -15;
        label.width = ScreenWidth;
        
        label.backgroundColor = [UIColor colorFromHexString:@"#fafafa"];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorFromHexString:@"0087d1"];
        label.font = [UIFont systemFontOfSize:14];
        if (iPhone6Plus) {
            label.font = [UIFont systemFontOfSize:16];
        }
        label.alpha = 0.9;
        [self addSubview:label];
        self.promptLabel = label;
        
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
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    self.tableView.tableHeaderView = self.searchView;
}

- (void)setCardFrames:(NSMutableArray *)cardFrames {
    _cardFrames = cardFrames;
    [self.tableView reloadData];
    if (cardFrames.count > 0) {
        self.searchView.hidden = NO;
    }
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
    // 隐藏上次看到位置的提示按钮
    for (CardFrame *cardFrame in self.cardFrames) {
        Card *card = cardFrame.card;
        if (!cardFrame.isTipButtonHidden) {
            [cardFrame setCard:card tipButtonHidden:YES];
            break;
        }
    }
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
        [CardTool cardsWithParam:param channelID: param.channelID success:^(NSArray *cards) {
            
            if (cards.count > 0) {
                
            [cardFrame setCard:card tipButtonHidden:NO];
                
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

    self.promptLabel.hidden = NO;
    if (count) {
        self.promptLabel.text = [NSString stringWithFormat:@"已为您推荐%ld条新内容", (long)count];
    } else {
        self.promptLabel.text = @"已经是最新内容";
    }
    [UIView animateWithDuration:0.4 animations:^{
        self.promptLabel.transform = CGAffineTransformMakeTranslation(0, 15);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4 animations:^{
                self.promptLabel.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.promptLabel.hidden = YES;
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
        [CardTool cardsWithParam:param  channelID:param.channelID success:^(NSArray *cards) {
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
    cell.delegate = self;
    if (cell == nil) {
        cell = [[LPHomeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.cardFrame = self.cardFrames[indexPath.row];
    
    
    __weak typeof(self) weakSelf = self;
    [cell didClickTipButtonBlock:^() {
        [weakSelf autotomaticLoadNewData];
        [weakSelf loadNewData];
    }];
    
    [cell didClickDeleteButtonBlock:^(UIButton *deleteButton) {
        if ([self.delegate respondsToSelector:@selector(page:didClickDeleteButtonWithCardFrame:deleteButton:indexPath:)]) {
            [self.delegate page:self didClickDeleteButtonWithCardFrame:cell.cardFrame deleteButton:deleteButton indexPath:indexPath];
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardFrame *cardFrame = self.cardFrames[indexPath.row];
    
    return cardFrame.cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CardFrame *cardFrame = self.cardFrames[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(page:didSelectCellWithCardID:cardFrame:)]) {
        [self.delegate page:self didSelectCellWithCardID:cardFrame.card.objectID cardFrame:cardFrame];
    }
}


#pragma mark - 删除某行数据
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath cardFrame:(CardFrame *)cardFrame {
    [self.cardFrames removeObject:cardFrame];
    [UIView animateWithDuration:0.5 animations:^{
        [self.tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
    }];
}

- (void)updateCardFramesWithCardFrame:(CardFrame *)cardFrame {
    if ([self.cardFrames containsObject:cardFrame]) {
        cardFrame.card.isRead = @(1);
        [self.cardFrames replaceObjectAtIndex:[self.cardFrames indexOfObject:cardFrame] withObject:cardFrame];
        [self.tableView reloadData];
    }
   
}

#pragma mark - 刷新主页面
- (void)tableViewReloadData {
    [self.tableView reloadData];
}

@end
