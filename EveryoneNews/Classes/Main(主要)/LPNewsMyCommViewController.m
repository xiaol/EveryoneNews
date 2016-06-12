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
#import "LPNewsMineViewCell.h"
#import "LPNewsMyCommCell.h"
#import "LPNewsHeaderView.h"
#import "LPNewsMineViewController.h"
#import "Comment+Create.h"
#import "LPMyCommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "LPMyCommentFrame.h"
#import "LPDetailViewController.h"
#import "LPDetailTipView.h"
#import "Comment+Create.h"



const static CGFloat headerHeight = 215.0f;
static NSString *cellIdentifier = @"cellIdentifier";
static BOOL status;
@interface LPNewsMyCommViewController()<UITableViewDelegate,UITableViewDataSource, LPMyCommentTableViewCellDelegate>

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property(nonatomic, strong) UIImageView *headerImageView;
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *commentArrayFrame;
@property (nonatomic, strong) UIView *tableHeaderView;

// 返回按钮
@property (nonatomic, strong) UIButton *backButton;
// 无评论提示信息
@property (nonatomic, strong) UIView *noCommentTipView;
// 导航栏
@property (nonatomic, strong) UIView *topView;
// 个人头像小图
@property (nonatomic, strong) UIImageView *smallAvatarImageView;
// 评论总高度
@property (nonatomic, assign) CGFloat sumHeight;


@end

@implementation LPNewsMyCommViewController

#pragma mark - 懒加载
- (NSMutableArray *)commentArrayFrame {
    if (_commentArrayFrame == nil) {
        _commentArrayFrame = [NSMutableArray array];
    }
    return _commentArrayFrame;
}

#pragma mark - preferredStatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
    return status ? UIStatusBarStyleLightContent: UIStatusBarStyleDefault;
   
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


#pragma mark - ViewDidLoad
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupData];
    [self setupSubViews];
}

#pragma mark - setup Data
- (void)setupData {
    NSArray *array = [Comment getPersonalComment];
    CGFloat sumHeight = 0.0;
    for (Comment *comment in array) {
        LPMyCommentFrame *commentFrame = [[LPMyCommentFrame alloc] init];
        commentFrame.comment = comment;
        [self.commentArrayFrame addObject:commentFrame];
        sumHeight += commentFrame.cellHeight;
    }
    self.sumHeight = sumHeight;
}

#pragma mark - setup SubViews
- (void)setupSubViews {
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
       
    // 头像背景
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.clipsToBounds = YES;
    headerImageView.layer.shouldRasterize = YES;
    headerImageView.image = [UIImage imageNamed:@"我的评论头像背景"];
    headerImageView.frame = CGRectMake(0, 0, ScreenWidth, headerHeight);
    self.headerImageView = headerImageView;
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headerHeight)];
    NSString *userName = @"奇点资讯";
    
    [tableHeaderView addSubview:headerImageView];
    
    Account *account = [AccountTool account];
    
    // 圆形头像
    CGFloat avatarImageViewW = 77.0f;
    CGFloat avatarImageViewH = 77.0f;
    CGFloat avatarImageViewX = (ScreenWidth - avatarImageViewW) / 2;
    CGFloat avatarImageViewY = (headerHeight - avatarImageViewH) / 2;
    UIImageView *avatarImageView = [[UIImageView alloc] init];
    avatarImageView.layer.cornerRadius = avatarImageViewW / 2;
    avatarImageView.alpha = 0.5;
    avatarImageView.backgroundColor = [UIColor whiteColor];
    avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.shouldRasterize = YES;
    avatarImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    avatarImageView.frame = CGRectMake(avatarImageViewX, avatarImageViewY, avatarImageViewW, avatarImageViewH);

    [tableHeaderView addSubview:avatarImageView];
    
    self.avatarImageView = avatarImageView;
    if (account) {
        userName = account.userName;
        [avatarImageView sd_setImageWithURL:[NSURL URLWithString:account.userIcon] placeholderImage:[UIImage imageNamed:@"我的评论个人头像"]];
    }
    
    
    CGFloat userNameLabelW = [userName sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] maxSize:CGSizeMake(CGFLOAT_MAX , CGFLOAT_MAX)].width;
    CGFloat userNameLabelH = [userName sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] maxSize:CGSizeMake(CGFLOAT_MAX , CGFLOAT_MAX)].height;
    CGFloat userNameLabelY = CGRectGetMaxY(avatarImageView.frame) + 18;
    CGFloat userNameLabelX = (ScreenWidth - userNameLabelW) / 2;
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.font = [UIFont boldSystemFontOfSize:18];
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.frame = CGRectMake(userNameLabelX, userNameLabelY, userNameLabelW, userNameLabelH);
    userNameLabel.text = userName;
    [tableHeaderView addSubview:userNameLabel];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorFromHexString:LPColor9];
    tableView.tableHeaderView = tableHeaderView;
    [self.tableView sendSubviewToBack:tableHeaderView];
    self.tableHeaderView = tableHeaderView;
    tableView.scrollEnabled = YES;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[LPMyCommentTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
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
    self.topView = topView;
    
    // 小圆形头像
    CGFloat smallAvatarImageViewW = 20.0f;
    CGFloat smallAvatarImageViewH = 20.0f;
    CGFloat smallAvatarImageViewX = (ScreenWidth - smallAvatarImageViewW) / 2;
    CGFloat smallAvatarImageViewY = (topViewHeight - smallAvatarImageViewH + StatusBarHeight) / 2;
    UIImageView *smallAvatarImageView = [[UIImageView alloc] init];
    smallAvatarImageView.layer.cornerRadius = smallAvatarImageViewW / 2;
    smallAvatarImageView.alpha = 0.5;
    smallAvatarImageView.backgroundColor = [UIColor whiteColor];
    smallAvatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    smallAvatarImageView.layer.masksToBounds = YES;
    smallAvatarImageView.layer.shouldRasterize = YES;
    smallAvatarImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    smallAvatarImageView.frame = CGRectMake(smallAvatarImageViewX, smallAvatarImageViewY, smallAvatarImageViewW, smallAvatarImageViewH);
    [topView addSubview:smallAvatarImageView];
    if (account) {
        [smallAvatarImageView sd_setImageWithURL:[NSURL URLWithString:account.userIcon] placeholderImage:[UIImage imageNamed:@"我的评论个人头像"]];
    }
    smallAvatarImageView.hidden = YES;
    self.smallAvatarImageView = smallAvatarImageView;
    
    // 返回button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, returnButtonPaddingTop, returnButtonWidth, returnButtonHeight)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"我的评论白色返回"] forState:UIControlStateNormal];
    backButton.enlargedEdge = 15;
    [backButton addTarget:self action:@selector(topViewBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    self.backButton = backButton;
    
    // 没有评论提示信息
    UIView *noCommentTipView = [[UIView alloc] initWithFrame:CGRectMake(0, headerHeight + 42, ScreenWidth, 140)];
    
    CGFloat noCommentImageViewW = 65;
    CGFloat noCommentImageViewH = 57;
    CGFloat noCommentImageViewX = (ScreenWidth - noCommentImageViewW) / 2;
    CGFloat noCommentImageViewY = 42;
    UIImageView *noCommentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(noCommentImageViewX, noCommentImageViewY, noCommentImageViewW, noCommentImageViewH)];
    noCommentImageView.image = [UIImage imageNamed:@"我的评论无评论提示"];
    
    CGFloat noCommentLabelX = 0;
    CGFloat noCommentLabelY = CGRectGetMaxY(noCommentImageView.frame) + 25;
    
    if (iPhone5) {
        noCommentLabelY = CGRectGetMaxY(noCommentImageView.frame) + 15;
    }
    CGFloat noCommentLabelW = ScreenWidth;
    CGFloat noCommentLabelH = 20;
    UILabel *noCommentLabelFirst = [[UILabel alloc] initWithFrame:CGRectMake(noCommentLabelX, noCommentLabelY, noCommentLabelW, noCommentLabelH)];
    noCommentLabelFirst.text = @"高冷的ta";
    noCommentLabelFirst.textColor = [UIColor colorFromHexString:@"#d4d4d4"];
    noCommentLabelFirst.font = [UIFont systemFontOfSize:17];
    noCommentLabelFirst.textAlignment = NSTextAlignmentCenter;
    
    UILabel *noCommentLabelSecond = [[UILabel alloc] initWithFrame:CGRectMake(noCommentLabelX, CGRectGetMaxY(noCommentLabelFirst.frame), noCommentLabelW, noCommentLabelH)];
    noCommentLabelSecond.text = @"还没有发表过任何评论";
    noCommentLabelSecond.textColor = [UIColor colorFromHexString:@"#d4d4d4"];
    noCommentLabelSecond.font = [UIFont systemFontOfSize:17];
    noCommentLabelSecond.textAlignment = NSTextAlignmentCenter;
    
    [noCommentTipView addSubview:noCommentLabelFirst];
    [noCommentTipView addSubview:noCommentLabelSecond];
    [noCommentTipView addSubview:noCommentImageView];
    
    self.noCommentTipView = noCommentTipView;
    [self.tableView insertSubview:noCommentTipView belowSubview:self.tableView];
    
    
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.commentArrayFrame.count > 0) {
        
        self.noCommentTipView.hidden = YES;
    } else {
        
        self.noCommentTipView.hidden = NO;
    }
    return self.commentArrayFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPMyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.commentFrame = self.commentArrayFrame[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.commentArrayFrame.count > 0) {
        return 60;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    label.textColor = [UIColor colorFromHexString:@"#9a9a9a"];
    label.text = @"已显示全部内容";
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:label];
    if (self.commentArrayFrame.count > 0) {
        return footerView;
    } else {
        return nil;
    }
}

#pragma mark UItableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPMyCommentFrame *commentFrame = self.commentArrayFrame[indexPath.row];
    return commentFrame.cellHeight;
}

#pragma mark - CommentCell Delegate
- (void)didTapTitleView:(LPMyCommentTableViewCell *)cell card:(Card *)card {
    LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
    detailVc.cardID = card.objectID;
    [self.navigationController pushViewController:detailVc animated:YES];
}

// 删除评论
- (void)deleteButtonDidClick:(LPMyCommentTableViewCell *)cell commentFrame:(LPMyCommentFrame *)commentFrame {
    NSInteger index = [self.commentArrayFrame indexOfObject:commentFrame];
    [self.commentArrayFrame removeObject:commentFrame];
    [self.tableView  deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [Comment deleteComment:commentFrame.comment];
    
    if (self.commentArrayFrame.count == 0) {
        [self.tableView reloadData];
    }
    
}

- (void)upButtonDidClick:(LPMyCommentTableViewCell *)cell {
    [self tipViewWithCondition:7];
}
#pragma mark - scrollViewDidScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        
        self.headerImageView.frame = CGRectMake(0, offsetY, ScreenWidth, headerHeight -  offsetY);
        
    } else {
        
        double topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
        if (iPhone6) {
            topViewHeight = 72;
        }
        if (offsetY > (headerHeight - topViewHeight)) {
            
            [self.backButton setBackgroundImage:[UIImage imageNamed:@"我的评论黑色返回"] forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.5 animations:^{
               self.topView.backgroundColor = [UIColor colorFromHexString:@"#ffffff" alpha:0.5f];
            }];
            
            self.smallAvatarImageView.hidden = NO;
            status = false;
            [self setNeedsStatusBarAppearanceUpdate];
            
        } else {
            [self.backButton setBackgroundImage:[UIImage imageNamed:@"我的评论白色返回"] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.5 animations:^{
                self.topView.backgroundColor = [UIColor colorFromHexString:@"#ffffff" alpha:0.0f];
            }];
            self.smallAvatarImageView.hidden = YES;
            status = true;
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
  
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

