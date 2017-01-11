//
//  LPNewsMyCommViewController.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsMyCommViewController.h"
#import "Account.h"
#import "AccountTool.h"
#import "SDWebImageManager.h"
#import "LPNewsMineViewController.h"
#import "Comment+Create.h"
#import "LPMyCommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "LPMyCommentFrame.h"
#import "LPDetailViewController.h"
#import "LPDetailTipView.h"
#import "CommentTool.h"
#import "LPMyComment.h"
#import "LPLoadingView.h"
#import "LPVideoDetailViewController.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface LPNewsMyCommViewController()<UITableViewDelegate,UITableViewDataSource,LPMyCommentTableViewCellDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *commentArrayFrame;
@property (nonatomic, strong) UIView *noCommentsTipView;
@property (nonatomic, strong) LPLoadingView *loadingView;

@end

@implementation LPNewsMyCommViewController

#pragma mark - 懒加载
- (NSMutableArray *)commentArrayFrame {
    if (_commentArrayFrame == nil) {
        _commentArrayFrame = [NSMutableArray array];
    }
    return _commentArrayFrame;
}


#pragma mark - ViewDidLoad
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupSubViews];
    [self setupData];

}

#pragma mark - setup Data
- (void)setupData {
     [CommentTool commentsQuerySuccess:^(NSArray *cards) {
         if (cards.count > 0) {
             for (LPMyComment *comment in cards) {
                 LPMyCommentFrame *commentFrame = [[LPMyCommentFrame alloc] init];
                 commentFrame.comment = comment;
                 [self.commentArrayFrame addObject:commentFrame];
             }
         }
         [self.loadingView stopAnimating];
         [self reloadData];
     } failure:^(NSError *error) {
         
     }];
}

#pragma mark - reloadData
- (void)reloadData {
    if (self.commentArrayFrame.count > 0) {
        self.noCommentsTipView.hidden = YES;
    } else {
        
        self.noCommentsTipView.hidden = NO;
    }
    [self.tableView reloadData];
}

#pragma mark - setup SubViews
- (void)setupSubViews {
    
    self.view.backgroundColor = [UIColor colorFromHexString:LPColor9];
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
    titleLabel.text = @"评论";
    titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
    titleLabel.font = [UIFont  boldSystemFontOfSize:LPFont8];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerX = topView.centerX;
    titleLabel.centerY = backButton.centerY;
    [topView addSubview:titleLabel];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenWidth , 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor10];
    [self.view addSubview:seperatorView];
    
    CGFloat tableViewY = CGRectGetMaxY(seperatorView.frame);
    CGFloat tableViewH = ScreenHeight - tableViewY;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, ScreenWidth, tableViewH)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[LPMyCommentTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    tableView.backgroundColor = [UIColor colorFromHexString:@"#ffffff" alpha:0.0f];
    tableView.delegate = self;
    tableView.dataSource = self;
 
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // 没有收藏提示信息
    UIView *noCommentsTipView = [[UIView alloc] initWithFrame:CGRectMake(0, topViewHeight + 42, ScreenWidth, 140)];
    CGFloat noCommentsImageViewW = 90;
    CGFloat noCommentsImageViewH = 83;
    CGFloat noCommentsImageViewX = (ScreenWidth - noCommentsImageViewW) / 2;
    CGFloat noCommentsImageViewY = 42;
    UIImageView *noCommentsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(noCommentsImageViewX, noCommentsImageViewY, noCommentsImageViewW, noCommentsImageViewH)];
    noCommentsImageView.image = [UIImage imageNamed:@"wupinglun"];
    
    CGFloat noCommentsLabelX = 0;
    CGFloat noCommentsLabelY = CGRectGetMaxY(noCommentsImageView.frame);
    CGFloat noCommentsLabelW = ScreenWidth;
    CGFloat noCommentsLabelH = 20;
    UILabel *noCommentsLabelFirst = [[UILabel alloc] initWithFrame:CGRectMake(noCommentsLabelX, noCommentsLabelY, noCommentsLabelW, noCommentsLabelH)];
    noCommentsLabelFirst.text = @"还没有发表任何评论";
    noCommentsLabelFirst.textColor = [UIColor colorFromHexString:@"#d4d4d4"];
    noCommentsLabelFirst.font = [UIFont systemFontOfSize:17];
    noCommentsLabelFirst.textAlignment = NSTextAlignmentCenter;
    [noCommentsTipView addSubview:noCommentsLabelFirst];
    [noCommentsTipView addSubview:noCommentsImageView];
    noCommentsTipView.hidden = YES;
    [self.tableView insertSubview:noCommentsTipView belowSubview:self.tableView];
    
    self.noCommentsTipView = noCommentsTipView;
    
    
    LPLoadingView *loadingView = [[LPLoadingView alloc] initWithFrame:CGRectMake(0, StatusBarHeight + TabBarHeight, ScreenWidth, (ScreenHeight - StatusBarHeight - TabBarHeight) / 2.0f)];
    [self.view addSubview:loadingView];
    self.loadingView = loadingView;
    [loadingView startAnimating];
    

  
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArrayFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPMyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.commentFrame = self.commentArrayFrame[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark UItableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPMyCommentFrame *commentFrame = self.commentArrayFrame[indexPath.row];
    return commentFrame.cellHeight;
}

#pragma mark - CommentCell Delegate
- (void)didTapTitleView:(LPMyCommentTableViewCell *)cell  commentFrame:(LPMyCommentFrame *)commentFrame {
    LPMyComment *comment = commentFrame.comment;
    if (comment.rtype == videoNewsType) {
        LPVideoDetailViewController *videoDetailVc= [[LPVideoDetailViewController alloc] init];
        videoDetailVc.sourceViewController = commentSource;
        videoDetailVc.myCommentFrame = commentFrame;
        [self.navigationController pushViewController:videoDetailVc animated:YES];
    } else {
        LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
        detailVc.sourceViewController = commentSource;
        detailVc.myCommentFrame = commentFrame;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
    
    
 
}

#pragma mark - 删除评论
- (void)deleteButtonDidClick:(LPMyCommentTableViewCell *)cell commentFrame:(LPMyCommentFrame *)commentFrame {
    [CommentTool deleteComment:commentFrame.comment deleteFlag:^(NSString *deleteFlag) {
        if ([deleteFlag isEqualToString:LPSuccess]) {
            NSInteger index = [self.commentArrayFrame indexOfObject:commentFrame];
            [self.commentArrayFrame removeObject:commentFrame];
            [self.tableView  deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            if (self.commentArrayFrame.count > 0) {
                self.noCommentsTipView.hidden = YES;
            } else {
                
                self.noCommentsTipView.hidden = NO;
      
            }
        }
    }];
}

- (void)upButtonDidClick:(LPMyCommentTableViewCell *)cell {
    [self tipViewWithCondition:7];
}

#pragma mark - 返回上一级
- (void)topViewBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 提示信息
- (void)tipViewWithCondition:(NSInteger)condition {
    LPDetailTipView *tipView = [[LPDetailTipView alloc] initWithCondition:condition];
    [self.view addSubview:tipView];
    
    [UIView animateWithDuration:0.4f delay:0.8f options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         tipView.alpha = 0.2f;
                     } completion:^(BOOL finished) {
                         [tipView removeFromSuperview];
                     }];
}

@end

