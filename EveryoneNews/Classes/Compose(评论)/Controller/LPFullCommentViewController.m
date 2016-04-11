//
//  LPFullCommentViewController.m
//  EveryoneNews
//
//  Created by dongdan on 15/10/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPFullCommentViewController.h"
#import "LPContent.h"
#import "LPComposeViewController.h"
#import "LPFullCommentFrame.h"
#import "LPFullCommentCell.h"
#import "LPDetailViewController.h"
#import "MainNavigationController.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "LPHttpTool.h"
#import "LPContent.h"
#import "LPContentFrame.h"
#import "MJExtension.h"
#import "NSString+LP.h"
#import "LPHttpTool.h"
#import "LPDiggerFooter.h"
#import "MJExtension.h"
#import "MJRefresh.h"

//// 底部输入框高度
//static const CGFloat inputViewHeight = 50;
// 顶部视图高度
static const CGFloat topViewHeight= 64;


@interface LPFullCommentViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, LPFullCommentCellDelegate, LPComposeViewControllerDelegate>
// 底部评论框
@property (nonatomic, strong) UIImageView *inputView;
@property (nonatomic, strong) LPHttpTool *http;
@property (nonatomic, strong) NSMutableArray *fullTextCommentFrames;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation LPFullCommentViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置背景颜色为白色
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupData];
    [self setupHeaderView];
    [self setupSubviews];
}

#pragma mark - viewDidDisappear
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.http) {
        [self.http cancelRequest];
        self.http = nil;
    }
}

#pragma mark - statusBar
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - 懒加载
- (NSMutableArray *)fullTextCommentFrames
{
    if (_fullTextCommentFrames == nil) {
        _fullTextCommentFrames = [NSMutableArray array];
    }
    return _fullTextCommentFrames;
}



#pragma mark - 顶部视图
- (void)setupHeaderView
{
    double topViewHeight = 64;
    
    double backButtonWidth = 10;
    double backButtonHeight = 17;
    double backButtonPaddingTop = 33.5f;
    
    if(iPhone6Plus)
    {
        topViewHeight = 64;
        
        backButtonWidth = 11;
        backButtonHeight = 19;
        backButtonPaddingTop = 30.5f;
    }
    // 顶部视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topViewHeight)];
     headerView.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    [self.view addSubview:headerView];

    // 返回button
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, backButtonPaddingTop, backButtonWidth, backButtonHeight)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"详情页返回"] forState:UIControlStateNormal];
    backBtn.enlargedEdge = 15;
    [backBtn addTarget:self action:@selector(popBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    
    // 分割线
    UILabel *seperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topViewHeight - 0.5, ScreenWidth, 0.5)];
    seperatorLabel.backgroundColor = [UIColor colorFromHexString:@"#cbcbcb"];
    [headerView addSubview:seperatorLabel];
 
    // 评论标题
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, topViewHeight)];
    headerLabel.centerX = headerView.centerX;
    headerLabel.centerY = backBtn.centerY;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.text = @"评论";
    headerLabel.textColor = [UIColor colorFromHexString:@"#747474"];
    [headerView addSubview:headerLabel];
}

#pragma mark - 加载评论视图
-(void)setupSubviews
{
    CGFloat bottomViewHeight = 40.0f;
    if (iPhone6Plus) {
        bottomViewHeight = 45.0f;
        
    }

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topViewHeight, ScreenWidth, ScreenHeight - bottomViewHeight -topViewHeight)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorColor = [UIColor colorFromHexString:@"#dddddd"];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.allowsSelection = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    __weak typeof(self) weakSelf = self;
    // 上拉加载更多
    self.tableView.footer = [LPDiggerFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0, ScreenHeight - bottomViewHeight, ScreenWidth, bottomViewHeight);
    bottomView.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
    
    UIView *composeView = [[UIView alloc] init];
    composeView.frame = CGRectMake(BodyPadding, 5, ScreenWidth - BodyPadding * 2, bottomViewHeight - 10);
    composeView.userInteractionEnabled = YES;
    composeView.layer.borderWidth = 0.5;
    composeView.layer.borderColor = [UIColor colorFromHexString:@"#c6c6c6"].CGColor;
    composeView.layer.cornerRadius = 15;
    composeView.backgroundColor = [UIColor whiteColor];
    
    [bottomView addSubview:composeView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputViewTap:)];
    [composeView addGestureRecognizer:tapGestureRecognizer];
    
    CGFloat composeImageViewPaddingTop = 2.5;
    UIImageView *composeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, composeImageViewPaddingTop, 18, bottomViewHeight -  10 - composeImageViewPaddingTop *2)];
    composeImageView.contentMode = UIViewContentModeScaleAspectFit;
    composeImageView.image = [UIImage imageNamed:@"发表评论"];
    
    UILabel *composeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(composeImageView.frame) + 10, 0, 100, bottomViewHeight - 10)];
    composeLabel.text = @"写评论...";
    composeLabel.textColor = [UIColor colorFromHexString:@"#909090"];
    composeLabel.textAlignment = NSTextAlignmentLeft;
    if (iPhone6Plus) {
        composeLabel.font = [UIFont systemFontOfSize:18];
    } else {
        composeLabel.font = [UIFont systemFontOfSize:15];
    }
    [composeView addSubview:composeImageView];
    [composeView addSubview:composeLabel];
    
    [self.view addSubview:bottomView];
}

#pragma mark - 加载更多
- (void)loadMoreData {
    self.pageIndex = self.pageIndex + 1;
    NSString *url = @"http://api.deeporiginalx.com/bdp/news/comment/ydzx";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"docid"] = self.docId;
    params[@"page"] = @(self.pageIndex);
    params[@"offset"] = @"20";
    
     __weak typeof(self) weakSelf = self;
    [LPHttpTool getWithURL:url params:params success:^(id json) {
        if ([json[@"code"] integerValue] == 0) {
            NSArray *commentsArray = json[@"data"];
            for (NSDictionary *dict in commentsArray) {
                LPComment *comment = [[LPComment alloc] init];
                comment.srcText = dict[@"content"];
                comment.createTime = dict[@"create_time"];
                comment.up = [NSString stringWithFormat:@"%@", dict[@"love"]] ;
                comment.userIcon = dict[@"profile"];
                comment.commentId = dict[@"comment_id"];
                comment.userName = dict[@"nickname"];
                comment.color = [UIColor colorFromHexString:@"#747474"];
                comment.isPraiseFlag = @"0";
                
                LPFullCommentFrame *commentFrame = [[LPFullCommentFrame alloc] init];
                commentFrame.comment = comment;
                
                [weakSelf.fullTextCommentFrames addObject:commentFrame];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.footer endRefreshing];
        } else {
            [weakSelf.tableView.footer noticeNoMoreData];
        }
    } failure:^(NSError *error) {
          [weakSelf.tableView.footer endRefreshing];
    }];
    
}

#pragma mark - 请求后台接口数据
- (void)setupData {
    self.pageIndex = 1;
    [self loadData:self.pageIndex];
}

- (void)loadData:(NSInteger)pageIndex {
        NSString *url = @"http://api.deeporiginalx.com/bdp/news/comment/ydzx";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"docid"] = self.docId;
        params[@"page"] = @(pageIndex);
        params[@"offset"] = @"20";
        NSMutableArray *commentFrameArray = [NSMutableArray array];
        [LPHttpTool getWithURL:url params:params success:^(id json) {
            
        if ([json[@"code"] integerValue] == 0) {
            NSArray *commentsArray = json[@"data"];
            for (NSDictionary *dict in commentsArray) {
                LPComment *comment = [[LPComment alloc] init];
                comment.srcText = dict[@"content"];
                comment.createTime = dict[@"create_time"];
                comment.up = [NSString stringWithFormat:@"%@", dict[@"love"]] ;
                comment.userIcon = dict[@"profile"];
                comment.commentId = dict[@"comment_id"];
                comment.userName = dict[@"nickname"];
                comment.color = [UIColor colorFromHexString:@"#747474"];
                comment.isPraiseFlag = @"0";
                comment.Id = dict[@"id"];
                
                
                LPFullCommentFrame *commentFrame = [[LPFullCommentFrame alloc] init];
                commentFrame.comment = comment;
                
                [commentFrameArray addObject:commentFrame];
            }
            self.fullTextCommentFrames = commentFrameArray;
            [self.tableView reloadData];
        } else {
            UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 100)];
    
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"暂无评论"]];
            imageView.centerX = self.view.centerX;
            imageView.centerY = ScreenHeight/4;
    
            UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
            noDataLabel.centerY = CGRectGetMaxY(imageView.frame) + 20;
    
            NSString *text = @"暂无评论，快抢沙发";
            NSMutableAttributedString *noDataString = [text attributedStringWithFont:[UIFont systemFontOfSize:12] color:[UIColor colorFromHexString:@"#c8c8c8"] lineSpacing:0];
            noDataLabel.attributedText = noDataString;
            noDataLabel.textAlignment = NSTextAlignmentCenter;
            [backgroundView addSubview:imageView];
            [backgroundView addSubview:noDataLabel];
            self.tableView.backgroundView = backgroundView;
        }
        } failure:^(NSError *error) {
            
        }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fullTextCommentFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPFullCommentCell *cell = [LPFullCommentCell cellWithTableView:tableView];
    cell.fullCommentFrame = self.fullTextCommentFrames[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPFullCommentFrame *fullCommentFrame = self.fullTextCommentFrames[indexPath.row];
    return fullCommentFrame.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(13, 0, ScreenWidth - 13, 10)];
    return view;
}


#pragma -mark 点赞 delegate
- (void)fullCommentCell:(LPFullCommentCell *)cell comment:(LPComment *)comment {
    
    __block Account *account = [AccountTool account];
    // 如果已经登录直接点赞，没有登录登录成功后才能点赞
    if ([AccountTool account]) {
        [self upComment:comment withAccount:account cell:cell];
    } else {
        [AccountTool accountLoginWithViewController:self success:^(Account *account){
            [self upComment:comment withAccount:account cell:cell];
        } failure:^{
            [MBProgressHUD showError:@"登录失败"];
        } cancel:^{
       
        }];
    }
}

- (void)upComment:(LPComment *)comment withAccount:(Account *)account cell:(LPFullCommentCell *)cell
{
    if (comment.isPraiseFlag.intValue) {
        [MBProgressHUD showError:@"您已赞过"];
    } else {
        NSString *url = [NSString stringWithFormat:@"%@/bdp/news/comment/ydzx/love?cid=%@&unam=%@&uuid=%@", ServerUrl, comment.Id , account.userName, account.userId];
        self.http = [LPHttpTool http];
        [self.http putWithURL:url params:nil success:^(id json) {
            comment.isPraiseFlag = @"1";
            comment.up = [NSString stringWithFormat:@"%@", json[@"data"]];
            
            // 点赞动画效果
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.upButton.frame];
            imageView.tag = -100;
            imageView.image = [UIImage imageNamed:@"点赞心1"];
            imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
            [cell addSubview:imageView];
            
            [UIView animateWithDuration:0.6 animations:^{
                imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            } completion:^(BOOL finished) {
                [self.tableView reloadData];
                [imageView removeFromSuperview];
            }];
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络不给力 :("];
        }];
    }
}
#pragma -mark 点击评论框
- (void)inputViewTap:(UITapGestureRecognizer *)recognizer {
        if (![AccountTool account]) {
            __weak typeof(self) weakSelf = self;
            [AccountTool accountLoginWithViewController:weakSelf success:^(Account *account){
                [MBProgressHUD showSuccess:@"登录成功"];
                [weakSelf performSelector:@selector(pushFulltextCommentComposeVc) withObject:nil afterDelay:0.6];
            } failure:^{
                [MBProgressHUD showError:@"登录失败!"];
            } cancel:nil];
        } else {
            [self pushFulltextCommentComposeVc];
        }
}

#pragma -mark 弹出发表评论对话框
- (void)pushFulltextCommentComposeVc {
    LPComposeViewController *composeVc = [[LPComposeViewController alloc] init];
    composeVc.delegate = self;
    composeVc.docId = self.docId;
    composeVc.commentsCount = self.commentsCount;
    [composeVc returnCommentsCount:^(NSInteger count) {
        self.commentsCount = count;
        NSLog(@"count2-%d", count);
        
    }];
    [self.navigationController pushViewController:composeVc animated:YES];
}

// 返回上一级菜单
- (void)popBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fulltextCommentDidComposed:(fulltextCommentHandle) handle {
    self.block = handle;
}


#pragma mark - 发表评论 delegate
- (void)insertComment:(LPComment *)comment {
    LPFullCommentFrame *commentFrame = [[LPFullCommentFrame alloc] init];
    commentFrame.comment = comment;
    [self.fullTextCommentFrames insertObject:commentFrame atIndex:0];
    [self.tableView reloadData];
    self.tableView.backgroundView = nil;
    [self.tableView setContentOffset:CGPointZero animated:NO];
}

#pragma mark - ViewDidAppear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 更新评论数量
    if (self.block != nil) {
    
        self.block(self.commentsCount);
    }
    
}

#pragma mark - dealloc
- (void)dealloc
{
     // NSLog(@"全文评论dealloc");
}

@end
