//
//  LPDetailViewController.m
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//  header: imgUrl title updateTime

#import "LPDetailViewController.h"
#import "LPPress.h"
#import "LPContent.h"
#import "LPContentFrame.h"
#import "LPComment.h"
#import "LPZhihuPoint.h"
#import "LPWeiboPoint.h"
#import "LPContentCell.h"
#import "UIImageView+WebCache.h"
#import "LPZhihuView.h"
#import "LPWaterfallView.h"
#import "LPPressTool.h"
#import "LPCommentView.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "LPConcernPress.h"
#import "LPConcern.h"
#import "LPPhoto.h"
#import "LPPhotoCell.h"
#import "MainNavigationController.h"
#import "LPRelateView.h"
#import "CardFrame.h"
#import "CardImage.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "MobClick.h"
#import "LPShareView.h"
#import "LPShareViewController.h"
#import "LPShareCell.h"
#import "LPCommentCell.h"
#import "LPRelateCell.h"
#import "LPDetailViewController+Share.h"
#import "LPDetailViewController+RelatePoint.h"
#import "LPDetailViewController+FulltextComment.h"
#import "LPFontSizeManager.h"
#import "UIControl+Swizzle.h"
#import "NSTimer+Additions.h"
#import "LPRelatePointFooter.h"
#import <libkern/OSAtomic.h>


static const NSString * privateContext;
static const NSString * fulltextContext;
static const CGFloat padding = 13.0f;
const static CGFloat headerViewHeight = 40;
const static CGFloat footerViewHeight = 59;
const static CGFloat relatePointCellHeight = 79;

static int imageDownloadCount;

@interface LPDetailViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,LPRelateCellDelegate, LPDetailTopViewDelegate, LPShareViewDelegate,LPDetailBottomViewDelegate, LPShareCellDelegate, LPContentCellDelegate>

@property (nonatomic, assign) CGFloat lastContentOffsetY;

@property (nonatomic, strong) NSMutableArray *contentArray;

@property (nonatomic, strong) NSArray *relates;

@property (nonatomic, strong) LPHttpTool *http;

@property (nonatomic, strong)   UIImageView *animationImageView;

@property (nonatomic, strong) UILabel *loadingLabel;

@property (nonatomic, strong) UIView *contentLoadingView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger stayTimeInterval;

@property (nonatomic, strong) NSMutableDictionary *contentDictionary;

@property (nonatomic, strong) NSMutableDictionary *heightDictionary;

@property (nonatomic, strong) NSMutableArray *contentFrames;

//@property (nonatomic, assign, getter=isrefreshTableView) BOOL refreshTableView;

@end

@implementation LPDetailViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    [self setupSubviews];
    [self setupBottomView];
    [self setupCardData];
    [self setupDetailData];
    [self setupCommentsData];
    [self setupRelateData];
    
    
    
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 友盟统计打开详情页次数
//    [MobClick beginLogPageView:@"DetailPage"];
    
    self.stayTimeInterval = 0;
    [self startTimer];
}

#pragma mark - 开启定时器
- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeating:YES firing:^{
    self.stayTimeInterval++;
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
}

#pragma mark - 清空定时器
- (void)endTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:@"DetailPage"];
    [self endTimer];
    // 提交用户日志
    [self submitUserOperationLog];

}

#pragma mark - 上传用户操作日志
- (void)submitUserOperationLog {
    
    NSString *uid= (NSString *)[userDefaults objectForKey:@"uuid"];
    NSString *cou = @""; // 国家
    NSString *pro = @""; // 省
    NSString *cit = @""; // 城市
    NSString *dis = @""; // 区，县
    NSString *clas = @"0"; // 0 表示详情页，1表示列表页上报
    NSString *nid = [self.card valueForKey:@"newId"];
    NSString *cid = self.channelID; // 频道编号
    NSString *tid= @""; // 包含置顶，热点 推荐 订阅 图片 兴趣探索 推广
    NSString *stime = [NSString stringWithFormat:@"%ld",(long)self.stayTimeInterval];
    NSString *sltime = @"";
    NSString *from = @"1"; // 1表示列表页

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:nid forKey:@"nid"];
    [dic setObject:cid forKey:@"cid"];
    [dic setObject:tid forKey:@"tid"];
    [dic setObject:stime forKey:@"stime"];
    [dic setObject:sltime forKey:@"sltime"];
    [dic setObject:from forKey:@"from"];
    
    NSString *url = @"http://bdp.deeporiginalx.com/rep";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = uid;
    params[@"cou"] = cou;
    params[@"pro"] = pro;
    params[@"cit"] = cit;
    params[@"dis"] = dis;
    params[@"clas"] = clas;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    params[@"data"] = [jsonData base64EncodedStringWithOptions:0];
    if (!error) {
        self.http = [LPHttpTool http];
        [self.http getImageWithURL:url params:params success:^(id json) {
           //NSLog(@"stime:%@", stime);
        } failure:^(NSError *error) {
        }];
    }
}

#pragma mark - viewDidDisappear
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.http) {
        [self.http cancelRequest];
        self.http = nil;
    }
    
}

#pragma mark - 设置状态栏样式
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - 懒加载
- (NSArray *)relates
{
    if (_relates == nil) {
        _relates = [NSArray array];
    }
    return _relates;
}

- (NSMutableArray *)relatePointFrames {
    if (!_relatePointFrames) {
        _relatePointFrames = [NSMutableArray array];
    }
    return _relatePointFrames;
}

- (NSMutableArray *)contentArray {
    if (!_contentArray) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}

- (NSMutableArray*)fulltextCommentFrames {
    if (_fulltextCommentFrames == nil) {
        _fulltextCommentFrames = [NSMutableArray array];
    }
    return _fulltextCommentFrames;
}

- (NSMutableDictionary *)contentDictionary {
    if (_contentDictionary == nil) {
        _contentDictionary = [NSMutableDictionary dictionary];
    }
    return _contentDictionary;
}

- (NSMutableDictionary *)heightDictionary {
    if (_contentDictionary == nil) {
        _contentDictionary = [NSMutableDictionary dictionary];
    }
    return _contentDictionary;

}

- (NSMutableArray *)contentFrames {
    if (_contentFrames == nil) {
        _contentFrames = [NSMutableArray array];
    }
    return _contentFrames;
}

#pragma mark - 顶部视图隐藏和显示
- (void)fadeIn
{
    [UIView animateWithDuration:0.1 animations:^{
        self.topView.alpha = 0.9;
    }];
}

- (void)fadeOut
{
    [UIView animateWithDuration:0.1 animations:^{
        self.topView.alpha = 0.0;;
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        self.lastContentOffsetY = self.tableView.contentOffset.y;
    }
}

#pragma mark - scrollViewDidScroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        self.lastContentOffsetY < scrollView.contentOffset.y ? [self fadeOut] : [self fadeIn];
    }
}

#pragma mark - 返回上一界面
-(void)backButtonDidClick:(LPDetailTopView *)detailTopView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)viewDidLayoutSubviews {
//    
//}

#pragma mark - 创建视图
- (void)setupSubviews {
    
    // 文章内容
    UITableView *tableView = [[UITableView alloc] initWithFrame: CGRectMake(BodyPadding, 20, ScreenWidth - BodyPadding * 2, ScreenHeight - 44) style:UITableViewStyleGrouped];
    //tableView.frame = CGRectMake(BodyPadding, 20, ScreenWidth - BodyPadding * 2, ScreenHeight - 65);
    tableView.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.hidden = YES;
 
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
 
    __weak typeof(self) weakSelf = self;
    // 上拉加载更多
    self.tableView.footer = [LPRelatePointFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreRelateData];
    }];
    
    // 顶部视图
    LPDetailTopView *topView = [[LPDetailTopView alloc] initWithFrame: self.view.bounds];
    topView.delegate = self;
    [self.view addSubview:topView];
    self.topView = topView;
    
    [self setupLoadingView];
    [self showLoadingView];
}

#pragma mark - Loading View
- (void)setupLoadingView {
    CGFloat statusBarHeight = 20.0f;
    CGFloat menuViewHeight = 44.0f;
    if (iPhone6Plus) {
        menuViewHeight = 51;
    }
    
    UIView *contentLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight + menuViewHeight, ScreenWidth, ScreenHeight - statusBarHeight - menuViewHeight)];
    
    // Load images
    NSArray *imageNames = @[@"xl_1", @"xl_2", @"xl_3", @"xl_4"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    // Normal Animation
    UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 36) / 2, (ScreenHeight - statusBarHeight - menuViewHeight) / 3, 36 , 36)];
    animationImageView.animationImages = images;
    animationImageView.animationDuration = 1;
    [self.view addSubview:animationImageView];
    self.animationImageView = animationImageView;
    contentLoadingView.hidden = YES;
    [contentLoadingView addSubview:animationImageView];
    [self.view addSubview:contentLoadingView];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(animationImageView.frame), ScreenWidth, 40)];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"正在努力加载...";
    loadingLabel.font = [UIFont systemFontOfSize:12];
    loadingLabel.textColor = [UIColor colorFromHexString:@"#999999"];
    [contentLoadingView addSubview:loadingLabel];
    self.loadingLabel = loadingLabel;
    
    self.contentLoadingView = contentLoadingView;
    
}

#pragma mark - 首页显示正在加载提示
- (void)showLoadingView {
    [self.animationImageView startAnimating];
    self.loadingLabel.hidden = NO;
    self.contentLoadingView.hidden = NO;
    
}


#pragma mark - 首页隐藏正在加载提示
- (void)hideLoadingView {
    
    [self.animationImageView stopAnimating];
    self.loadingLabel.hidden = YES;
    self.contentLoadingView.hidden = YES;
}

#pragma mark - 创建底部视图
- (void)setupBottomView {
    LPDetailBottomView *bottomView = [[LPDetailBottomView alloc] initWithFrame:CGRectZero];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
}

#pragma mark - 获取Card内容
- (void)setupCardData {
    
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Card *card = (Card *)[cdh.context existingObjectWithID:self.cardID error:nil];
    self.card = card;
    self.docId = [self.card valueForKey:@"docId"];
    self.channelID = [self.card valueForKey:@"channelId"];
    
}

#pragma mark - 加载详情页正文数据
- (void)setupDetailData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 加载详情页数据
    NSString *url = @"http://api.deeporiginalx.com/bdp/news/content";
    // 必须通过kvc方式获取，否则会有bug
    params[@"url"] = [self.card valueForKey:@"newId"];
    // 分享页面地址
    self.shareURL = [NSString stringWithFormat:@"http://deeporiginalx.com/news.html?type=0&url=%@&interface", params[@"url"]];
    NSLog(@"%@?url=%@", url, params[@"url"]);
    
    [self getDetailDataWithUrl:url params:params];
}

- (void)getDetailDataWithUrl:(NSString *)url params:(NSDictionary *)params {
    
    __block BOOL isRefreshTableView = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!isRefreshTableView) {
            
//            NSLog(@"8 times");
            [self.tableView reloadData];
        }
        
    });
    
    [LPHttpTool getWithURL:url params:params success:^(id json) {
        
        NSDictionary *dict = json[@"data"];
        NSString *title = dict[@"title"];
        NSString *pubTime = dict[@"pubTime"];
        NSString *pubName = dict[@"pubName"];
        
        self.shareTitle = title;
        self.docId = dict[@"docid"];
         // 更新详情页评论数量
        self.commentsCount = [dict[@"commentSize"] integerValue];
        self.topView.badgeNumber = self.commentsCount;
        self.bottomView.badgeNumber = self.commentsCount ;
     
        [self setupHeaderView:title pubTime:pubTime pubName:pubName];
        
        NSArray *bodyArray = dict[@"content"];
        
        // 第一个图片作为分享图片
        for (NSDictionary *dict in bodyArray) {
            if (dict[@"img"]) {
                self.shareImageURL = dict[@"img"];
                break;
            }
        }
        
        for (NSDictionary *dict in bodyArray) {
            
            LPContent *content = [[LPContent alloc] init];
            
            content.isAbstract = NO;
            content.index = dict[@"index"];
            content.photo = dict[@"img"];
            content.image = [UIImage imageNamed:@"单图大图占位图"];
            content.photoDesc = dict[@"img_info"];
            content.body = dict[@"txt"];
//            content.concern = self.concern;
            if (content.photo) {
                content.isPhoto = YES;
                
                
            } else {
                content.isPhoto = NO;
            }
            LPContentFrame *contentFrame = [[LPContentFrame alloc] init];
            contentFrame.content = content;
            [self.contentFrames addObject:contentFrame];
            [contentFrame downloadImageWithCompletionBlock:^{
                ++ imageDownloadCount;
                if (self.contentFrames.count > 0 && imageDownloadCount == self.contentFrames.count) {
                    isRefreshTableView = YES;
                    [self.tableView reloadData];
  
                }
            }];
        }
        self.tableView.hidden = NO;
        static OSSpinLock aspect_lock = OS_SPINLOCK_INIT;
        OSSpinLockLock(&aspect_lock);
        [self.tableView reloadData];
        OSSpinLockUnlock(&aspect_lock);
        
        
        [self hideLoadingView];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力"];
        [self hideLoadingView];
    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.contentFrames.count;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return self.fulltextCommentFrames.count;
    } else if(section == 3) {
        return self.relatePointFrames.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        LPContentCell *cell = [LPContentCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.contentFrame = self.contentFrames[indexPath.row];
        return cell;
        
    } else if (indexPath.section == 1) {
        
        LPShareCell *cell = [LPShareCell cellWithTableView:tableView];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == 2) {
        
        LPCommentCell *cell = [LPCommentCell cellWithTableView:tableView];
        cell.commentFrame = self.fulltextCommentFrames[indexPath.row];
        return cell;
        
    } else if (indexPath.section == 3) {
        
        LPRelateCell *cell = [LPRelateCell cellWithTableView:tableView];
        cell.relateFrame = self.relatePointFrames[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    return nil;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LPContentFrame *contentFrame = self.contentFrames[indexPath.row];
        return contentFrame.cellHeight;
    } else if (indexPath.section == 1) {
        return 100;
    } else if (indexPath.section == 2) {
        
        LPCommentFrame *commentFrame = self.fulltextCommentFrames[indexPath.row];
        return commentFrame.cellHeight;
    } else if (indexPath.section == 3) {
        
        return relatePointCellHeight;
    }
    return 0.0;
    
}

#pragma mark - TableView header and footer
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - padding * 2, headerViewHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.layer.borderWidth = 0.5;
    headerView.layer.borderColor = [UIColor colorFromHexString:@"#e9e9e9"].CGColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, headerViewHeight - 0.5)];
    titleLabel.textColor = [UIColor colorFromHexString:@"#0086d1"];
 
    titleLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:titleLabel];

    if (section == 2) {
        if (self.fulltextCommentFrames.count > 0) {
            titleLabel.text = @"精选评论";
            return headerView;
        } else {
            return nil;
        }
        
    } else if(section == 3) {
        if (self.relatePointArray.count > 0) {
            titleLabel.text = @"相关观点";
            return headerView;
        } else {
            return nil;
        }
      
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat bottomWidth = ScreenWidth - BodyPadding * 2;
    CGFloat bottomHeight = footerViewHeight;
    if (section == 2 && self.fulltextCommentFrames.count > 0) {
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomWidth , bottomHeight)];
        
        UIButton *bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, bottomWidth, bottomHeight - 12)];
        bottomButton.backgroundColor = [UIColor whiteColor];
        [bottomButton setTitle:@"查看更多评论" forState:UIControlStateNormal];
        [bottomButton setTitleColor:[UIColor colorFromHexString:@"#0086d1"] forState:UIControlStateNormal];
        [bottomButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [bottomButton addTarget:self action:@selector(showMoreComment) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:bottomButton];
        
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bottomWidth, bottomHeight - 12)];
        bottomLabel.backgroundColor = [UIColor whiteColor];
        bottomLabel.text = @"已加载完毕";
        bottomLabel.textColor = [UIColor colorFromHexString:@"#0086d1"];
        bottomLabel.font = [UIFont systemFontOfSize:15];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:bottomLabel];
        
        bottomButton.hidden = (self.fulltextCommentFrames.count < 3);
        bottomLabel.hidden = !bottomButton.hidden;
        
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointZero];
        [linePath addLineToPoint:CGPointMake(0, bottomHeight - 12)];
        [linePath addLineToPoint:CGPointMake(bottomWidth , bottomHeight - 12)];
        [linePath addLineToPoint:CGPointMake(bottomWidth, 0)];
        lineLayer.path = linePath.CGPath;
        lineLayer.fillColor = nil;
        lineLayer.strokeColor = [UIColor colorFromHexString:@"#e9e9e9"].CGColor;
        [footerView.layer addSublayer:lineLayer];
        
        return footerView;
    } else if (section == 3 && self.relatePointArray.count > 0) {
        // 底部视图
        CGFloat bottomWidth = ScreenWidth - BodyPadding * 2;
        CGFloat bottomHeight = 24;
    
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomWidth , bottomHeight)];
        
        
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bottomWidth, bottomHeight - 12)];
        bottomLabel.backgroundColor = [UIColor whiteColor];        
        [footerView addSubview:bottomLabel];
        return footerView;
       
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        if (self.fulltextCommentFrames.count > 0) {
             return headerViewHeight;
        } else {
            return 0;
        }
       
    } else if (section == 3) {
        if (self.relatePointArray.count > 0) {
             return headerViewHeight;
        } else {
            return 0;
        }
       
    }
    return 0.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        if (self.fulltextCommentFrames.count > 0) {
             return footerViewHeight;
        } else {
            return 0;
        }
    } else if (section == 3){
        if (self.relatePointArray.count > 0 ) {
            return 24;
        } else {
            return 0;
        }
    }
    return 0.0;
}

#pragma mark - 详情页标题
- (void)setupHeaderView:(NSString *)title pubTime:(NSString *)pubtime pubName:(NSString *)pubName {
    UIView *headerView = [[UIView alloc] init];
    CGFloat titleFontSize = [LPFontSizeManager sharedManager].currentDetaiTitleFontSize;
    CGFloat titlePaddingTop = TabBarHeight;
    CGFloat sourceFontSize = [LPFontSizeManager sharedManager].currentDetailSourceFontSize;;
    CGFloat sourcePaddingTop = 0;

    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    
    NSMutableAttributedString *titleString = [title attributedStringWithFont:[UIFont  systemFontOfSize:titleFontSize weight:0.5] color:[UIColor colorFromHexString:@"#060606"] lineSpacing:2.0f];
    
    
    CGFloat titleX = 0;
    CGFloat titleW = ScreenWidth - BodyPadding * 2;
    CGFloat titleH = [titleString heightWithConstraintWidth:titleW] + 30;
    CGFloat titleY = titlePaddingTop;
    titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    titleLabel.attributedText = titleString;
    [headerView addSubview:titleLabel];
    
    // 来源
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.textColor = [UIColor colorFromHexString:@"#747474"];
    sourceLabel.font = [UIFont fontWithName:OpinionFontName size:sourceFontSize];
    CGFloat sourceX = 0;
    CGFloat sourceY = sourcePaddingTop + CGRectGetMaxY(titleLabel.frame);
    CGFloat sourceW = ScreenWidth - titleX * 2;
    CGFloat sourceH = [@"123" sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(sourceW, MAXFLOAT)].height;
    sourceLabel.frame = CGRectMake(sourceX, sourceY, sourceW, sourceH);
    NSString *sourceSiteName = [pubName  isEqualToString: @""] ? @"未知来源": pubName;
    NSString *source = [NSString stringWithFormat:@"%@    %@",pubtime, sourceSiteName];
    sourceLabel.text = source;
    [headerView addSubview:sourceLabel];
    
    headerView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(sourceLabel.frame) + 10);
    
    self.tableView.tableHeaderView = headerView;

}
#pragma mark - Content Cell Delegate
-(void)contentCell:(LPContentCell *)contentCell didOpenURL:(NSString *)url {
    [LPPressTool loadWebViewWithURL:url viewController:self];
}


#pragma mark - Bottom View Delegate
- (void)didComposeCommentWithDetailBottomView:(LPDetailBottomView *)detailBottomView {
    if (![AccountTool account]) {
        __weak typeof(self) weakSelf = self;
        [AccountTool accountLoginWithViewController:weakSelf success:^(Account *account){
            [MBProgressHUD showSuccess:@"登录成功"];
            [weakSelf performSelector:@selector(pushFulltextCommentComposeVc) withObject:nil afterDelay:0.6];
        } failure:^{
            [MBProgressHUD showError:@"登录失败!"];
        } cancel:nil];
    } else {
        [self pushFulltextCommentComposeVc];
    }
}

- (void)didShareWithDetailBottomView:(LPDetailBottomView *)detailBottomView {
    // 详情页添加蒙层
    CGRect imageViewFrame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UIImageView *blurImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    blurImageView.tag = -1;
    blurImageView.image = [UIImage captureWithView:self.view];
    // create effect
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // add effect to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;
    // add the effect view to the image view
    [blurImageView addSubview:effectView];
    
    // 弹出分享view
    LPShareViewController *shareVc = [[LPShareViewController alloc] init];
    shareVc.detailTitleWithUrl = [NSString stringWithFormat:@"%@ %@",self.shareTitle, self.shareURL];
    shareVc.detailUrl = self.shareURL;
    shareVc.blurImageView = blurImageView;
    shareVc.detailTitle =  self.shareTitle;
    shareVc.detailImageUrl = self.shareImageURL;
    
    [self.navigationController pushViewController:shareVc animated:NO];
}

#pragma mark - LPZhihuView delegate

- (void)zhihuView:(LPZhihuView *)zhihuView didClickURL:(NSString *)url
{
    [LPPressTool loadWebViewWithURL:url viewController:self];
}

#pragma mark - LPRelateCell delegate

- (void)relateCell:(LPRelateCell *)cell didClickURL:(NSString *)url {
  [LPPressTool loadWebViewWithURL:url viewController:self];
}

#pragma mark - LPShareCell  Delegate
- (void)cell:(LPShareCell *)shareCell shareIndex:(NSInteger)index {
    switch (index) {
        case -1:
            [self shareToWechatSessionBtnClick];
            break;
        case -2:
            [self shareToWechatTimelineBtnClick];
            break;
        case -3:
            [self shareToQQBtnClick];
            break;
        case -4:
            [self shareToSinaBtnClick];
            break;
    }
}

@end
