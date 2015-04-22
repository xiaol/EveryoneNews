//
//  ViewController.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/23.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "ViewController.h"
#import "HeadViewCell.h"
#import "BigImgCell.h"
#import "ContentViewController.h"
#import "UIColor+HexToRGB.h"
#import "AFNetworking.h"
#import "MJRefresh.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, HeadViewDelegate>
{
    UITableView *myTableView;
    NSMutableArray *dataArr;
    int page;
    BOOL isRefreshing;
    
    NSInteger hasLoad;
    NSInteger rat;
    BOOL stopFadein;
    
}

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"FeedViewController receive Memory Warning");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
}

- (void)commonInit
{
    dataArr = [[NSMutableArray alloc] init];
    page = 1;
    isRefreshing = YES;
    hasLoad = 0;
    
    [self tableViewInit];
    [self setupRefresh];

    [self followRollingScrollView:myTableView];
    
//    [self getRequest:[NSString stringWithFormat:@"%@%@", kServerIP, kFetchHome]];
    [self getRequest:[NSString stringWithFormat:@"%@%@", kServerIP, kTimenews]];
}

- (void)tableViewInit
{
    myTableView = [[UITableView alloc] init];
    CGFloat W = self.view.frame.size.width;
    CGFloat H = self.view.frame.size.height - 64;
    myTableView.frame = CGRectMake(0, 0, W, H);
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.backgroundColor = [UIColor colorFromHexString:@"#EBEDED"];

    [self.view addSubview:myTableView];
}

#pragma mark MJRefresh
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [myTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [myTableView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    [self headerRefresh];
}

- (void)headerRefresh
{
    [myTableView headerEndRefreshing];
    
    isRefreshing = YES;
    
    if (hasLoad != dataArr.count || hasLoad == 0) {
        hasLoad++;
    }

    rat = hasLoad - 1;
    
    [myTableView reloadData];
   
//   [self getRequest:[NSString stringWithFormat:@"%@%@", kServerIP, kFetchHome]];
}


- (void)footerRefresh
{
    page++;
    NSString *url = [NSString stringWithFormat:@"%@%@?page=%d", kServerIP, kFetchHome, page];
    isRefreshing = NO;
    [self getRequest:url];
    
//    [self getRequest:[NSString stringWithFormat:@"%@%@", kServerIP, kTimenews]];
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (dataArr != nil && ![dataArr isKindOfClass:[NSNull class]] && dataArr.count != 0) {
        return hasLoad;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (dataArr != nil && ![dataArr isKindOfClass:[NSNull class]] && dataArr.count != 0) {
//        HeadViewCell *cell = (HeadViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//        CGFloat height = cell.headViewFrm.cellH;
//        return height;
//    } else {
//        return 0;
//    }
    NSDictionary *dict = dataArr[rat - indexPath.row];
    NSString *type = dict.allKeys[0];
    if ([type isEqualToString:@"headView"]){

        HeadViewCell *cell = (HeadViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        CGFloat height = cell.headViewFrm.cellH;
        return height;
    } else if ([type isEqualToString:@"bigImg"]) {
        BigImgCell *cell = (BigImgCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.bigImgFrm.CellH;
    } else {
        return 0;
    }


}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSDictionary *dict = resourceArr[indexPath.row];
    NSDictionary *dict = dataArr[rat - indexPath.row];
    NSString *type = dict.allKeys[0];
    if ([type isEqualToString:@"headView"]) {
        
        static NSString *cellId = @"headViewCell";
        HeadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[HeadViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //自定义UITableViewCell选中后的背景颜色和背景图片
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }
        if (indexPath.row == 0 && !stopFadein) {
            cell.contentView.alpha = 0;
            [UIView animateWithDuration:1 animations:^{
                cell.contentView.alpha = 1;
            }];
        }
        if ((rat - indexPath.row) == (dataArr.count - 1)) {
            stopFadein = YES;
        }
        cell.headViewFrm = dict[type];
        
        return cell;
    } else {
        static NSString *cellId = @"bigImg";
        BigImgCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[BigImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //自定义UITableViewCell选中后的背景颜色和背景图片
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }
        if (indexPath.row == 0 && !stopFadein) {
            cell.contentView.alpha = 0;
            [UIView animateWithDuration:1 animations:^{
                cell.contentView.alpha = 1;
            }];
        }
        if ((rat - indexPath.row) == (dataArr.count - 1)) {
            stopFadein = YES;
        }
        cell.bigImgFrm = dict[type];
        
        return cell;
    }

    
}


- (void)getTextContent:(NSString *)sourceUrl imgUrl:(NSString *)imgUrl SourceSite:(NSString *)sourceSite Update:(NSString *)update Title:(NSString *)title ResponseUrls:(NSArray *)responseUrls RootClass:(NSString *)rootClass hasImg:(BOOL)hasImg
{
    ContentViewController *contentVC = [[ContentViewController alloc] init];
    contentVC.sourceUrl = sourceUrl;
    contentVC.imgStr = imgUrl;
    contentVC.sourceSite = sourceSite;
    contentVC.titleStr = title;
    contentVC.hasImg = hasImg;
    contentVC.updateTime = update;
    contentVC.responseUrls = responseUrls;
    contentVC.rootClass = rootClass;
    [self.navigationController pushViewController:contentVC animated:YES];

}

#pragma mark AFNetworking
- (void)getRequest:(NSString *)URL
{
    
    NSString *URLTmp = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  //转码成UTF-8  否则可能会出现错误
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLTmp]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //系统自带JSON解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        
        [self convertToModel:resultDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    [operation start];
    
    stopFadein = NO;
    
}

- (void)convertToModel:(NSDictionary *)resultDic
{
    if (isRefreshing) {
        dataArr = [[NSMutableArray alloc] init];
    }
    
    for (NSDictionary *dict in resultDic) {
        
        NSString * special = [NSString stringWithFormat:@"1%@", dict[@"special"]];

        if (![special isEqualToString:@"11"]) {
            HeadViewFrame *headViewFrm = [[HeadViewFrame alloc] init];
            headViewFrm.headViewDatasource = [HeadViewDatasource headViewDatasourceWithDict:dict];
            [self putToResourceArr:headViewFrm Method:@"headView"];

        } else {
            BigImgFrm *bigImgFrm = [[BigImgFrm alloc] init];
            bigImgFrm.bigImgDatasource = [BigImgDatasource bigImgDatasourceWithDict:dict];
            [self putToResourceArr:bigImgFrm Method:@"bigImg"];

        }
        
//        [dataArr addObject:headViewFrm];
    }
    
    [myTableView reloadData];
    [myTableView headerEndRefreshing];
    [myTableView footerEndRefreshing];
}

- (void)putToResourceArr:(id)resource Method:(NSString *)method
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:resource, method, nil];
//    [dataArr addObject:dict];
    [dataArr insertObject:dict atIndex:0];
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"%@", indexPath);
//}



@end
