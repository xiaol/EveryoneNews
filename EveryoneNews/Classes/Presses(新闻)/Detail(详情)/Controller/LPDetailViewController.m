//
//  LPDetailViewController.m
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//  header: imgUrl title updateTime

#import "LPDetailViewController.h"
#import "LPNavigationController.h"
#import "LPPress.h"
#import "MJExtension.h"
#import "LPHttpTool.h"
#import "LPContent.h"
#import "LPContentFrame.h"
#import "LPComment.h"
#import "LPZhihuPoint.h"
#import "LPWeiboPoint.h"
#import "LPRelatePoint.h"
#import "LPContentCell.h"
#import "UIImageView+WebCache.h"
#import "LPZhihuView.h"
#import "LPWaterfallView.h"
#import "LPRelateCell.h"
#import "LPParaCommentViewController.h"
#import "LPPressTool.h"

#define CellAlpha 0.3

@interface LPDetailViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, LPContentCellDelegate, LPWaterfallViewDataSource, LPWaterfallViewDelegate, UIGestureRecognizerDelegate, LPZhihuViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat lastContentOffsetY;
@property (nonatomic, strong) UIButton *popBtn;
@property (nonatomic, strong) NSMutableArray *contentFrames;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *filterView;

@property (nonatomic, strong) NSIndexPath *watchingIndexPath;
@property (nonatomic, strong) NSArray *relates;

@end

@implementation LPDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self setupData];
}

- (NSArray *)relates
{
    if (_relates == nil) {
        self.relates = [NSArray array];
    }
    return _relates;
}

- (void)setupSubviews
{
    // 初始化tableview
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    tableView.backgroundColor = [UIColor colorFromHexString:TableViewBackColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 出栈button
    UIButton *popBtn = [[UIButton alloc] initWithFrame:CGRectMake(22, 44, 35, 35)];
    [popBtn setImage:[UIImage resizedImageWithName:@"back"] forState:UIControlStateNormal];
    popBtn.backgroundColor = [UIColor clearColor];
    popBtn.alpha = 0.8;
    [popBtn addTarget:self action:@selector(popBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
    self.popBtn = popBtn;
    // 菊花
    sharedIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    sharedIndicator.center = self.view.center;
    sharedIndicator.bounds = CGRectMake(0, 0, ScreenWidth / 4, ScreenWidth / 4);
    [self.view addSubview:sharedIndicator];
}

- (NSMutableArray *)contentFrames
{
    if (_contentFrames == nil) {
        _contentFrames = [NSMutableArray array];
    }
    return _contentFrames;
}

- (void)popBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupData
{
    [self.contentFrames removeAllObjects];
    [sharedIndicator startAnimating];
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", ContentUrl, self.press.sourceUrl];
    [LPHttpTool getWithURL:url params:nil success:^(id json) {
        [sharedIndicator stopAnimating];
        sharedIndicator.hidden = YES;
        // 0. json字典转模型
        NSString *headerImg = json[@"imgUrl"];
        NSString *title = json[@"title"];
        NSString *time = json[@"updateTime"];
        
        NSString *totalBody = json[@"content"];
        NSArray *commentArray = [LPComment objectArrayWithKeyValuesArray:json[@"point"]];
        
        NSArray *baikeArray = [LPWeiboPoint objectArrayWithKeyValuesArray:json[@"baike"]];
        NSArray *zhihuArray = [LPZhihuPoint objectArrayWithKeyValuesArray:json[@"zhihu"]];
        NSArray *doubanArray = [LPWeiboPoint objectArrayWithKeyValuesArray:json[@"douban"]];
        NSArray *weiboArray = [LPWeiboPoint objectArrayWithKeyValuesArray:json[@"weibo"]];
        NSArray *relateArray = [LPRelatePoint objectArrayWithKeyValuesArray:json[@"relate"]];
        // 1. header图像及标题的赋值
        [weakSelf setupHeaderWithImageURL:headerImg title:title time:time];
        
        // 2. 每段正文及其评论赋值
        NSArray *rawArray = [totalBody componentsSeparatedByString:@"\n"];
        NSMutableArray *bodyArray = [NSMutableArray array];
        for (NSString *str in rawArray) {
            if (![str isBlank]) {
                [bodyArray addObject:str];
            }
        }
        
        NSMutableArray *contentFrameArray = [NSMutableArray array];
        
        CGFloat contentH[bodyArray.count];
        CGFloat offsetSum[bodyArray.count];
        for (int k = 0 ; k < bodyArray.count; k++) {
            contentH[k] = 0.0;
            offsetSum[k] = 0.0;
        }
        for (int i = 0; i < bodyArray.count; i++) {
            // 2.1 正文
            LPContent *content = [[LPContent alloc] init];
            content.paragraphIndex = i;
            content.body = bodyArray[i];
            content.category = self.press.category;
            NSMutableArray *comments = [NSMutableArray array];
            if (i == 0) {
                content.isAbstract = YES;
            } else {
                content.isAbstract = NO;
            }
            // 2.2 评论
            if (!weakSelf.press.isCommentsFlag || content.isAbstract || commentArray.count == 0)
            { // 首页给的数据 如果该标志为0 表示没有任何评论 & 摘要暂时无评论
                content.hasComment = NO;
            } else {
                // 遍历point数组 根据索引确定每段的评论列表
                for (LPComment *comment in commentArray) {
                    if (comment.paragraphIndex.intValue == (i-1) && [comment.type isEqualToString:@"text_paragraph"])
                    {
                        [comments addObject:comment];
                    }
                }
                content.hasComment = (comments.count > 0);
                content.comments = comments;
            }
            LPContentFrame *contentFrame = [[LPContentFrame alloc] init];
            contentFrame.content = content;
            [contentFrameArray addObject:contentFrame];
            
            contentH[i] = contentFrame.cellHeight;
        }
        // 2.3 传递数据给contentFrames属性
        weakSelf.contentFrames = contentFrameArray;
        // 2.4 得到每个cell对应的offsetY值
//        for (int i = 1; i < contentFrameArray.count; i ++) {
//            offsetSum[i] = contentH[i-1] + offsetSum[i-1];
//        }
//        for (int i = 0; i < contentFrameArray.count; i++) {
//            offsetSum[i] += TableHeaderViewH;
//        }
//        self.offset = offsetSum;
//        for (int i = 0; i < contentFrameArray.count; i++) {
//            NSLog(@"offset[%d] = %.2f", i, self.offset[i]);
//        }
        
        // 3. 尾部数据的赋值
        [weakSelf setupFooterWithBaike:baikeArray Zhihu:zhihuArray douban:doubanArray weibo:weiboArray relate:relateArray];
        
        // 4. 刷新tableView
        [weakSelf.tableView reloadData];
        
//        // 5. 默认看第一个
//        detailVc.watchingIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    } failure:^(NSError *error) {
        [sharedIndicator stopAnimating];
        NSLog(@"Failure: %@", error);
    }];
}

# pragma mark - header view setting up
- (void)setupHeaderWithImageURL:(NSString *)imageURL title:(NSString *)title time:(NSString *)time
{
    UIView *headerView = [[UIView alloc] init];
    CGFloat headerViewH = TableHeaderViewH;
    headerView.frame = CGRectMake(0, 0, ScreenWidth, headerViewH);
    
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.clipsToBounds = YES;
//    headerImageView.frame = headerView.bounds;
    headerImageView.frame = CGRectMake(0, 0, headerView.width, TableHeaderImageViewH);
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    self.headerImageView = headerImageView;
    
    UIView *filterView = [[UIView alloc] init];
    filterView.frame = headerImageView.bounds;
    filterView.backgroundColor = [UIColor colorFromCategory:self.press.category alpha:0.24];
    self.filterView = filterView;
    [headerImageView addSubview:filterView];
    
    UIImageView *hud = [[UIImageView alloc] init];
    hud.image = [UIImage imageNamed:@"渐变"];
    hud.alpha = 0.2;
    CGFloat hudH = headerViewH * 0.4;
    CGFloat hudY = CGRectGetMaxY(headerImageView.frame) - hudH;
    hud.frame = CGRectMake(0, hudY, ScreenWidth, hudH);
//    [headerImageView addSubview:hud];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    NSMutableAttributedString *titleString = [title attributedStringWithFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:20] color:[UIColor whiteColor] lineSpacing:5];
    CGFloat titleX = 20;
    CGFloat titleW = ScreenWidth - titleX * 2;
    CGFloat titleH = [titleString heightWithConstraintWidth:titleW];
    CGFloat titleY = TableHeaderViewH - 9 - titleH;
    titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    titleLabel.attributedText = titleString;
    
    [headerView addSubview:headerImageView];
    [headerView addSubview:hud];
    [headerView addSubview:titleLabel];
    
    self.tableView.tableHeaderView = headerView;
    [self.tableView sendSubviewToBack:headerView];
}

# pragma mark - footer view setting up
- (void)setupFooterWithBaike:(NSArray *)baikeArray Zhihu:(NSArray *)zhihuArray douban:(NSArray *)doubanArray weibo:(NSArray *)weiboArray relate:(NSArray *)relateArray
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorFromHexString:TableViewBackColor];
    
    LPZhihuView *zhihuView = [[LPZhihuView alloc] init];
    if (zhihuArray && zhihuArray.count > 0) {
        zhihuView.hidden = NO;
        zhihuView.frame = CGRectMake(DetailCellPadding, 0, DetailCellWidth, [zhihuView heightWithPointsArray:zhihuArray]);
        zhihuView.zhihuPoints = zhihuArray;
    } else {
        zhihuView.hidden = YES;
    }
    zhihuView.delegate = self;
    [footerView addSubview:zhihuView];
    
    LPWaterfallView *waterfallView = [[LPWaterfallView alloc] init];
    if (relateArray && relateArray.count > 0) {
        self.relates = relateArray;
        waterfallView.backgroundColor = [UIColor whiteColor];
        CGFloat waterfallY = CGRectGetMaxY(zhihuView.frame) + DetailCellHeightBorder;
        waterfallView.hidden = NO;
        NSUInteger numberOfCells = relateArray.count;
        int numberOfColumns = 2;
        CGFloat topM = 15;
        CGFloat bottomM = 20;
        CGFloat leftM = 10;
        CGFloat columnM = 10;
        CGFloat rowM = 8;
        CGFloat rightM = leftM;
        CGFloat cellW = (DetailCellWidth - leftM - rightM - (numberOfColumns - 1) * columnM) / numberOfColumns;
        // 用数组maxYOfColumns存放所有列的最大Y值
        CGFloat maxYOfColumns[numberOfColumns];
        for (int i = 0; i<numberOfColumns; i++) {
            maxYOfColumns[i] = 0.0;
        }
        
        int k = 1;
        // 计算所有cell的frame
        for (int i = 0; i < numberOfCells; i++, k++) {
            // cell处在最短的一列, minMaxYOfCellColumn记录各列最大Y值中的最小值, cellColumn表示该列序号
            NSUInteger cellColumn = 0;
            CGFloat minMaxYOfCellColumn = maxYOfColumns[cellColumn];
            
            if (maxYOfColumns[1] < minMaxYOfCellColumn) {
                cellColumn = 1;
                minMaxYOfCellColumn = maxYOfColumns[1];
            }
            LPRelatePoint *relate = relateArray[i];
            CGFloat cellH = cellW * 0.7;
            if (relate.height) {
                cellH = cellW * relate.height.floatValue / relate.width.floatValue;
            }
            CGFloat cellY = 0;
            if (minMaxYOfCellColumn == 0.0) {
                cellY = topM;
            } else {
                cellY = minMaxYOfCellColumn + rowM;
            }
            maxYOfColumns[cellColumn] = cellY + cellH;
        }
        CGFloat contentH = MAX(maxYOfColumns[0], maxYOfColumns[1]);
        contentH += bottomM;
        waterfallView.dataSource = self;
        waterfallView.delegate = self;
        waterfallView.scrollEnabled = YES;
        waterfallView.frame = CGRectMake(DetailCellPadding, waterfallY, DetailCellWidth, contentH);
    } else {
        waterfallView.hidden = YES;
    }
    [footerView addSubview:waterfallView];
    
    CGFloat footerH = 0.0;
    if (waterfallView.hidden == NO) {
        footerH = CGRectGetMaxY(waterfallView.frame);
    } else if (zhihuView.hidden == NO) {
        footerH = CGRectGetMaxY(zhihuView.frame);
    }
    
    footerView.frame = CGRectMake(0, 0, ScreenWidth, footerH);
    self.tableView.tableFooterView = footerView;
}

- (void)fadeIn
{
    [UIView animateWithDuration:0.8 animations:^{
        self.popBtn.alpha = 0.8;
    }];
}

- (void)fadeOut
{
    [UIView animateWithDuration:0.8 animations:^{
        self.popBtn.alpha = 0.4;
    }];
}

- (void)setWatchingIndexPath:(NSIndexPath *)watchingIndexPath
{
    if (_watchingIndexPath == nil) {
        LPContentCell *cell = (LPContentCell *)[self.tableView cellForRowAtIndexPath:watchingIndexPath];
        cell.contentView.alpha = 1.0;
    }
    if (_watchingIndexPath.row != watchingIndexPath.row)
    {
        LPContentCell *pastCell = (LPContentCell *)[self.tableView cellForRowAtIndexPath:_watchingIndexPath];
        pastCell.contentView.alpha = CellAlpha;
        LPContentCell *cell = (LPContentCell *)[self.tableView cellForRowAtIndexPath:watchingIndexPath];
        cell.contentView.alpha = 1.0;
    }
    _watchingIndexPath = watchingIndexPath;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPContentCell *cell = [LPContentCell cellWithTableView:tableView];
    cell.contentFrame = self.contentFrames[indexPath.row];
    cell.delegate = self;
//    if (indexPath.row == self.watchingIndexPath.row) {
//        cell.contentView.alpha = 1.0;
//    } else {
//        cell.contentView.alpha = CellAlpha;
//    }
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPContentFrame *contentFrame = self.contentFrames[indexPath.row];
    return contentFrame.cellHeight;
}

#pragma mark - Scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollView.scrollEnabled = YES;
    self.lastContentOffsetY = self.tableView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    self.lastContentOffsetY < scrollView.contentOffset.y ? [self fadeOut] : [self fadeIn];
    
    
    if (scrollView.contentOffset.y < 0) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat diffY = 0.0;
        CGFloat scale = (diffY - offsetY) / TableHeaderViewH + 1;
        CGFloat w = ScreenWidth * scale;
        CGFloat offsetX = (w - ScreenWidth) / 2;
        
        self.headerImageView.frame = CGRectMake(- offsetX, offsetY, w, TableHeaderImageViewH -  offsetY + diffY);
        self.filterView.frame = self.headerImageView.bounds;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollView.contentOffset.y = %.2f", scrollView.contentOffset.y);
    
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (decelerate == YES && self.contentFrames.count > 1) {
//        CGFloat watchingCellHeight = [self tableView:self.tableView heightForRowAtIndexPath:self.watchingIndexPath];
//        NSUInteger row = self.watchingIndexPath.row;
//        // 1. 向下看
//        CGFloat deltaOffset = scrollView.contentOffset.y - self.lastContentOffsetY;
//        if (deltaOffset > 0) {
//            if (row == 0)
//            {
//                if (scrollView.contentOffset.y > offset[1] - 10.0) {
//                    self.watchingIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
//                     [scrollView setContentOffset:CGPointMake(0.0, offset[1]) animated:YES];
//                    [scrollView setContentOffset:CGPointMake(0.0, 300) animated:YES];
//                }
//            } else {
//                if (row + 1 < self.contentFrames.count) {
//                    if (deltaOffset > watchingCellHeight * 0.5 || offset[row + 1] - scrollView.contentOffset.y < 10.0 || offset[row + 1] < scrollView.contentOffset.y) {// 一次性滑动距离超过半个cell，或者offset接近其offset值，watchingIndex + 1; 否则，滚回原位置
//                        self.watchingIndexPath = [NSIndexPath indexPathForRow:row + 1 inSection:0];
//                        [scrollView setContentOffset:CGPointMake(0.0, offset[row + 1]) animated:YES];
//                    } else {
//                        [scrollView setContentOffset:CGPointMake(0.0, offset[row]) animated:YES];
//                    }
//                }
//            }
//        }
//        // 2. 向上看
//        if (deltaOffset < 0) {
//            if (row == 1)
//            {
//                if (scrollView.contentOffset.y < offset[0] * 0.5) {
//                    self.watchingIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                    // [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
//    //            } else if () {
//                    
//                }
//            } else if (row > 1) {
//                
//            }
//        }
//    }
//}

#pragma mark - LPWaterfall view data source
- (NSUInteger)numberOfCellsInWaterfallView:(LPWaterfallView *)waterfallView
{
    return self.relates.count;
}

- (LPRelateCell *)waterfallView:(LPWaterfallView *)waterfallView cellAtIndex:(NSUInteger)index
{
    LPRelateCell *cell = [LPRelateCell cellWithWaterfallView:waterfallView];
    
    cell.relatePoint = self.relates[index];
    
    return cell;
}

- (NSUInteger)numberOfColumnsInWaterfallView:(LPWaterfallView *)waterfallView
{
    return 2;
}


#pragma mark - LPWaterfall view delegate
- (CGFloat)waterfallView:(LPWaterfallView *)waterfallView marginForType:(LPWaterfallViewMarginType)type
{
    switch (type) {
        case LPWaterfallViewMarginTypeTop: return 15;
        case LPWaterfallViewMarginTypeBottom: return 20;
        case LPWaterfallViewMarginTypeLeft: return 10;
        case LPWaterfallViewMarginTypeRight: return 10;
        case LPWaterfallViewMarginTypeColumn: return 20;
        case LPWaterfallViewMarginTypeRow: return 8;
        default:
            return 10;
    }
}

- (CGFloat)waterfallView:(LPWaterfallView *)waterfallView heightAtIndex:(NSUInteger)index
{
    LPRelatePoint *relate = self.relates[index];
    if (relate.height) {
        return waterfallView.cellWidth * relate.height.floatValue / relate.width.floatValue;
    } else { // 没提供宽高
        return waterfallView.cellWidth * 0.7;
    }
}

- (void)waterfallView:(LPWaterfallView *)waterfallView didSelectAtIndex:(NSUInteger)index
{
    LPRelatePoint *relate = self.relates[index];
    [LPPressTool loadWebViewWithURL:relate.url viewController:self];
}

#pragma mark - LPContentCell delegate

- (void)contentCellDidClickCommentView:(LPContentCell *)cell
{
    LPContent *content = cell.contentFrame.content;
    NSArray *comments = content.comments;
    LPParaCommentViewController *paraVc = [[LPParaCommentViewController alloc] init];
    paraVc.comments = comments;
    paraVc.bgImage = [UIImage captureWithView:self.view];
    paraVc.category = content.category;
    [self presentViewController:paraVc animated:NO completion:^{
        
    }];
}

#pragma mark - LPZhihuView delegate

- (void)zhihuView:(LPZhihuView *)zhihuView didClickURL:(NSString *)url
{
    [LPPressTool loadWebViewWithURL:url viewController:self];
}

- (void)dealloc
{
    NSLog(@"xxx");
}
@end
