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
#import "LPSearchTool.h"
#import "LPLoadingView.h"


static NSString *cellIdentifier = @"cellIdentifier";
static NSString *qiDiancellIdentifier = @"qiDiancellIdentifier";

@interface LPSearchResultViewController ()<LPSearchResultTopViewDelegate, UITableViewDataSource, UITableViewDelegate, LPQiDianHaoViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cardFrames;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) LPSearchResultTopView *topView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) LPLoadingView *loadingView;
@property (nonatomic, assign, getter=isPublisherExist) BOOL publisherExist;
@property (nonatomic, strong) NSMutableArray *qiDianHaoConcernArray;
@property (nonatomic, copy) NSString *keywords;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed = true;
    }
    return self;
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
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(resultTopView.frame), ScreenWidth, 0)];
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage oddityImage:@"wusousuojieguo"]];
    imageView.centerX = self.view.centerX;
    imageView.centerY = ScreenHeight / 3;
    
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    noDataLabel.centerY = CGRectGetMaxY(imageView.frame);
    
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
    self.keywords = self.topView.searchBar.text;
    params[@"keywords"] = self.topView.searchBar.text;
    params[@"p"] = @(self.pageIndex);
    params[@"c"] = @"20";
    params[@"uid"] = [userDefaults objectForKey:@"uid"];
    
    NSArray *keywords = [LPSearchTool stringWithWord:self.keywords];
    
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/es/snp",ServerUrlVersion2];
    NSMutableArray *newSearchItemsFrames = self.cardFrames;
    __weak typeof(self) weakSelf = self;
    [LPHttpTool getWithURL:url params:params success:^(id json) {
        if ([json[@"code"] integerValue] == 2000) {
            NSArray *jsonNewsArray = (NSArray *)json[@"data"][@"news"];
            for (int i = 0; i < jsonNewsArray.count; i ++) {
                NSDictionary *dict = jsonNewsArray[i];
                LPSearchCard *card = [[LPSearchCard alloc] init];
                card.title = [LPSearchTool filterHTML:dict[@"title"]];
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
                cardFrame.keywords = keywords;
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
    LPLoadingView *loadingView = [[LPLoadingView alloc] initWithFrame:CGRectMake(0, StatusBarHeight + TabBarHeight, ScreenWidth, (ScreenHeight - StatusBarHeight - TabBarHeight) / 2.0f)];
    [self.view addSubview:loadingView];
    self.loadingView = loadingView;
    [loadingView startAnimating];
    
}



#pragma mark - 加载数据
- (void)setupDataWithKeyword:(NSString *)keyword {
    self.pageIndex = 1;
    [self.cardFrames removeAllObjects];
    // 移除奇点号
    [self.qiDianHaoConcernArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    self.keywords = keyword;
    params[@"keywords"] = keyword;
    params[@"p"] = @(self.pageIndex);
    params[@"c"] = @"20";
    params[@"uid"] = [userDefaults objectForKey:@"uid"];
    
    NSArray *keywords = [LPSearchTool stringWithWord:keyword];
    
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
                card.title = [LPSearchTool filterHTML:dict[@"title"]];
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
                cardFrame.keywords = keywords;
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
            [weakSelf.loadingView stopAnimating];
        } else if([json[@"code"] integerValue] == 2002) {
             weakSelf.tableView.hidden = NO;
            [weakSelf.tableView reloadData];
           [weakSelf.loadingView stopAnimating];
        }
    } failure:^(NSError *error) {
        [weakSelf.loadingView stopAnimating];
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
    qiDianConcernViewController.keywords = self.keywords;
    [self.navigationController pushViewController:qiDianConcernViewController animated:YES];
}

- (void)cell:(LPQiDianHaoViewCell *)cell didTapImageViewWithQiDianHao:(LPQiDianHao *)qiDianHao {
    LPConcernDetailViewController *concernDetailViewController = [[LPConcernDetailViewController alloc] init];
    concernDetailViewController.sourceName = qiDianHao.name;
    concernDetailViewController.conpubFlag = [NSString stringWithFormat:@"%d", qiDianHao.concernFlag];
    [self.navigationController pushViewController:concernDetailViewController animated:YES];
}


@end
