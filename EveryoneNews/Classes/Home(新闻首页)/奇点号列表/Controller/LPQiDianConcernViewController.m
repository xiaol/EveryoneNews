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
#import "Account.h"
#import "AccountTool.h"
#import "LPHttpTool.h"
#import "MBProgressHUD+MJ.h"

static NSString *cellIdentifier = @"cellIdentifier";
@interface LPQiDianConcernViewController () <UITableViewDelegate, UITableViewDataSource, LPQiDianHaoCellDelegate>

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
    
    [self setupData];
    self.view.backgroundColor = [UIColor colorFromHexString:LPColor9];
    [self setupTopView];
    [self setupTableView];
    
}

#pragma mark - setup Data
- (void)setupData {
    [self.qiDianHaoFrames removeAllObjects];
    for (int i = 0; i < self.qiDianArray.count; i++) {
        LPQiDianHao *qiDianHao = (LPQiDianHao *)self.qiDianArray[i];
        LPQiDianHaoFrame *qiDianHaoFrame = [[LPQiDianHaoFrame alloc] init];
        qiDianHaoFrame.qiDianHao = qiDianHao;
        [self.qiDianHaoFrames addObject:qiDianHaoFrame];
    }
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
    tableView.backgroundColor = [UIColor colorFromHexString:LPColor9];
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
    cell.delegate = self;
    cell.qiDianHaoFrame = self.qiDianHaoFrames[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPQiDianHaoFrame *qiDianHaoFrame = self.qiDianHaoFrames[indexPath.row];
    return qiDianHaoFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LPQiDianHaoFrame *qiDianHaoFrame = self.qiDianHaoFrames[indexPath.row];
    LPQiDianHao *qiDianHao = qiDianHaoFrame.qiDianHao;
    LPConcernDetailViewController *detailVC = [[LPConcernDetailViewController alloc] init];
    detailVC.conpubFlag = [NSString stringWithFormat:@"%d",qiDianHao.concernFlag];
    detailVC.sourceName = qiDianHao.name;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - LPQiDianCellDelegate
- (void)cell:(LPQiDianHaoCell *)cell didClickConcernButtonWithConcernState:(NSString *)concernState sourceName:(NSString *)sourceName qiDianHaoFrame:(LPQiDianHaoFrame *)qiDianHaoFrame {
    // 未登录则登录成功后刷新数据
    if (![AccountTool account]) {
        [AccountTool accountLoginWithViewController:self success:^(Account *account){
            [MBProgressHUD showSuccess:@"登录成功"];
            [self reloadTableViewAfterLogin];
        } failure:^{
        } cancel:nil];
    } else {
        [self concernOrCancel:concernState sourceName:sourceName qiDianHaoFrame:qiDianHaoFrame];
    }
}


#pragma mark - 重新登录刷新关注状态
- (void)reloadTableViewAfterLogin {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"keywords"] = self.keywords;
    params[@"p"] = @(1);
    params[@"c"] = @"20";
    params[@"uid"] = [userDefaults objectForKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/es/snp",ServerUrlVersion2];
    __weak typeof(self) weakSelf = self;
    [LPHttpTool getWithURL:url params:params success:^(id json) {
        if ([json[@"code"] integerValue] == 2000) {
            // 获取奇点号
            NSArray *jsonPublisherArray = (NSArray *)json[@"data"][@"publisher"];
            if (jsonPublisherArray.count > 0) {
                [weakSelf.qiDianArray removeAllObjects];
                for (int i = 0; i < jsonPublisherArray.count; i++) {
                    NSDictionary *dict = jsonPublisherArray[i];
                    LPQiDianHao *qiDianHao = [[LPQiDianHao alloc] init];
                    qiDianHao.concernID = [dict[@"id"] integerValue];
                    qiDianHao.concernCount = [dict[@"concern"] integerValue];
                    qiDianHao.concernFlag = [dict[@"flag"] integerValue];
                    qiDianHao.name = dict[@"name"];
                    [weakSelf.qiDianArray addObject:qiDianHao];
                }
            }
            [weakSelf setupData];
            [weakSelf.tableView reloadData];
 
        } else if([json[@"code"] integerValue] == 2002) {
  
        }
    } failure:^(NSError *error) {
    
    }];

}


#pragma mark - 关注和取消关注
- (void)concernOrCancel:(NSString *)concernState sourceName:(NSString *)sourceName qiDianHaoFrame:(LPQiDianHaoFrame *)qiDianHaoFrame {
    
    NSString *uid = [userDefaults objectForKey:@"uid"];
    // 必须进行编码操作
    NSString *pname = [sourceName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *addConcernUrl = [NSString stringWithFormat:@"%@/v2/ns/pbs/cocs?pname=%@&&uid=%@", ServerUrlVersion2, pname, uid];
    NSString *cancelConcernUrl = [NSString stringWithFormat:@"%@/v2/ns/pbs/cocs?pname=%@&&uid=%@", ServerUrlVersion2, pname, uid];
    NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
       __weak typeof(self) weakSelf = self;
    if ([concernState isEqualToString:@"0"]) {
        // 添加关注
        [LPHttpTool postAuthorizationJSONWithURL:addConcernUrl authorization:authorization params:nil success:^(id json) {
            
            if ([json[@"code"] integerValue] == 2000 ) {
                LPQiDianHao *qiDianHao = qiDianHaoFrame.qiDianHao;
                qiDianHao.concernFlag = 1;
                qiDianHaoFrame.qiDianHao = qiDianHao;
                NSInteger index = [self.qiDianHaoFrames indexOfObject:qiDianHaoFrame];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [noteCenter postNotificationName:LPAddConcernSourceNotification object:nil];
                [noteCenter postNotificationName:LPReloadAddConcernPageNotification object:nil];
               
                
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    } else {
        // 取消关注
        [LPHttpTool deleteAuthorizationJSONWithURL:cancelConcernUrl authorization:authorization params:nil success:^(id json) {
            
            if ([json[@"code"] integerValue] == 2000 ) {
                LPQiDianHao *qiDianHao = qiDianHaoFrame.qiDianHao;
                qiDianHao.concernFlag = 0;
                qiDianHaoFrame.qiDianHao = qiDianHao;
                NSInteger index = [self.qiDianHaoFrames indexOfObject:qiDianHaoFrame];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [noteCenter postNotificationName:LPRemoveConcernSourceNotification object:nil];
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:sourceName,@"sourceName", nil];
                [noteCenter postNotificationName:LPReloadCancelConcernPageNotification object:nil userInfo:dict];
           
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

@end
