//
//  LPSearchViewController.m
//  EveryoneNews
//
//  Created by dongdan on 16/1/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPSearchViewController.h"
#import "LPSearchItemFrame.h"
#import "LPHttpTool.h"
#import "LPSearchItem.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "LPDiggerFooter.h"
#import "LPSearchItemViewCell.h"
#import "LPWebViewController.h"
#import "LPHotWordCollectionViewCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "LPSearchHistoryCollectionViewCell.h"
#import "UITextField+LP.h"

static NSString *hotWordCellIdentifier = @"hotWordCellIdentifier";
static NSString *searchHistoreCellIdentifier = @"searchHistoreCellIdentifier";
static NSString *historySearchRecord = @"historySearchRecord";
static const CGFloat searchHistoryHeight = 200;

@interface LPSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchItemsFrames;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *hotWordArray;
@property (nonatomic, strong) UICollectionView *hotWordCollectionView;
@property (nonatomic, strong) UICollectionView *searchHistoryCollectionView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableArray *searchHistoryArray;
@property (nonatomic, strong) UILabel *searchHistoryLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) UIView *hotWordBackgroundView;
@property (nonatomic ,strong) UIView *searchHistoryBackgroundView;


@end
@implementation LPSearchViewController

- (NSMutableArray *)searchItemsFrames {
    if (_searchItemsFrames == nil) {
        _searchItemsFrames = [NSMutableArray array];
    }
    return _searchItemsFrames;
}

- (NSMutableArray *)hotWordArray {
    if (_hotWordArray == nil) {
        _hotWordArray = [NSMutableArray array];
    }
    return _hotWordArray;
}

- (NSMutableArray *)searchHistoryArray {
    if (_searchHistoryArray == nil) {
        _searchHistoryArray = [NSMutableArray array];
    }
    return _searchHistoryArray;
}

- (void)viewDidLoad {
    if([userDefaults objectForKey:historySearchRecord]) {
        self.searchHistoryArray = [[userDefaults objectForKey:historySearchRecord] mutableCopy];
    }
    [self setupView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [userDefaults setObject:self.searchHistoryArray forKey:historySearchRecord];
    [userDefaults synchronize];

}

#pragma mark - 保存搜索历史记录
- (void)searchHistoryDidSavedWithTitle:(NSString *)title {
    if (self.searchHistoryArray.count > 8) {
        [self.searchHistoryArray removeLastObject];
    }
    BOOL wordIsExist = NO;
    if (self.searchHistoryArray.count > 0) {
        for (NSString *searchString in self.searchHistoryArray) {
            if ([searchString isEqualToString:title]) {
                wordIsExist = YES;
                break;
            }
        }
    }
    if (wordIsExist == NO) {
        [self.searchHistoryArray insertObject:title atIndex:0];
    }
}

#pragma mark - 隐藏键盘
- (void)hideKeyboard:(UITapGestureRecognizer *)tapGesture {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self setCancelButtonEnable];
}

#pragma mark - 取消按钮可用
- (void)setCancelButtonEnable {
        UIView *subView0 = self.searchBar.subviews[0];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            for (UIView *subView in subView0.subviews)
            {
                // 获得UINavigationButton按钮，也就是Cancel按钮对象，并修改此按钮的各项属性
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *cannelButton = (UIButton*)subView;
                    [cannelButton setEnabled:YES];
                    break;
                }
            }
        }
}

#pragma mark - 删除浏览历史
- (void)deleteHistory:(UITapGestureRecognizer *)sender {
    self.searchHistoryArray = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.seperatorView.hidden = YES;
        self.imageView.hidden = YES;
        self.searchHistoryLabel.hidden = YES;
        self.hotWordBackgroundView.frame = CGRectMake(0, 20 , ScreenWidth, ScreenHeight - 20 - TabBarHeight);
        self.hotWordCollectionView.frame = CGRectMake(0, 30.5 , ScreenWidth, self.hotWordBackgroundView.frame.size.height - 30.5);
        [self.hotWordCollectionView setContentOffset:CGPointZero];
    } completion:nil];
    
    [self.searchHistoryCollectionView reloadData];
    
}

#pragma mark - 初始化视图
- (void)setupView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20 + TabBarHeight)];
    headerView.backgroundColor = [UIColor colorFromHexString:@"#ededed"];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, TabBarHeight)];
    searchBar.showsCancelButton = YES;
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor  colorFromHexString:@"#7c7c7c"];
    searchBar.backgroundImage = [[UIImage alloc] init];
    searchBar.backgroundColor = [UIColor colorFromHexString:@"#ededed"];
    [searchBar becomeFirstResponder];
   
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#8e8e93"],
                                                                                                 NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setLayerCornerRadius:12];
    [headerView addSubview:searchBar];
    self.searchBar = searchBar;
    [self.view addSubview:headerView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + TabBarHeight, ScreenWidth, ScreenHeight - 20 - TabBarHeight)];
    tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    __weak typeof(self) weakSelf = self;
    // 上拉加载更多
    self.tableView.footer = [LPDiggerFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 + TabBarHeight, ScreenWidth, ScreenHeight - 20 - TabBarHeight)];
    backgroundView.backgroundColor = [UIColor colorFromHexString:@"#F6F6F6"];
    
    UIView *searchHistoryBackgroundView = [[UIView alloc] init];
    
    if (self.searchHistoryArray.count > 0) {
        searchHistoryBackgroundView.frame = CGRectMake(0, 0, ScreenWidth, searchHistoryHeight);
    } else {
        searchHistoryBackgroundView.frame =  CGRectMake(0, 0, ScreenWidth, 0);
    }
    
    UIView *searchHistoryHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50.5)];
    
    // 移除键盘
    searchHistoryHeaderView.userInteractionEnabled = YES;
    UITapGestureRecognizer *searchHistoryHeaderViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    searchHistoryHeaderViewTap.delegate = self;
    [searchHistoryHeaderView addGestureRecognizer:searchHistoryHeaderViewTap];
    
    CGFloat searchHistoryFontSize = 14;
    if (iPhone6Plus) {
        searchHistoryFontSize = 16;
    }
    
    // 搜索历史
    UILabel *searchHistoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 200, 30)];
    searchHistoryLabel.text = @"搜索历史";
    searchHistoryLabel.font = [UIFont systemFontOfSize:searchHistoryFontSize];
    searchHistoryLabel.textAlignment = NSTextAlignmentLeft;
    searchHistoryLabel.textColor = [UIColor colorFromHexString:@"#acacaf"];
    [searchHistoryHeaderView addSubview:searchHistoryLabel];
    self.searchHistoryLabel = searchHistoryLabel;
    
    // 删除历史记录
    UIImage *image = [UIImage imageNamed:@"搜索删除按钮"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeRight;
    imageView.frame = CGRectMake(ScreenWidth - 37, 20, 22, 30);
    [searchHistoryHeaderView addSubview:imageView];
    
    self.imageView = imageView;
    
    UITapGestureRecognizer *deleteHistoryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteHistory:)];
    deleteHistoryTap.delegate = self;
    [imageView addGestureRecognizer:deleteHistoryTap];
    
    // 分割线
    UIView *searchHistorySeperatorView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(searchHistoryLabel.frame), ScreenWidth - 30, 0.5)];
    searchHistorySeperatorView.backgroundColor = [UIColor colorFromHexString:@"#d2d2d2"];
    [searchHistoryHeaderView addSubview:searchHistorySeperatorView];
    self.seperatorView = searchHistorySeperatorView;
    
    [searchHistoryBackgroundView addSubview: searchHistoryHeaderView];
    
    if (self.searchHistoryArray.count == 0) {
        self.seperatorView.hidden = YES;
        self.imageView.hidden = YES;
        self.searchHistoryLabel.hidden = YES;
    }
    
    // 历史记录
    UICollectionViewLeftAlignedLayout *searchHistoryFollowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    CGFloat searchHistoryCollectionViewHeight = searchHistoryHeight - 50.5;
    UICollectionView *searchHistoryCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchHistorySeperatorView.frame), ScreenWidth, searchHistoryCollectionViewHeight)  collectionViewLayout:searchHistoryFollowLayout];
    searchHistoryCollectionView.backgroundColor = [UIColor colorFromHexString:@"#F6F6F6"];
    searchHistoryCollectionView.delegate = self;
    searchHistoryCollectionView.dataSource = self;
    [searchHistoryCollectionView registerClass:[LPSearchHistoryCollectionViewCell class] forCellWithReuseIdentifier:searchHistoreCellIdentifier];
    searchHistoryCollectionView.backgroundView = [[UIView alloc] init];
    
    // 移除键盘手势
    UITapGestureRecognizer *searchHistoryCollectionViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    searchHistoryCollectionViewTap.delegate = self;
    [searchHistoryCollectionView.backgroundView addGestureRecognizer:searchHistoryCollectionViewTap];
    [searchHistoryBackgroundView addSubview:searchHistoryCollectionView];
    self.searchHistoryCollectionView = searchHistoryCollectionView;
    
    [backgroundView addSubview:searchHistoryBackgroundView];
    self.searchHistoryBackgroundView = searchHistoryBackgroundView;

    
    // ------------近期热点
    UIView *hotWordBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchHistoryBackgroundView.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(searchHistoryBackgroundView.frame) - 20 - TabBarHeight)];
    UIView *hotWordHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30.5)];
    // 移除键盘
    UITapGestureRecognizer *hotWordHeaderViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    hotWordHeaderViewTap.delegate = self;
    [hotWordHeaderView addGestureRecognizer:hotWordHeaderViewTap];
    
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth, 30)];
    hotLabel.text = @"近期热点";
    hotLabel.font = [UIFont systemFontOfSize:searchHistoryFontSize];
    hotLabel.textAlignment = NSTextAlignmentLeft;
    hotLabel.textColor = [UIColor colorFromHexString:@"#acacaf"];
    [hotWordHeaderView addSubview:hotLabel];
    
    // 近期热点分割线
    UIView *hotSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(hotLabel.frame), ScreenWidth - 30, 0.5)];
    hotSeperatorView.backgroundColor = [UIColor colorFromHexString:@"#d2d2d2"];
    [hotWordHeaderView addSubview:hotSeperatorView];
    
    [hotWordBackgroundView addSubview:hotWordHeaderView];
    
    UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    // 计算近期热点高度
    CGFloat hotWordCollectionViewHeight = ScreenHeight - CGRectGetMaxY(hotWordHeaderView.frame) - 20 - TabBarHeight - CGRectGetMaxY(searchHistoryBackgroundView.frame);
    
    UICollectionView *hotWordCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hotWordHeaderView.frame), ScreenWidth, hotWordCollectionViewHeight)  collectionViewLayout:flowLayout];
    hotWordCollectionView.backgroundColor = [UIColor colorFromHexString:@"#F6F6F6"];
    hotWordCollectionView.delegate = self;
    hotWordCollectionView.dataSource = self;
    [hotWordCollectionView registerClass:[LPHotWordCollectionViewCell class] forCellWithReuseIdentifier:hotWordCellIdentifier];
    
    UITapGestureRecognizer *hotWordCollectionViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    hotWordCollectionViewTap.delegate = self;
    hotWordCollectionView.backgroundView = [[UIView alloc] init];
    [hotWordCollectionView.backgroundView addGestureRecognizer:hotWordCollectionViewTap];
    self.hotWordCollectionView = hotWordCollectionView;
    [hotWordBackgroundView addSubview:hotWordCollectionView];
    
    [backgroundView addSubview:hotWordBackgroundView];
    
    self.hotWordBackgroundView = hotWordBackgroundView;
    
    [self.view addSubview:backgroundView];
    self.backgroundView = backgroundView;
    
    // 加载热词
    [self setupHotWord];
    
    
}

- (void)loadMoreData {
    self.pageIndex = self.pageIndex + 1;
    
    NSMutableArray *newSearchItemsFrames = self.searchItemsFrames;
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"keyword"] = self.searchBar.text;
    params[@"page"] = @(self.pageIndex);
    NSString *url = @"http://api.deeporiginalx.com/news/baijia/search";
    [LPHttpTool postWithURL:url params:params success:^(id json) {
        NSArray *jsonArray = (NSArray *)json;
        for (int i = 0; i < jsonArray.count; i ++) {
            NSDictionary *dict = jsonArray[i];
            LPSearchItem *searchItem = [[LPSearchItem alloc] init];
            searchItem.title =  dict[@"title"];
            searchItem.updateTime = dict[@"updateTime"];
            searchItem.sourceUrl = dict[@"sourceUrl"];
            searchItem.sourceSiteName = dict[@"sourceSiteName"];
            
            LPSearchItemFrame *searchItemFrame = [[LPSearchItemFrame alloc] init];
            searchItemFrame.searchItem = searchItem;
            [newSearchItemsFrames addObject:searchItemFrame];
        }
        weakSelf.searchItemsFrames = newSearchItemsFrames;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.footer endRefreshing];
        if (!jsonArray.count) {
            [weakSelf.tableView.footer noticeNoMoreData];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.footer endRefreshing];
    }];
}

#pragma mark - 加载热词
- (void)setupHotWord {
    __weak typeof(self) weakSelf = self;
    // 加载挖掘机热词
    [LPHttpTool postWithURL:HotwordsURL params:nil success:^(id json) {
        NSArray *jsonArray = (NSArray *)json;
        for (int i = 0; i < jsonArray.count; i++) {
            NSDictionary *dict = jsonArray[i];
            NSString *title = dict[@"title"];
            [weakSelf.hotWordArray addObject:title];
        }
        [weakSelf.hotWordCollectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
    if (collectionView == self.hotWordCollectionView) {
          return self.hotWordArray.count;
    }
    else {
        return self.searchHistoryArray.count;
    }
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.hotWordCollectionView) {
        LPHotWordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotWordCellIdentifier forIndexPath:indexPath];
        cell.title = [self.hotWordArray objectAtIndex:indexPath.row];
        return cell;
    } else {
        LPSearchHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:searchHistoreCellIdentifier forIndexPath:indexPath];
        cell.title = [self.searchHistoryArray objectAtIndex:indexPath.row];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.hotWordCollectionView) {
        UILabel *label = [[UILabel alloc] init];
        [label setText:[self.hotWordArray objectAtIndex:indexPath.row]];
        [label sizeToFit];
        return CGSizeMake(label.frame.size.width + 10, label.frame.size.height + 10);
    } else {
        UILabel *label = [[UILabel alloc] init];
        [label setText:[self.searchHistoryArray objectAtIndex:indexPath.row]];
        [label sizeToFit];
        return CGSizeMake(label.frame.size.width + 10, label.frame.size.height + 10);
    }

}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (collectionView == self.hotWordCollectionView) {
        return UIEdgeInsetsMake(15, 15, 15, 15);
    } else {
        return UIEdgeInsetsMake(15, 15, 15, 15);
    }
   
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self setCancelButtonEnable];
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.hotWordCollectionView) {
        LPHotWordCollectionViewCell *cell = (LPHotWordCollectionViewCell *)[self.hotWordCollectionView cellForItemAtIndexPath:indexPath];
        self.searchBar.text = cell.hotWordLabel.text;
    } else {
        LPSearchHistoryCollectionViewCell *cell = (LPSearchHistoryCollectionViewCell *)[self.searchHistoryCollectionView cellForItemAtIndexPath:indexPath];
        self.searchBar.text = cell.searchHistoryLabel.text;
    }
    [self searchBarSearchButtonClicked:self.searchBar];
}

#pragma mark - 加载数据
- (void)setupDataWithKeyword:(NSString *)keyword {
    [self.searchItemsFrames removeAllObjects];

     __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"keyword"] = keyword;
    params[@"page"] = @(self.pageIndex == 0 ? 1: self.pageIndex);
    NSString *url = @"http://api.deeporiginalx.com/news/baijia/search";
    [LPHttpTool postWithURL:url params:params success:^(id json) {
        if (json != nil) {
            NSArray *jsonArray = (NSArray *)json;
            NSMutableArray *searchItemsFrameArray = [NSMutableArray array];
            for (int i = 0; i < jsonArray.count; i ++) {
                NSDictionary *dict = jsonArray[i];
                LPSearchItem *searchItem = [[LPSearchItem alloc] init];
                searchItem.title =  dict[@"title"];
                searchItem.updateTime = dict[@"updateTime"];
                searchItem.sourceUrl = dict[@"sourceUrl"];
                searchItem.sourceSiteName = dict[@"sourceSiteName"];
                
                LPSearchItemFrame *searchItemFrame = [[LPSearchItemFrame alloc] init];
                searchItemFrame.searchItem = searchItem;
                [searchItemsFrameArray addObject:searchItemFrame];
            }
            weakSelf.searchItemsFrames = searchItemsFrameArray;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView setContentOffset:CGPointZero];
        }

    } failure:^(NSError *error) {
    }];
}


#pragma mark - 显示状态栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numOfSections = 0;
    if(self.searchItemsFrames.count == 0) {
        
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

        self.tableView.backgroundView = backgroundView;
        numOfSections = 0;
    }
    else {
        self.tableView.backgroundView = nil;
        numOfSections = 1;
    }
    return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchItemsFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"searchItemIdentifier";
    LPSearchItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LPSearchItemViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.searchItemFrame = self.searchItemsFrames[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPSearchItemFrame *searchItemFrame = self.searchItemsFrames[indexPath.row];
    return searchItemFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LPSearchItemFrame *searchItemFrame = self.searchItemsFrames[indexPath.row];
    LPSearchItem *searchItem = searchItemFrame.searchItem;
    LPWebViewController *webVc = [[LPWebViewController alloc] init];
    webVc.webUrl = searchItem.sourceUrl;
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark - SearchBar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.pageIndex = 1;
    if([searchText isEqualToString:@""] || searchText == nil) {
        self.backgroundView.hidden = NO;
        [self.searchHistoryCollectionView reloadData];
        self.tableView.hidden = YES;
        [self.hotWordCollectionView setContentOffset:CGPointZero];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.seperatorView.hidden = NO;
            self.imageView.hidden = NO;
            self.searchHistoryLabel.hidden = NO;
            
            self.searchHistoryBackgroundView.frame = CGRectMake(0, 0, ScreenWidth, searchHistoryHeight);
            CGFloat hotWordCollectionViewHeight = ScreenHeight - 20 - TabBarHeight - searchHistoryHeight;
            
            self.hotWordBackgroundView.frame = CGRectMake(0, searchHistoryHeight, ScreenWidth, hotWordCollectionViewHeight);
            self.hotWordCollectionView.frame = CGRectMake(0, 30.5 , ScreenWidth, self.hotWordBackgroundView.frame.size.height - 30.5);
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
}


#pragma mark - 回车
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchString = searchBar.text;
    [self searchHistoryDidSavedWithTitle:searchString];
   [self setupDataWithKeyword:searchString];
    
    self.backgroundView.hidden = YES;
    self.tableView.hidden = NO;
    
   [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self setCancelButtonEnable];
}

#pragma mark - 返回上一个界面
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:NO];

}

@end
