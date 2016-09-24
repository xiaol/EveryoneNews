//
//  QDNewsMineViewController.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsMineViewController.h"
#import "LPNewsMineViewCell.h"
#import "LPNewsSettingViewController.h"
#import "Account.h"
#import "AccountTool.h"
#import "SDWebImageManager.h"
#import "MainNavigationController.h"
#import "LPPersonalMessageViewController.h"
#import "LPSpringLayout.h"
#import "LPNewsMyCommViewController.h"
#import "LPMyCollectionViewController.h"
#import "UIImageView+WebCache.h"
#import "LPPersonalFrame.h"
#import "LPPersonal.h"
#import "LPOneBookController.h"


static NSString *cellIdentifier = @"cellIdentifier";
@interface LPNewsMineViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *personalFrames;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LPNewsMineViewController

#pragma mark - 懒加载
- (NSMutableArray *)personalFrames {
    if (_personalFrames == nil) {
        _personalFrames = [NSMutableArray array];
    }
    return _personalFrames;
}

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorFromHexString:LPColor9];
    // 分享，评论，添加按钮边距设置
    CGFloat topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
    CGFloat padding = 11;
    if (iPhone6) {
        topViewHeight = 72;
    }
    if (iPhone6Plus) {
        padding = 12;
    }
    
    CGFloat fontSize = 16;
    if (iPhone6Plus || iPhone6) {
        fontSize = 18;
    } else if (iPhone5) {
        fontSize = 16;
    }
    NSString *strClose = @"关闭";
    
    CGSize size = [strClose sizeWithFont:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat returnButtonW = size.width ;
    CGFloat returnButtonH = size.height;
    CGFloat returnButtonX = padding;
    CGFloat returnButtonY = (topViewHeight - returnButtonH - StatusBarHeight) / 2 + StatusBarHeight;
    
    // 返回button
    UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(returnButtonX, returnButtonY, returnButtonW, returnButtonH)];
    [returnButton setTitle:@"关闭" forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [returnButton setTitleColor:[UIColor colorFromHexString:LPColor1] forState:UIControlStateNormal];
    returnButton.enlargedEdge = 15;
    [returnButton addTarget:self action:@selector(returnButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnButton];
    
    // 分割线
    UILabel *seperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topViewHeight - 0.5, ScreenWidth, 0.5)];
    seperatorLabel.backgroundColor = [UIColor colorFromHexString:@"#dddddd"];
    [self.view addSubview:seperatorLabel];
    
    [self setupData];
    
    [self setupViews];
}

#pragma mark - returnButtonDidClick
- (void)returnButtonDidClick {
    [self dismissViewControllerAnimated:YES completion:^{
        self.statusWindow.hidden = NO;
    }];
}

#pragma mark - setup Data 
- (void)setupData {
    LPPersonal *personComment = [[LPPersonal alloc] initWithImageName:@"个人中心我的评论" title:@"我的评论"];
    LPPersonal *personCollection = [[LPPersonal alloc] initWithImageName:@"个人中心我的收藏" title:@"我的收藏"];
    LPPersonal *personMessage = [[LPPersonal alloc] initWithImageName:@"个人中心消息中心" title:@"消息中心"];
    
    LPPersonalFrame *commentFrame = [[LPPersonalFrame alloc] init];
    commentFrame.personal = personComment;
    
    LPPersonalFrame *collectionFrame = [[LPPersonalFrame alloc] init];
    collectionFrame.personal = personCollection;
    
    LPPersonalFrame *messageFrame = [[LPPersonalFrame alloc] init];
    messageFrame.personal = personMessage;
    
    [self.personalFrames addObject:commentFrame];
    [self.personalFrames addObject:collectionFrame];
    [self.personalFrames addObject:messageFrame];
}

#pragma mark - setup SubViews
- (void)setupViews{
    
    // 个人头像
    CGFloat iconImageViewY = 146;
    CGFloat iconImageViewW = 70;
    if (iPhone5) {
        iconImageViewY = 129;
        iconImageViewW = 60;
    }
    CGFloat iconImageViewX = (ScreenWidth - iconImageViewW) / 2;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconImageViewX, iconImageViewY, iconImageViewW, iconImageViewW)];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.shouldRasterize = YES;
    iconImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    iconImageView.layer.cornerRadius = iconImageViewW / 2;
    iconImageView.layer.borderWidth = 0.5f;
    iconImageView.layer.borderColor = [[UIColor colorFromHexString:LPColor5] CGColor];
    Account *account = [AccountTool account];
    NSString *nickName = @"奇点资讯";
    if (account) {
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:account.userIcon] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        nickName = account.userName;
    }
    [self.view addSubview:iconImageView];

    // 用户名
    CGFloat aliasLabelW = [nickName sizeWithFont:[UIFont systemFontOfSize:LPFont3] maxSize:CGSizeMake(ScreenWidth, ScreenHeight)].width;
    CGFloat aliasLabelX = (ScreenWidth - aliasLabelW) / 2;
    CGFloat aliasLabelY = CGRectGetMaxY(iconImageView.frame) + 12;
    if (iPhone5) {
        aliasLabelY = CGRectGetMaxY(iconImageView.frame) + 8;
    }
    CGFloat aliasLabelH = [nickName sizeWithFont:[UIFont systemFontOfSize:LPFont3] maxSize:CGSizeMake(ScreenWidth, ScreenHeight)].height;
    
    UILabel *aliasLabel = [[UILabel alloc] initWithFrame:CGRectMake(aliasLabelX, aliasLabelY, aliasLabelW, aliasLabelH)];
    aliasLabel.text = nickName;
    aliasLabel.textAlignment = NSTextAlignmentCenter;
    aliasLabel.textColor = [UIColor colorFromHexString:LPColor1];
    aliasLabel.font = [UIFont systemFontOfSize:LPFont3];
    [self.view addSubview:aliasLabel];
    
    // 表格顶部分割线
    CALayer *tableViewHeaderLayer = [CALayer layer];
    tableViewHeaderLayer.backgroundColor = [UIColor colorFromHexString:LPColor10].CGColor;
    tableViewHeaderLayer.frame = CGRectMake(0, CGRectGetMaxY(aliasLabel.frame) + 46.5f, ScreenWidth, 0.5f);
    [self.view.layer addSublayer:tableViewHeaderLayer];
    
    // UITableView
    CGFloat tableViewX = 0;
    CGFloat tableViewY = CGRectGetMaxY(aliasLabel.frame) + 47;
    CGFloat tableViewH = 174;
    CGFloat tableViewW = ScreenWidth;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH)];
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.rowHeight = 58;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[LPNewsMineViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    // 表格底部分割线
    CALayer *tableViewBottomLayer = [CALayer layer];
    tableViewBottomLayer.backgroundColor = [UIColor colorFromHexString:LPColor10].CGColor;
    tableViewBottomLayer.frame = CGRectMake(0, CGRectGetMaxY(tableView.frame), ScreenWidth, 0.5f);
    [self.view.layer addSublayer:tableViewBottomLayer];
    
    
    // 一订
    CGFloat bookButtonW = 26;
    CGFloat bookButtonH = 26;
    
    NSString *bookStr = @"一订";
    CGFloat bookLabelH = [bookStr sizeWithFont:[UIFont systemFontOfSize:LPFont5] maxSize:CGSizeMake(ScreenWidth, ScreenHeight)].height;
    CGFloat bookLabelW = [bookStr sizeWithFont:[UIFont systemFontOfSize:LPFont5] maxSize:CGSizeMake(ScreenWidth, ScreenHeight)].width;
    CGFloat bookLabelY = ScreenHeight - bookLabelH - 24;
    CGFloat bookLabelX = (ScreenWidth - bookLabelW * 2  - 73) / 2.0f;
    
    UILabel *bookLabel = [[UILabel alloc] initWithFrame:CGRectMake(bookLabelX, bookLabelY, bookLabelW, bookLabelH)];
    bookLabel.font = [UIFont systemFontOfSize:LPFont5];
    bookLabel.textColor = [UIColor colorFromHexString:LPColor1];
    bookLabel.text = bookStr;
    bookLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bookLabel];
    
    CGFloat bookButtonY = CGRectGetMinY(bookLabel.frame) - 14 - bookButtonH;
    UIButton *bookButton = [[UIButton alloc] initWithFrame:CGRectMake(0, bookButtonY, bookButtonW, bookButtonH)];
    [bookButton setBackgroundImage:[UIImage imageNamed:@"个人中心一订"] forState:UIControlStateNormal];
    bookButton.centerX = bookLabel.centerX;
    bookButton.enlargedEdge = 10;
    [bookButton addTarget:self action:@selector(bookButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bookButton];
    
    // 设置
    CGFloat settingLabelX = CGRectGetMaxX(bookLabel.frame) + 73;
    CGFloat settingLabelY = bookLabelY;
    CGFloat settingLabelW = bookLabelW;
    CGFloat settingLabelH = bookLabelH;
    UILabel *settingLabel = [[UILabel alloc] initWithFrame:CGRectMake(settingLabelX, settingLabelY, settingLabelW, settingLabelH)];
    settingLabel.font = [UIFont systemFontOfSize:LPFont5];
    settingLabel.textColor = [UIColor colorFromHexString:LPColor1];
    settingLabel.textAlignment = NSTextAlignmentCenter;
    settingLabel.text = @"设置";
    [self.view addSubview:settingLabel];
    
    CGFloat settingButtonY = bookButtonY;
    CGFloat settingButtonW = bookButtonW;
    CGFloat settingButtonH = bookButtonH;
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, settingButtonY, settingButtonW, settingButtonH)];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"个人中心设置"] forState:UIControlStateNormal];
    settingButton.centerX = settingLabel.centerX;
    settingButton.enlargedEdge = 10;
    [settingButton addTarget:self action:@selector(settingButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];
}


#pragma mark - settingButtonDidClick
- (void)settingButtonDidClick {
    LPNewsSettingViewController *settingVC = [[LPNewsSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}


#pragma mark - bookButtonDidClick
- (void)bookButtonDidClick {
    LPOneBookController *oneBookVC = [[LPOneBookController alloc] init];
    [self.navigationController pushViewController:oneBookVC animated:YES];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.personalFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPNewsMineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[LPNewsMineViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.personalFrame = self.personalFrames[indexPath.row];
    return cell;
}


#pragma mark - UITableView Delegate
- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        LPNewsMyCommViewController *commView = [[LPNewsMyCommViewController alloc] init];
        [self.navigationController pushViewController:commView animated:YES];

    } else if (indexPath.row ==1) {
        LPMyCollectionViewController *collectionViewController = [[LPMyCollectionViewController alloc] init];
        [self.navigationController pushViewController:collectionViewController animated:YES];
    } else{
        LPPersonalMessageViewController *infoView = [[LPPersonalMessageViewController alloc] init];
        [self.navigationController pushViewController:infoView animated:YES];

    }
}

@end

