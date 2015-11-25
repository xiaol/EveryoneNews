//
//  LPParaCommentViewController.m
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPParaCommentViewController.h"
#import "LPComment.h"
#import "LPParaCommentFrame.h"
#import "LPParaCommentCell.h"
#import "MobClick.h"
#import "LPDetailViewController.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "LPHttpTool.h"
#import "LPUpView.h"
#import "LPContent.h"
#import "MainNavigationController.h"

#define InputViewHeight 44

@interface LPParaCommentViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, LPParaCommentCellCellDelegate>
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) NSMutableArray *paraCommentFrames;
@property (nonatomic, strong) UIImageView *inputView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, assign) CGFloat totalCommentHeight;
@property (nonatomic, strong) UILabel *underLabel;
@property (nonatomic, assign) BOOL shouldReloadDetailCell;
@end

@implementation LPParaCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
    [self setupHeaderView];
//    [self setupTableFooterView];
    [self setupData];
    [noteCenter addObserver:self selector:@selector(reloadData:) name:LPParaVcRefreshDataNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MainNavigationController *nav = (MainNavigationController *)self.navigationController;
    nav.popRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.shouldReloadDetailCell) {
        NSDictionary *info = @{LPReloadCellIndex: @(self.contentIndex)};
        [noteCenter postNotificationName:LPDetailVcShouldReloadDataNotification object:self userInfo:info];
    }
    MainNavigationController *nav = (MainNavigationController *)self.navigationController;
    nav.popRecognizer.enabled = YES;
}

- (NSMutableArray *)paraCommentFrames
{
    if (_paraCommentFrames == nil) {
        _paraCommentFrames = [NSMutableArray array];
    }
    return _paraCommentFrames;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setupSubviews
{
    UIImageView *bgView = [[UIImageView alloc] initWithImage:self.bgImage];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    UIView *blackView = [[UIView alloc] initWithFrame:self.view.bounds];
    blackView.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.5];
    [self.view addSubview:blackView];
    self.blackView = blackView;
    [self.blackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlackView:)]];

    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = LPColor(255, 255, 250);
    tableView.separatorColor = [UIColor colorFromHexString:TableViewBackColor alpha:0.6];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIImageView *inputView = [[UIImageView alloc] initWithImage:[UIImage resizableImage:@"评论框"]];
    inputView.x = 0;
    inputView.y = ScreenHeight - InputViewHeight;
    inputView.width = ScreenWidth;
    inputView.height = InputViewHeight;
    [self.view addSubview:inputView];
    self.inputView = inputView;
}

- (void)setupHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *aboveLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    aboveLabel.textAlignment = NSTextAlignmentCenter;
    aboveLabel.font = [UIFont boldSystemFontOfSize:18];
    aboveLabel.text = @"他·她们说";
    aboveLabel.textColor = [UIColor whiteColor];
    aboveLabel.backgroundColor = self.color;
    [headerView addSubview:aboveLabel];
    
    UILabel *underLabel = [[UILabel alloc] init];
    CGFloat underY = CGRectGetMaxY(aboveLabel.frame);
    underLabel.frame = CGRectMake(0, underY, ScreenWidth, 24);
    underLabel.textAlignment = NSTextAlignmentLeft;
    underLabel.font = [UIFont systemFontOfSize:15];
    underLabel.text = [NSString stringWithFormat:@" 精彩评论 (%d)", self.comments.count];
    underLabel.backgroundColor = [UIColor colorFromHexString:TableViewBackColor];
    [headerView addSubview:underLabel];
    self.underLabel = underLabel;
    
    CGFloat headerViewHeight = CGRectGetHeight(aboveLabel.frame) + CGRectGetHeight(underLabel.frame);
    self.headerViewHeight = headerViewHeight;
    headerView.frame = CGRectMake(0, 0, ScreenWidth, headerViewHeight);
    self.headerView = headerView;
    
    [self.view insertSubview:headerView aboveSubview:self.tableView];
}

- (void)setupData
{
    NSMutableArray *commentFrameArray = [NSMutableArray array];
    CGFloat tableViewHeight = 0.0;
    for (LPComment *comment in self.comments) {
        LPParaCommentFrame *commentFrame = [[LPParaCommentFrame alloc] init];
        comment.color = self.color;
        commentFrame.comment = comment;
        [commentFrameArray addObject:commentFrame];
        
        tableViewHeight += commentFrame.cellHeight;
    }
    self.tableViewHeight = tableViewHeight;
    CGFloat maxHeight = tableViewHeight + self.headerViewHeight;
    CGFloat totalCommentHeight = MIN(maxHeight, ScreenHeight * 0.63);
    self.totalCommentHeight = totalCommentHeight;
    self.headerView.frame = CGRectMake(0, ScreenHeight - totalCommentHeight - InputViewHeight, ScreenWidth, self.headerViewHeight);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), ScreenWidth, totalCommentHeight - self.headerViewHeight);
    self.paraCommentFrames = commentFrameArray;
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.0;
        self.inputView.y = ScreenHeight;
        self.tableView.y = ScreenHeight;
        self.headerView.y = ScreenHeight;
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

- (void)tapBlackView:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    if (location.y < ScreenHeight - self.totalCommentHeight) {
        [self dismiss];
    }
    if (location.y > ScreenHeight - InputViewHeight) {
        // 发表评论
//        LPComment *comment = [self.comments firstObject];
//        int paraIndex = comment.paragraphIndex.intValue; // 评论的索引值要+1，因为他是相对于正文段落的索引
        NSDictionary *info = @{LPComposeParaIndex: [NSString stringFromIntValue:self.contentIndex]};
        [noteCenter postNotificationName:LPCommentWillComposeNotification object:self userInfo:info];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.paraCommentFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPParaCommentCell *cell = [LPParaCommentCell cellWithTableView:tableView];
    cell.paraCommentFrame = self.paraCommentFrames[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPParaCommentFrame *paraCommentFrame = self.paraCommentFrames[indexPath.row];
    return paraCommentFrame.cellHeight;
}

#pragma mark - Para comment cell delegate
- (void)paraCommentCell:(LPParaCommentCell *)cell didClickUpView:(LPUpView *)upView withUpComment:(LPComment *)comment
{
    self.blackView.userInteractionEnabled = NO;
    upView.userInteractionEnabled = NO;

    __block Account *account = [AccountTool account];
    if ([AccountTool account]) {
        [self upComment:comment withAccount:account upView:upView];
    } else {
        NSUInteger index = [self.comments indexOfObject:comment];
        [AccountTool accountLoginWithViewController:self success:^(Account *account){
            // 1. 刷新detailVc，更新自身comments值
            [self.fromVc returnContentsBlock:^(NSArray *contents) {
                LPContent *content = contents[self.contentIndex];
                self.comments = content.comments;
                LPComment *comment = self.comments[index];
                // 2. 刷新tableView
                [self setupData];
                [self.tableView reloadData];
                // 3. 点赞
                [self upComment:comment withAccount:account upView:upView];
            }];
        } failure:^{
            [MBProgressHUD showError:@"登录失败"];
            upView.userInteractionEnabled = YES;
            self.blackView.userInteractionEnabled = YES;
        } cancel:^{
            upView.userInteractionEnabled = YES;
            self.blackView.userInteractionEnabled = YES;
        }];
    }
}

- (void)upComment:(LPComment *)comment withAccount:(Account *)account upView:(LPUpView *)upView
{
    if (comment.isPraiseFlag.intValue) {
        [MBProgressHUD showError:@"您已赞过"];
        self.blackView.userInteractionEnabled = YES;
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
            
            [self.tableView reloadData];
            if ([self.comments indexOfObject:comment] == 0) {
                // 如果是第一个评论，还须刷新detailVc table view
                self.shouldReloadDetailCell = YES;
            }
            upView.userInteractionEnabled = YES;
            self.blackView.userInteractionEnabled = YES;
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络不给力 :("];
            upView.userInteractionEnabled = YES;
            self.blackView.userInteractionEnabled = YES;
        }];
    }
}

# pragma mark - notification selector 
- (void)reloadData:(NSNotification *)note
{
    [self.fromVc returnContentsBlock:^(NSArray *contents) {
//        NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.comments];
//        [mArray addObject:note.userInfo[LPComposeComment]];
//        self.comments = mArray;
        LPContent *content = contents[self.contentIndex];
        self.comments = content.comments;
        // 2. 刷新tableView
        [self setupData];
        self.underLabel.text = [NSString stringWithFormat:@" 精彩评论 (%d)", self.comments.count];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.comments.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
    


}

- (void)dealloc
{
    [noteCenter removeObserver:self];
}
@end
