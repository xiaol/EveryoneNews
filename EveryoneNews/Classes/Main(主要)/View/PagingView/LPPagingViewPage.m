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
        CGFloat searchViewHeight = 35;
        CGFloat cornerRadius = 10;
        CGFloat paddingTop = 5;
        CGFloat searchImageH = 12;
        CGFloat searchImageW = 12;
        CGFloat searchLabelFontSize = 12;
        CGFloat searchViewPadding = 10;
        
        if (iPhone6Plus) {
            searchViewHeight = 42;
            cornerRadius = 15;
            searchImageH = 15;
            searchImageW = 15;
            searchLabelFontSize = 16;
            paddingTop = 6;
            searchViewPadding = 13;
        } else if (iPhone5) {
            searchViewHeight = 35;
            paddingTop = 5;
            cornerRadius = 12;
            searchViewPadding = 10;
            searchLabelFontSize = 12;
        } else if (iPhone6) {
            searchViewHeight = 47;
            paddingTop = 9;
            searchViewPadding = 10;
            searchLabelFontSize = LPFont4;
            cornerRadius = 14;
            searchImageH = 15;
            searchImageW = 15;
        }
        
        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, searchViewHeight)];
        searchView.backgroundColor = [UIColor colorFromHexString:@"#f0f0f0"];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(searchViewPadding, paddingTop, ScreenWidth - searchViewPadding * 2, searchViewHeight - paddingTop * 2);
        layer.backgroundColor =[UIColor whiteColor].CGColor;
        layer.cornerRadius = cornerRadius;
        layer.borderColor = [UIColor colorFromHexString:@"e4e4e4"].CGColor;
        layer.borderWidth = 0.5;
        [searchView.layer addSublayer:layer];
        
        UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(26, 0, searchImageW, searchImageH)];
        searchImageView.image = [UIImage imageNamed:@"首页搜索"];
        searchImageView.centerY = searchViewHeight / 2;
        [searchView addSubview:searchImageView];
        
        UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchImageView.frame) + 6, 0, 40, 29)];
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
        tableView.backgroundColor =  [UIColor colorFromHexString:LPColor9];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.scrollsToTop = NO;
              
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
        
        // 重新加载提示
        [self setupReloadPage];
        
        // 正在加载
        [self setupLoadingView];
    }
    return self;
}


#pragma mark - 重新加载
- (void)setupReloadPage {
    double topViewHeight = TabBarHeight + StatusBarHeight;
    if (iPhone6) {
        topViewHeight = 72;
    }
    // 重新加载提示框
    UIView *reloadPage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - topViewHeight)];
    reloadPage.backgroundColor = [UIColor colorFromHexString:LPColor9];
    reloadPage.userInteractionEnabled = YES;
    UITapGestureRecognizer *reloadTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReloadPage)];
    [reloadPage addGestureRecognizer:reloadTapGesture];
    reloadPage.hidden = YES;
    self.reloadPage = reloadPage;
    
    CGFloat reloadImageViewW = 107;
    CGFloat reloadImageViewH = 109;
    CGFloat reloadImageViewX = (ScreenWidth - reloadImageViewW) / 2;
    CGFloat reloadImageViewY = (ScreenHeight - reloadImageViewH) / 2 - topViewHeight;
    
    UIImageView *reloadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"重新加载"]];
    reloadImageView.frame = CGRectMake(reloadImageViewX, reloadImageViewY, reloadImageViewW, reloadImageViewH);
    [reloadPage addSubview:reloadImageView];
    
    NSString *reloadStr = @"点击屏幕重新加载";
    CGFloat fontSize = 12;
    CGSize size = [reloadStr sizeWithFont:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat labelW = size.width;
    CGFloat labelH = size.height;
    CGFloat labelX = (ScreenWidth - labelW) / 2;
    CGFloat labelY = CGRectGetMaxY(reloadImageView.frame) + 20;
    
    UILabel *reloadLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
    reloadLabel.text = reloadStr;
    reloadLabel.font = [UIFont systemFontOfSize:fontSize];
    reloadLabel.textColor = [UIColor colorFromHexString:LPColor4];
    [reloadPage addSubview:reloadLabel];
    
    [self addSubview:reloadPage];
}

#pragma mark - 正在加载
- (void)setupLoadingView {
    
    double topViewHeight = TabBarHeight + StatusBarHeight;
    if (iPhone6) {
        topViewHeight = 72;
    }
    UIView *contentLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - topViewHeight)];
    contentLoadingView.hidden = YES;
    // Load images
    NSArray *imageNames = @[@"xl_1", @"xl_2", @"xl_3", @"xl_4"];

    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }

    CGFloat animationImageViewW = 36;
    CGFloat animationImageViewH = 36;
    CGFloat animationImageViewX = (ScreenWidth - animationImageViewW) / 2;
    CGFloat animationImageViewY = (ScreenHeight - animationImageViewH) / 2 - topViewHeight;
    // Normal Animation
    UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(animationImageViewX, animationImageViewY, animationImageViewW , animationImageViewH)];
    animationImageView.animationImages = images;
    animationImageView.animationDuration = 1;
    [contentLoadingView addSubview:animationImageView];
     self.animationImageView = animationImageView;

    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(animationImageView.frame), ScreenWidth, 40)];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"正在努力加载...";
    loadingLabel.font = [UIFont systemFontOfSize:12];
    loadingLabel.textColor = [UIColor colorFromHexString:LPColor4];
    
    [contentLoadingView addSubview:loadingLabel];
    [self addSubview:contentLoadingView];
    
    self.contentLoadingView = contentLoadingView;
}

- (void)tapReloadPage {
    if ([self.delegate respondsToSelector:@selector(didClickReloadPage:)]) {
        [self.delegate didClickReloadPage:self];
    }
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
        if ([weakSelf.delegate respondsToSelector:@selector(page:didClickDeleteButtonWithCardFrame:deleteButton:)]) {
            [weakSelf.delegate page:weakSelf didClickDeleteButtonWithCardFrame:cell.cardFrame deleteButton:deleteButton];
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
- (void)deleteRowAtIndexPath:(CardFrame *)cardFrame {
    NSInteger index = [self.cardFrames indexOfObject:cardFrame];
    [self.cardFrames removeObject:cardFrame];
    [self.tableView  deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
    
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
//    } completion:^(BOOL finished) {
//        [self.tableView reloadData];
//    }];
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

- (void)tapStatusBarScrollToTop{
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

@end
