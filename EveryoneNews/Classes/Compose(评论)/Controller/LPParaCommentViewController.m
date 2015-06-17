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

@interface LPParaCommentViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    CGFloat headerHeight;
    CGFloat tableViewHeight;
    CGFloat totalCellHeight;
}
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *paraCommentFrames;
@end

@implementation LPParaCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
    [self setupTableHeaderView];
    [self setupTableFooterView];
    [self setupData];
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
    blackView.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.4];
    [self.view addSubview:blackView];
    self.blackView = blackView;
    [self.blackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlackView:)]];

    
    UITableView *tableView = [[UITableView alloc] init];
//    CGFloat tableViewH = ScreenHeight * 0.63;
    tableView.backgroundColor = [UIColor clearColor];
//    tableView.frame = CGRectMake(0, ScreenHeight - tableViewH, ScreenWidth, tableViewH);
    tableView.separatorColor = [UIColor colorFromHexString:TableViewBackColor alpha:0.6];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)setupTableHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    
    UILabel *aboveLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    aboveLabel.textAlignment = NSTextAlignmentCenter;
    aboveLabel.font = [UIFont boldSystemFontOfSize:18];
    aboveLabel.text = @"他·她们说";
    aboveLabel.textColor = [UIColor whiteColor];
    aboveLabel.backgroundColor = [UIColor colorFromCategory:self.category];
    [headerView addSubview:aboveLabel];
    
    UILabel *underLabel = [[UILabel alloc] init];
    CGFloat underY = CGRectGetMaxY(aboveLabel.frame);
    underLabel.frame = CGRectMake(0, underY, ScreenWidth, 24);
    underLabel.textAlignment = NSTextAlignmentLeft;
    underLabel.font = [UIFont systemFontOfSize:15];
    underLabel.text = [NSString stringWithFormat:@" 精彩评论 (%ld)", self.comments.count];
    underLabel.backgroundColor = [UIColor colorFromHexString:TableViewBackColor alpha:0.9];
    [headerView addSubview:underLabel];
    
    headerHeight = CGRectGetHeight(aboveLabel.frame) + CGRectGetHeight(underLabel.frame);
    headerView.frame = CGRectMake(0, 0, ScreenWidth, headerHeight);
    self.tableView.tableHeaderView = headerView;
}

- (void)setupTableFooterView
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footerView;
    footerView.frame = CGRectMake(0, 0, ScreenWidth, 300);
}

- (void)setupData
{
    NSMutableArray *commentFrameArray = [NSMutableArray array];
    totalCellHeight = 0.0;
    for (LPComment *comment in self.comments) {
        LPParaCommentFrame *commentFrame = [[LPParaCommentFrame alloc] init];
        comment.category = self.category;
        commentFrame.comment = comment;
        [commentFrameArray addObject:commentFrame];
        
        totalCellHeight += commentFrame.cellHeight;
    }
    CGFloat tableViewMaxHeight = totalCellHeight + headerHeight;
    tableViewHeight = MIN(tableViewMaxHeight, ScreenHeight * 0.68);
    self.tableView.frame = CGRectMake(0, ScreenHeight - tableViewHeight, ScreenWidth, tableViewHeight);
    self.paraCommentFrames = commentFrameArray;
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.0;
        self.tableView.transform = CGAffineTransformMakeTranslation(0, tableViewHeight);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }];
}

- (void)tapBlackView:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    if (location.y < ScreenHeight - tableViewHeight) {
        [self dismiss];
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
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPParaCommentFrame *paraCommentFrame = self.paraCommentFrames[indexPath.row];
    return paraCommentFrame.cellHeight;
}

#pragma mark - Scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
//        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.frame.size.height)];
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == YES) {
        NSLog(@"-scrollView.contentOffset.y: %.2f", - scrollView.contentOffset.y);
        if ((- scrollView.contentOffset.y > tableViewHeight * 0.2)||( - scrollView.contentOffset.y > ScreenHeight / 8)) {
            [self dismiss];
        }
    }
}

@end
