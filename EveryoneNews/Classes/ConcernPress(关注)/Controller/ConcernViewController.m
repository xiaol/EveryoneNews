//
//  ConcernViewController.m
//  EveryoneNews
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ConcernViewController.h"
#import "LPConcern.h"
#import "LPConcernPress.h"
#import "LPConcernPressFrame.h"
#import "LPConcernPressCell.h"
#import "LPHttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "LPDetailViewController.h"
#import "DiggerFooter.h"
#import "DiggerHeader.h"

@interface ConcernViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *concernPressFrames;
//@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, assign) CGFloat initialTableHeight;

@end

@implementation ConcernViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupHeaderView];
    [self setupTableView];
//    [self setupIndicatorView];
    [self setupRefreshView];
}

#pragma mark - setup subviews
- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorFromConcern:self.concern];
    headerView.x = 0;
    headerView.y = 0;
    headerView.width = ScreenWidth;
    if (iPhone4) {
        headerView.height = 55;
    } else if (iPhone6Plus) {
        headerView.height = 80;
    } else {
        headerView.height = 70;
    }
    [self.view addSubview:headerView];
    self.headerView = headerView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.x = 0;
    titleLabel.y = headerView.height / 2 - 20;
    titleLabel.width = ScreenWidth;
    titleLabel.height = 20;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.concern.channel_name;
    [headerView addSubview:titleLabel];
    [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToTop:)]];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.x = 0;
    subTitleLabel.y = CGRectGetMaxY(titleLabel.frame) + 5;
    subTitleLabel.width = ScreenWidth;
    subTitleLabel.height = 20;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.font = [UIFont systemFontOfSize:12];
    subTitleLabel.textColor = [UIColor whiteColor];
    subTitleLabel.text = self.concern.channel_des;
    [headerView addSubview:subTitleLabel];
}

- (void)scrollToTop:(UITapGestureRecognizer *)tap {
    CGPoint location = [tap locationInView:tap.view];
    if (location.y < self.headerView.height / 2) {
        if (self.concernPressFrames.count > 5) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.x = 0;
    tableView.y = self.headerView.height;
    tableView.width = ScreenWidth;
    tableView.height = ScreenHeight - tableView.y;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view insertSubview:tableView belowSubview:self.headerView];
    self.tableView = tableView;
}

- (void)setupRefreshView {
    __weak typeof(self) weakSelf = self;
    int refreshCount = 20;
    self.tableView.header = [DiggerHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDataWithCount:refreshCount];
    }];
    DiggerHeader *header = (DiggerHeader *)self.tableView.header;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    header.autoChangeAlpha = YES;
    [self.tableView.header beginRefreshing];
}

//- (void)setupIndicatorView {
//    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    indicator.center = self.view.center;
//    indicator.color = [UIColor lightGrayColor];
//    [self.view addSubview:indicator];
//    self.indicator = indicator;
//}

#pragma mark - lazy loading
- (NSMutableArray *)concernPressFrames {
    if (_concernPressFrames == nil) {
        _concernPressFrames = [NSMutableArray array];
    }
    return _concernPressFrames;
}

#pragma mark - load initial data
- (void)setupInitialData {
//    [self.indicator startAnimating];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"channelId"] = self.concern.channel_id;
    param[@"limit"] = @(30);
    __weak typeof(self) weakSelf = self;
    [LPHttpTool getWithURL:ConcernHomeUrl params:param success:^(id json) {
        self.concernPressFrames = [weakSelf concernPressFramesFromJSONArray:json];
        CGFloat sumHeight = 0.0;
        for (LPConcernPressFrame *frm in self.concernPressFrames) {
            sumHeight += frm.cellHeight;
        }
        self.initialTableHeight = sumHeight;
        [self.tableView reloadData];
//        [self.indicator stopAnimating];
//        [self setupRefreshView];
        [self.tableView.header endRefreshing];
        self.tableView.footer = [DiggerFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreDataWithCount:20];
        }];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:@"网络不给力:("];
    }];
}

#pragma mark - load new data
- (void)loadNewDataWithCount:(int)count {
    if (self.concernPressFrames.count == 0) {
        [self setupInitialData];
    } else {
        __weak typeof(self) weakSelf = self;
        LPConcernPressFrame *concernPressFrame = self.concernPressFrames[0];
        LPConcernPress *concernPress = concernPressFrame.concernPress;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"limit"] = @(count);
        param[@"time"] = concernPress.create_time;
        param[@"type"] = @(0);
        param[@"channel_id"] = concernPress.channel_id;
        param[@"news_id"] = concernPress.pressID;
        NSLog(@"%@, %@, %@, %@, %@", param[@"limit"], param[@"time"], param[@"type"], param[@"channel_id"], param[@"news_id"]);
        [LPHttpTool postWithURL:ConcernHomeRefreshingUrl params:param success:^(id json) {
            NSMutableArray *concernPressFrameArray = [weakSelf concernPressFramesFromJSONArray:json];
            NSLog(@"%ld", concernPressFrameArray.count);
            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray addObjectsFromArray:concernPressFrameArray];
            [tempArray addObjectsFromArray:self.concernPressFrames];
            self.concernPressFrames = tempArray;
            [self.tableView reloadData];
            
            [self showNewCount:concernPressFrameArray.count];
            
            [self.tableView.header endRefreshing];
        } failure:^(NSError *error) {
            [self.tableView.header endRefreshing];
            [MBProgressHUD showError:@"网络不给力:("];
        }];
    }
}

#pragma mark - load more data
- (void)loadMoreDataWithCount:(int)count {
    if (self.concernPressFrames.count == 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    LPConcernPressFrame *concernPressFrame = [self.concernPressFrames lastObject];
    LPConcernPress *concernPress = concernPressFrame.concernPress;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"limit"] = @(count);
    param[@"time"] = concernPress.create_time;
    param[@"type"] = @(1);
    param[@"channel_id"] = concernPress.channel_id;
    param[@"news_id"] = concernPress.pressID;
    [LPHttpTool postWithURL:ConcernHomeRefreshingUrl params:param success:^(id json) {
        NSMutableArray *concernPressFrameArray = [weakSelf concernPressFramesFromJSONArray:json];
        [self.concernPressFrames addObjectsFromArray:concernPressFrameArray];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        if (!concernPressFrameArray.count) {
            [self.tableView.footer noticeNoMoreData];
        }
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
        [MBProgressHUD showError:@"网络不给力:("];
    }];
}

#pragma mark - JSONs to data-frame models
- (NSMutableArray *)concernPressFramesFromJSONArray:(NSArray *)json {
    NSMutableArray *concernPressFrameArray = [NSMutableArray array];
    for (NSDictionary *dict in json) {
        LPConcernPress *concernPress = [LPConcernPress objectWithKeyValues:dict];
        concernPress.pressID = dict[@"id"];
        LPConcernPressFrame *concernPressFrame = [[LPConcernPressFrame alloc] init];
        // compute subviews' frames for each cell
        concernPressFrame.concernPress = concernPress;
        [concernPressFrameArray addObject:concernPressFrame];
    }
    return concernPressFrameArray;
}

#pragma mark - show new data's count
- (void)showNewCount:(NSUInteger)count {
    UILabel *label = [[UILabel alloc] init];
    [self.view insertSubview:label belowSubview:self.headerView];
    
    label.height = 30;
    if (iPhone6Plus) {
        label.height = 35;
    }
    label.x = 0;
    label.width = ScreenWidth;
    label.y = self.headerView.height - label.height;
    
    label.backgroundColor = [UIColor colorFromHexString:@"#fafafa"];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorFromConcern:self.concern];
    label.font = [UIFont systemFontOfSize:14];
    if (iPhone6Plus) {
        label.font = [UIFont systemFontOfSize:16];
    }
    label.alpha = 0.9;
    
    if (count) {
        label.text = [NSString stringWithFormat:@"有%ld条更新", count];
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.concernPressFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPConcernPressCell *cell = [LPConcernPressCell cellWithTableView:tableView];
    cell.concernPressFrame = self.concernPressFrames[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPConcernPressFrame *concernPressFrame = self.concernPressFrames[indexPath.row];
    return concernPressFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LPConcernPressFrame *frm = self.concernPressFrames[indexPath.row];
    LPConcernPress *concernPress = frm.concernPress;
    LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
    detailVc.concernPress = concernPress;
    detailVc.concern = self.concern;    
    [self.navigationController pushViewController:detailVc animated:YES];
}

@end
