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
#import "LPParaCommentFrame.h"
#import "LPFullCommentCell.h"
#import "LPUpView.h"
#import "LPDetailViewController.h"
#import "MainNavigationController.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "LPHttpTool.h"
#import "LPContent.h"
#import "LPContentFrame.h"
#import "MJExtension.h"
#import "NSString+LP.h"

// 底部输入框高度
static const CGFloat inputViewHeight = 50;
// 顶部视图高度
static const CGFloat topViewHeight= 44;
// 按钮大小
static const CGFloat btnWidth= 44;

@interface LPFullCommentViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, LPFullCommentCellDelegate>
// 全文评论frame集合
@property (nonatomic, strong) NSMutableArray *fullTextCommentFrames;
// 底部评论框
@property (nonatomic, strong) UIImageView *inputView;
@property (nonatomic, strong) LPHttpTool *http;
@end

@implementation LPFullCommentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置背景颜色为白色
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupHeaderView];
    [self setupSubviews];
    [self setupData];
}

// 懒加载
- (NSMutableArray *)fullTextCommentFrames
{
    if (_fullTextCommentFrames == nil) {
        _fullTextCommentFrames = [NSMutableArray array];
    }
    return _fullTextCommentFrames;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.shouldRefresh) {
        [self refreshData];
    }
}
// 添加头部视图
- (void)setupHeaderView
{
    // 顶部视图
    UIView *headerView = [[UIView alloc] init];
    [self.view addSubview:headerView];
    headerView.x = 0;
    headerView.y = 0;
    headerView.width = ScreenWidth;
    headerView.height = topViewHeight;
    headerView.backgroundColor=self.color;
    // 返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth)];
    [backBtn setImage:[UIImage resizableImage:@"返回"] forState:UIControlStateNormal];
     backBtn.imageEdgeInsets=UIEdgeInsetsMake(0,0,0,10);
    [backBtn addTarget:self action:@selector(popBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    // 评论标题
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, topViewHeight)];
    headerLabel.centerX=headerView.centerX;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.text = @"评论";
    headerLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:headerLabel];
    // 评论列表
    [self.view insertSubview:headerView aboveSubview:self.tableView];
}
// 添加表格
-(void)setupSubviews
{

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,topViewHeight,ScreenWidth, ScreenHeight - inputViewHeight-topViewHeight)];
    tableView.backgroundColor = LPColor(255, 255, 250);
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorColor = [UIColor colorFromHexString:TableViewBackColor alpha:0.6];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.allowsSelection=NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIImageView *inputView = [[UIImageView alloc] initWithImage:[UIImage resizableImage:@"评论框"]];
    inputView.x = 0;
    inputView.y = ScreenHeight - inputViewHeight;
    inputView.width = ScreenWidth;
    inputView.height = inputViewHeight;
    inputView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputViewTap:)];
    [inputView addGestureRecognizer:singleTap];
    [self.view addSubview:inputView];
    self.inputView = inputView;
    
}


- (void)setupData
{
    NSMutableArray *commentFrameArray = [NSMutableArray array];
    for (LPComment *comment in self.comments) {
        LPParaCommentFrame *commentFrame = [[LPParaCommentFrame alloc] init];
        comment.color = self.color;
        commentFrame.comment = comment;
        [commentFrameArray addObject:commentFrame];
    }
    self.fullTextCommentFrames = commentFrameArray;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fullTextCommentFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPFullCommentCell *cell = [LPFullCommentCell cellWithTableView:tableView];
    cell.paraCommentFrame = self.fullTextCommentFrames[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPParaCommentFrame *paraCommentFrame = self.fullTextCommentFrames[indexPath.row];
    return paraCommentFrame.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(13, 0, ScreenWidth-13, 10)];
    return view;
}

//   没有数据的时候给出提示信息
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numOfSections = 0;
    if(self.fullTextCommentFrames.count == 0) {
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
        numOfSections = 0;
    }
    else {
        self.tableView.backgroundView = nil;
        numOfSections = 1;
    }
    return numOfSections;
}

#pragma -mark 点赞
- (void)fullCommentCell:(LPFullCommentCell *)cell upView:(LPUpView *)upView comment:(LPComment *)comment
{
    upView.userInteractionEnabled = NO;
    __block Account *account = [AccountTool account];
    // 如果已经登录直接点赞，没有登录登录成功后才能点赞
    if ([AccountTool account]) {
        [self upComment:comment withAccount:account upView:upView cell:cell];
    }else {
        NSUInteger index = [self.comments indexOfObject:comment];
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if([viewController isKindOfClass:[LPDetailViewController class]]) {
                [AccountTool accountLoginWithViewController:self success:^(Account *account){
                    // 1. 刷新detailVc，更新自身comments值
                    [(LPDetailViewController*)viewController fulltextCommentsUpDidComposed:^(NSArray *fulltextComments) {
                        self.comments = fulltextComments;
                        LPComment *comment = self.comments[index];
                        // 2. 刷新tableView
                        [self setupData];
                        [self.tableView reloadData];
                        // 3. 点赞
                        [self upComment:comment withAccount:account upView:upView cell:cell];
                    }];
                } failure:^{
                    [MBProgressHUD showError:@"登录失败"];
                    
                } cancel:^{
                    
                }];
                break;
            }
        }
    } 
}

- (void)upComment:(LPComment *)comment withAccount:(Account *)account upView:(LPUpView *)upView cell:(LPFullCommentCell *)cell
{
    
    if (comment.isPraiseFlag.intValue) {
        [MBProgressHUD showError:@"您已赞过"];
        upView.userInteractionEnabled = YES;
    } else {
        NSString *url = [NSString stringWithFormat:@"%@/news/baijia/praise", ServerUrl];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"userId"] = account.userId;
        params[@"platformType"] = account.platformType;
        params[@"sourceUrl"] = self.sourceURL;
        params[@"commentId"] = comment.commentId;
        params[@"deviceType"] = @"ios";
        params[@"uuid"] = @"";
        [LPHttpTool postWithURL:url params:params success:^(id json) {
            comment.isPraiseFlag = @"1";
            int up = comment.up.intValue + 1;
            comment.up = [NSString stringFromIntValue:up];
            //  点赞动画效果
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:upView.commentFrame.upImageViewF];
            imageView.tag=-100;
            imageView.image = [UIImage imageNamed:@"点赞心1"];
            imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
            [cell.upView addSubview:imageView];
            [UIView animateWithDuration:0.6
                                  delay:0
                                  options:UIViewAnimationOptionBeginFromCurrentState
                                  animations:(void (^)(void)) ^{
                                  imageView.transform= CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                             }
                             completion:^(BOOL finished){
                                 [self.tableView reloadData];
                             }];
         

        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络不给力 :("];
            upView.userInteractionEnabled = YES;
        }];
    }
}
#pragma -mark 点击评论框
- (void)inputViewTap:(UITapGestureRecognizer *)recognizer {
        if (![AccountTool account]) {
            __weak typeof(self) weakSelf = self;
            [AccountTool accountLoginWithViewController:weakSelf success:^(Account *account){
                [MBProgressHUD showSuccess:@"登录成功"];
                [weakSelf refreshData];
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
    composeVc.commentType = 2;
    composeVc.color = self.color;
    composeVc.sourceURL = self.sourceURL;
    self.shouldRefresh = YES;
    [self.navigationController pushViewController:composeVc animated:YES];
}
#pragma -mark 刷新全文评论
- (void)refreshData {
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if([viewController isKindOfClass:[LPDetailViewController class]]) {
                // 1. 刷新detailVc，更新自身comments值
                [(LPDetailViewController*)viewController fulltextCommentsUpDidComposed:^(NSArray *fulltextComments) {
                    self.comments = fulltextComments;
                    // 2. 刷新tableView
                    [self setupData];
                    [self.tableView reloadData];
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.comments.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }];
                break;
        }
    }
}
// 返回上一级菜单
- (void)popBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fulltextCommentDidComposed:(fulltextCommentHandle) handle {
    self.block = handle;
}

- (void)dealloc
{
     NSLog(@"全文评论dealloc");
}

@end
