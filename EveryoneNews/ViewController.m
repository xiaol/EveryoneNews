//
//  ViewController.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/23.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "ViewController.h"
#import "HeadViewCell.h"
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
    
    NSMutableArray *indexPahtsArr;
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
    indexPahtsArr = [[NSMutableArray alloc] init];
    
    [self tableViewInit];
    [self setupRefresh];

    [self followRollingScrollView:myTableView];
    
    [self getRequest:[NSString stringWithFormat:@"%@%@", kServerIP, kFetchHome]];
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
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (dataArr != nil && ![dataArr isKindOfClass:[NSNull class]] && dataArr.count != 0) {
//        return dataArr.count;
        return hasLoad;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataArr != nil && ![dataArr isKindOfClass:[NSNull class]] && dataArr.count != 0) {
        HeadViewFrame *frm = dataArr[indexPath.row];
        return frm.cellH;
    } else {
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"headViewCell";
    HeadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[HeadViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //自定义UITableViewCell选中后的背景颜色和背景图片
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }

    
//    if (![indexPahtsArr containsObject:indexPath]) {
//        
//        cell.shutDown = YES;
//        
//        [indexPahtsArr addObject:indexPath];
//    }
    if (indexPath.row == 0) {
        cell.contentView.alpha = 0;
        [UIView animateWithDuration:1 animations:^{
            cell.contentView.alpha = 1;
        }];
    }
    
    cell.headViewFrm = dataArr[rat - indexPath.row];
//    cell.contentView.alpha = 0;
//    [UIView animateWithDuration:1 animations:^{
//        cell.contentView.alpha = 1;
//    }];
    
    return cell;
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
}

- (void)convertToModel:(NSDictionary *)resultDic
{
    if (isRefreshing) {
        dataArr = [[NSMutableArray alloc] init];
    }
    
    for (NSDictionary *dict in resultDic) {
        
        HeadViewFrame *headViewFrm = [[HeadViewFrame alloc] init];
        headViewFrm.headViewDatasource = [HeadViewDatasource headViewDatasourceWithDict:dict];
        
        [dataArr addObject:headViewFrm];
    }
    
    [myTableView reloadData];
    [myTableView headerEndRefreshing];
    [myTableView footerEndRefreshing];
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"%@", indexPath);
//}



@end
