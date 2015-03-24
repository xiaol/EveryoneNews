//
//  ViewController.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/23.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "ViewController.h"
#import "HeadViewCell.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *myTableView;
    NSMutableArray *dataList;
}

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"FeedViewController receive Memory Warning");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)commonInit
{
    self.title = @"百家争鸣";
//    self.view.backgroundColor = [UIColor greenColor];
//    self.view.alpha = 0.3;
    [self tableViewInit];
}

- (void)tableViewInit
{
    myTableView = [[UITableView alloc] init];
    myTableView.frame = self.view.frame;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    myTableView.backgroundColor = [UIColor blueColor];
//    myTableView.alpha = 0.3;
    myTableView.showsVerticalScrollIndicator = NO;

    [self.view addSubview:myTableView];
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellH = [UIScreen mainScreen].bounds.size.width * 512 / 640 + 10;
    return cellH;
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
    }
    NSDictionary *dict = nil;
    HeadViewFrame *headViewFrm = [[HeadViewFrame alloc] init];
    headViewFrm.HeadViewDatasource = [HeadViewDatasource headViewDatasourceWithDict:dict];
//    cell.headViewFrm.headViewDatasource = [HeadViewDatasource headViewDatasourceWithDict:dict];
    cell.headViewFrm = headViewFrm;
    return cell;
}


@end
