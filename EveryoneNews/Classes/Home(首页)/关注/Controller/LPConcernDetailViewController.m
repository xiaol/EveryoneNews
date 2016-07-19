//
//  LPConcernDetailViewController.m
//  EveryoneNews
//
//  Created by dongdan on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPConcernDetailViewController.h"
#import "LPConcernCardTableViewCell.h"
#import "LPConcernIndroduceTableViewCell.h"
#import "LPConcernCardFrame.h"
#import "LPConcernIntroduceFrame.h"
#import "LPConcernIntroduce.h"
#import "LPConcernCard.h"
#import "LPBottomShareView.h"
#import "LPDetailChangeFontSizeView.h"
#import "LPFontSizeManager.h"
#import "MBProgressHUD+MJ.h"
#import "UMSocial.h"

static NSString *introduceCellIdentifier = @"introduceCellIdentifier";
static NSString *contentCellIdentifier = @"contentCellIdentifier";
const static CGFloat changeFontSizeViewH = 150;

@interface LPConcernDetailViewController() <UITableViewDelegate, UITableViewDataSource, LPBottomShareViewDelegate, LPDetailChangeFontSizeViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NSMutableArray *concernCardFrames;
@property (nonatomic, strong) NSMutableArray *concernIntroduceCardFrames;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, assign) CGFloat lastContentOffsetY;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) LPBottomShareView *bottomShareView;
@property (nonatomic, strong)  UIView *detailBackgroundView;
@property (nonatomic, strong)  LPDetailChangeFontSizeView *changeFontSizeView;
// 分享url
@property (nonatomic, copy) NSString *shareURL;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareImageURL;

@end

@implementation LPConcernDetailViewController


#pragma mark - 懒加载
- (NSMutableArray *)concernCardFrames {
    if (!_concernCardFrames) {
        _concernCardFrames = [NSMutableArray array];
    }
    return _concernCardFrames;
}

- (NSMutableArray *)concernIntroduceCardFrames {
    if (!_concernIntroduceCardFrames) {
        _concernIntroduceCardFrames = [NSMutableArray array];
    }
    return _concernIntroduceCardFrames;
}

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:LPColor9];
    [self setupData];
    [self setupTopView];
    [self setupTableView];
   
  
}

#pragma mark - setup Data 
- (void)setupData {
    LPConcernIntroduce *concernIntroduce = [[LPConcernIntroduce alloc] init];
    concernIntroduce.introduce = @"关注农村注册啊实打实的";
    
    LPConcernIntroduceFrame *introduceFrame = [[LPConcernIntroduceFrame alloc] init];
    introduceFrame.concernIntroduce = concernIntroduce;
    [self.concernIntroduceCardFrames addObject:introduceFrame];
    
    for(int i = 0 ;i < 20; i++) {
        LPConcernCard *card = [[LPConcernCard alloc] init];
        card.title = @"欧洲杯-神锋4分钟2球+造红牌 法国2-1逆转进8强";
        card.commentsCount = @(2);
        card.updateTime = @"2016-06-26 23:53:26";
        card.cardImages = @[@"http://bdp-pic.deeporiginalx.com/4ad701a70a4ac8952e2eb85d1bcbd4e5_570X355.jpg"];
        
        LPConcernCardFrame *cardFrame = [[LPConcernCardFrame alloc] init];
        cardFrame.card = card;
        [self.concernCardFrames addObject:cardFrame];
    }
    

}

#pragma mark - setupTopView 
- (void)setupTopView {
    
    // 分享，评论，添加按钮边距设置
    CGFloat topViewHeight = TabBarHeight + StatusBarHeight;
    if (iPhone6) {
        topViewHeight = 72;
    }
    CGFloat padding = 15;
    CGFloat returnButtonWidth = 13;
    CGFloat returnButtonHeight = 22;
    
    if (iPhone6Plus) {
        returnButtonWidth = 12;
        returnButtonHeight = 21;
    }
    CGFloat shareButtonW = 25;
    CGFloat shareButtonH = 5;
    CGFloat shareButtonX = ScreenWidth - padding - shareButtonW;
    
    CGFloat returnButtonPaddingTop = (topViewHeight - returnButtonHeight + StatusBarHeight) / 2;
    CGFloat shareButtonY =  (topViewHeight - shareButtonH + StatusBarHeight) / 2.0f;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, ScreenWidth, topViewHeight)];
    topView.backgroundColor = [UIColor colorFromHexString:LPColor9];
    [self.view addSubview:topView];
    
    // 返回button
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(padding, returnButtonPaddingTop, returnButtonWidth, returnButtonHeight)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"详情页返回"] forState:UIControlStateNormal];
    backBtn.enlargedEdge = 15;
    [backBtn addTarget:self action:@selector(topViewBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];

    // 详情页右上角分享
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(shareButtonX, shareButtonY , shareButtonW, shareButtonH)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"详情页右上分享"] forState:UIControlStateNormal];
    shareBtn.enlargedEdge = 15;
    [shareBtn addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:shareBtn];
    
    CGFloat concernBtnW = 52;
    CGFloat concernBtnH = 24;
    CGFloat concernBtnX =  CGRectGetMinX(shareBtn.frame) - 17 - concernBtnW;
    CGFloat concernBtnY = 0;
    
    UIButton *concernButton = [[UIButton alloc] initWithFrame:CGRectMake(concernBtnX, concernBtnY, concernBtnW, concernBtnH)];
    concernButton.centerY = backBtn.centerY;
    concernButton.layer.borderColor = [UIColor colorFromHexString:@"#e71f19"].CGColor;
    concernButton.layer.borderWidth = 1.0f;
    concernButton.clipsToBounds = YES;
    concernButton.layer.cornerRadius = 12.0f;
    [concernButton setTitle:@"关注" forState:UIControlStateNormal];
    [concernButton setTitleColor:[UIColor colorFromHexString:@"#e71f19"] forState:UIControlStateNormal];
    concernButton.titleLabel.font = [UIFont systemFontOfSize:LPFont5];
    [topView addSubview:concernButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    NSString *headerStr = @"住宅产业住宅产业";
    titleLabel.text = headerStr;
    titleLabel.font = [UIFont boldSystemFontOfSize:LPFont4];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.hidden = YES;
    
    CGFloat titleLabelW = 100;
    CGFloat titleLabelH = [headerStr sizeWithFont:[UIFont boldSystemFontOfSize:LPFont4] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat titleLabelX = (ScreenWidth - titleLabelW) / 2;
    CGFloat titleLabelY = (topViewHeight - titleLabelH + StatusBarHeight) / 2.0f;
    titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    [topView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, topViewHeight - 0.5, ScreenWidth, 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
    seperatorView.hidden = YES;
    [topView addSubview:seperatorView];
    self.seperatorView = seperatorView;
    
    self.topView = topView;

}

#pragma mark - 返回按钮
- (void)topViewBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 分享按钮
- (void)shareButtonClick {
    
    UIView *detailBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    detailBackgroundView.backgroundColor = [UIColor blackColor];
    detailBackgroundView.alpha = 0.6;
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBackgroundView)];
    [detailBackgroundView addGestureRecognizer:tapGestureRecognizer];
    
    [self.view addSubview:detailBackgroundView];
    self.detailBackgroundView = detailBackgroundView;
    
    // 添加分享
    LPBottomShareView *bottomShareView = [[LPBottomShareView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    bottomShareView.delegate = self;
    [self.view addSubview:bottomShareView];
    
    // 改变字体大小视图
    LPDetailChangeFontSizeView *changeFontSizeView = [[LPDetailChangeFontSizeView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, changeFontSizeViewH)];
    changeFontSizeView.delegate = self;
    [self.view addSubview:changeFontSizeView];
    self.changeFontSizeView = changeFontSizeView;
    
    CGRect toFrame = CGRectMake(0, ScreenHeight - bottomShareView.size.height, ScreenWidth, bottomShareView.size.height);
    
    [UIView animateWithDuration:0.3f animations:^{
        bottomShareView.frame = toFrame;
    }];
    self.bottomShareView = bottomShareView;
}

#pragma mark LPDetailTopView Delegate
- (void)shareView:(LPBottomShareView *)shareView cancelButtonDidClick:(UIButton *)cancelButton {
    [self removeBackgroundView];
}

- (void)removeBackgroundView {
    CGRect bottomShareViewToFrame = CGRectMake(0, ScreenHeight, ScreenWidth, self.bottomShareView.size.height);
    CGRect changeFontSizeViewToFrame = CGRectMake(0, ScreenHeight, ScreenWidth, self.changeFontSizeView.height);
    
    [UIView animateWithDuration:0.3f animations:^{
        if (self.bottomShareView.origin.y == ScreenHeight - self.bottomShareView.size.height) {
            self.bottomShareView.frame = bottomShareViewToFrame;
        }
        if (self.changeFontSizeView.origin.y == ScreenHeight - self.changeFontSizeView.size.height) {
            self.changeFontSizeView.frame = changeFontSizeViewToFrame;
        }
        self.detailBackgroundView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.bottomShareView removeFromSuperview];
        [self.changeFontSizeView removeFromSuperview];
        [self.detailBackgroundView removeFromSuperview];
    }];
}

- (void)shareView:(LPBottomShareView *)shareView index:(NSInteger)index {
    switch (index) {
        case -2:
            [self shareToWechatSessionBtnClick];
            break;
        case -1:
            [self shareToWechatTimelineBtnClick];
            break;
        case -3:
            [self shareToQQBtnClick];
            break;
        case -4:
            [self shareToSinaBtnClick];
            break;
        case -5:
            [self shareToSmsBtnClick];
            break;
        case -6:
            [self shareToEmailBtnClick];
            break;
        case -7:
            [self shareToLinkBtn];
            break;
        case -8:
            [self changeDetailFontSize];
            break;
            
    }
}

// 提示信息
-(void)shareSucess {
    [self removeBackgroundView];
    [MBProgressHUD showSuccess:@"分享成功"];
}

-(void)shareFailure {
    [self removeBackgroundView];
    [MBProgressHUD showError:@"分享失败"];
}


// 朋友圈按钮
- (void)shareToWechatTimelineBtnClick {
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url: self.shareImageURL];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb ;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareURL;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shareTitle image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
        }
        else {
            [self shareFailure];
        }
    }];
}

// 微信好友
- (void)shareToWechatSessionBtnClick {
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url: self.shareImageURL];
    [UMSocialData defaultData].extConfig.wxMessageType=UMSocialYXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareURL;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.shareTitle image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
            
        }
    }];
}

// qq 好友
- (void)shareToQQBtnClick {
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:[NSString stringWithFormat:@"%@ %@", self.shareTitle, self.shareURL] image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
        }
    }];
}

// 新浪微博
- (void)shareToSinaBtnClick {
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url: self.shareImageURL];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@ %@", self.shareTitle, self.shareURL] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
        }
        else {
            [self shareFailure];
        }
        
    }];
}

// 短信分享
- (void)shareToSmsBtnClick {
    NSString *url = [NSString stringWithFormat:@"%@ %@", self.shareTitle, self.shareURL];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:url image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
        }
    }];
}

// 邮件分享
- (void)shareToEmailBtnClick {
    NSString *url = self.shareURL;
    [UMSocialData defaultData].extConfig.title =[NSString stringWithFormat:@"【奇点资讯】%@",self.shareTitle];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToEmail] content:url image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
        }
    }];
}

// 转发链接
- (void)shareToLinkBtn {
    NSString *url = [NSString stringWithFormat:@"%@ %@", self.shareTitle, self.shareURL] ;
    UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
    gpBoard.string=url;
    [self removeBackgroundView];
    [MBProgressHUD showSuccess:@"复制成功"];
}


#pragma mark - 改变详情页字体大小
- (void)changeDetailFontSize {
    CGRect shareViewToFrame = CGRectMake(0, ScreenHeight, ScreenWidth, self.bottomShareView.size.height);
    CGRect changeFontSizeViewToFrame = CGRectMake(0, ScreenHeight - changeFontSizeViewH, ScreenWidth, self.changeFontSizeView.height);
    [UIView animateWithDuration:0.3f animations:^{
        self.bottomShareView.frame = shareViewToFrame;
        self.changeFontSizeView.frame = changeFontSizeViewToFrame;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - LPDetailChangeFontSizeView delegate
- (void)changeFontSizeView:(LPDetailChangeFontSizeView *)changeFontSizeView reloadTableViewWithFontSize:(NSInteger)fontSize fontSizeType:(NSString *)fontSizeType currentDetailContentFontSize:(NSInteger)currentDetailContentFontSize currentDetaiTitleFontSize:(NSInteger)currentDetaiTitleFontSize currentDetailCommentFontSize:(NSInteger)currentDetailCommentFontSize currentDetailRelatePointFontSize:(NSInteger)currentDetailRelatePointFontSize currentDetailSourceFontSize:(NSInteger)currentDetailSourceFontSize {
    
    [LPFontSizeManager sharedManager].currentHomeViewFontSize = fontSize;
    [LPFontSizeManager sharedManager].currentHomeViewFontSizeType = fontSizeType;
    [LPFontSizeManager sharedManager].currentDetailContentFontSize = currentDetailContentFontSize;
    [LPFontSizeManager sharedManager].currentDetaiTitleFontSize = currentDetaiTitleFontSize;
    [LPFontSizeManager sharedManager].currentDetailCommentFontSize = currentDetailCommentFontSize;
    [LPFontSizeManager sharedManager].currentDetailRelatePointFontSize = currentDetailRelatePointFontSize;
    [LPFontSizeManager sharedManager].currentDetailSourceFontSize = currentDetailSourceFontSize;
    
   
    [noteCenter postNotificationName:LPFontSizeChangedNotification object:nil];
}

- (void)finishButtonDidClick:(LPDetailChangeFontSizeView *)changeFontSizeView {
    [self removeBackgroundView];
}


#pragma mark - setup TableView
- (void)setupTableView {
    
    // 分享，评论，添加按钮边距设置
    CGFloat topViewHeight = TabBarHeight + StatusBarHeight;
    if (iPhone6) {
        topViewHeight = 72;
    }
    UIView *headerView = [[UIView alloc] init];
    
    CGFloat headerImageViewW = 60;
    CGFloat headerImageViewH = 60;
    CGFloat headerImageViewX = (ScreenWidth - headerImageViewW) / 2;
    CGFloat headerImageViewY = 0;
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headerImageViewX, headerImageViewY, headerImageViewW, headerImageViewH)];
    headerImageView.image = [UIImage imageNamed:@"奇点号占位图2"];
    [headerView addSubview:headerImageView];
    self.headerImageView = headerImageView;
    
    NSString *headerStr = @"住宅产业";
    
    CGFloat headerLabelW = [headerStr sizeWithFont:[UIFont systemFontOfSize:LPFont1] maxSize:CGSizeMake(ScreenWidth, CGFLOAT_MAX)].width;
    CGFloat headerLabelH = [headerStr sizeWithFont:[UIFont systemFontOfSize:LPFont1] maxSize:CGSizeMake(headerLabelW, CGFLOAT_MAX)].height;
    CGFloat headerLabelX = (ScreenWidth - headerLabelW) / 2;
    CGFloat headerLabelY = CGRectGetMaxY(headerImageView.frame) + 10;
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.font = [UIFont systemFontOfSize:LPFont1];
    headerLabel.text = headerStr;
    headerLabel.textColor = [UIColor colorFromHexString:LPColor1];
    headerLabel.frame = CGRectMake(headerLabelX, headerLabelY, headerLabelW, headerLabelH);
    [headerView addSubview:headerLabel];
    self.headerLabel = headerLabel;
    
    CGFloat seperatorViewX = 17;
    CGFloat seperatorViewY = CGRectGetMaxY(headerLabel.frame) + 22;
    CGFloat seperatorViewW = ScreenWidth - seperatorViewX * 2;
    CGFloat seperatorViewH = 0.5;
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(seperatorViewX, seperatorViewY, seperatorViewW, seperatorViewH)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
    [headerView addSubview:seperatorView];
    
    CGFloat headerViewH = CGRectGetMaxY(seperatorView.frame);
    headerView.frame = CGRectMake(0, 0 , ScreenWidth, headerViewH);
    
    CGFloat tableViewH = ScreenHeight - topViewHeight;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topViewHeight, ScreenWidth, tableViewH) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[LPConcernCardTableViewCell class] forCellReuseIdentifier:contentCellIdentifier];
    [tableView registerClass:[LPConcernIndroduceTableViewCell class] forCellReuseIdentifier:introduceCellIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = headerView;
    [self.view addSubview:tableView];
    self.tableView = tableView;

}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LPConcernIndroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:introduceCellIdentifier];
        if (cell == nil) {
            cell =  [[LPConcernIndroduceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:introduceCellIdentifier];
        }
        cell.cardFrame = self.concernIntroduceCardFrames[indexPath.row];
        return cell;
    } else {
        LPConcernCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentCellIdentifier];
        if (cell == nil) {
            cell =  [[LPConcernCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentCellIdentifier];
        }
        cell.cardFrame  = self.concernCardFrames[indexPath.row];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.concernIntroduceCardFrames.count;
    } else {
        return self.concernCardFrames.count;
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LPConcernIntroduceFrame *frame = self.concernIntroduceCardFrames[indexPath.row];
        return frame.cellHeight;
    } else {
        LPConcernCardFrame *frame = self.concernCardFrames[indexPath.row];
        return frame.cellHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = nil;
    CGFloat height = [self heightForTableViewHeader];
    CGFloat paddingLeft = 17;
    CGFloat paddingTop = 13;
    if (section == 0) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
        view.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, paddingTop, ScreenWidth - paddingLeft, height - paddingTop)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:LPFont10];
        label.textColor = [UIColor colorFromHexString:LPColor4];
        label.text = @"介绍";
        [view addSubview:label];
        return view;
        
    } else {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
        view.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, paddingTop, ScreenWidth - paddingLeft, height - paddingTop)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:LPFont10];
        label.textColor = [UIColor colorFromHexString:LPColor4];
        label.text = @"历史文章";
        [view addSubview:label];
        
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForTableViewHeader];
}


#pragma mark - heightForTableViewHeader
- (CGFloat)heightForTableViewHeader {
    
    NSString *str = @"介绍";
    CGFloat height = [str sizeWithFont:[UIFont systemFontOfSize:LPFont10] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat padding = 13;
    return height + padding;
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollView.scrollEnabled = YES;
    self.lastContentOffsetY = self.tableView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([scrollView isKindOfClass:[UITableView class]]) { // 上下拖动table view
        if (offsetY > 0) {
            if (offsetY > self.tableView.tableHeaderView.frame.size.height - 20) {
                self.titleLabel.hidden = NO;
                self.seperatorView.hidden = NO;
            } else {
                self.titleLabel.hidden = YES;
                self.seperatorView.hidden = YES;

            }
        }
    }
}


@end
