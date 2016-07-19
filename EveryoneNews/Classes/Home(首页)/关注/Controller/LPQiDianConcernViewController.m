//
//  LPQiDianConcernViewController.m
//  EveryoneNews
//
//  Created by dongdan on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPQiDianConcernViewController.h"
#import "LPQiDianHaoCell.h"
#import "LPQiDianHao.h"
#import "LPQiDianHaoFrame.h"
#import "LPConcernDetailViewController.h"

static NSString *cellIdentifier = @"cellIdentifier";
@interface LPQiDianConcernViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *qiDianHaoFrames;

@end

@implementation LPQiDianConcernViewController

- (NSMutableArray *)qiDianHaoFrames {
    if (_qiDianHaoFrames == nil) {
        _qiDianHaoFrames = [NSMutableArray array];
    }
    return _qiDianHaoFrames;
}

#pragma  mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    LPQiDianHao *qiDianHao = [[LPQiDianHao alloc] init];
    qiDianHao.title = @"奇点号";
    qiDianHao.concernCount = @"9.6万人关注";
    qiDianHao.imageViewURL = @"http://p0.qhimg.com/t012e264d72f4228193.jpg";
    
    LPQiDianHaoFrame *qiDianHaoFrame = [[LPQiDianHaoFrame alloc] init];
    qiDianHaoFrame.qiDianHao = qiDianHao;
    
    [self.qiDianHaoFrames addObject:qiDianHaoFrame];
    
    self.view.backgroundColor = [UIColor colorWithDesignIndex:9];
    [self setupTopView];
    [self setupTableView];
    
}

#pragma mark - 顶部视图
- (void)setupTopView {
    // 导航栏
    double topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
    double padding = 15;
    
    double returnButtonWidth = 13;
    double returnButtonHeight = 22;
    
    if (iPhone6Plus) {
        returnButtonWidth = 12;
        returnButtonHeight = 21;
    }
    if (iPhone6) {
        topViewHeight = 72;
    }
    double returnButtonPaddingTop = (topViewHeight - returnButtonHeight + StatusBarHeight) / 2;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topViewHeight)];
    topView.backgroundColor = [UIColor colorFromHexString:@"#ffffff" alpha:0.0f];
    [self.view addSubview:topView];
    
    // 返回button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, returnButtonPaddingTop, returnButtonWidth, returnButtonHeight)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"消息中心返回"] forState:UIControlStateNormal];
    backButton.enlargedEdge = 15;
    [backButton addTarget:self action:@selector(topViewBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text = @"奇点号";
    titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
    titleLabel.font = [UIFont  boldSystemFontOfSize:LPFont8];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerX = topView.centerX;
    titleLabel.centerY = backButton.centerY;
    [topView addSubview:titleLabel];
    self.topView = topView;
    
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenWidth , 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor10];
    [self.view addSubview:seperatorView];
    
}

#pragma mark - setupTableView
- (void)setupTableView {
    CGFloat tableViewY = CGRectGetMaxY(self.topView.frame) + 2;
    CGFloat tableViewH = ScreenHeight - tableViewY;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, ScreenWidth, tableViewH)];
    tableView.backgroundColor = [UIColor colorWithDesignIndex:9];
    [tableView registerClass:[LPQiDianHaoCell class] forCellReuseIdentifier:cellIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;

}

#pragma mark - 返回上一层
- (void)topViewBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.qiDianHaoFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPQiDianHaoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell =  [[LPQiDianHaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.qiDianHaoFrame = self.qiDianHaoFrames[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPQiDianHaoFrame *qiDianHaoFrame = self.qiDianHaoFrames[indexPath.row];
    return qiDianHaoFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LPConcernDetailViewController *detailVC = [[LPConcernDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
