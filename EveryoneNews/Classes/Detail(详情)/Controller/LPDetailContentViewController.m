//
//  LPContentDetailViewController.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/30.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPDetailContentViewController.h"
//#import "LPPress.h"
#import "MJExtension.h"
#import "LPHttpTool.h"
//#import "LPContent.h"
//#import "LPContentFrame.h"
//#import "LPComment.h"
//#import "LPZhihuPoint.h"
//#import "LPWeiboPoint.h"
//#import "LPRelatePoint.h"
//#import "LPContentCell.h"
#import "UIImageView+WebCache.h"
//#import "LPZhihuView.h"
//#import "LPWaterfallView.h"
//#import "LPRelateCell.h"
//#import "LPParaCommentViewController.h"
//#import "LPPressTool.h"
//#import "LPCommentView.h"
//#import "LPComposeViewController.h"
//#import "LPComment.h"
#import "AccountTool.h"
//#import "MBProgressHUD+MJ.h"
//#import "LPConcernPress.h"
//#import "LPConcern.h"
//#import "LPPhoto.h"
//#import "LPPhotoCell.h"
#import "MainNavigationController.h"
//#import "LPPhotoWallViewController.h"
//#import "LPShareViewController.h"
//#import "LPFullCommentViewController.h"
//#import "LPDetailTopView.h"
//#import "LPRelateView.h"
#import "CardImage.h"
//#import "LPDetailContent.h"
#import "LPDetail.h"
#import "LPDetailContent.h"
#import "LPDetailContentFrame.h"
#import "LPDetailContentCell.h"


static const CGFloat CellAlpha =0.3;
NSString * const PhotoCellIdentifier = @"photoWallCell";
@interface LPDetailContentViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) LPDetailTopView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat lastContentOffsetY;
//@property (nonatomic, strong) UIButton *popBtn;
@property (nonatomic, strong) NSMutableArray *contentFrames;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, assign) CGFloat diffPercent;
//
//@property (nonatomic, strong) NSIndexPath *watchingIndexPath;
//@property (nonatomic, strong) NSArray *relates;
//@property (nonatomic,strong) NSArray *imageWallArray;
//
//@property (nonatomic, copy) NSString *commentText;
//@property (nonatomic, assign) BOOL shouldPush;
//@property (nonatomic, assign) int realParaIndex;
//
//@property (nonatomic, strong) NSArray *photos;
//@property (nonatomic, assign) CGFloat offOriginX; // 最初offset的绝对值
//@property (nonatomic, assign) CGFloat pageWidth;
@property (nonatomic, assign) CGFloat beginOffX;
//@property (nonatomic, strong) UICollectionView *photoWall;
//@property (nonatomic, assign) CGFloat velocity;
//
//@property (nonatomic,strong) UIColor *categoryColor;


@property (nonatomic, strong) LPHttpTool *http;
@property (nonatomic, assign) BOOL requestSuccess;
@property (nonatomic, copy) NSString *detailImgUrl;

@end
@implementation LPDetailContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupDataWithCompletion];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.http) {
        [self.http cancelRequest];
        self.http = nil;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setupSubviews
{
    // 初始化tableview
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    tableView.backgroundColor = [UIColor colorFromHexString:@"#edefef"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;

    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
  
}

#pragma mark - request new data (if re-login, pass contents model to paraVc)
- (void)setupDataWithCompletion
{
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (account) {
        params[@"userId"] = account.userId;
        params[@"platformType"] = account.platformType;
    }
    __weak typeof(self) weakSelf = self;
    [self.contentFrames removeAllObjects];

    self.http = [LPHttpTool http];
    NSString *url = [NSString stringWithFormat:@"%@%@", @"http://api.deeporiginalx.com/bdp/news/content?url=", self.card.newId];
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    BOOL isPhoto = YES;
    if (self.card.cardImages.count > 0) {
        isPhoto = YES;
        for (CardImage * cardImage in self.card.cardImages) {
            [imageArray addObject:cardImage.imgUrl];
        }
    } else {
        isPhoto = NO;
    }
    [self.http getWithURL:url params:params success:^(id json) {
    NSArray *contentArray  = [LPDetailContent objectArrayWithKeyValuesArray:json[@"data"][@"content"]];
    NSString *title = json[@"data"][@"title"];
    NSString *time =  json[@"data"][@"pubTime"];
    if (isPhoto) {
        NSString *headerImgUrl = imageArray[0];
        [weakSelf setupHeaderWithImageURL:headerImgUrl title:title time:time color:[UIColor colorFromHexString:@"#0087d1" alpha:0.1]];
    } else {
        [weakSelf setupHeaderWithImageURL:nil title:title time:time color:[UIColor colorFromHexString:@"#0087d1" alpha:0.1]];
    }
    NSMutableArray *contentFrameArray = [NSMutableArray array];
    for (LPDetailContent *content in contentArray) {
        LPDetailContentFrame *contentFrame = [[LPDetailContentFrame alloc] init];
        contentFrame.content = content;
        [contentFrameArray addObject:contentFrame];
    }
    weakSelf.contentFrames = contentFrameArray;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [sharedIndicator stopAnimating];
        NSLog(@"Failure: %@", error);
    }];
}

# pragma mark - header view setting up
- (void)setupHeaderWithImageURL:(NSString *)imageURL title:(NSString *)title time:(NSString *)time color:(UIColor *)color
{
    UIView *headerView = [[UIView alloc] init];
    if (imageURL) {
        CGFloat headerViewH = TableHeaderViewH;
        headerView.frame = CGRectMake(0, 0, ScreenWidth, headerViewH);
        
        self.diffPercent = 0.5;
        
        UIImageView *headerImageView = [[UIImageView alloc] init];
        headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        headerImageView.layer.shouldRasterize = YES;
        headerImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        
        headerImageView.clipsToBounds = YES;
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
        filterView.backgroundColor = color;
        self.filterView = filterView;
        [headerImageView addSubview:filterView];
        
        // 渐变加在headerView上
        UIImageView *hud = [[UIImageView alloc] init];
        hud.image = [UIImage imageNamed:@"渐变"];
        hud.alpha = 0.6;
        CGFloat hudH = headerViewH * 0.4;
        CGFloat hudY = CGRectGetMaxY(headerImageView.frame) - hudH;
        hud.frame = CGRectMake(0, hudY, ScreenWidth, hudH);
        hud.layer.shouldRasterize = YES;
        hud.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
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
    } else {
        CGFloat headerViewH = 100;
        headerView.frame = CGRectMake(0, 0, ScreenWidth, headerViewH);
        UILabel *titleLabel = [[UILabel alloc] init];
        
        titleLabel.numberOfLines = 0;
        NSMutableAttributedString *titleString = [title attributedStringWithFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:20] color:[UIColor colorFromHexString:@"#2b2b2b"] lineSpacing:5];
        CGFloat titleX = 20;
        CGFloat titleW = ScreenWidth - titleX * 2;
        CGFloat titleH = [titleString heightWithConstraintWidth:titleW];
        CGFloat titleY = 0;
        titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
        titleLabel.attributedText = titleString;
        [headerView addSubview:titleLabel];
    }
    self.tableView.tableHeaderView = headerView;
    [self.tableView sendSubviewToBack:headerView];
}

#pragma mark - Table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPDetailContentCell *cell = [LPDetailContentCell cellWithTableView:tableView];
    cell.layer.cornerRadius = 1.0;
    cell.contentFrame = self.contentFrames[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPDetailContentFrame *contentFrame = self.contentFrames[indexPath.row];
    return contentFrame.cellHeight;
}

#pragma mark - Scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollView.scrollEnabled = YES;
    self.lastContentOffsetY = self.tableView.contentOffset.y;
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        self.beginOffX = scrollView.contentOffset.x;
    }
}

/**
 *  头图视差效果
 *
 *  @param scrollView tableView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) { // 上下拖动table view
//        self.lastContentOffsetY < scrollView.contentOffset.y ? [self fadeOut] : [self fadeIn];
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
    } else {
    }
}
@end
