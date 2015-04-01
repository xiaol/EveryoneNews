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

#import "UIColor+HexToRGB.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
//#import "YLImageView.h"
#import "ScaleImage.h"

//#import "UIImage+GIF.h"



#define kTitleFont 17.0

@interface ContentViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *resourceArr;    //存储图文详细内容
    UITableView *contentTableView;
//    YLImageView *gifView;
    
//    UIImageView *imgView;
}

@end

@implementation ContentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSString *sourceId = @"4d4716525b6d76e79a657116f318ba2be5ba7068";
    
    NSString *url = @"http://121.41.75.213:9999/news/baijia/fetchContent?url=";
    url = [NSString stringWithFormat:@"%@%@", url, self.sourceUrl];
    for (NSString *str in self.responseUrls) {
        url = [NSString stringWithFormat:@"%@&filterurls=%@", url, str];
    }
//    [self getContentDetails:sourceId];
    [self getContentDetails:url];
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
//    if (self.hasImg) {
//        contentTableView.tableHeaderView = [self getHeaderView];
//    } else {
//        contentTableView.tableHeaderView = [self getHeaderViewWithoutImg];
//    }
    contentTableView.tableHeaderView = [self getHeaderView];
    
    
}

- (void)commonInit
{
    resourceArr = [[NSMutableArray alloc] init];
    
//    self.navigationController.navigationBarHidden = YES;
    
    UIView *backView = [[UIView alloc] initWithFrame:self.view.frame];
    backView.backgroundColor = [UIColor colorFromHexString:@"#EDEDF3"];
    [self.view addSubview:backView];
    
//    /* 添加GIF */
//    gifView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, 145, 141)];
//    gifView.center = CGPointMake(backView.center.x, backView.center.y - 64);
//    [backView addSubview:gifView];
//    gifView.image = [YLGIFImage imageNamed:@"yazi.gif"];
    
    
}
- (void)initTableView
{
    contentTableView = [[UITableView alloc] init];
    CGRect frame = self.view.frame;
    frame.size.height -= 64;
    contentTableView.frame = frame;
    
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    contentTableView.backgroundColor = [UIColor clearColor];
    contentTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentTableView];
}


#pragma mark tabelView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resourceArr.count;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row < resourceArr.count ) {
//        NSDictionary *dict = resourceArr[indexPath.row];
//        if ([dict.allKeys[0] isEqualToString:@"img"]) {
//            CGFloat width = [UIScreen mainScreen].bounds.size.width - 2 * 15;
//            CGFloat height = width * 9 / 16;
//            return height;
//        } else
//            return 0;
//    }
//    else {
//        return 0;
//
//    }
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = resourceArr[indexPath.row];
//    if ([dict.allKeys[0] isEqualToString:@"img"]) {
//        ContentCellFrame *frm = dict[@"img"];
//        return [frm cellHeight];
//    } else
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
    } else {
        DoubanCell *cell = (DoubanCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
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
        }
        cell.zhihuDatasource = dict[type];
        return cell;
    }
    else
    {
        static NSString *cellId = @"douban";
        DoubanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[DoubanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        }
        cell.doubanDatasource = dict[type];
        return cell;
    }

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
//            [SVProgressHUD dismiss];
        }];
    }
    [backView addSubview:imgView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = _titleStr;
    titleLab.font = [UIFont fontWithName:kFont size:18];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.textColor = [UIColor colorFromHexString:@"#000000"];
    titleLab.numberOfLines = 2;
    
    CGFloat titleW = imgW - 14;
    /***************** 标题过长时自动转行 ********************************/
    NSDictionary * attribute = @{NSFontAttributeName: [UIFont fontWithName:kFont size:18]};
    CGSize nameSize = [_titleStr boundingRectWithSize:CGSizeMake(titleW, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    CGFloat titleY = 5;
    if (nameSize.height < 40) {
        titleY = 15;
    }
    titleLab.frame = CGRectMake(7, imgH, titleW, nameSize.height);
    [backView addSubview:titleLab];
   
    UILabel *updateTimeLab = [[UILabel alloc] init];
    updateTimeLab.text = _updateTime;
    updateTimeLab.font = [UIFont fontWithName:kFont size:9];
    updateTimeLab.textColor = [UIColor colorFromHexString:@"#7f7f7f"];
    updateTimeLab.textAlignment = NSTextAlignmentLeft;
    CGFloat updateY = CGRectGetMaxY(titleLab.frame) + 15;
    updateTimeLab.frame = CGRectMake(7, updateY, 120, 12);
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
    
    CGFloat backViewH = CGRectGetMaxY(updateTimeLab.frame) + 25;
    
    backView.frame = CGRectMake(0, 0, imgW, backViewH);
    
    return backView;
}

- (UIView *)getHeaderViewWithoutImg
{
    UIView *backView = [[UIView alloc] init];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = _titleStr;
    titleLab.font = [UIFont boldSystemFontOfSize:kTitleFont];
    titleLab.textAlignment = NSTextAlignmentLeft;
//    titleLab.textColor = [UIColor colorFromHexString:@"#ffffff"];
    titleLab.textColor = [UIColor blackColor];
    titleLab.numberOfLines = 0;
    CGFloat titleW = [UIScreen mainScreen].bounds.size.width - 14;
    /***************** 标题过长时自动转行 ********************************/
    NSDictionary * attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleFont]};
    CGSize nameSize = [_titleStr boundingRectWithSize:CGSizeMake(titleW, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

    
    titleLab.frame = CGRectMake(7, 5, titleW, nameSize.height);
    [backView addSubview:titleLab];
    
    UILabel *sourceSite = [[UILabel alloc] init];
    sourceSite.text = _sourceSite;
    sourceSite.font = [UIFont systemFontOfSize:10];
//    sourceSite.textColor = [UIColor colorFromHexString:@"#ffffff"];
    sourceSite.textColor = [UIColor blackColor];
    sourceSite.textAlignment = NSTextAlignmentLeft;
    CGFloat sourceSiteY = CGRectGetMaxY(titleLab.frame) + 15;
    sourceSite.frame = CGRectMake(10, sourceSiteY, 150, 11);
    [backView addSubview:sourceSite];
    
    UILabel *updateTimeLab = [[UILabel alloc] init];
    updateTimeLab.text = _updateTime;
    updateTimeLab.font = [UIFont systemFontOfSize:10];
//    updateTimeLab.textColor = [UIColor colorFromHexString:@"#ffffff"];
    updateTimeLab.textColor = [UIColor blackColor];
    updateTimeLab.textAlignment = NSTextAlignmentLeft;
    CGFloat updateX = CGRectGetMaxX(titleLab.frame) - 120 - 20;
    updateTimeLab.frame = CGRectMake(updateX, sourceSiteY, 120, 11);
    [backView addSubview:updateTimeLab];
    
    CGFloat backViewH = CGRectGetMaxY(updateTimeLab.frame);
    backView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, backViewH);
    backView.backgroundColor = [UIColor whiteColor];

    
    return backView;
}

#pragma mark Get请求
- (void)getContentDetails:(NSString *)URL
{
//    URL = [NSString stringWithFormat:@"http://api.up.oforever.net/eagle/FetchContent?id=%@", URL];
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

//- (void)convertToDetailModel:(NSDictionary *)resultDic
//{
//    resourceArr = [[NSMutableArray alloc] init];
//    
//    NSArray *content = resultDic[@"content"];
//    //调用解析函数
//    for (NSArray *arr in content) {
//        for (NSDictionary *dict in arr) {
//            NSArray *keyArr = dict.allKeys;
//            /* 头图去重 */
//
//            if ([keyArr[0] isEqualToString:@"img"]) {
//                NSLog(@"imgUrl:%@", dict[@"img"]);
//                if  (![dict[@"img"] isEqualToString:self.imgStr]) {
//                    ContentCellFrame *contentFrm = [[ContentCellFrame alloc] init];
//                    contentFrm.contentDatasource = [ContentDatasource contentDatasourceWithImgStr:dict[@"img"]];
//                    [self putToResourceArr:contentFrm Method:@"img"];
//                }
//            }
//            else
//            {
//                NSString *string = dict[@"txt"];
//                //**** 字符串去特殊符号 ****// //--此地需要重新设置判断及循环
//                NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
//                NSString *trimmedString = [string stringByTrimmingCharactersInSet:set];
//                trimmedString = [trimmedString stringByTrimmingCharactersInSet:set];
//                //**** 去空格 ****//
//                set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//                trimmedString = [trimmedString stringByTrimmingCharactersInSet:set];
//                NSLog(@"string:%@", trimmedString);
//
//                TxtDatasource *txtDatasource = [TxtDatasource txtDatasourceWithTxtStr:trimmedString];
//                [self putToResourceArr:txtDatasource Method:@"FTText"];
//            }
//        }
//    }
//    
//    [self.view addSubview:contentTableView];
//    [contentTableView reloadData];
//    gifView.image = nil;
////    gifImg.image = nil;
//}

- (void)convertToDetailModel:(NSDictionary *)resultDic
{
    resourceArr = [[NSMutableArray alloc] init];
    
    NSString *string = resultDic[@"content"];
//    //**** 字符串去特殊符号 ****// //--此地需要重新设置判断及循环
//    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
//    NSString *trimmedString = [string stringByTrimmingCharactersInSet:set];
//    trimmedString = [trimmedString stringByTrimmingCharactersInSet:set];
//    //**** 去空格 ****//
//    set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//    trimmedString = [trimmedString stringByTrimmingCharactersInSet:set];
//    NSLog(@"string:%@", trimmedString);

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
    
    
    NSDictionary *zhihuDic = resultDic[@"zhihu"];
    NSString *zhihuTitle = zhihuDic[@"title"];
    if (![self isBlankString:zhihuTitle]) {
        ZhihuDatasource *zhihuDatasource = [ZhihuDatasource zhihuWithDict:zhihuDic];
        [self putToResourceArr:zhihuDatasource Method:@"zhihu"];
    }
    
    NSArray *doubanArr = resultDic[@"douban"];
    if (doubanArr != nil && ![doubanArr isKindOfClass:[NSNull class]] && doubanArr.count != 0) {
        DoubanDatasource *doubanDatasource = [DoubanDatasource doubanDatasourceWithArr:doubanArr];
        [self putToResourceArr:doubanDatasource Method:@"douban"];
    }
    
    [contentTableView reloadData];
}

- (void)putToResourceArr:(id)resource Method:(NSString *)method
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:resource, method, nil];
    [resourceArr addObject:dict];
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


@end
