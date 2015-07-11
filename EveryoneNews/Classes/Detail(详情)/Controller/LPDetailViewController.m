//
//  LPDetailViewController.m
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//  header: imgUrl title updateTime

#import "LPDetailViewController.h"
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
#import "MobClick.h"
#import "LPCommentView.h"
#import "LPComposeViewController.h"
#import "LPComment.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"

#define CellAlpha 0.3

@interface LPDetailViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, LPContentCellDelegate, UIGestureRecognizerDelegate, LPZhihuViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat lastContentOffsetY;
@property (nonatomic, strong) UIButton *popBtn;
@property (nonatomic, strong) NSMutableArray *contentFrames;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, assign) CGFloat diffPercent;

@property (nonatomic, strong) NSIndexPath *watchingIndexPath;
@property (nonatomic, strong) NSArray *relates;

@property (nonatomic, copy) NSString *commentText;
@property (nonatomic, assign) BOOL shouldPush;
@property (nonatomic, assign) int realParaIndex;
@end

@implementation LPDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self setupDataWithCompletion:nil];
    [self setupNoteObserver];
}

- (void)setupNoteObserver
{
    [noteCenter addObserver:self selector:@selector(willComposeComment:) name:LPCommentWillComposeNotification object:nil];
    [noteCenter addObserver:self selector:@selector(didComposeComment) name:LPCommentDidComposeNotification object:nil];
    [noteCenter addObserver:self selector:@selector(reloadCell:) name:LPDetailVcShouldReloadDataNotification object:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DetailPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DetailPage"];
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

#pragma mark - request new data (if re-login, pass contents model to paraVc)
- (void)setupDataWithCompletion:(returnCommentsToUpBlock)block
{
    [self.contentFrames removeAllObjects];
    [sharedIndicator startAnimating];
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", ContentUrl, self.press.sourceUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    Account *account = [AccountTool account];
    if (account) {
        params[@"userId"] = account.userId;
        params[@"platformType"] = account.platformType;
    } else {
        params = nil;
    }
    [LPHttpTool getWithURL:url params:params success:^(id json) {
        [sharedIndicator stopAnimating];
        sharedIndicator.hidden = YES;
        // 0. json字典转模型
        NSString *headerImg = json[@"imgUrl"];
        NSString *title = json[@"title"];
        NSString *time = json[@"updateTime"];
        
        NSString *abstract = json[@"abs"];
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
        NSMutableArray *bodyArray = [NSMutableArray arrayWithArray:@[abstract]];
        for (NSString *str in rawArray) {
            if (![str isBlank]) {
                [bodyArray addObject:str];
            }
        }
        
        NSMutableArray *contents = [NSMutableArray array];

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
                    if (comment.paragraphIndex.intValue == i - 1 && [comment.type isEqualToString:@"text_paragraph"])
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
            [contents addObject:content];
            
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
        
        if (block) {
            block(contents);
        }
        
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
    
    self.diffPercent = 0.5;
    
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;

    headerImageView.clipsToBounds = YES;
//    headerImageView.frame = headerView.bounds;
    headerImageView.frame = CGRectMake(0, 0, headerView.width, TableHeaderImageViewH);
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    self.headerImageView = headerImageView;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(0, 0, ScreenWidth, TableHeaderImageViewH);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:maskLayer.bounds];
    maskLayer.path = path.CGPath;
    self.headerImageView.layer.mask = maskLayer;
    self.maskLayer = maskLayer;
    
    // 颜色版加在headerImageView上
    UIView *filterView = [[UIView alloc] init];
    filterView.frame = headerImageView.bounds;
    filterView.backgroundColor = [UIColor colorFromCategory:self.press.category alpha:0.2];
    self.filterView = filterView;
    [headerImageView addSubview:filterView];
    
    // 渐变加在headerView上
    UIImageView *hud = [[UIImageView alloc] init];
    hud.image = [UIImage imageNamed:@"渐变"];
    hud.alpha = 0.6;
    CGFloat hudH = headerViewH * 0.4;
    CGFloat hudY = CGRectGetMaxY(headerImageView.frame) - hudH;
    hud.frame = CGRectMake(0, hudY, ScreenWidth, hudH);
    
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
    if ([self.press.category isEqualToString:@"财经"]) {
        zhihuView.backgroundColor = [UIColor whiteColor];
    } else {
        zhihuView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:250/255.0 alpha:0.9];
    }

    [footerView addSubview:zhihuView];
    
    
    CGFloat footerH = 0.0;
    if (zhihuView.hidden == NO) {
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
    cell.layer.shadowOpacity = 0.24f;
    cell.layer.shadowRadius = 3.0;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    cell.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.layer.zPosition = 999.0;
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

/**
 *  头图视差效果
 *
 *  @param scrollView tableView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.lastContentOffsetY < scrollView.contentOffset.y ? [self fadeOut] : [self fadeIn];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) { // 内切时，放大头部imageView及其颜色蒙版
        CGFloat scale = - offsetY / TableHeaderViewH + 1;
        CGFloat w = ScreenWidth * scale;
        CGFloat offsetX = (w - ScreenWidth) / 2;
        
        self.headerImageView.frame = CGRectMake(- offsetX, offsetY, w, TableHeaderImageViewH -  offsetY);
        self.filterView.frame = self.headerImageView.bounds;
        self.headerImageView.layer.mask = nil;
    } else { // 向上拖动时，控制视差并添加遮盖
        if (offsetY < TableHeaderViewH) {
            CGFloat diff = self.diffPercent * offsetY;
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, ScreenWidth, TableHeaderImageViewH - diff)];
            self.maskLayer.path = path.CGPath;
            self.headerImageView.layer.mask = self.maskLayer;
            self.headerImageView.frame = CGRectMake(0, diff, ScreenWidth, TableHeaderImageViewH);
            self.filterView.frame = self.headerImageView.bounds;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
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

#pragma mark - push para comment view controller
- (void)pushParaVcWithContent:(LPContent *)content
{
    LPParaCommentViewController *paraVc = [[LPParaCommentViewController alloc] init];
    paraVc.comments = content.comments;
    paraVc.bgImage = [UIImage captureWithView:self.view];
    paraVc.category = content.category;
    paraVc.contentIndex = content.paragraphIndex;
    paraVc.fromVc = self;
    paraVc.commentText = self.commentText;
    paraVc.press = self.press;
    [self.navigationController pushViewController:paraVc animated:NO];
}

#pragma mark - LPContentCell delegate

- (void)contentCellDidClickCommentView:(LPContentCell *)cell
{
    LPContent *content = cell.contentFrame.content;
    NSArray *comments = content.comments;
    if (comments.count) {
        [self pushParaVcWithContent:content];
    }
}

#pragma mark - LPZhihuView delegate

- (void)zhihuView:(LPZhihuView *)zhihuView didClickURL:(NSString *)url
{
    [LPPressTool loadWebViewWithURL:url viewController:self];
}

#pragma mark - notification selector will compose comment
- (void)willComposeComment:(NSNotification *)note
{
    if (![AccountTool account]) {
        __weak typeof(self) weakSelf = self;
        [AccountTool accountLoginWithViewController:self.navigationController.topViewController
        success:^{
            [MBProgressHUD showSuccess:@"登录成功"];
            [weakSelf performSelector:@selector(pushCommentComposeVcWithNote:) withObject:note afterDelay:0.6];
        } failure:^{
            [MBProgressHUD showError:@"登录失败"];
        } cancel:nil];
    } else {
        [self pushCommentComposeVcWithNote:note];
    }
}

- (void)pushCommentComposeVcWithNote:(NSNotification *)note
{
    NSDictionary *info = note.userInfo;
    int paraIndex = [info[LPComposeParaIndex] intValue];
    self.realParaIndex = paraIndex;
    LPContentFrame *contentFrame = self.contentFrames[paraIndex];
    LPContent *content = contentFrame.content;
    LPComposeViewController *composeVc = [[LPComposeViewController alloc] init];
    composeVc.category = content.category;
    composeVc.draftText = self.commentText;
    [composeVc returnText:^(NSString *text) {
        self.commentText = text;
    }];
    [self.navigationController pushViewController:composeVc animated:YES];
}

#pragma mark - notification selector did compose comment
/**
 *  评论发送后的处理
 */
- (void)didComposeComment
{
    // 1. 刷新当前页
//    LPContent *content = self.commentContent;
    LPContentFrame *contentFrame = self.contentFrames[self.realParaIndex];
    LPContent *content = contentFrame.content;

    Account *account = [AccountTool account];
    NSMutableArray *commentArray = [NSMutableArray arrayWithArray:content.comments];
    // 1.1 创建comment对象
    LPComment *comment = [[LPComment alloc] init];
    comment.sourceUrl = self.press.sourceUrl;
    comment.srcText = self.commentText;
    comment.category = content.category;
    comment.paragraphIndex = [NSString stringFromIntValue:content.paragraphIndex - 1];
    comment.type = @"text_paragraph";
    comment.uuid = account.userId;
    comment.userIcon = account.userIcon;
    comment.userName = account.userName;
    comment.createTime = [NSString stringFromNowDate];
    
    comment.up = @"0";
    comment.isPraiseFlag = @"0";
    
    if (self.navigationController.viewControllers.count == 4) {
        self.shouldPush = YES;
    } else {
        self.shouldPush = NO;
    }
    // 2. 发送post请求
    NSString *url = [NSString stringWithFormat:@"%@/news/baijia/point", ServerUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sourceUrl"] = self.press.sourceUrl;
    params[@"srcText"] = comment.srcText;
    params[@"paragraphIndex"] = comment.paragraphIndex;
    params[@"type"] = comment.type;
    params[@"uuid"] = comment.uuid;
    params[@"userIcon"] = comment.userIcon;
    params[@"userName"] = comment.userName;
    params[@"desText"] = content.body;

    [LPHttpTool postWithURL:url params:params success:^(id json) {
        // 1.2 更新content对象
        content.hasComment = YES;
        comment.commentId = json[@"commentId"];
        [commentArray addObject:comment];
        content.comments = commentArray;
        content.paragraphIndex = self.realParaIndex;
        contentFrame.content = content;
        [self.tableView reloadData];
        // 发送成功，通知首页，使无评论图标的对应卡片显示评论图标
        [noteCenter postNotificationName:LPCommentDidComposeSuccessNotification object:self];
        
        if (self.shouldPush) {
            NSDictionary *info = @{LPComposeComment:comment};
            [noteCenter postNotificationName:LPParaVcRefreshDataNotification object:self userInfo:info];
        }
        // 3. 清空草稿
        self.commentText = nil;
        [MBProgressHUD showSuccess:@"发表成功"];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"发表失败"];
    }];
}


- (void)dealloc
{
    [noteCenter removeObserver:self];
}


# pragma mark - handle unLogin up comment
- (void)returnContentsBlock:(returnCommentsToUpBlock)returnBlock
{
    [self setupDataWithCompletion:returnBlock];
}

#pragma mark - notification selector reload cell
- (void)reloadCell:(NSNotification *)note
{
//    NSNumber *rowNum = note.userInfo[LPReloadCellIndex];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNum.integerValue inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

@end
