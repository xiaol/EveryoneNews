//
//  ContentViewController.m
//  upNews
//
//  Created by 于咏畅 on 15/1/20.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "ContentViewController.h"
#import "AFNetworking.h"
#import "ContentCell.h"

#import "FTCoreTextCell.h"
#import "BaiduCell.h"
#import "ZhihuCell.h"
#import "DoubanCell.h"
#import "WeiboCell.h"

#import "UIColor+HexToRGB.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "ScaleImage.h"

#import "MJRefresh.h"

#import "TMQuiltView.h"
#import "TMPhotoQuiltViewCell.h"

#import "WebViewController.h"

#import "AutoLabelSize.h"

@interface ContentViewController ()<UITableViewDataSource, UITableViewDelegate, TMQuiltViewDataSource,TMQuiltViewDelegate, WebDelegate>
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
    CGFloat flag;
    
    UIButton *backBtn;
    float lastContentOffset;
    
}

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

- (void)commonInit
{
    resourceArr = [[NSMutableArray alloc] init];
    
    
    
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


#pragma mark WaterFlow Function
-(void)warterFlowReloadData{

    CGRect rect;
    if (waterFlowH == 0) {
        
        NSInteger i = waterFlowArr.count / 2 + waterFlowArr.count % 2;
        
        qtmquitView.frame = CGRectMake(0, qtmquitView.frame.origin.y, qtmquitView.contentSize.width, i * 110);
        contentTableView.tableFooterView = qtmquitView;

    } else {
//        NSLog(@"waterHeight:%f", waterFlowH);
        
        rect = CGRectMake(0, qtmquitView.frame.origin.y, qtmquitView.contentSize.width, waterFlowH);
        qtmquitView = [[TMQuiltView alloc] initWithFrame:rect];
        qtmquitView.delegate = self;
        qtmquitView.dataSource = self;
        qtmquitView.backgroundColor = [UIColor whiteColor];
        qtmquitView.bounces = NO;
        qtmquitView.scrollEnabled = NO;
        contentTableView.tableFooterView = qtmquitView;
        contentTableView.contentSize = CGSizeMake(contentTableView.frame.size.width, qtmquitView.frame.origin.y + waterFlowH);
        
    }
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

    if ([dict.allKeys[0] isEqualToString:@"FTText"]){
        FTCoreTextCell *cell = (FTCoreTextCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        CGFloat height = cell.cellH;
        return height;
    } else if ([dict.allKeys[0] isEqualToString:@"baike"]){
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
    if (scrollView == contentTableView) {

        if (hasRelate && scrollView.contentOffset.y > scrollView.contentSize.height * 0.9) {
            [self warterFlowReloadData];
        }
    }
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
    imgView.image = [UIImage imageNamed:@"demo_1.jpg"];
    
    if (![self isBlankString:_imgStr]) {
        NSURL *url = [NSURL URLWithString:_imgStr];
        [imgView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (imgView.image.size.width / imgView.image.size.height > imgView.frame.size.width / imgView.frame.size.height) {
                imgView.contentMode = UIViewContentModeScaleAspectFill;
                imgView.clipsToBounds = YES;
            } else {
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
    
    CGFloat leftMarkY = 25 + CGRectGetMaxY(updateTimeLab.frame);
    UIImageView *leftMark = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabX, leftMarkY, 11, 15)];
    leftMark.image = [UIImage imageNamed:@"leftMark.png"];
    [backView addSubview:leftMark];
    
    CGFloat bigTitleY = leftMarkY + 12.5;
    CGFloat bigTitleX = titleLabX + 14;
    CGFloat bigTitleW = imgW - 1.8 * bigTitleX;
    
    nameSize = [AutoLabelSize autoLabSizeWithStr:_titleStr Fontsize:16 SizeW:bigTitleW SizeH:0];
    
    UILabel *bigTitle = [[UILabel alloc] initWithFrame:CGRectMake(bigTitleX, bigTitleY, bigTitleW, nameSize.height)];
    bigTitle.font = [UIFont fontWithName:kFont size:16];
    bigTitle.textColor = [UIColor blackColor];
    bigTitle.numberOfLines = 2;
    bigTitle.text = _titleStr;
    [backView addSubview:bigTitle];
    
    CGFloat rightMarkY = CGRectGetMaxY(bigTitle.frame);
    CGFloat rightMarkX = CGRectGetMaxX(titleLab.frame) - 15;
    UIImageView *rightMark = [[UIImageView alloc] initWithFrame:CGRectMake(rightMarkX, rightMarkY, 11, 15)];
    rightMark.image = [UIImage imageNamed:@"rightMark.png"];
    [backView addSubview:rightMark];
    
    CGFloat backViewH = CGRectGetMaxY(rightMark.frame) + 25;
    
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
    
    NSString *string = resultDic[@"content"];

    TxtDatasource *txtDatasource = [TxtDatasource txtDatasourceWithTxtStr:string];
    [self putToResourceArr:txtDatasource Method:@"FTText"];
    
    NSArray *baikeArr = resultDic[@"baike"];
    for (NSDictionary *dic in baikeArr) {
        NSString *baikeTitle = dic[@"title"];
        if (![self isBlankString:baikeTitle]) {
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
    
    waterFlowArr = resultDic[@"relate"];
    if (waterFlowArr != nil && ![waterFlowArr isKindOfClass:[NSNull class]] && waterFlowArr.count != 0) {

        hasRelate = YES;
        [qtmquitView reloadData];
    }
    
    [contentTableView reloadData];
    [contentTableView headerEndRefreshing];
}

- (void)putToResourceArr:(id)resource Method:(NSString *)method
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:resource, method, nil];
    [resourceArr addObject:dict];
}

#pragma mark waterFlow methods

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return waterFlowArr.count;
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
    }
    
    NSDictionary *dic = waterFlowArr[indexPath.row];
    
    cell.titleLabel.text = dic[@"title"];
    NSString *imgStr = dic[@"img"];
    if ([self isBlankString:imgStr] || [imgStr hasPrefix:@".."]) {
        cell.photoView.image = [UIImage imageNamed:@"demo_1.jpg"];
        
        NSArray *keyArr = waterDic.allKeys;
        if (![keyArr containsObject:[NSString stringWithFormat:@"%ld", indexPath.row]]) {
            
            waterFlowH = [self getHeight:100];
            [waterDic setObject:[NSNumber numberWithFloat:100.0] forKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
        }
    }
    else
    {
        NSURL *imgUrl = [NSURL URLWithString:dic[@"img"]];
        
        [cell.photoView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"demo_1.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            CGFloat imgW = ([UIScreen mainScreen].bounds.size.width - 30 ) / 2;
            if (image.size.width < imgW) {
                imgW = image.size.width;
            }
            CGFloat imgH = image.size.height * imgW / image.size.width;
            if (imgH == 0) {
                imgH = 100;
            }
            
            //每个Cell只重调一次
            NSArray *keyArr = waterDic.allKeys;
            if (![keyArr containsObject:[NSString stringWithFormat:@"%ld", indexPath.row]]) {
                
                [waterDic setObject:[NSNumber numberWithFloat:imgH] forKey:[NSString stringWithFormat:@"%ld", indexPath.row]];

                if (indexPath.row == 0) {
                    columnOne = imgH + cellMargin * 2;
                    CGFloat tempH = columnOne;
                    waterFlowH = (waterFlowH > tempH)?waterFlowH:tempH;
                    NSLog(@"waterFlowH:%f index----:0", waterFlowH);
//                    waterFlowH = [self getHeight:imgH];
                } else if (indexPath.row == 1) {
                    columnTwo = imgH + cellMargin * 2;
                    CGFloat tempH = (columnOne > columnTwo)?columnOne:columnTwo;
                    waterFlowH = (waterFlowH > tempH)?waterFlowH:tempH;
                    NSLog(@"waterFlowH:%f index----:1", waterFlowH);
                } else {
                    waterFlowH = [self getHeight:imgH];
                }
                
                
                [self warterFlowReloadData];
            }
            
            cell.photoView.image = [ScaleImage scaleImage:cell.photoView.image size:CGSizeMake(imgW, imgH)];
        }];
    }
   
    return cell;
}

#pragma mark - TMQuiltViewDelegate

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {

    return 2;
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{

    if (waterDic.count != 0) {
        CGFloat height = [waterDic[[NSString stringWithFormat:@"%ld", indexPath.row]] floatValue];
        if (height == 0) {
            return 100;
        } else {
            NSLog(@"height:%f indexPath:%ld", height, indexPath.row);
            return height;
        }
        
    }
    else {
        return 100;
    }

}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index:%ld",indexPath.row);
}

#pragma mark WebDelegate
- (void)loadWebViewWithURL:(NSString *)URL
{
    WebViewController *webVC = [[WebViewController alloc] init];
    
    webVC.webUrl = URL;
    
    [self.navigationController pushViewController:webVC animated:YES];
}



#pragma mark 判断字符串是否为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark 计算高度

- (CGFloat)getHeight:(CGFloat)height
{

    if (columnTwo > columnOne) {
        columnOne = columnOne + height + cellMargin;
    } else {
        columnTwo = columnTwo + height + cellMargin;
    }
    
    if (columnOne > columnTwo) {
        waterFlowH = columnOne;
    } else {
        waterFlowH = columnTwo;
    }
    NSLog(@"waterFlowH:%f", waterFlowH);
    return waterFlowH;
}


@end
