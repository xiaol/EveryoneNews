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
#import "LPCommentView.h"
#import "LPComposeViewController.h"
#import "LPComment.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "LPConcernPress.h"
#import "LPConcern.h"
#import "LPPhoto.h"
#import "LPPhotoCell.h"
#import "MainNavigationController.h"
#import "LPPhotoWallViewController.h"
#import "LPShareViewController.h"
#import "LPFullCommentViewController.h"
#import "LPDetailTopView.h"
#import "LPRelateView.h"
#import "CardFrame.h"
#import "Card.h"
#import "CardImage.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"

static const CGFloat CellAlpha =0.3;
NSString * const PhotoCellReuseId = @"photoWallCell";

@interface LPDetailViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, LPZhihuViewDelegate,LPRelateViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate, LPDetailTopViewDelegate, LPContentCellDelegate>
//{
//    // 分享图片地址
//    NSString *detailImgUrl;
//    NSString *detailTitle;
//}

@property (nonatomic, strong) LPDetailTopView *topView;
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
@property (nonatomic,strong) NSArray *imageWallArray;

@property (nonatomic, copy) NSString *commentText;
@property (nonatomic, assign) BOOL shouldPush;
@property (nonatomic, assign) int realParaIndex;

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) CGFloat offOriginX; // 最初offset的绝对值
@property (nonatomic, assign) CGFloat pageWidth;
@property (nonatomic, assign) CGFloat beginOffX;
@property (nonatomic, strong) UICollectionView *photoWall;
@property (nonatomic, assign) CGFloat velocity;

@property (nonatomic,strong) UIColor *categoryColor;


@property (nonatomic, strong) LPHttpTool *http;
@property (nonatomic, assign) BOOL requestSuccess;


// 分享url
@property (nonatomic, copy) NSString *shareURL;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareImageURL;
@property (nonatomic, strong) NSMutableDictionary *heightCache;

@end

@implementation LPDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
    [self setupDataWithCompletion:nil fulltextCommentsUpHandle:nil];
    [self setupNoteObserver];
    

    
}

 
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.http) {
        [self.http cancelRequest];
        self.http = nil;
    }
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)setupNoteObserver
{
//    [noteCenter addObserver:self selector:@selector(willComposeComment:) name:LPCommentWillComposeNotification object:nil];
//    [noteCenter addObserver:self selector:@selector(didComposeComment:) name:LPCommentDidComposeNotification object:nil];
//    [noteCenter addObserver:self selector:@selector(reloadCell:) name:LPDetailVcShouldReloadDataNotification object:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (NSArray *)relates
{
    if (_relates == nil) {
        _relates = [NSArray array];
    }
    return _relates;
}

- (NSMutableDictionary *)heightCache {
    if (_heightCache) {
        _heightCache = [[NSMutableDictionary alloc] init];
    }
    return _heightCache;
}

- (NSArray *)photos {
    if (_photos == nil) {
        _photos = [NSArray array];
    }
    return _photos;
}

- (NSMutableArray *)contentFrames
{
    if (_contentFrames == nil) {
        _contentFrames = [NSMutableArray array];
    }
    return _contentFrames;
}

- (void)setupSubviews
{
    // 初始化tableview
    UITableView *tableView = [[UITableView alloc] init];
    
    double topViewHeight = 64;
    if (iPhone6Plus) {
        topViewHeight = 64;
    }
//    tableView.frame = CGRectMake(0, topViewHeight, ScreenWidth, ScreenHeight - topViewHeight);
    tableView.frame = CGRectMake(0, 20, ScreenWidth, ScreenHeight);
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.delegate = self;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 26)];
    tableView.tableFooterView = footerView;
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.topView = [[LPDetailTopView alloc] initWithFrame: self.view.bounds];
    self.topView.delegate = self;
    self.topView.alpha = 0.9;
    [self.view addSubview:self.topView];
}

// 点击分享按钮
- (void)shareBtnClick
{
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
 
//    NSString *detailURL = [NSString stringWithFormat:@"http://deeporiginalx.com/news.html?type=0&url=%@",self.shareURL];
    NSString *detailURL = self.shareURL;
    shareVc.detailTitleWithUrl = [NSString stringWithFormat:@"%@ %@",self.shareTitle, detailURL];
    shareVc.detailUrl = detailURL;
    shareVc.blurImageView = blurImageView;
    shareVc.detailTitle = self.shareTitle;;
    shareVc.detailImageUrl = self.shareImageURL;
    [self.navigationController pushViewController:shareVc animated:NO];
}

// 全文评论
- (void)fulltextCommentBtnClick
{
    LPFullCommentViewController *fullCommentVc = [[LPFullCommentViewController alloc] init];
    fullCommentVc.color = self.categoryColor;
    fullCommentVc.comments = self.fullTextComments;
    if (self.isConcernDetail) {
        fullCommentVc.sourceURL = self.concernPress.sourceUrl;
    } else {
        fullCommentVc.sourceURL = self.press.sourceUrl;
    }
    [fullCommentVc fulltextCommentDidComposed:^(NSInteger count) {
            self.topView.badgeNumber = count;
    }];
    [self.navigationController pushViewController:fullCommentVc animated:YES];
}

- (void)fulltextWillCompose {
    
}

-(void)topViewBackBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - request new data (if re-login, pass contents model to paraVc)
- (void)setupDataWithCompletion:(returnCommentsToUpBlock)block fulltextCommentsUpHandle:(fulltextCommentsUpHandler)fulltextCommentsUpHandle
{
    [self.contentFrames removeAllObjects];
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (account) {
        params[@"userId"] = account.userId;
        params[@"platformType"] = account.platformType;
    }
    __weak typeof(self) weakSelf = self;
    if (!self.isConcernDetail) {
        if (!account) {
            params = nil;
        }
//        params[@"url"] = self.press.sourceUrl;
        NSString *url = [NSString stringWithFormat:@"%@%@", ContentUrl, self.press.sourceUrl];
          // url=@"http://api.deeporiginalx.com/news/baijia/fetchContent?url=http://finance.ifeng.com/a/20150820/13921905_0.shtml";
        self.http = [LPHttpTool http];
        [self.http getWithURL:url params:params success:^(id json) {
            // 0. json字典转模型
            NSString *headerImg = json[@"imgUrl"];
            // 设置分享链接图片地址
//            detailImgUrl=headerImg;
            NSString *title = json[@"title"];
            NSString *time = json[@"updateTime"];
            NSString *abstract = json[@"abs"];
            NSString *totalBody = json[@"content"];
            NSArray *commentArray = [LPComment objectArrayWithKeyValuesArray:json[@"point"]];
            
//            NSArray *baikeArray = [LPWeiboPoint objectArrayWithKeyValuesArray:json[@"baike"]];
            NSArray *zhihuArray = [LPZhihuPoint objectArrayWithKeyValuesArray:json[@"zhihu"]];
//            NSArray *doubanArray = [LPWeiboPoint objectArrayWithKeyValuesArray:json[@"douban"]];
//            NSArray *weiboArray = [LPWeiboPoint objectArrayWithKeyValuesArray:json[@"weibo"]];
            // 相关观点
            NSArray *relateArray = [LPRelatePoint objectArrayWithKeyValuesArray:json[@"relate"]];
            NSArray *photoWallArray = [LPPhoto objectArrayWithKeyValuesArray:json[@"imgWall"]];
            
            // 1. header图像及标题的赋值
            [weakSelf setupHeaderWithImageURL:headerImg title:title time:time color:[UIColor colorFromCategory:self.press.category alpha:0.1]];
            // 设置全文评论顶部视图颜色
            self.categoryColor = [UIColor colorFromCategory:self.press.category];
            // 防止数据为空时详情页崩溃
            abstract = (abstract == nil || abstract.length == 0) ? title : [abstract stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            // 2. 每段正文及其评论赋值
            NSArray *rawArray = [totalBody componentsSeparatedByString:@"\n"];
            NSMutableArray *bodyArray = [NSMutableArray arrayWithArray:@[abstract]];
            for (NSString *str in rawArray) {
                if (![str isBlank]) {
                    [bodyArray addObject:[str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
                }
            }
            
            NSMutableArray *contents = [NSMutableArray array];
            NSMutableArray *contentFrameArray = [NSMutableArray array];
            
            // 全文评论
            NSMutableArray *textComments=[NSMutableArray array];
            // 获取所有的全文评论
            for(LPComment *comment in commentArray)
            {
                //  判断是否为全文评论
                if([comment.type isEqualToString:@"text_doc"])
                {
                    [textComments addObject:comment];
                }
            }
            self.fullTextComments = textComments;
            self.topView.badgeNumber = self.fullTextComments.count;
            for (int i = 0; i < bodyArray.count; i++) {
                // 2.1 正文
                LPContent *content = [[LPContent alloc] init];
                content.isOpinion = NO;
                content.paragraphIndex = i;
                content.body = bodyArray[i];
                content.category = self.press.redefineCategory;
                content.color = [UIColor colorFromCategory:content.category];
                // 分段评论
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
                        comment.color = content.color;
                    }
                    content.hasComment = (comments.count > 0);
                    content.comments = comments;
                }
                LPContentFrame *contentFrame = [[LPContentFrame alloc] init];
                contentFrame.content = content;
                [contentFrameArray addObject:contentFrame];
                [contents addObject:content];
            }
            
            // 2.3 观点数据
            NSDictionary *relateOpinion = json[@"relate_opinion"];
            NSArray *opinions = relateOpinion[@"self_opinion"];
            for (NSDictionary *dict in opinions) {
                LPContent *content = [[LPContent alloc] init];
                content.isOpinion = YES;
                content.url = dict[@"url"];
                content.body = dict[@"self_opinion"];
                content.opinion = dict[@"title"];
                LPContentFrame *frm = [[LPContentFrame alloc] init];
                frm.content = content;
                [contentFrameArray addObject:frm];
            }
            
            // 2.4 传递数据给contentFrames属性
            weakSelf.contentFrames = contentFrameArray;
            
            // 3. 尾部数据的赋值
            [weakSelf setupFooterWithPhotoWallArray:photoWallArray zhihu:zhihuArray relateArray:relateArray];
            
            // 4. 刷新tableView
            [weakSelf.tableView reloadData];
            
            [sharedIndicator stopAnimating];
            
            if (block) {
                block(contents);
            }
            if(fulltextCommentsUpHandle) {
                fulltextCommentsUpHandle(textComments);
            }
            
        } failure:^(NSError *error) {
            [sharedIndicator stopAnimating];
            NSLog(@"Failure: %@", error);
        }];
    } else {
        // 加载详情页数据
        CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        Card *card = (Card *)[cdh.context existingObjectWithID:self.cardID error:nil];
        NSString *url = @"http://api.deeporiginalx.com/bdp/news/content";
        // 必须通过kvc方式获取，否则会有bug
        params[@"url"] = [card valueForKey:@"newId"];
        NSLog(@"http://api.deeporiginalx.com/bdp/news/content?url=%@",params[@"url"]);
        [self getDataWithUrl:url params:params];

    }

}

- (void)getDataWithUrl:(NSString *)url params:(NSDictionary *)params {
    [LPHttpTool getWithURL:url params:params success:^(id json) {
        
        NSDictionary *dict = json[@"data"];
        NSString *title = dict[@"title"];
        NSString *pubTime = dict[@"pubTime"];
        NSString *pubName = dict[@"pubName"];
        NSString *pubURL = dict[@"url"];
        
        self.shareURL = pubURL;
        self.shareTitle = title;
    
        [self setupHeaderView:title pubTime:pubTime pubName:pubName];
        
        NSArray *zhihuArray = [LPZhihuPoint objectArrayWithKeyValuesArray:dict[@"zhihu"]];
        NSArray *commentArray = [LPComment objectArrayWithKeyValuesArray:dict[@"point"]];
        
        NSArray *bodyArray = dict[@"content"];
        
        // 第一个图片作为分享图片
        for (NSDictionary *dict in bodyArray) {
            LPContent *content = [[LPContent alloc] init];
            content.photo = dict[@"img"];
            if (content.photo) {
                self.shareImageURL = content.photo;
                break;
            }
        }
        
        NSMutableArray *contentFrameArray = [NSMutableArray array];
        for (NSDictionary *dict in bodyArray) {
            LPContent *content = [[LPContent alloc] init];
            content.isAbstract = NO;
            content.index = dict[@"index"];
            content.photo = dict[@"img"];
            content.photoDesc = dict[@"img_info"];
            content.body = dict[@"txt"];
            content.concern = self.concern;
            if (content.photo) {
                content.isPhoto = YES;
            } else {
                content.isPhoto = NO;
            }
            LPContentFrame *contentFrame = [[LPContentFrame alloc] init];
            contentFrame.content = content;
            [contentFrameArray addObject:contentFrame];
        }
        self.contentFrames = contentFrameArray;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力"];
    }];
}


#pragma mark - 详情页标题
- (void)setupHeaderView:(NSString *)title pubTime:(NSString *)pubtime pubName:(NSString *)pubName {
    UIView *headerView = [[UIView alloc] init];
    CGFloat titleFontSize = 23;
    CGFloat titlePaddingLeft = 13;
//    CGFloat titlePaddingTop = 25;
    CGFloat titlePaddingTop = TabBarHeight;
    CGFloat sourceFontSize = 14;
    CGFloat sourcePaddingTop = 21;
    
    if (iPhone6Plus) {
        titleFontSize = 23;
        sourceFontSize = 14;
    }
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
//    NSMutableAttributedString *titleString = [title attributedStringWithFont:[UIFont fontWithName:@"SanFranciscoText-Bold" size:titleFontSize] color:[UIColor colorFromHexString:@"#060606"] lineSpacing:0];
    
    NSMutableAttributedString *titleString = [title attributedStringWithFont:[UIFont boldSystemFontOfSize:titleFontSize] color:[UIColor colorFromHexString:@"#060606"] lineSpacing:0];
    
    CGFloat titleX = titlePaddingLeft;
    CGFloat titleW = ScreenWidth - titleX * 2;
    CGFloat titleH = [titleString heightWithConstraintWidth:titleW];
    CGFloat titleY = titlePaddingTop;
    titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    titleLabel.attributedText = titleString;
    [headerView addSubview:titleLabel];
    
    // 来源
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.textColor = [UIColor colorFromHexString:@"#747474"];
    sourceLabel.font = [UIFont fontWithName:OpinionFontName size:sourceFontSize];
    CGFloat sourceX = titlePaddingLeft;
    CGFloat sourceY = sourcePaddingTop + CGRectGetMaxY(titleLabel.frame);
    CGFloat sourceW = ScreenWidth - titleX * 2;
    CGFloat sourceH = [@"123" sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(sourceW, MAXFLOAT)].height;
    sourceLabel.frame = CGRectMake(sourceX, sourceY, sourceW, sourceH);
    NSString *sourceSiteName = [pubName  isEqualToString: @""] ? @"未知来源": pubName;
    NSString *source = [NSString stringWithFormat:@"%@    %@",pubtime, sourceSiteName];
    sourceLabel.text = source;
    [headerView addSubview:sourceLabel];
    
    headerView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(sourceLabel.frame));
    
//    headerView.backgroundColor = [UIColor greenColor];
    self.tableView.tableHeaderView = headerView;

}




# pragma mark - header view setting up
- (void)setupHeaderWithImageURL:(NSString *)imageURL title:(NSString *)title time:(NSString *)time color:(UIColor *)color
{
    UIView *headerView = [[UIView alloc] init];
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
    
    self.tableView.tableHeaderView = headerView;
    [self.tableView sendSubviewToBack:headerView];
}
# pragma mark - footer view setting up
- (void)setupFooterWithPhotoWallArray:(NSArray *)photos zhihu:(NSArray *)zhihuArray relateArray:(NSArray *)relateArray{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorFromHexString:TableViewBackColor];
    
    CGFloat footerH = 0.0;
    UIView *photoBgView = [[UIView alloc] init];
    if (photos && photos.count) {
        self.photos = photos;
        CGFloat photoW = DetailCellWidth - 2 * BodyPadding;
        CGFloat photoH = photoW / 2;
        // 1. 加个卡片
        photoBgView.x = DetailCellPadding;
        photoBgView.width = DetailCellWidth;
        photoBgView.y = 0;
        photoBgView.layer.shadowOpacity = 0.24f;
        photoBgView.layer.shadowRadius = 3.0;
        photoBgView.layer.shadowOffset = CGSizeMake(0, 0);
        photoBgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//        photoBgView.layer.zPosition = 999.0;
        photoBgView.backgroundColor = [UIColor whiteColor];
        photoBgView.layer.cornerRadius = 1.0;
        photoBgView.layer.shouldRasterize = YES;
        photoBgView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        // 2. "相关图片"
        NSString *tip = @"相关图片";
        UILabel *tipLabel = [[UILabel alloc] init];
        [photoBgView addSubview:tipLabel];
        tipLabel.font = [UIFont systemFontOfSize:15];
        tipLabel.textColor = [UIColor lightGrayColor];
        tipLabel.text = tip;
        tipLabel.x = BodyPadding;
        tipLabel.y = BodyPadding;
        CGSize tipSize = [tip sizeWithFont:tipLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        tipLabel.size = tipSize;
        CGFloat photoWallY = CGRectGetMaxY(tipLabel.frame) + 10;
        photoBgView.height = photoWallY + photoH + BodyPadding;
        [footerView addSubview:photoBgView];
        
        // 2. 设置图片墙
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, DetailCellPadding + BodyPadding, 0, 0);
        layout.minimumLineSpacing = DetailCellPadding;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(photoW, photoH);
        layout.footerReferenceSize = CGSizeMake(DetailCellPadding + BodyPadding, 0);
        
        self.pageWidth = layout.minimumLineSpacing + layout.itemSize.width;
        self.offOriginX = layout.sectionInset.left;
        
        UICollectionView *photoWall = [[UICollectionView alloc] initWithFrame:CGRectMake(0, photoWallY, ScreenWidth, photoH) collectionViewLayout:layout];
        [photoWall registerClass:[LPPhotoCell class] forCellWithReuseIdentifier:PhotoCellReuseId];
        photoWall.backgroundColor = [UIColor clearColor];
        photoWall.showsHorizontalScrollIndicator = NO;
        [footerView addSubview:photoWall];
        photoWall.dataSource = self;
        photoWall.delegate = self;
        self.photoWall = photoWall;
        [photoWall reloadData];
        footerH=CGRectGetMaxY(photoBgView.frame) + DetailCellPadding;
    } else {
        photoBgView.height = 0;
        photoBgView.hidden = YES;
    }
    // 相关观点
    LPRelateView *relateView=[[LPRelateView alloc] init];
    relateView.backgroundColor=[UIColor whiteColor];
    if(relateArray&&relateArray.count)
    {
        relateView.frame = CGRectMake(DetailCellPadding,footerH, DetailCellWidth, 60+79*relateArray.count);
        relateView.layer.shadowOpacity = 0.24f;
        relateView.layer.shadowRadius = 3.0;
        relateView.layer.shadowOffset = CGSizeMake(0, 0);
        relateView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        relateView.layer.zPosition = 999.0;
        relateView.layer.cornerRadius = 1.0;
        relateView.relateArray=relateArray;
        [footerView addSubview:relateView];
        footerH = CGRectGetMaxY(relateView.frame) + DetailCellPadding;
    }
    else
    {
        relateView.height=0;
        relateView.hidden=YES;
    }
    relateView.delegate=self;

    // 知乎推荐
    LPZhihuView *zhihuView = [[LPZhihuView alloc] init];
    if (zhihuArray && zhihuArray.count) {
        zhihuView.hidden = NO;
        zhihuView.frame = CGRectMake(DetailCellPadding, footerH, DetailCellWidth, [zhihuView heightWithPointsArray:zhihuArray]);
        zhihuView.layer.shadowOpacity = 0.24f;
        zhihuView.layer.shadowRadius = 3.0;
        zhihuView.layer.shadowOffset = CGSizeMake(0, 0);
        zhihuView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        zhihuView.layer.zPosition = 999.0;
        zhihuView.layer.cornerRadius = 1.0;
        zhihuView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        zhihuView.layer.shouldRasterize = YES;
        zhihuView.zhihuPoints = zhihuArray;
        footerH = CGRectGetMaxY(zhihuView.frame) + DetailCellPadding;
    } else {
        zhihuView.hidden = YES;
    }
    zhihuView.delegate = self;
    zhihuView.backgroundColor = [UIColor whiteColor];
    
    [footerView addSubview:zhihuView];
    footerView.frame = CGRectMake(0, 0, ScreenWidth, footerH);
    self.tableView.tableFooterView = footerView;
}

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
    cell.layer.cornerRadius = 1.0;
    cell.contentFrame = self.contentFrames[indexPath.row];
    [self setShadowForCell:cell];
    return cell;
}

- (void)setShadowForCell:(LPContentCell *)cell {
//    cell.layer.shadowOpacity = 0.24f;
//    cell.layer.shadowRadius = 3.0;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.layer.zPosition = 999.0;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPContentFrame *contentFrame = self.contentFrames[indexPath.row];
    return contentFrame.cellHeight;
}

- (void)tableViewDidReload:(LPContentCell *)contentCell {
    [self.tableView reloadData];
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
    } else {
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([scrollView isKindOfClass:[UICollectionView class]]) { // 左右拖动图片墙
        self.velocity = velocity.x;
    }

}

//
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isKindOfClass:[UICollectionView class]]) { // 左右拖动图片墙
        if (self.offOriginX > 0 && self.pageWidth > 0) {
            CGPoint pagedOffset = [self pagedOffsetWithScrollView:scrollView];
            [scrollView setContentOffset:pagedOffset animated:YES];
        }
    }
}

// deactive scroll view decelerating, forced into paging
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UICollectionView class]]) { // 左右拖动图片墙
        [scrollView setContentOffset:scrollView.contentOffset animated:YES];
        
        CGPoint pagedOffset = [self pagedOffsetWithScrollView:scrollView];
        [scrollView setContentOffset:pagedOffset animated:YES];
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if ([scrollView isKindOfClass:[UICollectionView class]]) { // 左右拖动图片墙
//        if (self.offOriginX > 0 && self.pageWidth > 0) {
//            CGPoint pagedOffset = [self pagedOffsetWithScrollView:scrollView];
//            [scrollView setContentOffset:pagedOffset animated:YES];
//        }
//    }
//}

- (CGPoint)pagedOffsetWithScrollView:(UIScrollView *)scrollView {
    CGFloat offX = scrollView.contentOffset.x;
//    NSUInteger page = (offX + self.offOriginX) / self.pageWidth + 0.5;
    CGFloat diff = offX > self.beginOffX ? 0.6 : 0.4;
    NSUInteger page = offX / self.pageWidth + diff;
    NSUInteger oldPage = self.beginOffX / self.pageWidth + 0.5;
    if (ABS(self.velocity) > 1.0 && ABS(offX - self.beginOffX) < self.pageWidth / 2 ) {
        page = offX > self.beginOffX ? oldPage + 1 : oldPage - 1;
        page = offX < 0 ? 0 : page;
        page = MIN(page, self.photos.count - 1);
    }
    
    CGFloat newOffX = page * self.pageWidth;
    return CGPointMake(newOffX, 0);
}

#pragma mark - push para comment view controller
- (void)pushParaVcWithContent:(LPContent *)content
{
    LPParaCommentViewController *paraVc = [[LPParaCommentViewController alloc] init];
    paraVc.comments = content.comments;
    paraVc.bgImage = [UIImage captureWithView:self.view];
    paraVc.color = content.color;
    paraVc.contentIndex = content.paragraphIndex;
    paraVc.commentText = self.commentText;
    if (self.isConcernDetail) {
        paraVc.sourceURL = self.concernPress.sourceUrl;
    } else {
        paraVc.sourceURL = self.press.sourceUrl;
    }
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

- (void)contentCell:(LPContentCell *)cell didVisitOpinionURL:(NSString *)url {
    NSLog(@"url = %@", url);
    [LPPressTool loadWebViewWithURL:url viewController:self];
}

- (void)contentPhotoTap {
    
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
        [AccountTool accountLoginWithViewController:self.navigationController.topViewController success:^(Account *account) {
            [MBProgressHUD showSuccess:@"登录成功"];
            [weakSelf performSelector:@selector(pushCommentComposeVcWithNote:) withObject:note afterDelay:0.3];
        } failure:^{
            [MBProgressHUD showError:@"登录失败"];
        } cancel:nil];
    } else {
        [self pushCommentComposeVcWithNote:note];
    }
}
// 相关观点
-(void)relateView:(LPRelateView *)relateView didCliclURL:(NSString *)url
{
    [LPPressTool loadWebViewWithURL:url viewController:self];
}


#pragma mark - 分段评论处理
- (void)didComposeComment:(NSNotification *)note {
    LPContentFrame *contentFrame = self.contentFrames[self.realParaIndex];
    LPContent *content = contentFrame.content;
    Account *account = [AccountTool account];
    NSMutableArray *commentArray = [NSMutableArray arrayWithArray:content.comments];
    
    // 1.1 创建comment对象
    LPComment *comment = [[LPComment alloc] init];
    comment.sourceUrl = self.press.sourceUrl;
    comment.color = content.color;
    // 评论段落索引为整体(real)段落索引值 - 1
    comment.type = @"text_paragraph";
    comment.srcText = self.commentText;
    comment.uuid = account.userId;
    comment.userIcon = account.userIcon;
    comment.userName = account.userName;
    comment.createTime = [NSString stringFromNowDate];
    comment.up = @"0";
    comment.isPraiseFlag = @"0";

    if (self.navigationController.viewControllers.count >= 4) {
        self.shouldPush = YES;
    } else {
        self.shouldPush = NO;
    }
    // 2. 发送post请求
    NSString *url = [NSString stringWithFormat:@"%@/news/baijia/point", ServerUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.isConcernDetail) {
        params[@"sourceUrl"] = self.concernPress.sourceUrl;
        comment.paragraphIndex = [NSString stringFromIntValue:content.index.intValue];
    } else {
        params[@"sourceUrl"] = self.press.sourceUrl;
        comment.paragraphIndex = [NSString stringFromIntValue:(content.paragraphIndex - 1)];
    }
    
    params[@"srcText"] = comment.srcText;
    params[@"paragraphIndex"] = comment.paragraphIndex;
    params[@"type"] = comment.type;
    params[@"uuid"] = comment.uuid;
    params[@"userIcon"] = comment.userIcon;
    params[@"userName"] = comment.userName;
    if (content.photo) {
        params[@"desText"] = content.photo;
    } else {
        params[@"desText"] = content.body;
    }

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
        if (!self.isConcernDetail) {
            [noteCenter postNotificationName:LPCommentDidComposeSuccessNotification object:self];
        }
        
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

#pragma mark - dealloc
- (void)dealloc {
//    [noteCenter removeObserver:self];
}


# pragma mark - handle unLogin up comment
- (void)returnContentsBlock:(returnCommentsToUpBlock)returnBlock
{
    [self setupDataWithCompletion:returnBlock fulltextCommentsUpHandle:nil];
}

#pragma mark - handle unlogin up fulltext comment
- (void)fulltextCommentsUpDidComposed:(fulltextCommentsUpHandler) fulltextCommentsUpHandle {
    [self setupDataWithCompletion:nil fulltextCommentsUpHandle:fulltextCommentsUpHandle];
}

#pragma mark - notification selector reload cell
- (void)reloadCell:(NSNotification *)note
{
//    NSNumber *rowNum = note.userInfo[LPReloadCellIndex];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNum.integerValue inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

#pragma mark - collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellReuseId forIndexPath:indexPath];
    cell.photo = self.photos[indexPath.item];
    return cell;
}

#pragma mark - collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!collectionView.isDragging && !collectionView.isDecelerating) {
        LPPhotoWallViewController *photoVc = [[LPPhotoWallViewController alloc] init];
        photoVc.originIndexPath = indexPath;
        photoVc.photos = self.photos;
        [self.navigationController pushViewController:photoVc animated:YES];
    }
}

// 分段评论
- (void)pushCommentComposeVcWithNote:(NSNotification *)note {

        NSDictionary *info = note.userInfo;
        int paraIndex = [info[LPComposeParaIndex] intValue];
        self.realParaIndex = paraIndex;
        LPContentFrame *contentFrame = self.contentFrames[paraIndex];
        LPContent *content = contentFrame.content;
        LPComposeViewController *composeVc = [[LPComposeViewController alloc] init];
        // 类别为1代表分段评论
        composeVc.commentType=1;
        composeVc.color = content.color;
        composeVc.draftText = self.commentText;
        [composeVc returnText:^(NSString *text) {
            self.commentText = text;
        }];
        [self.navigationController pushViewController:composeVc animated:YES];

}
@end
