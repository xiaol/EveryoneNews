//
//  LPPagingViewVideoPage.m
//  EveryoneNews
//
//  Created by dongdan on 2017/1/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LPPagingViewVideoPage.h"
#import "LPDiggerFooter.h"
#import "LPDiggerHeader.h"
#import "LPHomeVideoFrame.h"
#import "Card+Create.h"
#import "CardFrame.h"
#import "Card+CoreDataProperties.h"
#import "CardTool.h"
#import "CardParam.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "LPHomeVideoCell.h"
#import "LPPlayerView.h"
#import "LPPlayerControlView.h"
#import "LPPlayerModel.h"
#import "LPVideoDetailViewController.h"
#import "LPAdsDetailViewController.h"


static NSString *cellIdentifier = @"cellIdentifier";
@interface LPPagingViewVideoPage() <UITableViewDataSource, UITableViewDelegate, LPPlayerDelegate, LPHomeVideoCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) LPPlayerView *playerView;
@property (nonatomic, strong) LPPlayerControlView *controlView;
@property (nonatomic, strong) NSMutableArray *adsMutableArray;

@end


@implementation LPPagingViewVideoPage


@synthesize delegate = _delegate, cardFrames = _cardFrames, offset = _offset;

#pragma mark - 懒加载
- (NSMutableArray *)adsMutableArray {
    if (!_adsMutableArray) {
        _adsMutableArray = [NSMutableArray array];
    }
    return _adsMutableArray;
}

- (LPPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[LPPlayerControlView alloc] init];
    }
    return _controlView;
}

- (LPPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [LPPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
    }
    return _playerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat searchViewHeight = 35;
        UITableView *tableView = [[UITableView alloc] init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor =  [UIColor colorFromHexString:LPColor9];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.scrollsToTop = NO;
        tableView.hidden = YES;
        [self addSubview:tableView];
        self.tableView = tableView;
        
        UILabel *label = [[UILabel alloc] init];
        label.hidden = YES;
        label.height = searchViewHeight;
        label.x = 0;
        label.y = -15;
        label.width = ScreenWidth;
        
        label.backgroundColor = [UIColor colorFromHexString:LPColor23];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorFromHexString:LPColor15];
        label.font = [UIFont systemFontOfSize:14];
        if (iPhone6Plus) {
            label.font = [UIFont systemFontOfSize:16];
        }
        label.alpha = 0.9;
        [self addSubview:label];
        self.promptLabel = label;
        
        // 下拉刷新功能
        __weak typeof(self) weakSelf = self;
        self.tableView.mj_header = [LPDiggerHeader headerWithRefreshingBlock:^{
            [weakSelf loadNewData];
        }];
        // 上拉加载更多
        self.tableView.mj_footer = [LPDiggerFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
    }
    return self;
}

#pragma mark - 下拉刷新
- (void)loadNewData{
    if ([self.delegate respondsToSelector:@selector(homeListRefreshData)]) {
        [(id<LPPagingViewVideoPageDelegate>)self.delegate homeListRefreshData];
    }
    
    if (self.cardFrames.count != 0) {
        LPHomeVideoFrame *cardFrame = self.cardFrames[0];
        Card *card = cardFrame.card;
        CardParam *param = [[CardParam alloc] init];
        param.type = HomeCardsFetchTypeNew;
        param.channelID = [NSString stringWithFormat:@"%@", card.channelId];
        param.count = @20;
        param.startTime = card.updateTime;
        param.nid = [NSString stringWithFormat:@"%@",card.nid];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        [CardTool cardsWithParam:param channelID: param.channelID success:^(NSArray *cards) {
            if (cards.count > 0) {
                for (int i = 0; i < (int)cards.count; i ++) {
                    LPHomeVideoFrame *cardFrame = [[LPHomeVideoFrame alloc] init];
                    cardFrame.card = cards[i];
                    [tempArray addObject:cardFrame];
                }
                NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                       NSMakeRange(0,[tempArray count])];
                [self.cardFrames insertObjects: tempArray atIndexes:indexes];
                
                [self.tableView reloadData];
            }
            
            [self showNewCount:tempArray.count];
            [self.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:@"网络连接中断"];
        }];
    } else {
        [self.tableView.mj_header endRefreshing];
    }
}

#pragma mark - 加载更多
- (void)loadMoreData {
    LPHomeVideoFrame *cardFrame = [self.cardFrames lastObject];
    Card *card = cardFrame.card;
    CardParam *param = [[CardParam alloc] init];
    param.channelID = [NSString stringWithFormat:@"%@", card.channelId];
    param.type = HomeCardsFetchTypeMore;
    param.count = @20;
    param.startTime = card.updateTime;
    param.nid = [NSString stringWithFormat:@"%@",card.nid];
    NSMutableArray *tempCardFrames = self.cardFrames;
    [CardTool cardsWithParam:param  channelID:param.channelID success:^(NSArray *cards) {
        for (Card *card in cards) {
            LPHomeVideoFrame *cardFrame = [[LPHomeVideoFrame alloc] init];
            cardFrame.card = card;
            [tempCardFrames addObject:cardFrame];
        }
        self.cardFrames = tempCardFrames;
        [self.tableView.mj_footer endRefreshing];
        if (!cards.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
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

#pragma mark - 自动加载最新数据
- (void)autotomaticLoadNewData {
    if (self.cardFrames.count > 0) {
        [self.tableView.mj_header beginRefreshing];
    }
    
}

- (id<LPPagingViewVideoPageDelegate>)delegate {
    return (id<LPPagingViewVideoPageDelegate>)_delegate;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (void)setCardFrames:(NSMutableArray *)cardFrames {
    
    _cardFrames = cardFrames;
    if (cardFrames.count > 0) {
        self.tableView.hidden = NO;
        
    } else {
        self.tableView.hidden = YES;
    }
    [self.tableView reloadData];
}

#pragma mark - tableView  datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LPHomeVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LPHomeVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];;
    }
    cell.videoFrame = self.cardFrames[indexPath.row];
    cell.delegate = self;
  
    Card *card = cell.videoFrame.card;
    
    __block LPHomeVideoCell *weakCell = cell;
    __weak typeof(self) weakSelf = self;
    __block NSIndexPath *weakIndexPath = indexPath;
    
    cell.playButtonBlock = ^(UIButton *button) {
        LPPlayerModel *playerModel = [[LPPlayerModel alloc] init];
        playerModel.title = card.title;
        playerModel.videoURL = [NSURL URLWithString:card.videoUrl] ;
        playerModel.placeHolderImageURLString = card.thumbnail;
        playerModel.tableView = weakSelf.tableView;
        playerModel.indexPath  = weakIndexPath;
        playerModel.parentView = weakCell.coverImageView;
        
        [weakSelf.playerView playerControlView:weakSelf.controlView playerModel:playerModel];
        [weakSelf.playerView resetToPlayNewVideo:playerModel];
        
        
    };
    if ([card.rtype integerValue] != adNewsType) {
        
        cell.coverImageBlock = ^(UIImageView *imageView) {
            LPPlayerModel *playerModel = [[LPPlayerModel alloc] init];
            playerModel.title = card.title;
            playerModel.videoURL = [NSURL URLWithString:card.videoUrl];
            playerModel.placeHolderImageURLString = card.thumbnail;
            playerModel.tableView = weakSelf.tableView;
            playerModel.indexPath  = weakIndexPath;
            playerModel.parentView = weakCell.coverImageView;
            [weakSelf.playerView playerControlView:weakSelf.controlView playerModel:playerModel];
            [weakSelf.playerView resetToPlayNewVideo:playerModel];
        };
    }
    
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(homeListDidScroll)]) {
        [(id<LPPagingViewVideoPageDelegate>)self.delegate homeListDidScroll];
    }
    UITableView *tableView = (UITableView *)scrollView;
    for (LPHomeVideoCell *cell in tableView.visibleCells) {
        Card *card = cell.videoFrame.card;
        if ([card.rtype integerValue] == adNewsType) {
            if (![self.adsMutableArray containsObject:card.title]) {
                //  请求广告接口
                [self.adsMutableArray addObject:card.title];
                [self getAdsWithAdImpression:card.adimpression];
                [self postWeatherAdsStatistics];
            }
        }
    }
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPHomeVideoFrame *videoFrame = self.cardFrames[indexPath.row];
    return videoFrame.cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LPHomeVideoCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    LPHomeVideoFrame *videoFrame = self.cardFrames[indexPath.row];
    Card *card = videoFrame.card;
    if ([card.rtype integerValue] == adNewsType) {
        if ([self.delegate respondsToSelector:@selector(videoPage:card:)]) {
            [(id<LPPagingViewVideoPageDelegate>)self.delegate videoPage:self card:card];
        }
    } else {
        LPVideoDetailViewController *videoDetailController = [[LPVideoDetailViewController alloc] init];
        videoDetailController.card = card;
        // 当前正在播放
        if (self.playerView.state == LPPlayerStatePlaying) {
            [self.playerView pause];
            videoDetailController.playerView = self.playerView;
            videoDetailController.isPlaying = YES;
            videoDetailController.coverImageView = cell.coverImageView;
        }
        
        videoDetailController.videoDetailControllerBlock = ^() {
            [self.playerView play];
        };
        if ([self.delegate respondsToSelector:@selector(videoPage:pushViewController:)]) {
            [(id<LPPagingViewVideoPageDelegate>)self.delegate videoPage:self pushViewController:videoDetailController];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(pushDetailViewController)]) {
        [(id<LPPagingViewVideoPageDelegate>)self.delegate pushDetailViewController];
    }
    
}

- (void)cell:(LPHomeVideoCell *)cell didTapImageViewWithCard:(Card *)card {
    if ([self.delegate respondsToSelector:@selector(videoPage:card:)]) {
        [(id<LPPagingViewVideoPageDelegate>)self.delegate videoPage:self card:card];
    }
}


- (void)tapStatusBarScrollToTop {
    
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (void)setOffset:(CGPoint)offset {
    _offset = offset;
    [self.tableView setContentOffset:offset];
}

- (CGPoint)offset {
    return self.tableView.contentOffset;
}

#pragma mark - 广告提交到后台
- (void)getAdsWithAdImpression:(NSString *)adImpression {
    if (adImpression.length > 0) {
        [CardTool getAdsImpression:adImpression];
    }
}

#pragma mark - 黄历天气
- (void)postWeatherAdsStatistics {
    [CardTool postWeatherAds];
}



@end
