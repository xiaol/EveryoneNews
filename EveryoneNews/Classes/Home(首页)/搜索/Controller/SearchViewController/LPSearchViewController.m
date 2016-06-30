//
//  LPSearchViewController.m
//  EveryoneNews
//
//  Created by dongdan on 16/1/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPSearchViewController.h"
#import "LPSearchTopView.h"
#import "LPHttpTool.h"
#import "LPHotWordCollectionViewCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "LPSearchHistoryTableViewCell.h"
#import "LPSearchHistoryFrame.h"
#import "LPSearchHistoryItem.h"
#import "LPSearchResultViewController.h"


static NSString *hotWordCellIdentifier = @"hotWordCellIdentifier";
//static NSString *searchHistoreCellIdentifier = @"searchHistoreCellIdentifier";
static NSString *historySearchRecord = @"historySearchRecord";
static NSString *cellIdentifier = @"tableViewCellIdentifier";

@interface LPSearchViewController()<LPSearchTopViewDelegate,UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *hotWordArray;
@property (nonatomic, strong) UICollectionView *hotWordCollectionView;
@property (nonatomic, strong) NSMutableArray *searchHistoryArray;
@property (nonatomic, strong) NSMutableArray *searchHistoryFrames;
@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) LPSearchTopView *topView;
@end

@implementation LPSearchViewController


#pragma mark - 懒加载
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

- (NSMutableArray *)searchHistoryFrames {
    if (_searchHistoryFrames == nil) {
        _searchHistoryFrames = [NSMutableArray array];
    }
    return  _searchHistoryFrames;
}
#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    
    [self setupHistoryRecord];
    [self setupHotWord];
    [self setupSubViews];
    
}


#pragma mark - setupSubViews;
- (void)setupSubViews {
    
    // 顶部搜索框
    LPSearchTopView *topView = [[LPSearchTopView alloc]  initWithFrame: self.view.bounds];
    topView.delegate = self;
    [self.view addSubview:topView];
    self.topView = topView;
    
    // 热门搜索
    CGFloat headerViewH = 35;
    UIView *hotSearchHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) + 10, ScreenWidth, headerViewH)];
    
    CGFloat hotDecorationViewX = 0;
    CGFloat hotDecorationViewH = 15;
    CGFloat hotDecorationViewY = (headerViewH - hotDecorationViewH) / 2;
    CGFloat hotDecorationViewW = 4;
    
    UIView *hotDecorationView = [[UIView alloc] initWithFrame:CGRectMake(hotDecorationViewX, hotDecorationViewY, hotDecorationViewW, hotDecorationViewH)];
    hotDecorationView.backgroundColor = [UIColor colorFromHexString:LPColor2];
    [hotSearchHeaderView addSubview:hotDecorationView];
    
    CGFloat headerFontSize = 15;
    CGFloat hotHeaderLabelX = CGRectGetMaxX(hotDecorationView.frame) + 8;
    NSString *hotSearch = @"热门搜索";
    CGFloat hotHeaderLabelW = [hotSearch sizeWithFont:[UIFont systemFontOfSize:headerFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    CGFloat hotHeaderLabelH = [hotSearch sizeWithFont:[UIFont systemFontOfSize:headerFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat hotHeaderLabelY =  (headerViewH - hotHeaderLabelH) / 2;
    
    UILabel *hotHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(hotHeaderLabelX, hotHeaderLabelY, hotHeaderLabelW, hotHeaderLabelH)];
    hotHeaderLabel.textAlignment = NSTextAlignmentLeft;
    hotHeaderLabel.text =  @"热门搜索";
    hotHeaderLabel.textColor = [UIColor colorFromHexString:LPColor7];
    hotHeaderLabel.font = [UIFont systemFontOfSize:15];
    [hotSearchHeaderView addSubview:hotHeaderLabel];
    
    UILabel *hotSeperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hotSearchHeaderView.frame), ScreenWidth, 0.5)];
    hotSeperatorLabel.backgroundColor = [UIColor colorFromHexString:LPColor5];
    [self.view addSubview:hotSeperatorLabel];
    
    [self.view addSubview:hotSearchHeaderView];
    
    UICollectionViewLeftAlignedLayout *hotHistoryFollowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    CGFloat hotWordCollectionViewX = 12;
    CGFloat hotWordCollectionViewW = ScreenWidth - hotWordCollectionViewX * 2;
    CGFloat hotWordCollectionViewY = CGRectGetMaxY(hotSeperatorLabel.frame) + 20;
    CGFloat hotWordCollectionViewH = 120;
    
    
    UICollectionView *hotWordCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(hotWordCollectionViewX, hotWordCollectionViewY, hotWordCollectionViewW, hotWordCollectionViewH)  collectionViewLayout:hotHistoryFollowLayout];
    hotWordCollectionView.backgroundColor = [UIColor colorFromHexString:@"#F6F6F6"];
    hotWordCollectionView.delegate = self;
    hotWordCollectionView.dataSource = self;
    [hotWordCollectionView registerClass:[LPHotWordCollectionViewCell class] forCellWithReuseIdentifier:hotWordCellIdentifier];
    [self.view addSubview:hotWordCollectionView];
    self.hotWordCollectionView = hotWordCollectionView;
    
    // 分割视图
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hotWordCollectionView.frame), ScreenWidth, 11)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:@"#f0f0f0"];
    [self.view addSubview:seperatorView];
    
    // 历史搜索
    UIView *historySearchHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(seperatorView.frame), ScreenWidth, headerViewH)];
    
    UIView *historyDecorationView = [[UIView alloc] initWithFrame:CGRectMake(hotDecorationViewX, hotDecorationViewY, hotDecorationViewW, hotDecorationViewH)];
    historyDecorationView.backgroundColor = [UIColor colorFromHexString:LPColor2];
    [historySearchHeaderView addSubview:historyDecorationView];

    UILabel *historyHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(hotHeaderLabelX, hotHeaderLabelY, hotHeaderLabelW, hotHeaderLabelH)];
    historyHeaderLabel.textAlignment = NSTextAlignmentLeft;
    historyHeaderLabel.text =  @"历史搜索";
    historyHeaderLabel.textColor = [UIColor colorFromHexString:LPColor7];
    historyHeaderLabel.font = [UIFont systemFontOfSize:15];
    [historySearchHeaderView addSubview:historyHeaderLabel];
    
    CGFloat cleanHistoryButtonW = 14;
    CGFloat cleanHistoryButtonH = 15;
    CGFloat cleanHistoryButtonY = (headerViewH - cleanHistoryButtonH) / 2;
    CGFloat cleanHistoryButtonX = ScreenWidth - 20 - cleanHistoryButtonW;
    
    // 删除历史记录
    UIButton *cleanHistoryButton = [[UIButton alloc] initWithFrame:CGRectMake(cleanHistoryButtonX, cleanHistoryButtonY, cleanHistoryButtonW, cleanHistoryButtonH)];
    [cleanHistoryButton setBackgroundImage:[UIImage imageNamed:@"历史搜索清理"] forState:UIControlStateNormal];
    cleanHistoryButton.enlargedEdge = 5;
    [cleanHistoryButton addTarget:self action:@selector(cleanHistoryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [historySearchHeaderView addSubview:cleanHistoryButton];
    
    [self.view addSubview:historySearchHeaderView];
    
    UILabel *historySeperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(historySearchHeaderView.frame), ScreenWidth, 0.5)];
    historySeperatorLabel.backgroundColor = [UIColor colorFromHexString:LPColor5];
    [self.view addSubview:historySeperatorLabel];
    
    CGFloat historyTableViewX = 0;
    CGFloat historyTableViewY = CGRectGetMaxY(historySeperatorLabel.frame);
    CGFloat historyTableViewW = ScreenWidth;
    CGFloat historyTableViewH = ScreenHeight - historyTableViewY;
    
    UITableView *historyTableView = [[UITableView alloc] initWithFrame:(CGRectMake(historyTableViewX, historyTableViewY, historyTableViewW, historyTableViewH))];
    historyTableView.backgroundColor = [UIColor colorFromHexString:@"#F6F6F6"];
    historyTableView.dataSource = self;
    historyTableView.delegate = self;
    historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [historyTableView registerClass:[LPSearchHistoryTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:historyTableView];
    self.historyTableView = historyTableView;
    
    
    // 移除键盘
    historySearchHeaderView.userInteractionEnabled = YES;
    hotSearchHeaderView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    recognizer1.delegate = self;
    [hotSearchHeaderView addGestureRecognizer:recognizer1];
    
    UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    recognizer2.delegate = self;
    [historySearchHeaderView addGestureRecognizer:recognizer2];
    
//    // 移除键盘手势
//    UITapGestureRecognizer *recognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    recognizer3.delegate = self;
//    [hotWordCollectionView addGestureRecognizer:recognizer3];
//    
    
}

#pragma mark - LPSearchTopView Delegate
- (void)backButtonDidClick:(LPSearchTopView *)searchTopView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)topView:(LPSearchTopView *)topView searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchString = searchBar.text;
    if ([searchString stringByTrimmingNewline].length > 0) {
        [self searchHistoryDidSavedWithTitle:searchString];
        // 跳转到搜索界面
        LPSearchResultViewController *resultViewController = [[LPSearchResultViewController alloc] init];
        resultViewController.searchText = searchString;
        [self.navigationController pushViewController:resultViewController animated:YES];
    }
    searchBar.text = @"";
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

#pragma mark - 加载历史记录
- (void)setupHistoryRecord {
    if([userDefaults objectForKey:historySearchRecord]) {
        self.searchHistoryArray = [[userDefaults objectForKey:historySearchRecord] mutableCopy];
    }
    [self setHistoryFrames];
}

#pragma mark - 加载历史记录Frame
- (void)setHistoryFrames {
    if (self.searchHistoryArray.count > 0) {
        [self.searchHistoryFrames removeAllObjects];
        for (NSString *historyString in self.searchHistoryArray) {
            
            LPSearchHistoryItem *searchItem = [[LPSearchHistoryItem alloc] init];
            searchItem.historyString = historyString;
            LPSearchHistoryFrame *searchHistoryFrame = [[LPSearchHistoryFrame alloc] init];
            searchHistoryFrame.searchHistoryItem = searchItem;
            [self.searchHistoryFrames addObject:searchHistoryFrame];
        }
        [self.historyTableView reloadData];
    }

}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.hotWordArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    LPHotWordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotWordCellIdentifier forIndexPath:indexPath];
    cell.title = [self.hotWordArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        UILabel *label = [[UILabel alloc] init];
        [label setText:[self.hotWordArray objectAtIndex:indexPath.row]];
        [label sizeToFit];
        return CGSizeMake(label.frame.size.width + 10, label.frame.size.height + 10);
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LPHotWordCollectionViewCell *cell = (LPHotWordCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *searchText = cell.hotWordLabel.text;
    if ([searchText stringByTrimmingNewline].length > 0) {
        // 跳转到搜索界面
        LPSearchResultViewController *resultViewController = [[LPSearchResultViewController alloc] init];
        resultViewController.searchText = searchText;
        [self.navigationController pushViewController:resultViewController animated:YES];
    }
    
}


#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchHistoryFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPSearchHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LPSearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.searchHistoryFrame = self.searchHistoryFrames[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPSearchHistoryFrame *historyFrame = self.searchHistoryFrames[indexPath.row];
    return historyFrame.cellHeight;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LPSearchHistoryFrame *searchHistoryFrame = self.searchHistoryFrames[indexPath.row];
    NSString *searchText = searchHistoryFrame.searchHistoryItem.historyString;
    if ([searchText stringByTrimmingNewline].length > 0) {
        // 跳转到搜索界面
        LPSearchResultViewController *resultViewController = [[LPSearchResultViewController alloc] init];
        resultViewController.searchText = searchText;
        [self.navigationController pushViewController:resultViewController animated:YES];
    }
}

#pragma mark - 隐藏键盘
- (void)hideKeyboard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - viewDidDisappear
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
        [self setHistoryFrames];
       
    }
    
}

#pragma mark - 删除浏览历史
- (void)cleanHistoryButtonClick {
    [self.searchHistoryArray removeAllObjects];
    [self.searchHistoryFrames removeAllObjects];
    [self.historyTableView reloadData];
}
@end


