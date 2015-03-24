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
//#import "TextCell.h"
//#import "LikeNShareCell.h"
//#import "CorrelationCell.h"
#import "FTCoreTextCell.h"
#import "TxtCell.h"
//#import "TextCellFrame.h"
#import "UIColor+HexToRGB.h"
//#import "DetailHeaderView.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "YLImageView.h"
#import "ScaleImage.h"

#import "UIImage+GIF.h"

#import "UMSocial.h"


#define kTitleFont 17.0

@interface ContentViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *resourceArr;
    UITableView *contentTableView;
    NSMutableArray *resourceList;
    YLImageView *gifView;
//    UIImageView *gifImg;
    
    UIImageView *imgView;
}

@end

@implementation ContentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getContentDetails:self.sourceId];
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
    if (self.hasImg) {
        contentTableView.tableHeaderView = [self getHeaderView];
    } else {
        contentTableView.tableHeaderView = [self getHeaderViewWithoutImg];
    }
    
    
}

- (void)commonInit
{
    resourceArr = [[NSMutableArray alloc] init];
    resourceList = [[NSMutableArray alloc] init];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.view.frame];
    backView.backgroundColor = [UIColor colorFromHexString:@"#EDEDF3"];
    [self.view addSubview:backView];
    
    /* 添加GIF */
    gifView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, 145, 141)];
    gifView.center = CGPointMake(backView.center.x, backView.center.y - 64);
    [backView addSubview:gifView];
    gifView.image = [YLGIFImage imageNamed:@"yazi.gif"];
    
//    gifImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 145, 141)];
//    gifImg.center = CGPointMake(backView.center.x, backView.center.y - 64);
//    [backView addSubview:gifImg];
//    gifImg.image = [UIImage sd_animatedGIFNamed:@"yazi.gif"];
    
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
    contentTableView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:contentTableView];
}


#pragma mark tabelView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (resourceList.count > 0) {
        return resourceArr.count + 2 + resourceList.count;
    }
    else
    {
        return resourceArr.count + 1;
    }
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
    if (indexPath.row < resourceArr.count) {
        NSDictionary *dict = resourceArr[indexPath.row];
        if ([dict.allKeys[0] isEqualToString:@"img"]) {
            ContentCellFrame *frm = dict[@"img"];
            return [frm cellHeight];
        }
        else
        {
            
            FTCoreTextCell *cell = (FTCoreTextCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            CGFloat height = cell.cellH;
            return height;
        }
        
    }
    else if (indexPath.row == resourceArr.count)
    {
        if (resourceArr.count == 0) {
            return 0;
        }
        return 32; //like & share Height
    }
    else if (indexPath.row == resourceArr.count + 1)
    {
        return 40; //相关 Height
    }
    else
    {
        return [resourceList[indexPath.row - resourceArr.count - 2] cellHeight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (resourceList.count > 0) {
        if (indexPath.row < resourceArr.count) {
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
            else
            {
                static NSString *cellId = @"FTCell";

                FTCoreTextCell *cell = [[FTCoreTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //自定义UITableViewCell选中后的背景颜色和背景图片
                cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
                cell.txtDatasource = dict[type];
                return cell;

            }
        }
        else if (indexPath.row == resourceArr.count && resourceArr.count > 0 && indexPath.row != 0)
        {

        }
        else if (indexPath.row == resourceArr.count + 1)
        {

        }
        else
        {

            return nil;
        }
    }
    else
    {
        if (indexPath.row < resourceArr.count)
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
            else
            {
                static NSString *cellId = @"FTCell";

                FTCoreTextCell *cell = [[FTCoreTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //自定义UITableViewCell选中后的背景颜色和背景图片
                cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
                cell.txtDatasource = dict[type];
                return cell;
            }
        }
        else
        {
            if (resourceArr.count > 0 && indexPath.row != 0) {

            } else {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                return cell;
            }
        }
    }
}

#pragma mark setHeaderView
- (UIView *)getHeaderView
{
    CGFloat imgW = [UIScreen mainScreen].bounds.size.width;
    CGFloat imgH = imgW * 512 / 640;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgH)];
    imgView = [[UIImageView alloc] init];;
    imgView.frame = backView.frame;
    imgView.image = [UIImage imageNamed:@"defaultImgBig.png"];
    
    if (![self isBlankString:_imgStr]) {
        NSURL *url = [NSURL URLWithString:_imgStr];
        [imgView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (imgView.image.size.width / imgView.image.size.height > imgView.frame.size.width / imgView.frame.size.height) {
                imgView.contentMode = UIViewContentModeScaleAspectFill;
//                imgView.frame = _headerCellFrm.imgFrame;
                imgView.clipsToBounds = YES;
            } else {
                imgView.image = [ScaleImage scaleImage:imgView.image size:imgView.frame.size];
            }

            [SVProgressHUD dismiss];
        }];
    }
    [backView addSubview:imgView];
    
    UIImageView *shadow = [[UIImageView alloc] init];
    shadow.image = [UIImage imageNamed:@"toum.png"];
    shadow.alpha = 0.7;
    CGFloat shadowY = CGRectGetMaxY(backView.frame) - 67;
    shadow.frame = CGRectMake(0, shadowY, imgW, 67);
    [backView addSubview:shadow];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = _titleStr;
    titleLab.font = [UIFont boldSystemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.textColor = [UIColor colorFromHexString:@"#ffffff"];
    titleLab.numberOfLines = 2;
    
    CGFloat titleW = imgW - 14;
    /***************** 标题过长时自动转行 ********************************/
    NSDictionary * attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleFont]};
    CGSize nameSize = [_titleStr boundingRectWithSize:CGSizeMake(titleW, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    CGFloat titleY = 5;
    if (nameSize.height < 40) {
        titleY = 15;
    }
    titleLab.frame = CGRectMake(7, titleY, titleW, nameSize.height);
    [shadow addSubview:titleLab];
    
    UILabel *sourceSite = [[UILabel alloc] init];
    sourceSite.text = _sourceSite;
    sourceSite.font = [UIFont systemFontOfSize:10];
    sourceSite.textColor = [UIColor colorFromHexString:@"#ffffff"];
    sourceSite.textAlignment = NSTextAlignmentLeft;
    CGFloat sourceSiteY = shadow.frame.size.height - 11 - 5;
    sourceSite.frame = CGRectMake(10, sourceSiteY, 150, 11);
    [shadow addSubview:sourceSite];
    
    UILabel *updateTimeLab = [[UILabel alloc] init];
    updateTimeLab.text = _updateTime;
    updateTimeLab.font = [UIFont systemFontOfSize:10];
    updateTimeLab.textColor = [UIColor colorFromHexString:@"#ffffff"];
    updateTimeLab.textAlignment = NSTextAlignmentLeft;
//    CGFloat updateX = CGRectGetMaxX(sourceSite.frame) + 25;
    CGFloat updateX = CGRectGetMaxX(titleLab.frame) - 120 - 20;
    updateTimeLab.frame = CGRectMake(updateX, sourceSiteY, 120, 11);
    [shadow addSubview:updateTimeLab];
    
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
    URL = [NSString stringWithFormat:@"http://api.up.oforever.net/eagle/FetchContent?id=%@", URL];
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
    
    NSArray *content = resultDic[@"content"];
    //调用解析函数
    for (NSArray *arr in content) {
        for (NSDictionary *dict in arr) {
            NSArray *keyArr = dict.allKeys;
            /* 头图去重 */

            if ([keyArr[0] isEqualToString:@"img"]) {
                NSLog(@"imgUrl:%@", dict[@"img"]);
                if  (![dict[@"img"] isEqualToString:self.imgStr]) {
                    ContentCellFrame *contentFrm = [[ContentCellFrame alloc] init];
                    contentFrm.contentDatasource = [ContentDatasource contentDatasourceWithImgStr:dict[@"img"]];
                    [self putToResourceArr:contentFrm Method:@"img"];
                }
            }
            else
            {
                NSString *string = dict[@"txt"];
                //**** 字符串去特殊符号 ****// //--此地需要重新设置判断及循环
                NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
                NSString *trimmedString = [string stringByTrimmingCharactersInSet:set];
                trimmedString = [trimmedString stringByTrimmingCharactersInSet:set];
                //**** 去空格 ****//
                set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                trimmedString = [trimmedString stringByTrimmingCharactersInSet:set];
                NSLog(@"string:%@", trimmedString);

                TxtDatasource *txtDatasource = [TxtDatasource txtDatasourceWithTxtStr:trimmedString];
                [self putToResourceArr:txtDatasource Method:@"FTText"];
            }
        }
    }
    
//    resourceList = [[NSMutableArray alloc] init];
//    NSMutableArray *elementListArr = resultDic[@"elementList"];
//    if (elementListArr.count > 0) {
//        //头图Cell的解析
//        //图文解析
//        for (int i = 0; i < elementListArr.count; i++) {
//            BOOL isFirstCell = NO;
//            if (i == 0) {
//                isFirstCell = YES;
//            }
//            NSDictionary *temp = elementListArr[i];
//            TextCellFrame *textCellFrame = [[TextCellFrame alloc] init];
//            textCellFrame.textDatasource = [TextDatasource textDatasourceWithDict:temp IsFirstCell:isFirstCell RootClass:@"-1"];
//            textCellFrame.baseView = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, textCellFrame.cellHeight);
//            CGRect frm = textCellFrame.backgroupViewFrame;
//            frm.origin.x = frm.origin.x + 10;
//            textCellFrame.backgroupViewFrame = frm;
//            [resourceList addObject:textCellFrame];
//        }
//    }

    [self.view addSubview:contentTableView];
    [contentTableView reloadData];
    gifView.image = nil;
//    gifImg.image = nil;
}

- (void)putToResourceArr:(id)resource Method:(NSString *)method
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:resource, method, nil];
    [resourceArr addObject:dict];
}

#pragma mark TxtDelegate
- (void)getTextContent:(NSString *)sourceId imgUrl:(NSString *)imgUrl SourceSite:(NSString *)sourceSite Update:(NSString *)update Title:(NSString *)title sourceUrl:(NSString *)sourceUrl hasImg:(BOOL)hasImg favorNum:(int)favorNum
{
    ContentViewController *contentVC = [[ContentViewController alloc] init];
    
    contentVC.sourceId = sourceId;
    contentVC.imgStr = imgUrl;
    contentVC.sourceSite = sourceSite;
    contentVC.titleStr = title;
    contentVC.updateTime = update;
    contentVC.hasImg = hasImg;
    contentVC.favorNum = favorNum;
    [self.navigationController pushViewController:contentVC animated:YES];
    
    NSLog(@"sourceId:%@", sourceId);
    NSLog(@"sourceUrl:%@", sourceUrl);

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

- (void)share
{
    NSString *shareText = [NSString stringWithFormat:@"%@", self.titleStr];

//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"550811d8fd98c53b4d00074c"
//                                      shareText:shareText
//                                     shareImage:imgView.image
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,
//                                                 UMShareToWechatSession,UMShareToWechatTimeline,nil]
//                                       delegate:self];
    

    [[UMSocialControllerService defaultControllerService] setShareText:@"分享内嵌文字" shareImage:[UIImage imageNamed:@"icon"] socialUIDelegate:self];        //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        
        [self.navicationController dismissViewControllerAnimated:YES completion:nil];
    }
    if(response.responseCode == UMSResponseCodeFaild)
    {
        NSLog(@"share failed");
    }
    if (response.responseCode == UMSResponseCodeNotLogin) {
        NSLog(@"未登陆");
    }

}


@end
