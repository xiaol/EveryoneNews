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
#import "CenterCell.h"
#import "MoreCell.h"
#import "ContentViewController.h"
#import "UIColor+HexToRGB.h"
#import "AFNetworking.h"
#import "MJRefresh.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, HeadViewDelegate, MoreCellDelegate>
{
    UITableView *myTableView;
    NSMutableArray *dataArr;
    NSMutableArray *imgArr;
    NSMutableArray *textArr;
    int page;
    BOOL isHeaderFreshing;
    
    NSIndexPath *centerIndexPath;
    
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
    imgArr = [[NSMutableArray alloc] init];
    textArr = [[NSMutableArray alloc] init];
    
    centerIndexPath = [[NSIndexPath alloc] init];
    
    page = 1;
    hasLoad = 2;
    
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
    isHeaderFreshing = YES;
    
    if (imgArr != nil && ![imgArr isKindOfClass:[NSNull class]] && imgArr.count != 0) {
        [dataArr addObject:imgArr[0]];
        [imgArr removeObjectAtIndex:0];
        if (imgArr == nil || [imgArr isKindOfClass:[NSNull class]] || imgArr.count == 0) {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"MoreCell", @"MoreCell", nil];
            [dataArr addObject:dict];
            [myTableView removeHeader];
            hasLoad++;
        }
    }

    [self stopRefresh];
    
}

- (void)footerRefresh
{
    [myTableView footerEndRefreshing];
    isHeaderFreshing = NO;
    
    if (textArr != nil && ![textArr isKindOfClass:[NSNull class]] && textArr.count != 0) {
        [dataArr insertObject:textArr[0] atIndex:0];
        [textArr removeObjectAtIndex:0];
        if (textArr == nil || [textArr isKindOfClass:[NSNull class]] || textArr.count == 0) {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"MoreCell", @"MoreCell", nil];
            [dataArr insertObject:dict atIndex:0];
            [myTableView removeFooter];
            hasLoad++;
        }
    }
    [self stopRefresh];
}

- (void)stopRefresh
{
    if (hasLoad != dataArr.count || hasLoad == 2) {
        hasLoad++;
    }
    rat = hasLoad - 1;
    [myTableView reloadData];
    
    
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
    NSDictionary *dict = dataArr[rat - indexPath.row];
    NSString *type = dict.allKeys[0];
    if ([type isEqualToString:@"headView"]){

        HeadViewCell *cell = (HeadViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        CGFloat height = cell.headViewFrm.cellH;
        return height;
    } else if ([type isEqualToString:@"bigImg"]) {
        
        BigImgCell *cell = (BigImgCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.bigImgFrm.CellH;
    }
    else if ([type isEqualToString:@"centerCell"]){
        CenterCell *cell = (CenterCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellH;
    }
    else if ([type isEqualToString:@"MoreCell"]){
        MoreCell *cell = (MoreCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellH;
    }
    else {
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        if (isHeaderFreshing) {
            if (indexPath.row == 0 && !stopFadein) {
                cell.contentView.alpha = 0;
                [UIView animateWithDuration:1 animations:^{
                    cell.contentView.alpha = 1;
                }];
            }
        } else {
            if (indexPath.row == rat) {
                cell.contentView.alpha = 0;
                [UIView animateWithDuration:1 animations:^{
                    cell.contentView.alpha = 1;
                }];
            }
        }
        if ((rat - indexPath.row) == (dataArr.count - 1)) {
            stopFadein = YES;
        }
        cell.headViewFrm = dict[type];
        return cell;
    } else if ([type isEqualToString:@"centerCell"]){
        static NSString *cellId = @"centerCell";
        CenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[CenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        }
        centerIndexPath = indexPath;

        return cell;
        
    } else if ([type isEqualToString:@"bigImg"]){
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
    } else {
        static NSString *cellId = @"MoreCell";
        MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //自定义UITableViewCell选中后的背景颜色和背景图片
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        }
        cell.delegate = self;
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
    
    for (NSDictionary *dict in resultDic) {
        
        NSString * special = [NSString stringWithFormat:@"1%@", dict[@"special"]];

        if (![special isEqualToString:@"11"]) {
            HeadViewFrame *headViewFrm = [[HeadViewFrame alloc] init];
            headViewFrm.headViewDatasource = [HeadViewDatasource headViewDatasourceWithDict:dict];
            [self putToTextArr:headViewFrm Method:@"headView"];
//            [self putToResourceArr:headViewFrm Method:@"headView"];

        } else {
            BigImgFrm *bigImgFrm = [[BigImgFrm alloc] init];
            bigImgFrm.bigImgDatasource = [BigImgDatasource bigImgDatasourceWithDict:dict];
            [self putToImgArr:bigImgFrm Method:@"bigImg"];
//            [self putToResourceArr:bigImgFrm Method:@"bigImg"];

        }
        
    }
    [dataArr addObject:textArr[0]];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"centerCell", @"centerCell", nil];
    [dataArr addObject:dict];
    [dataArr addObject:imgArr[0]];
    
    
    [imgArr removeObjectAtIndex:0];
    [textArr removeObjectAtIndex:0];

    
    [myTableView reloadData];
    [myTableView headerEndRefreshing];
    [myTableView footerEndRefreshing];
}

//- (void)putToResourceArr:(id)resource Method:(NSString *)method
//{
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:resource, method, nil];
////    [dataArr addObject:dict];
//    [dataArr insertObject:dict atIndex:0];
//}


- (void)putToImgArr:(id)resource Method:(NSString *)method
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:resource, method, nil];
    [imgArr addObject:dict];
}

- (void)putToTextArr:(id)resource Method:(NSString *)method
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:resource, method, nil];
    [textArr addObject:dict];
}

#pragma mark MoreCellDelegate
- (void)scrollToPosition
{
    [myTableView scrollToRowAtIndexPath:centerIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    NSLog(@"scrollToPosition");
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"%@", indexPath);
//}



@end
