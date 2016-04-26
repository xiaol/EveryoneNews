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

NS_ASSUME_NONNULL_BEGIN

CGSize static const kAvatarImageViewSize = {70,70};
CGSize static const kAvatarSize = {25,25};
static const CGFloat kDefaultHeadHeight = (215.f);
static const CGFloat kContentIndent = 0.f;
static NSString * const kCellIdentify = @"LPNewsMyCommCell";
static NSString *const kHeaderViewIdentify = @"LPNewsMineHeadViewIdentify";

@interface LPNewsMyCommViewController()<UITableViewDelegate,UITableViewDataSource>{
    
    CGFloat lastContentOffset;
    CGFloat navAlpha;
}

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong, nullable) NSArray *dataSource;
@property (nonatomic, strong) UIView *navBarView;
@end

@implementation LPNewsMyCommViewController
#pragma mark- Initialize

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc{
    
}


#pragma mark-  ViewLife Cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    [self addContentView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    if ([self.view window] == nil && [self isViewLoaded]) {
    }
}



#pragma mark- private methods

-(void)addContentView{
   
    [self.view addSubview:self.headImageView];
    self.headImageView.image = [UIImage imageNamed:@"LP_commBG"];
    __weak __typeof(self)weakSelf = self;
    [self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.left.top.equalTo(strongSelf.view);
        make.size.mas_equalTo(CGSizeMake(kApplecationScreenWidth, kDefaultHeadHeight));
    }];
    
    self.dataSource = [self getDataSource];
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.left.top.equalTo(strongSelf.view);
        make.size.equalTo(strongSelf.view);
    }];
    if (!self.tableView.tableHeaderView) {
        UIView *tableHeadBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kApplecationScreenWidth, kDefaultHeadHeight)];
        tableHeadBgView.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = tableHeadBgView;
    }
   
    UIImageView *avatarBGImg = [[UIImageView alloc] init];
    avatarBGImg.layer.cornerRadius = 77/2;
    avatarBGImg.alpha = 0.5;
    avatarBGImg.backgroundColor = [UIColor whiteColor];
    [self.tableView.tableHeaderView addSubview:avatarBGImg];
    __weak __typeof(self.tableView.tableHeaderView)weakHeadView = self.tableView.tableHeaderView;
    [avatarBGImg mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakHeadView)strongHeadView = weakHeadView;
        make.top.equalTo(strongHeadView.mas_top).with.offset(55);
        make.centerX.equalTo(strongHeadView);
        make.size.mas_equalTo(CGSizeMake(77, 77));
    }];
    [self.tableView.tableHeaderView addSubview:self.avatarImageView];
    [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(avatarBGImg);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];

    [self.tableView.tableHeaderView addSubview:self.userNameLabel];
    [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:strongSelf.userNameLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:36.f/fontSizePxToSystemMultiple]}];
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr.size.width)+10, ceilf(attStr.size.height)));
        make.centerX.mas_equalTo(strongSelf.view);
        make.top.mas_equalTo(avatarBGImg.mas_bottom).with.offset(18);
    }];

    UIImageView *noticeImg = [[UIImageView alloc] init];
    [noticeImg setImage:[UIImage imageNamed:@"LP_construction"]];
    [self.view addSubview:noticeImg];
    [noticeImg mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.view);
        make.top.equalTo(strongSelf.headImageView.mas_bottom).with.offset(55);
        
    }];
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"正在建设中，请移步";
    noticeLabel.font = [UIFont systemFontOfSize:32.f/fontSizePxToSystemMultiple];
    noticeLabel.textColor = [UIColor colorWithDesignIndex:5];
    [self.view addSubview:noticeLabel];
    [noticeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.view);
        make.top.equalTo(noticeImg.mas_bottom).with.offset(21);
    }];

    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"BackArrow_white"] forState:UIControlStateNormal];
    backBtn.enlargedEdge = 14;
    [backBtn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(backBtn.imageView.image.size);
        make.top.equalTo(self.view.mas_top).offset(34);
        make.left.equalTo(self.view.mas_left).with.offset(12);
        
    }];
    
    [self addNavBarView];
}


- (NSArray *)getDataSource{
    NSArray *array = @[@[@{@"User_account":@"我的账户"},@{@"User_account":@"我的账户"},@{@"User_account":@"我的账户"},@{@"User_account":@"我的账户"},@{@"User_account":@"我的账户"},@{@"User_account":@"我的账户"},@{@"User_account":@"我的账户"},@{@"User_account":@"我的账户"},@{@"User_account":@"我的账户"},@{@"User_account":@"我的账户"},@{@"User_account":@"我的账户"},@{@"User_account":@"我的账户"}]];
    
    return array;
}

- (void)addNavBarView{
    
    _navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kApplecationScreenWidth, kNavigationBarHEIGHT+20.f)];
    _navBarView.backgroundColor = [UIColor colorWithHexString:@"#FF69B4"];
    _navBarView.alpha = 0.f;
    
    UIImageView *avatar = nil;
    if (!avatar) {
        Account *account = [AccountTool account];
        avatar = [[UIImageView alloc] init];
        
        avatar.contentMode = UIViewContentModeScaleAspectFit;
        avatar.layer.masksToBounds = YES;
        avatar.layer.shouldRasterize = YES;
        avatar.layer.rasterizationScale = [UIScreen mainScreen].scale;
        avatar.layer.cornerRadius = kAvatarSize.width/2;
        
        if (account == nil) {
            avatar.image = [UIImage imageNamed:@"LP_icon"];
        }else{
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:account.userIcon] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image && finished) {
                    avatar.image = image;
                }
            }];
        }
    }
    __weak __typeof(self.navBarView)weakNavBarView = self.navBarView;
    [self.navBarView addSubview:avatar];
    [avatar mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakNavBarView)strongNavBarView = weakNavBarView;
        make.centerX.equalTo(strongNavBarView.mas_centerX);
        make.top.equalTo(strongNavBarView.mas_top).with.offset(33.f);
        make.size.mas_equalTo(kAvatarSize);
    }];
    
    UIButton *scrollToTopBtn = [[UIButton alloc] initWithFrame:_navBarView.frame];
    [scrollToTopBtn addTarget:self action:@selector(scrollToTop:) forControlEvents:UIControlEventTouchUpInside];
    [_navBarView addSubview:scrollToTopBtn];
    
    UIButton *backBtn1 = [[UIButton alloc] init];
    [backBtn1 setImage:[UIImage imageNamed:@"BackArrow_black"] forState:UIControlStateNormal];
    backBtn1.enlargedEdge = 14;
    [backBtn1 addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    [_navBarView addSubview:backBtn1];
    [backBtn1 mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakNavBarView)strongNavBarView = weakNavBarView;
        make.size.mas_equalTo(backBtn1.imageView.image.size);
        make.top.equalTo(strongNavBarView.mas_top).offset(34);
        make.left.equalTo(strongNavBarView.mas_left).with.offset(12);
        
    }];
    [self.view addSubview:_navBarView];

}

- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollToTop:(BOOL)animated {
    [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark - 设置状态栏样式
- (UIStatusBarStyle) preferredStatusBarStyle {
    if (self.navBarView.alpha == 0) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

#pragma mark- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSource.count > section) {
        NSArray *array = self.dataSource[section];
        return array.count;
    }
    return 0;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    LPNewsMyCommCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentify forIndexPath:indexPath];
    if (!cell) {
        cell = [[LPNewsMyCommCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentify];
    }
    if (indexPath.section < self.dataSource.count) {
        NSArray *array = self.dataSource[indexPath.section];
        if (indexPath.row < array.count) {
            NSDictionary *dict = [array objectAtIndex:indexPath.row];
            [cell setModel:dict IndexPath:indexPath];
            
        }
    }
    return cell;
}

#pragma mark- UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y < 0.f){
        [self setHeadImageViewConstraints:kDefaultHeadHeight - scrollView.contentOffset.y originalY:kContentIndent];
        self.navBarView.alpha = 0.f;
        [self preferredStatusBarStyle];
    }else {
        [self setHeadImageViewConstraints:kDefaultHeadHeight originalY:(0.f-scrollView.contentOffset.y)+kContentIndent];
        [self preferredStatusBarStyle];
        
        if (scrollView.contentOffset.y < 121.f){
            self.navBarView.alpha = 0.f;
        }else if(scrollView.contentOffset.y >= 121.f && scrollView.contentOffset.y <= 151.f){
            self.navBarView.alpha = ((scrollView.contentOffset.y-121)/30.f)*0.8;
        }else if (scrollView.contentOffset.y > 151.f){
            self.navBarView.alpha = 0.8f;
        }
    }
    
    if (lastContentOffset > scrollView.contentOffset.y){    //向下滑动
        
        if (self.navBarView.alpha == 0 && self.navBarView.alpha != navAlpha) {
//            [self preferredStatusBarStyle];
//            [super preferredStatusBarStyle];
            NSLog(@"self.alpha=0");
        }
        navAlpha = self.navBarView.alpha;
    }else{   //向上滑动
        
        if (self.navBarView.alpha == 0.8f && self.navBarView.alpha != navAlpha) {
//            [self preferredStatusBarStyle];
//            [super preferredStatusBarStyle];
            NSLog(@"self.alpha=0.8");
        }
        navAlpha = self.navBarView.alpha;
    }
    
    lastContentOffset = scrollView.contentOffset.y;


    
}


-(void)setHeadImageViewConstraints:(CGFloat)height originalY:(CGFloat)y{
    __weak __typeof(self)weakSelf = self;
    [self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.top.equalTo(strongSelf.view).offset(y);
        make.left.equalTo(strongSelf.view);
        make.size.mas_equalTo(CGSizeMake(kApplecationScreenWidth, height));
    }];
}

#pragma mark- Getters and Setters

- (UIImageView * __nonnull)headImageView{
    if (!_headImageView) {
        UIImageView *headImageView = [[UIImageView alloc] init];
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.clipsToBounds = YES;
        _headImageView = headImageView;
    }
    return _headImageView;
}

- (UIImageView *__nonnull)avatarImageView{
    if (!_avatarImageView) {
        Account *account = [AccountTool account];
        UIImageView *avatarImageView = [[UIImageView alloc] init];
        
        avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.shouldRasterize = YES;
        avatarImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        avatarImageView.layer.cornerRadius = kAvatarImageViewSize.width/2;
        _avatarImageView = avatarImageView;
        
        if (account == nil) {
            avatarImageView.image = [UIImage imageNamed:@"LP_icon"];
        }else{
            __weak typeof(self) weakSelf = self;
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:account.userIcon] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image && finished) {
                    weakSelf.avatarImageView.image = image;
                }
            }];
        }
    }
    
    return _avatarImageView;
}

- (UILabel * __nonnull)userNameLabel{
    if (!_userNameLabel) {
        Account *account = [AccountTool account];
        UILabel *userNameLabel = [[UILabel alloc] init];
        userNameLabel.text = @"奇点资讯";
        if (account != nil) {
            userNameLabel.text = account.userName;
        }
        userNameLabel.textAlignment = NSTextAlignmentCenter;
        userNameLabel.textColor = [UIColor whiteColor];
        userNameLabel.font = [UIFont boldSystemFontOfSize:36.f/fontSizePxToSystemMultiple];
        _userNameLabel = userNameLabel;
    }
    return _userNameLabel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kMineViewCellHeight;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[LPNewsMyCommCell class] forCellReuseIdentifier:kCellIdentify];
    }
    return _tableView;
}

@end

NS_ASSUME_NONNULL_END
