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
    
//    [self getRequest:@"http://121.41.75.213:9999/news/baijia/fetchHome"];
    
    [self commonInit];
    
}

- (void)commonInit
{
    dataArr = [[NSMutableArray alloc] init];
    page = 1;
    isRefreshing = YES;
    
    self.title = @"头条百家";

    [self tableViewInit];
    [self setupRefresh];
    
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

#pragma mark refresh
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
    isRefreshing = YES;
   [self getRequest:@"http://121.41.75.213:9999/news/baijia/fetchHome"];
}

- (void)footerRefresh
{
    page++;
    NSString *url = [NSString stringWithFormat:@"http://121.41.75.213:9999/news/baijia/fetchHome?page=%d", page];
    isRefreshing = NO;
    [self getRequest:url];
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    HeadViewFrame *frm = dataArr[indexPath.row];
    return frm.cellH;
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

    cell.headViewFrm = dataArr[indexPath.row];
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
//        NSLog(@"dict:%@", dict);
    }
    
    [myTableView reloadData];
    [myTableView headerEndRefreshing];
    [myTableView footerEndRefreshing];
}


@end
