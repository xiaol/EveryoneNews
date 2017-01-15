//
//  LPConcernDetailViewController.m
//  EveryoneNews
//
//  Created by dongdan on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPConcernDetailViewController.h"
#import "LPConcernCardTableViewCell.h"
#import "LPConcernIndroduceTableViewCell.h"
#import "LPConcernCardFrame.h"
#import "LPConcernIntroduce.h"
#import "LPConcernCard.h"
#import "LPBottomShareView.h"
#import "LPDetailChangeFontSizeView.h"
#import "LPFontSizeManager.h"
#import "MBProgressHUD+MJ.h"
#import "LPHttpTool.h"
#import "LPDiggerFooter.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "LPDetailTipView.h"
#import "Card+Create.h"
#import "LPDetailViewController.h"
#import "CoreDataHelper.h"
#import "LPFontSize.h"
#import "LPLoadingView.h"
#import "UIImageView+WebCache.h"
#import "LPVideoDetailViewController.h"


static NSString *introduceCellIdentifier = @"introduceCellIdentifier";
static NSString *contentCellIdentifier = @"contentCellIdentifier";
const static CGFloat changeFontSizeViewH = 150;

@interface LPConcernDetailViewController() <UITableViewDelegate, UITableViewDataSource, LPBottomShareViewDelegate, LPDetailChangeFontSizeViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NSMutableArray *concernCardFrames;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, assign) CGFloat lastContentOffsetY;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) LPBottomShareView *bottomShareView;
@property (nonatomic, strong)  UIView *detailBackgroundView;
@property (nonatomic, strong)  LPDetailChangeFontSizeView *changeFontSizeView;
// 分享url
@property (nonatomic, copy) NSString *shareURL;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareImageURL;
@property (nonatomic, strong) UIButton *concernButton;
// 正在加载提示
@property (nonatomic, strong) LPLoadingView *loadingView;


@end

@implementation LPConcernDetailViewController


#pragma mark - 懒加载
- (NSMutableArray *)concernCardFrames {
    if (!_concernCardFrames) {
        _concernCardFrames = [NSMutableArray array];
    }
    return _concernCardFrames;
}

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:LPColor9];
    [self setupData];
    [self setupTopView];
    [self setupTableView];
    [self setupLoadingView];
   
  
}

#pragma mark - setup Data 
- (void)setupData {
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/pbs", ServerUrlVersion2];
    NSMutableDictionary *concernParams = [NSMutableDictionary dictionary];
    concernParams[@"pname"] = self.sourceName;
    concernParams[@"info"] = @"0";
    NSString *startTime = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
    concernParams[@"tcr"] = startTime;
    NSString *encodedSourceName = [self.sourceName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.shareURL = [NSString stringWithFormat:@"http://deeporiginalx.com/dingyue.html?pname=%@",encodedSourceName];
    self.shareTitle = self.sourceName;
    
    [LPHttpTool getWithURL:url params:concernParams success:^(id json) {
        if ([json[@"code"] integerValue] == 2000) {
            [self.concernCardFrames removeAllObjects];
            NSMutableDictionary *dict = json[@"data"];
            NSMutableArray *bodyArray = [[NSMutableArray alloc] initWithArray:dict[@"news"]];
            for (NSDictionary *dict in bodyArray) {
                LPConcernCard *card = [[LPConcernCard alloc] init];
                card.nid = dict[@"nid"];
                card.title = dict[@"title"];
                card.sourceSiteName = dict[@"pname"];
                card.sourceSiteURL = dict[@"purl"];
                card.updateTime = [NSString stringWithFormat:@"%lld", (long long)([dict[@"ptime"] timestampWithDateFormat:@"YYYY-MM-dd HH:mm:ss"] * 1000)];
                card.channelId = @(99999);
                card.docId = dict[@"docid"];
                card.commentsCount = dict[@"comment"];
                card.cardImages = dict[@"imgs"];
                if ([dict[@"rtype"] integerValue] == videoNewsType) {
                card.rtype = [dict[@"rtype"] integerValue];
                card.thumbnail = dict[@"thumbnail"];
                card.duration = [dict[@"duration"] integerValue];
                }
                LPConcernCardFrame *cardFrame = [[LPConcernCardFrame alloc] init];
                cardFrame.card = card;
                [self.concernCardFrames addObject:cardFrame];
            }
            self.tableView.hidden = NO;
            [self.loadingView stopAnimating];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
 
}

#pragma mark - setupTopView 
- (void)setupTopView {
    
    // 分享，评论，添加按钮边距设置
    CGFloat topViewHeight = TabBarHeight + StatusBarHeight;
    if (iPhone6) {
        topViewHeight = 72;
    }
    CGFloat padding = 15;
    CGFloat returnButtonWidth = 13;
    CGFloat returnButtonHeight = 22;
    
    if (iPhone6Plus) {
        returnButtonWidth = 12;
        returnButtonHeight = 21;
    }
    CGFloat shareButtonW = 25;
    CGFloat shareButtonH = 5;
    CGFloat shareButtonX = ScreenWidth - padding - shareButtonW;
    
    CGFloat returnButtonPaddingTop = (topViewHeight - returnButtonHeight + StatusBarHeight) / 2;
    CGFloat shareButtonY =  (topViewHeight - shareButtonH + StatusBarHeight) / 2.0f;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, ScreenWidth, topViewHeight)];
    topView.backgroundColor = [UIColor colorFromHexString:LPColor29];
    [self.view addSubview:topView];
    
    // 返回button
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(padding, returnButtonPaddingTop, returnButtonWidth, returnButtonHeight)];
    [backBtn setBackgroundImage:[UIImage oddityImage:@"video_back"] forState:UIControlStateNormal];
    backBtn.enlargedEdge = 15;
    [backBtn addTarget:self action:@selector(topViewBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
//
    // 详情页右上角分享
//    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(shareButtonX, shareButtonY , shareButtonW, shareButtonH)];
//    [shareBtn setBackgroundImage:[UIImage oddityImage:@"详情页右上分享"] forState:UIControlStateNormal];
//    shareBtn.enlargedEdge = 15;
//    [shareBtn addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [topView addSubview:shareBtn];
//
//    UIButton *concernButton = [[UIButton alloc] init];
//    concernButton.layer.borderWidth = 1.0f;
//    concernButton.clipsToBounds = YES;
//
//    concernButton.titleLabel.font = [UIFont systemFontOfSize:LPFont5];
//    concernButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    NSString *concernStr = @"关注";
//    NSString *concernNotStr = @"取消";
//    CGFloat concernBtnW = [concernStr sizeWithFont:[UIFont systemFontOfSize:LPFont5] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width + 16;
//    CGFloat concernBtnH = [concernStr sizeWithFont:[UIFont systemFontOfSize:LPFont5] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height + 4;
//    concernButton.layer.cornerRadius = concernBtnH / 2.0f;
//    [concernButton setTitleColor:[UIColor colorFromHexString:@"#e71f19"] forState:UIControlStateNormal];
//    concernButton.layer.borderColor = [UIColor colorFromHexString:@"#e71f19"].CGColor;
//    if (![self.conpubFlag isEqualToString:@"1"]) {
//        [concernButton setTitle:concernStr forState:UIControlStateNormal];
//    } else {
//        [concernButton setTitle:concernNotStr forState:UIControlStateNormal];
//    }
//   
//    CGFloat concernBtnX =  CGRectGetMinX(shareBtn.frame) - 17 - concernBtnW;
//    CGFloat concernBtnY = 0;
//    concernButton.frame = CGRectMake(concernBtnX, concernBtnY, concernBtnW, concernBtnH);
//    concernButton.centerY = backBtn.centerY;
//    [concernButton addTarget:self action:@selector(concernButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    concernButton.enlargedEdge = 10;
//    [topView addSubview:concernButton];
//    self.concernButton = concernButton;
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    NSString *headerStr = self.sourceName;
    titleLabel.text = headerStr;
    titleLabel.font = [UIFont boldSystemFontOfSize:LPFont4];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.hidden = YES;
    
    CGFloat titleLabelW = 100;
    CGFloat titleLabelH = [headerStr sizeWithFont:[UIFont boldSystemFontOfSize:LPFont4] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat titleLabelX = (ScreenWidth - titleLabelW) / 2;
    CGFloat titleLabelY = (topViewHeight - titleLabelH + StatusBarHeight) / 2.0f;
    titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    [topView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, topViewHeight - 0.5, ScreenWidth, 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
    seperatorView.hidden = YES;
    [topView addSubview:seperatorView];
    self.seperatorView = seperatorView;
    
    self.topView = topView;

}

#pragma mark - 返回按钮
- (void)topViewBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)concernButtonClick {
    
    NSString *uid = [userDefaults objectForKey:@"uid"];
    // 必须进行编码操作
    NSString *pname = [self.sourceName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *addConcernUrl = [NSString stringWithFormat:@"%@/v2/ns/pbs/cocs?pname=%@&&uid=%@", ServerUrlVersion2, pname, uid];
    NSString *cancelConcernUrl = [NSString stringWithFormat:@"%@/v2/ns/pbs/cocs?pname=%@&&uid=%@", ServerUrlVersion2, pname, uid];
    NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
    
    NSString *concernStr = @"关注";
    NSString *concernNotStr = @"取消";
    
    if ([self.conpubFlag isEqualToString:@"0"]) {
        [LPHttpTool postAuthorizationJSONWithURL:addConcernUrl authorization:authorization params:nil success:^(id json) {
            if ([json[@"code"] integerValue] == 2000 ) {
                self.conpubFlag = @"1";
                [self.concernButton setTitle:concernNotStr forState:UIControlStateNormal];
                // 关注成功
                [self tipViewWithCondition:10];
                [noteCenter postNotificationName:LPAddConcernSourceNotification object:nil];
                [noteCenter postNotificationName:LPReloadAddConcernPageNotification object:nil];
                
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
        
    } else {

        [LPHttpTool deleteAuthorizationJSONWithURL:cancelConcernUrl authorization:authorization params:nil success:^(id json) {
            if ([json[@"code"] integerValue] == 2000 ) {
                self.conpubFlag = @"0";
                [self.concernButton setTitle:concernStr forState:UIControlStateNormal];
                [noteCenter postNotificationName:LPRemoveConcernSourceNotification object:nil];
                
                NSString *sourceName = self.sourceName;
                
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:sourceName,@"sourceName", nil];
                [noteCenter postNotificationName:LPReloadCancelConcernPageNotification object:nil userInfo:dict];
//                [Card cancelConcernCard:self.sourceName];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

#pragma mark - 提示信息
- (void)tipViewWithCondition:(NSInteger)condition {
    LPDetailTipView *tipView = [[LPDetailTipView alloc] initWithCondition:condition];
    [self.view addSubview:tipView];
    
    [UIView animateWithDuration:0.4f delay:0.8f options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         tipView.alpha = 0.2f;
                     } completion:^(BOOL finished) {
                         [tipView removeFromSuperview];
                     }];
}

#pragma mark - 分享按钮
- (void)shareButtonClick {
    
    UIView *detailBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    detailBackgroundView.backgroundColor = [UIColor blackColor];
    detailBackgroundView.alpha = 0.6;
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBackgroundView)];
    [detailBackgroundView addGestureRecognizer:tapGestureRecognizer];
    
    [self.view addSubview:detailBackgroundView];
    self.detailBackgroundView = detailBackgroundView;
    
    // 添加分享
    LPBottomShareView *bottomShareView = [[LPBottomShareView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    bottomShareView.delegate = self;
    [self.view addSubview:bottomShareView];
    
    // 改变字体大小视图
    LPDetailChangeFontSizeView *changeFontSizeView = [[LPDetailChangeFontSizeView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, changeFontSizeViewH)];
    changeFontSizeView.delegate = self;
    [self.view addSubview:changeFontSizeView];
    self.changeFontSizeView = changeFontSizeView;
    
    CGRect toFrame = CGRectMake(0, ScreenHeight - bottomShareView.size.height, ScreenWidth, bottomShareView.size.height);
    
    [UIView animateWithDuration:0.3f animations:^{
        bottomShareView.frame = toFrame;
    }];
    self.bottomShareView = bottomShareView;
}

#pragma mark LPDetailTopView Delegate
- (void)shareView:(LPBottomShareView *)shareView cancelButtonDidClick:(UIButton *)cancelButton {
    [self removeBackgroundView];
}

- (void)removeBackgroundView {
    CGRect bottomShareViewToFrame = CGRectMake(0, ScreenHeight, ScreenWidth, self.bottomShareView.size.height);
    CGRect changeFontSizeViewToFrame = CGRectMake(0, ScreenHeight, ScreenWidth, self.changeFontSizeView.height);
    
    [UIView animateWithDuration:0.3f animations:^{
        if (self.bottomShareView.origin.y == ScreenHeight - self.bottomShareView.size.height) {
            self.bottomShareView.frame = bottomShareViewToFrame;
        }
        if (self.changeFontSizeView.origin.y == ScreenHeight - self.changeFontSizeView.size.height) {
            self.changeFontSizeView.frame = changeFontSizeViewToFrame;
        }
        self.detailBackgroundView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.bottomShareView removeFromSuperview];
        [self.changeFontSizeView removeFromSuperview];
        [self.detailBackgroundView removeFromSuperview];
    }];
}


#pragma mark - 改变详情页字体大小
- (void)changeDetailFontSize {
    CGRect shareViewToFrame = CGRectMake(0, ScreenHeight, ScreenWidth, self.bottomShareView.size.height);
    CGRect changeFontSizeViewToFrame = CGRectMake(0, ScreenHeight - changeFontSizeViewH, ScreenWidth, self.changeFontSizeView.height);
    [UIView animateWithDuration:0.3f animations:^{
        self.bottomShareView.frame = shareViewToFrame;
        self.changeFontSizeView.frame = changeFontSizeViewToFrame;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - LPDetailChangeFontSizeView delegate
- (void)changeFontSizeView:(LPDetailChangeFontSizeView *)changeFontSizeView reloadTableViewWithFontSize:(LPFontSize *)lpFontSize {
    
    [LPFontSizeManager sharedManager].lpFontSize = lpFontSize;
    [noteCenter postNotificationName:LPFontSizeChangedNotification object:nil];
}

- (void)finishButtonDidClick:(LPDetailChangeFontSizeView *)changeFontSizeView {
    [self removeBackgroundView];
}


#pragma mark - setup TableView
- (void)setupTableView {
    
    // 分享，评论，添加按钮边距设置
    CGFloat topViewHeight = TabBarHeight + StatusBarHeight;
    if (iPhone6) {
        topViewHeight = 72;
    }
    UIView *headerView = [[UIView alloc] init];
    
    CGFloat headerImageViewW = 60;
    CGFloat headerImageViewH = 60;
    CGFloat headerImageViewX = (ScreenWidth - headerImageViewW) / 2;
    CGFloat headerImageViewY = 0;
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headerImageViewX, headerImageViewY, headerImageViewW, headerImageViewH)];
    headerImageView.layer.cornerRadius = (headerImageViewW / 2);
    headerImageView.clipsToBounds = YES;
    if (self.sourceImageURL) {
       [headerImageView sd_setImageWithURL:[NSURL URLWithString:self.sourceImageURL] placeholderImage:[UIImage oddityImage:@"奇点号占位图2"]];
    } else {
        headerImageView.image = [UIImage oddityImage:@"奇点号占位图2"];
    }
    [headerView addSubview:headerImageView];
    self.headerImageView = headerImageView;
    
    NSString *headerStr = self.sourceName;
    
    CGFloat headerLabelW = [headerStr sizeWithFont:[UIFont systemFontOfSize:LPFont1] maxSize:CGSizeMake(ScreenWidth, CGFLOAT_MAX)].width;
    CGFloat headerLabelH = [headerStr sizeWithFont:[UIFont systemFontOfSize:LPFont1] maxSize:CGSizeMake(headerLabelW, CGFLOAT_MAX)].height;
    CGFloat headerLabelX = (ScreenWidth - headerLabelW) / 2;
    CGFloat headerLabelY = CGRectGetMaxY(headerImageView.frame) + 10;
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.font = [UIFont systemFontOfSize:LPFont1];
    headerLabel.text = headerStr;
    headerLabel.textColor = [UIColor colorFromHexString:LPColor1];
    headerLabel.frame = CGRectMake(headerLabelX, headerLabelY, headerLabelW, headerLabelH);
    [headerView addSubview:headerLabel];
    self.headerLabel = headerLabel;
    
    CGFloat seperatorViewX = 17;
    CGFloat seperatorViewY = CGRectGetMaxY(headerLabel.frame) + 22;
    CGFloat seperatorViewW = ScreenWidth - seperatorViewX * 2;
    CGFloat seperatorViewH = 0.5;
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(seperatorViewX, seperatorViewY, seperatorViewW, seperatorViewH)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
    [headerView addSubview:seperatorView];
    
    CGFloat headerViewH = CGRectGetMaxY(seperatorView.frame);
    headerView.frame = CGRectMake(0, 0 , ScreenWidth, headerViewH);
    
    CGFloat tableViewH = ScreenHeight - topViewHeight;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topViewHeight, ScreenWidth, tableViewH) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[LPConcernCardTableViewCell class] forCellReuseIdentifier:contentCellIdentifier];
//    [tableView registerClass:[LPConcernIndroduceTableViewCell class] forCellReuseIdentifier:introduceCellIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.hidden = YES;
    tableView.tableHeaderView = headerView;
    [self.view addSubview:tableView];
    
    __weak typeof(self) weakSelf = self;
    // 上拉加载更多
    tableView.mj_footer = [LPDiggerFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.tableView = tableView;

}


#pragma mark - loadMoreData
- (void)loadMoreData {
    LPConcernCardFrame *cardFrame = [self.concernCardFrames lastObject];
    LPConcernCard *card = cardFrame.card;
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/pbs", ServerUrlVersion2];
    NSMutableDictionary *concernParams = [NSMutableDictionary dictionary];
    concernParams[@"pname"] = self.sourceName;
    concernParams[@"info"] = @"0";
    NSString *startTime = card.updateTime;
    concernParams[@"tcr"] = startTime;
    
    [LPHttpTool getWithURL:url params:concernParams success:^(id json) {
        if ([json[@"code"] integerValue] == 2000) {
            NSMutableDictionary *dict = json[@"data"];
            NSMutableArray *bodyArray = [[NSMutableArray alloc] initWithArray:dict[@"news"]];
            for (NSDictionary *dict in bodyArray) {
                LPConcernCard *card = [[LPConcernCard alloc] init];
                card.nid = dict[@"nid"];
                card.title = dict[@"title"];
                card.sourceSiteName = dict[@"pname"];
                card.updateTime = [NSString stringWithFormat:@"%lld", (long long)([dict[@"ptime"] timestampWithDateFormat:@"YYYY-MM-dd HH:mm:ss"] * 1000)];
                card.channelId = @(99999);
                card.docId = dict[@"docid"];
                card.commentsCount = dict[@"comment"];
                card.cardImages = dict[@"imgs"];
                if ([dict[@"rtype"] integerValue] == videoNewsType) {
                    card.rtype = [dict[@"rtype"] integerValue];
                    card.thumbnail = dict[@"thumbnail"];
                    card.duration = [dict[@"duration"] integerValue];
                }
                
                LPConcernCardFrame *cardFrame = [[LPConcernCardFrame alloc] init];
                cardFrame.card = card;
                [self.concernCardFrames addObject:cardFrame];
            }
            [self.tableView reloadData];
           [self.tableView.mj_footer endRefreshing];
            if (bodyArray.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPConcernCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentCellIdentifier];
        if (cell == nil) {
            cell =  [[LPConcernCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentCellIdentifier];
        }
        cell.cardFrame  = self.concernCardFrames[indexPath.row];
        return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.concernCardFrames.count;

}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPConcernCardFrame *frame = self.concernCardFrames[indexPath.row];
    return frame.cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LPConcernCardFrame *cardFrame = self.concernCardFrames[indexPath.row];
    LPConcernCard *concernCard = cardFrame.card;
    
    if (concernCard.rtype == videoNewsType) {
        LPVideoDetailViewController *videoDetailViewController = [[LPVideoDetailViewController alloc] init];
        videoDetailViewController.sourceViewController = concernHistorySource;
        videoDetailViewController.concernCardFrame = cardFrame;
        [self.navigationController pushViewController:videoDetailViewController animated:YES];
        
    } else {
        LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
        detailVc.sourceViewController = concernHistorySource;
        detailVc.concernCardFrame = cardFrame;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = nil;
    CGFloat height = [self heightForTableViewHeader];
    CGFloat paddingLeft = 17;
    CGFloat paddingTop = 13;
 
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, paddingTop, ScreenWidth - paddingLeft, height - paddingTop)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:LPFont10];
    label.textColor = [UIColor colorFromHexString:LPColor4];
    label.text = @"历史文章";
    [view addSubview:label];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForTableViewHeader];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark - heightForTableViewHeader
- (CGFloat)heightForTableViewHeader {
    NSString *str = @"历史文章";
    CGFloat height = [str sizeWithFont:[UIFont systemFontOfSize:LPFont10] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat padding = 13;
    return height + padding;
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollView.scrollEnabled = YES;
    self.lastContentOffsetY = self.tableView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([scrollView isKindOfClass:[UITableView class]]) { // 上下拖动table view
        if (offsetY > 0) {
            if (offsetY > self.tableView.tableHeaderView.frame.size.height - 20) {
                self.titleLabel.hidden = NO;
                self.seperatorView.hidden = NO;
            } else {
                self.titleLabel.hidden = YES;
                self.seperatorView.hidden = YES;

            }
        }
    }
}

#pragma mark - 正在加载
- (void)setupLoadingView {
    
    double topViewHeight = TabBarHeight + StatusBarHeight;
    if (iPhone6) {
        topViewHeight = 72;
    }
    LPLoadingView *loadingView = [[LPLoadingView alloc] initWithFrame:CGRectMake(0, topViewHeight, ScreenWidth, (ScreenHeight - topViewHeight) / 2.0f)];
    [self.view addSubview:loadingView];
    self.loadingView = loadingView;
    [loadingView startAnimating];
}



@end
