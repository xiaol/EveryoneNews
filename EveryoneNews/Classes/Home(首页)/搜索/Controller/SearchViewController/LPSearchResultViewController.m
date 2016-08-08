//
//  LPSearchResultViewController.m
//  EveryoneNews
//
//  Created by dongdan on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPSearchResultViewController.h"
#import "LPSearchResultTopView.h"
#import "LPHttpTool.h"
#import "LPSearchResultViewCell.h"
#import "LPSearchCardFrame.h"
#import "Card.h"
#import "LPDiggerFooter.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "LPSearchCard.h"
#import "LPDetailViewController.h"
#import "LPQiDianHaoViewCell.h"
#import "LPQiDianConcernViewController.h"
#import "LPConcernDetailViewController.h"
#import "LPQiDianHao.h"


static NSString *cellIdentifier = @"cellIdentifier";
static NSString *qiDiancellIdentifier = @"qiDiancellIdentifier";

@interface LPSearchResultViewController ()<LPSearchResultTopViewDelegate, UITableViewDataSource, UITableViewDelegate, LPQiDianHaoViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cardFrames;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) LPSearchResultTopView *topView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong)   UIImageView *animationImageView;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIView *contentLoadingView;
@property (nonatomic, assign, getter=isPublisherExist) BOOL publisherExist;
@property (nonatomic, strong) NSMutableArray *qiDianHaoConcernArray;

@end

@implementation LPSearchResultViewController

#pragma mark - 懒加载
- (NSMutableArray *)cardFrames {
    if (_cardFrames == nil) {
        _cardFrames = [NSMutableArray array];
    }
    return _cardFrames;
}

- (NSMutableArray *)qiDianHaoConcernArray {
    if (_qiDianHaoConcernArray == nil) {
        _qiDianHaoConcernArray = [NSMutableArray array];
    }
    return _qiDianHaoConcernArray;
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
  
    [self setupSubViews];
    [self setupDataWithKeyword:self.searchText];
}

#pragma mark - setupSubViews
- (void)setupSubViews {
    
    // 导航栏
    LPSearchResultTopView *resultTopView = [[LPSearchResultTopView alloc] initWithFrame:self.view.bounds];
    resultTopView.delegate = self;
    resultTopView.searchBar.text = self.searchText;
    [self.view addSubview:resultTopView];
    self.topView = resultTopView;
    
    // 分割线
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(resultTopView.frame), ScreenWidth, 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
    [self.view addSubview:seperatorView];
    
    
    CGFloat tableViewY = CGRectGetMaxY(seperatorView.frame);
    CGFloat tableViewH = ScreenHeight - tableViewY;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, ScreenWidth, tableViewH)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor =  [UIColor colorFromHexString:@"#f6f6f6"];
    [tableView registerClass:[LPQiDianHaoViewCell class] forCellReuseIdentifier:qiDiancellIdentifier];
    [tableView registerClass:[LPSearchResultViewCell class] forCellReuseIdentifier:cellIdentifier];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.hidden = YES;
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    // 没有搜索到数据提示
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 100)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"未找到相关内容"]];
    imageView.centerX = self.view.centerX;
    imageView.centerY = ScreenHeight / 3;
    
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    noDataLabel.centerY = CGRectGetMaxY(imageView.frame) + 20;
    
    NSString *text = @"未找到相关内容";
    NSMutableAttributedString *noDataString = [text attributedStringWithFont:[UIFont systemFontOfSize:13] color:[UIColor colorFromHexString:@"#c8c8c8"] lineSpacing:0];
    noDataLabel.attributedText = noDataString;
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:noDataLabel];
    backgroundView.hidden = YES;
    [self.tableView insertSubview:backgroundView belowSubview:self.tableView];
    self.backgroundView = backgroundView;
    
    __weak typeof(self) weakSelf = self;
    // 上拉加载更多
    self.tableView.mj_footer = [LPDiggerFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    [self setupLoadingView];
}

#pragma mark - loadMoreData
- (void)loadMoreData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"keywords"] = self.topView.searchBar.text;
    params[@"p"] = @(self.pageIndex);
    params[@"c"] = @"20";
    params[@"uid"] = [userDefaults objectForKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/es/snp",ServerUrlVersion2];
    NSMutableArray *newSearchItemsFrames = self.cardFrames;
    __weak typeof(self) weakSelf = self;
    [LPHttpTool getWithURL:url params:params success:^(id json) {
        if ([json[@"code"] integerValue] == 2000) {
            NSArray *jsonNewsArray = (NSArray *)json[@"data"][@"news"];
            for (int i = 0; i < jsonNewsArray.count; i ++) {
                NSDictionary *dict = jsonNewsArray[i];
                LPSearchCard *card = [[LPSearchCard alloc] init];
                card.title = dict[@"title"];
                card.sourceSiteURL = dict[@"purl"];
                card.sourceSiteName =  dict[@"pname"];
                card.updateTime = [NSString stringWithFormat:@"%lld", (long long)([dict[@"ptime"] timestampWithDateFormat:@"YYYY-MM-dd HH:mm:ss"] * 1000)];
                card.cardImages = dict[@"imgs"];
                card.docId = dict[@"docid"];
                card.nid = dict[@"nid"];
                card.commentsCount = dict[@"comment"];
                card.channelId = dict[@"channel"];
                
                LPSearchCardFrame *cardFrame = [[LPSearchCardFrame alloc] init];
                cardFrame.card = card;
                [newSearchItemsFrames addObject:cardFrame];
            }
            weakSelf.cardFrames = newSearchItemsFrames;
            weakSelf.tableView.hidden = NO;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
            self.pageIndex = self.pageIndex + 1;
            
        } else if ([json[@"code"] integerValue] == 2002) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark - Loading View
- (void)setupLoadingView {
    UIView *contentLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0, StatusBarHeight + TabBarHeight, ScreenWidth, ScreenHeight - StatusBarHeight - TabBarHeight)];
    
    // Load images
    NSArray *imageNames = @[@"xl_1", @"xl_2", @"xl_3", @"xl_4"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    // Normal Animation
    UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 36) / 2, (ScreenHeight - StatusBarHeight - TabBarHeight) / 3, 36 , 36)];
    animationImageView.animationImages = images;
    animationImageView.animationDuration = 1;
    [self.view addSubview:animationImageView];
    self.animationImageView = animationImageView;

    [contentLoadingView addSubview:animationImageView];
    [self.view addSubview:contentLoadingView];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(animationImageView.frame), ScreenWidth, 40)];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"正在努力搜索...";
    loadingLabel.font = [UIFont systemFontOfSize:12];
    loadingLabel.textColor = [UIColor colorFromHexString:@"#999999"];
    [contentLoadingView addSubview:loadingLabel];
    self.loadingLabel = loadingLabel;
    self.contentLoadingView = contentLoadingView;
    
    [self showLoadingView];
    
}

#pragma mark - 首页显示正在加载提示
- (void)showLoadingView {
    [self.animationImageView startAnimating];
    self.contentLoadingView.hidden = NO;
}


#pragma mark - 首页隐藏正在加载提示
- (void)hideLoadingView {
    [self.animationImageView stopAnimating];
    self.contentLoadingView.hidden = YES;
}


#pragma mark - 加载数据
- (void)setupDataWithKeyword:(NSString *)keyword {
    self.pageIndex = 1;
    [self.cardFrames removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"keywords"] = keyword;
    params[@"p"] = @(self.pageIndex);
    params[@"c"] = @"20";
    params[@"uid"] = [userDefaults objectForKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/es/snp",ServerUrlVersion2];
    __weak typeof(self) weakSelf = self;
    [LPHttpTool getWithURL:url params:params success:^(id json) {
        if ([json[@"code"] integerValue] == 2000) {
            // 获取新闻列表
            NSArray *jsonNewsArray = (NSArray *)json[@"data"][@"news"];
            // 获取奇点号
            NSArray *jsonPublisherArray = (NSArray *)json[@"data"][@"publisher"];
      
            for (int i = 0; i < jsonNewsArray.count; i ++) {
                NSDictionary *dict = jsonNewsArray[i];
                LPSearchCard *card = [[LPSearchCard alloc] init];
                card.title = dict[@"title"];
                card.sourceSiteURL = dict[@"purl"];
                card.sourceSiteName =  dict[@"pname"];
                card.updateTime = [NSString stringWithFormat:@"%lld", (long long)([dict[@"ptime"] timestampWithDateFormat:@"YYYY-MM-dd HH:mm:ss"] * 1000)];
                card.cardImages = dict[@"imgs"];
                card.docId = dict[@"docid"];
                card.nid = dict[@"nid"];
                card.commentsCount = dict[@"comment"];
                card.channelId = dict[@"channel"];
                
                LPSearchCardFrame *cardFrame = [[LPSearchCardFrame alloc] init];
                cardFrame.card = card;
                [weakSelf.cardFrames addObject:cardFrame];
            }
            
            if (jsonPublisherArray.count > 0) {
                
                for (int i = 0; i < jsonPublisherArray.count; i++) {
                    NSDictionary *dict = jsonPublisherArray[i];
                    LPQiDianHao *qiDianHao = [[LPQiDianHao alloc] init];
                    qiDianHao.concernID = [dict[@"id"] integerValue];
                    qiDianHao.concernCount = [dict[@"concern"] integerValue];
                    qiDianHao.concernFlag = [dict[@"flag"] integerValue];
                    qiDianHao.name = dict[@"name"];
                    [weakSelf.qiDianHaoConcernArray addObject:qiDianHao];
                }
                [weakSelf.cardFrames insertObject:@"奇点号" atIndex:2];
                 weakSelf.publisherExist = YES;
            }
             weakSelf.tableView.hidden = NO;
            [weakSelf.tableView reloadData];
            weakSelf.pageIndex = self.pageIndex + 1;
            [weakSelf hideLoadingView];
        } else if([json[@"code"] integerValue] == 2002) {
             weakSelf.tableView.hidden = NO;
            [weakSelf.tableView reloadData];
            [weakSelf hideLoadingView];
        }
    } failure:^(NSError *error) {
        [weakSelf hideLoadingView];
    }];
}

#pragma mark - LPSearchResultTopView Delegate
- (void)backButtonDidClick:(LPSearchResultTopView *)searchResultTopView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)topView:(LPSearchResultTopView *)topView searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([searchBar.text stringByTrimmingNewline].length > 0) {
        [self setupDataWithKeyword:searchBar.text];
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}



#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.cardFrames.count > 0) {
        self.backgroundView.hidden = YES;
    } else {
        self.backgroundView.hidden = NO;
    }
    return self.cardFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isPublisherExist) {
        if (indexPath.row == 2) {
            LPQiDianHaoViewCell *cell = [[LPQiDianHaoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:qiDiancellIdentifier];
            [cell setupQiDianHaoWithArray:self.qiDianHaoConcernArray];
            cell.delegate = self;
            return cell;
            
        } else {
            
            LPSearchResultViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[LPSearchResultViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.cardFrame = self.cardFrames[indexPath.row];
            return cell;
        }
    } else {
        
        LPSearchResultViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[LPSearchResultViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.cardFrame = self.cardFrames[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isPublisherExist) {
        LPSearchCardFrame *cardFrame = self.cardFrames[indexPath.row];
        if (indexPath.row == 2) {
            return [self heightWithQiDianView];
        } else {
            return cardFrame.cellHeight;
        }
    } else {
        LPSearchCardFrame *cardFrame = self.cardFrames[indexPath.row];
        return cardFrame.cellHeight;
    }
}

- (CGFloat)heightWithQiDianView {
    NSString *qiDianStr = @"奇点号";
    CGFloat qiDianLabelH = [qiDianStr sizeWithFont:[UIFont systemFontOfSize:LPFont2] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    NSString *title = @"历史";
    CGFloat titleLabelH = [title sizeWithFont:[UIFont systemFontOfSize:LPFont5] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat padding = 11 * 2 + 18 * 2 + 17 + 7 + 59;
    return qiDianLabelH + titleLabelH + padding;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      if (self.isPublisherExist) {
          if (indexPath.row != 2) {
              LPSearchCardFrame *searchCardFrame = self.cardFrames[indexPath.row];
              LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
              detailVc.searchCardFrame = searchCardFrame;
              detailVc.sourceViewController = searchSource;
              [self.navigationController pushViewController:detailVc animated:YES];
          } else {
              return;
          }
      } else {
          LPSearchCardFrame *searchCardFrame = self.cardFrames[indexPath.row];
          LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
          detailVc.searchCardFrame = searchCardFrame;
          detailVc.sourceViewController = searchSource;
          [self.navigationController pushViewController:detailVc animated:YES];
      }


}

#pragma mark - LPQiDianHaoViewCellDelegate
- (void)cell:(LPQiDianHaoViewCell *)cell didTapImageViewWithQiDianArray:(NSArray *)qiDianArray {
    LPQiDianConcernViewController *qiDianConcernViewController = [[LPQiDianConcernViewController alloc] init];
    qiDianConcernViewController.qiDianArray = qiDianArray;
    [self.navigationController pushViewController:qiDianConcernViewController animated:YES];
}

- (void)cell:(LPQiDianHaoViewCell *)cell didTapImageViewWithQiDianHao:(LPQiDianHao *)qiDianHao {
    LPConcernDetailViewController *concernDetailViewController = [[LPConcernDetailViewController alloc] init];
    concernDetailViewController.sourceName = qiDianHao.name;
    concernDetailViewController.conpubFlag = [NSString stringWithFormat:@"%d", qiDianHao.concernFlag];
    [self.navigationController pushViewController:concernDetailViewController animated:YES];
}


@end
