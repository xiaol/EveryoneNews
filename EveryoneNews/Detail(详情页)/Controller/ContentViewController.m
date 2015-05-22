//
//  ContentViewController.m
//  upNews
//
//  Created by 于咏畅 on 15/1/20.
//  Copyright (c) 2015年 yyc. All rights reserved.
//
//  ** 详情页控制器 ***

#import "ContentViewController.h"
#import "AFNetworking.h"
#import "ContentCell.h"

#import "FTCoreTextCell.h"
#import "BaiduCell.h"
#import "ZhihuCell.h"
#import "DoubanCell.h"
#import "WeiboCell.h"
#import "AbsCell.h"

#import "UIColor+HexToRGB.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "ScaleImage.h"

#import "MJRefresh.h"
#import "TMQuiltView.h"
#import "TMPhotoQuiltViewCell.h"

#import "AutoLabelSize.h"
#import "NSString+YU.h"
#import "NSArray+isEmpty.h"

#import "LPWaterfallView.h"
#import "MJExtension.h"
#import "Relate.h"
#import "RelateCell.h"


@interface ContentViewController ()<UITableViewDataSource, UITableViewDelegate, TMQuiltViewDataSource,TMQuiltViewDelegate, LPWaterfallViewDataSource, LPWaterfallViewDelegate, WebDelegate>
{
    NSMutableArray *resourceArr;    //存储图文详细内容
    UITableView *contentTableView;

    TMQuiltView *qtmquitView;
    
    BOOL firstLoad;
    CGFloat waterFlowH;

    NSMutableArray *waterFlowArr;
    NSMutableDictionary *waterDic;

    CGFloat columnOne;
    CGFloat columnTwo;
    CGFloat cellMargin;
    
    BOOL hasRelate;
    
    UIButton *backBtn;
    float lastContentOffset;
    NSInteger flag;
    
}

@property (nonatomic, strong) NSMutableArray *relates;
// @property (nonatomic, weak) LPWaterfallView *waterfallView;

@end

@implementation ContentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"MemoryWarning_contentView-----");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    [self initTableView];
    [self initWaterFlow];
    
    //返回按钮
    backBtn = [[UIButton alloc] initWithFrame:CGRectMake(22, 44, 42, 42)];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
//    [self setupRefresh];
    [self headerRefresh];
}

- (NSMutableArray *)relates
{
    if (_relates == nil) {
        self.relates = [NSMutableArray array];
    }
    return _relates;

}

- (void)commonInit
{
    resourceArr = [[NSMutableArray alloc] init];
    
    flag = 0;
    
    UIView *backView = [[UIView alloc] initWithFrame:self.view.frame];
    backView.backgroundColor = [UIColor colorFromHexString:@"#EDEDF3"];
    [self.view addSubview:backView];
    
}


- (void)initTableView
{
    contentTableView = [[UITableView alloc] init];
//    CGRect frame = self.view.frame;
//    frame.size.height -= 64;
    contentTableView.frame = self.view.frame;
    
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    contentTableView.backgroundColor = [UIColor clearColor];
    contentTableView.showsVerticalScrollIndicator = NO;
    
    contentTableView.tableHeaderView = [self getHeaderView];
    
    [self.view addSubview:contentTableView];
}

- (void)initWaterFlow
{
    waterFlowH = 0;
    
    cellMargin = 10;
    
    columnOne = cellMargin;
    columnTwo = cellMargin;

    waterFlowArr = [[NSMutableArray alloc] init];
    waterDic = [[NSMutableDictionary alloc] init];
    
    qtmquitView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 0, 320, 110)];
    qtmquitView.delegate = self;
    qtmquitView.dataSource = self;
    qtmquitView.backgroundColor = [UIColor whiteColor];
    qtmquitView.bounces = NO;
    qtmquitView.scrollEnabled = NO;

}
#pragma mark backBtn
- (void)backBtnPress
{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark MJRefresh
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [contentTableView addHeaderWithTarget:self action:@selector(headerRefresh)];

    [self headerRefresh];
}

- (void)headerRefresh
{

    NSString *url = [NSString stringWithFormat:@"%@%@%@", kServerIP, kFetchContent, self.sourceUrl];

    NSLog(@"detailUrl:%@", url);
    [self getContentDetails:url];
}


#pragma mark tabelView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = resourceArr[indexPath.row];

    if ([dict.allKeys[0] isEqualToString:@"abs"]){
//        FTCoreTextCell *cell = (FTCoreTextCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//        CGFloat height = cell.cellH;
//        return height;
        AbsCell *cell = (AbsCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        CGFloat height = cell.cellH;
        return height;
    }
    else if ([dict.allKeys[0] isEqualToString:@"FTText"]){
        FTCoreTextCell *cell = (FTCoreTextCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        CGFloat height = cell.cellH;
        return height;
    }
    
    else if ([dict.allKeys[0] isEqualToString:@"baike"]){
        BaiduCell *cell = (BaiduCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.baiduFrm.cellH;
    } else if ([dict.allKeys[0] isEqualToString:@"zhihu"]){
        ZhihuCell *cell = (ZhihuCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellH;
    } else if ([dict.allKeys[0] isEqualToString:@"douban"]){
        DoubanCell *cell = (DoubanCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellH;
    } else {
        WeiboCell *cell = (WeiboCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellH;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *dict = resourceArr[indexPath.row];
    NSString *type = dict.allKeys[0];
    if ([type isEqualToString:@"img"]) {
        static NSString *cellId = @"ContentCell";
        
        ContentCell *cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //自定义UITableViewCell选中后的背景颜色和背景图片
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        cell.contentCellFrm = dict[type];
        return cell;
    }
    else if ([type isEqualToString:@"abs"])
    {
        static NSString *cellId = @"abs";
        
        AbsCell *cell = [[AbsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //自定义UITableViewCell选中后的背景颜色和背景图片
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        cell.absDatasource = dict[type];
        return cell;
        
    }
    else if ([type isEqualToString:@"FTText"])
    {
        static NSString *cellId = @"FTCell";

        FTCoreTextCell *cell = [[FTCoreTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //自定义UITableViewCell选中后的背景颜色和背景图片
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        cell.txtDatasource = dict[type];
        return cell;

    }
    else if ([type isEqualToString:@"baike"])
    {
        static NSString *cellId = @"baike";
        
        BaiduCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[BaiduCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //自定义UITableViewCell选中后的背景颜色和背景图片
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }
        cell.baiduFrm = dict[type];
        return cell;
    }
    else if ([type isEqualToString:@"zhihu"])
    {
        static NSString *cellId = @"zhihu";
        ZhihuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[ZhihuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }
        cell.zhihuDatasource = dict[type];
        return cell;
    }
    else if ([type isEqualToString:@"douban"])
    {
        static NSString *cellId = @"douban";
        DoubanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[DoubanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }
        cell.doubanDatasource = dict[type];
        return cell;
    }
    else
    {
        static NSString *cellId = @"weibo";
        WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }
        cell.weiboDatasource = dict[type];
        return cell;
    }

}

#pragma mark ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView == contentTableView) {
//
//        if (hasRelate && scrollView.contentOffset.y > scrollView.contentSize.height * 0.9) {
//            [self warterFlowReloadData];
//        }
//    }
    //判断滚动方向
    if (lastContentOffset < scrollView.contentOffset.y) {
//        NSLog(@"向上滚动");
        [self fadeOut];
    }else{
//        NSLog(@"向下滚动");
        [self fadeIn];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
}

#pragma mark Fadeout & fadein
- (void)fadeIn
{
    [UIView animateWithDuration:0.8 animations:^{
        backBtn.alpha = 1;
    }];
}

- (void)fadeOut
{
    [UIView animateWithDuration:0.8 animations:^{
        backBtn.alpha = 0;
    }];
}

#pragma mark setHeaderView
- (UIView *)getHeaderView
{
    CGFloat imgW = [UIScreen mainScreen].bounds.size.width;
    CGFloat imgH = imgW * 512 / 640;
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] init];;
    imgView.frame = CGRectMake(0, 0, imgW, imgH);
    imgView.image = [UIImage imageNamed:@"demo_1.png"];
    
    if (![NSString isBlankString:_imgStr]) {
        NSURL *url = [NSURL URLWithString:_imgStr];
        [imgView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image.size.width / image.size.height > imgView.frame.size.width / imgView.frame.size.height) {
                imgView.contentMode = UIViewContentModeScaleAspectFill;
                imgView.clipsToBounds = YES;
            } else {
                //若是竖图，截图图片中央位置
                imgView.image = [ScaleImage scaleImage:imgView.image size:imgView.frame.size];
            }
        }];
    }
    [backView addSubview:imgView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = _titleStr;
    titleLab.font = [UIFont fontWithName:kFont size:18];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.textColor = [UIColor colorFromHexString:@"#000000"];
    titleLab.numberOfLines = 2;
    
    CGFloat titleLabX = 20;
    if ([UIScreen mainScreen].bounds.size.width > 320) {
        titleLabX = 40;
    }
    CGFloat titleW = imgW - 2 * titleLabX;

    CGSize nameSize = [AutoLabelSize autoLabSizeWithStr:_titleStr Fontsize:18 SizeW:titleW SizeH:0];
    
    CGFloat titleY = 5;
    if (nameSize.height < 40) {
        titleY = 15;
    }
    
    titleLab.frame = CGRectMake(titleLabX, imgH + 15, titleW, nameSize.height);
    [backView addSubview:titleLab];
   
    UILabel *updateTimeLab = [[UILabel alloc] init];
    updateTimeLab.text = _updateTime;
    updateTimeLab.font = [UIFont fontWithName:kFont size:9];
    updateTimeLab.textColor = [UIColor colorFromHexString:@"#7f7f7f"];
    updateTimeLab.textAlignment = NSTextAlignmentLeft;
    CGFloat updateY = CGRectGetMaxY(titleLab.frame) + 15;
    updateTimeLab.frame = CGRectMake(titleLabX, updateY, 120, 12);
    [backView addSubview:updateTimeLab];
    
    UIImageView *hotImg = [[UIImageView alloc] init];
    CGFloat hotImgX = CGRectGetMaxX(updateTimeLab.frame);
    hotImg.frame = CGRectMake(hotImgX, updateY + 1, 14.5, 9);
    hotImg.image = [UIImage imageNamed:@"hot.png"];
    [backView addSubview:hotImg];
    
    UILabel *hotLab = [[UILabel alloc] init];
    CGFloat hotLabX = CGRectGetMaxX(hotImg.frame);
    hotLab.frame = CGRectMake(hotLabX, updateY, 30, 9);
    hotLab.font = [UIFont fontWithName:kFont size:9];
    hotLab.textColor = [UIColor colorFromHexString:@"#7f7f7f"];
    hotLab.text = self.rootClass;
    [backView addSubview:hotLab];
    
    CGFloat backViewH = CGRectGetMaxY(hotLab.frame) + 25;
    
    backView.frame = CGRectMake(0, 0, imgW, backViewH);
    
    return backView;
}

#pragma mark Get请求
- (void)getContentDetails:(NSString *)URL
{
    NSString *URLTmp = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  //转码成UTF-8  否则可能会出现错误
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLTmp]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //系统自带JSON解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        [self convertToDetailModel:resultDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    [operation start];
}


- (void)convertToDetailModel:(NSDictionary *)resultDic
{
    resourceArr = [[NSMutableArray alloc] init];
    
    NSString *absStr = resultDic[@"abs"];
    if (![NSString isBlankString:absStr]) {
        AbsDatasource *absData = [AbsDatasource absDatasourceWithStr:absStr];
        [self putToResourceArr:absData Method:@"abs"];
    }
    
    NSString *string = resultDic[@"content"];

    TxtDatasource *txtDatasource = [TxtDatasource txtDatasourceWithTxtStr:string];
    [self putToResourceArr:txtDatasource Method:@"FTText"];
    
    NSArray *baikeArr = resultDic[@"baike"];
    for (NSDictionary *dic in baikeArr) {
        NSString *baikeTitle = dic[@"title"];
        if (![NSString isBlankString:baikeTitle]) {
            BaiduFrame *baiduFrm = [[BaiduFrame alloc] init];
            baiduFrm.baiduDatasource = [BaiduDatasource baiduDatasourceWithDict:dic];
            [self putToResourceArr:baiduFrm Method:@"baike"];
        }
    }
    
    NSArray *zhihuArr = resultDic[@"zhihu"];
    if (zhihuArr != nil && ![zhihuArr isKindOfClass:[NSNull class]] && zhihuArr.count != 0) {
        ZhihuDatasource *zhihuDatasource = [ZhihuDatasource zhihuWithArr:zhihuArr];
        [self putToResourceArr:zhihuDatasource Method:@"zhihu"];
    }
    
    
    NSArray *doubanArr = resultDic[@"douban"];
    if (doubanArr != nil && ![doubanArr isKindOfClass:[NSNull class]] && doubanArr.count != 0) {
        DoubanDatasource *doubanDatasource = [DoubanDatasource doubanDatasourceWithArr:doubanArr];
        [self putToResourceArr:doubanDatasource Method:@"douban"];
    }
    
    NSArray *weiboArr = resultDic[@"weibo"];
    if (weiboArr != nil && ![weiboArr isKindOfClass:[NSNull class]] && weiboArr.count != 0) {
        WeiboDatasource *weiboDatasource = [WeiboDatasource weiboDatasourceWithArr:weiboArr];
        [self putToResourceArr:weiboDatasource Method:@"weibo"];
    }
    
#pragma mark - 瀑布流

    NSMutableArray *newRelates = [NSMutableArray array];
    for (NSDictionary *dict in resultDic[@"relate"]) {
        Relate *relate = [Relate relateWithDict:dict];
        [newRelates addObject:relate];
    }
    
    
    if (newRelates && newRelates.count > 0 && ![newRelates isKindOfClass:[NSNull class]]) {
        [self.relates addObjectsFromArray:newRelates];
        
#pragma mark - 计算总高度
        NSUInteger numberOfCells = self.relates.count;
        NSLog(@"%ld", numberOfCells);
        int numberOfColumns = 2;
        
        CGFloat topM = 10;
        CGFloat bottomM = 20;
        CGFloat leftM = 30;
        CGFloat columnM = 20;
        CGFloat rowM = 8;
        CGFloat rightM = leftM;
        
        CGFloat cellW = ([UIScreen mainScreen].bounds.size.width - leftM - rightM - (numberOfColumns - 1) * columnM) / numberOfColumns;
        
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
            Relate *relate = self.relates[i];
            CGFloat cellH = cellW * 0.7;
            if (relate.height != nil) {
                cellH = cellW * relate.height.floatValue / relate.width.floatValue;
                NSLog(@"k = %d", k);
            }
            
            CGFloat cellY = 0;
            if (minMaxYOfCellColumn == 0.0) {
                cellY = topM;
            } else {
                cellY = minMaxYOfCellColumn + rowM;
            }
            
            
            // 更新最短那一列的最大Y值
            maxYOfColumns[cellColumn] = cellY + cellH;
            NSLog(@"第%d个cell的cellHeight = %.1f", i+1, cellH);
        }
        
        NSLog(@"cellWidth = %.1f", cellW);
        
        
        // 设置contentSize
        CGFloat contentH = MAX(maxYOfColumns[0], maxYOfColumns[1]);
        contentH += bottomM;

        
        LPWaterfallView *waterfallView = [[LPWaterfallView alloc] init];
        waterfallView.backgroundColor = [UIColor whiteColor];

        waterfallView.dataSource = self;
        waterfallView.delegate = self;
        waterfallView.scrollEnabled = YES;
        
        waterfallView.frame = CGRectMake(0, 0, self.view.bounds.size.width, contentH);
        

        waterFlowH = contentH;
        
        
        contentTableView.tableFooterView = waterfallView;
        

        NSLog(@"waterfallView.contentOffset.y = %.1f", waterfallView.contentOffset.y);
        NSLog(@"contentH = %.1f", contentH);
        
        
    }
    
    
    
    [contentTableView reloadData];

    [contentTableView headerEndRefreshing];
}

#pragma mark - 数据源方法
- (NSUInteger)numberOfCellsInWaterfallView:(LPWaterfallView *)waterfallView
{
    return self.relates.count;
}

- (RelateCell *)waterfallView:(LPWaterfallView *)waterfallView cellAtIndex:(NSUInteger)index
{
    RelateCell *cell = [RelateCell cellWithWaterfallView:waterfallView];
    
    cell.relate = self.relates[index];
    
    return cell;
}

- (NSUInteger)numberOfColumnsInWaterfallView:(LPWaterfallView *)waterfallView
{
    return 2;
}

//- (void)dealloc
//{
//    contentTableView.tableHeaderView = nil;
//    contentTableView.tableFooterView = nil;
//}


#pragma mark - 代理方法
- (CGFloat)waterfallView:(LPWaterfallView *)waterfallView marginForType:(LPWaterfallViewMarginType)type
{
//    if (!contentTableView.tableFooterView) {
//        return 0;
//    }
    switch (type) {
        case LPWaterfallViewMarginTypeTop: return 10;
        case LPWaterfallViewMarginTypeBottom: return 10;
        case LPWaterfallViewMarginTypeLeft: return 30;
        case LPWaterfallViewMarginTypeRight: return 30;
        case LPWaterfallViewMarginTypeColumn: return 20;
        case LPWaterfallViewMarginTypeRow: return 8;
        default:
            return 10;
    }
}

-(CGFloat)waterfallView:(LPWaterfallView *)waterfallView heightAtIndex:(NSUInteger)index
{
    Relate *relate = self.relates[index];
    if (relate.height) {
        return waterfallView.cellWidth * relate.height.floatValue / relate.width.floatValue;
    } else { // 没提供宽高
        return waterfallView.cellWidth * 0.7;
    }
}

- (void)waterfallView:(LPWaterfallView *)waterfallView didSelectAtIndex:(NSUInteger)index
{
    Relate *relate = self.relates[index];
    [self loadWebViewWithURL:relate.url];
}

- (void)putToResourceArr:(id)resource Method:(NSString *)method
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:resource, method, nil];
    [resourceArr addObject:dict];
}


@end
