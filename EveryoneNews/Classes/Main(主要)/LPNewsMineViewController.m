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
#import "LPNewsNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const kCellIdentify = @"JoyMineViewCell";
CGSize const kAvatarImageViewSize = {70,70};

@interface LPNewsMineViewController () <UITableViewDelegate,UITableViewDataSource>{
    NSIndexPath * tempIndexPath;
    UIButton * userBookBtn;
    UIButton * userSetBtn;
    UILabel * userBookLabel;
    UILabel * userSetLabel;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property(nonatomic, strong, nullable) NSArray *dataSource;

@end

@implementation LPNewsMineViewController

#pragma mark- Initialize

- (instancetype)initWithCustom{
    self = [super initWithCustom];
    if (self) {
       
    }
    return self;
}

- (void)dealloc{
    
}

#pragma mark-  ViewLife Cycle

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithDesignIndex:9];
    [self backItem:@"关闭"];
    [self addContent];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
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

- (void)addContent{
    
    [self.view addSubview:self.avatarImageView];
    __weak __typeof(self)weakSelf = self;
    [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.top.equalTo(strongSelf.view).with.offset(64+75);
        make.centerX.equalTo(strongSelf.view);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.view addSubview:self.userNameLabel];
    [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:strongSelf.userNameLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:36.f]}];
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr.size.width), ceilf(attStr.size.height)));
        make.centerX.mas_equalTo(strongSelf.view);
        make.top.mas_equalTo(strongSelf.avatarImageView.mas_bottom).with.offset(12);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.top.mas_equalTo(strongSelf.userNameLabel.mas_bottom).with.offset(47);
        make.left.equalTo(strongSelf.view);
        make.width.mas_equalTo(kApplecationScreenWidth);
        make.height.mas_equalTo(58*3);
    }];
    
    UIImageView *separatorLine = [[UIImageView alloc] init];
    separatorLine.backgroundColor = [UIColor colorWithDesignIndex:5];
    [self.view addSubview:separatorLine];
    [separatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.top.equalTo(strongSelf.tableView);
        make.width.mas_equalTo(kApplecationScreenWidth);
        make.height.mas_equalTo(0.5);
    }];
    
    userBookLabel = [[UILabel alloc] init];
    userBookLabel.text = @"一订";
    userBookLabel.textAlignment = NSTextAlignmentCenter;
    userBookLabel.textColor = [UIColor colorWithDesignIndex:1];
    userBookLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [self.view addSubview:userBookLabel];
    [userBookLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:userBookLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]}];
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr.size.width), ceilf(attStr.size.height)));
        make.right.equalTo(strongSelf.view.mas_left).with.offset((kApplecationScreenWidth-73)/2);
        make.bottom.mas_equalTo(strongSelf.view.mas_bottom).with.offset(-24);
        
    }];
    
    userSetLabel = [[UILabel alloc] init];
    userSetLabel.text = @"设置";
    userSetLabel.textAlignment = NSTextAlignmentCenter;
    userSetLabel.textColor = [UIColor colorWithDesignIndex:1];
    userSetLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [self.view addSubview:userSetLabel];
    [userSetLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:userBookLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]}];
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr.size.width), ceilf(attStr.size.height)));
        make.left.equalTo(userBookLabel.mas_right).with.offset(73);
        make.bottom.mas_equalTo(strongSelf.view.mas_bottom).with.offset(-24);
        
    }];
    
    userBookBtn = [[UIButton alloc] init];
    [userBookBtn setImage:[LPNewsAssistant imageWithContentsOfFile:@"User_book"] forState:UIControlStateNormal];
    [userBookBtn addTarget:self action:@selector(doBookingAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userBookBtn];
    __weak __typeof (userBookBtn)weakUserBookBtn = userBookBtn;
    [userBookBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakUserBookBtn)strongUserBookBtn = weakUserBookBtn;
        make.centerX.mas_equalTo(userBookLabel.mas_centerX);
        make.bottom.mas_equalTo(userBookLabel.mas_top).with.offset(-14);
        make.size.mas_equalTo(strongUserBookBtn.imageView.image.size);
    }];
    
    userSetBtn = [[UIButton alloc] init];
    [userSetBtn setImage:[LPNewsAssistant imageWithContentsOfFile:@"User_setting"] forState:UIControlStateNormal];
    [userSetBtn addTarget:self action:@selector(gotoSettingView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userSetBtn];
    __weak __typeof (userSetBtn)weakUserSetBtn = userSetBtn;
    [userSetBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakUserSetBtn)strongUserSetBtn = weakUserSetBtn;
        make.centerX.equalTo(userSetLabel.mas_centerX);
        make.centerY.mas_equalTo(userBookBtn.mas_centerY);
        make.size.mas_equalTo(strongUserSetBtn.imageView.image.size);
    }];

    
}

- (void)doBookingAction{
    
    NSLog(@"doBookingAction");
    
}

- (void)gotoSettingView{
    
    LPNewsSettingViewController *settingVC = [[LPNewsSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
    
}

#pragma mark- BackItemMethod

- (void)doBackAction:(nullable id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- Getters and Setters

- (UIImageView *__nonnull)avatarImageView{
    if (!_avatarImageView) {
        Account *account = [AccountTool account];
        UIImageView *avatarImageView = [[UIImageView alloc] init];
        
        avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.shouldRasterize = YES;
        avatarImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        avatarImageView.layer.cornerRadius = kAvatarImageViewSize.width/2;
        avatarImageView.layer.borderWidth = 0.5f;
        avatarImageView.layer.borderColor = [[UIColor colorWithDesignIndex:5] CGColor];
        _avatarImageView = avatarImageView;
        
        if (account == nil) {
           avatarImageView.image = [LPNewsAssistant imageWithContentsOfFile:@"UserDeafultImage"];
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

- (UITableView * __nonnull)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        _tableView = tableView;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kMineViewCellHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[LPNewsMineViewCell class] forCellReuseIdentifier:kCellIdentify];
        
    }
    return _tableView;
}

- (UILabel * __nonnull)userNameLabel{
    if (!_userNameLabel) {
        UILabel *userNameLabel = [[UILabel alloc] init];
        userNameLabel.text = @"奇点资讯";
        userNameLabel.textAlignment = NSTextAlignmentCenter;
        userNameLabel.textColor = [UIColor colorWithDesignIndex:1];
        userNameLabel.font = [UIFont boldSystemFontOfSize:36.f];
        _userNameLabel = userNameLabel;
    }
    return _userNameLabel;
}

- (NSArray * __nullable)dataSource{
    if (!_dataSource) {
        NSArray *array = @[@[@{@"User_comment":@"我的评论"},@{@"User_coll":@"我的收藏"},@{@"User_mess":@"消息中心"}]];
        _dataSource = array;
    }
    return _dataSource;
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
    tempIndexPath = indexPath;
    LPNewsMineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentify forIndexPath:indexPath];
    if (!cell) {
        cell = [[LPNewsMineViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentify];
    }
    
    if (indexPath.section < self.dataSource.count) {
        NSArray *array = self.dataSource[indexPath.section];
        if (indexPath.row < array.count) {
            NSDictionary *dict = [array objectAtIndex:indexPath.row];
            [cell setModel:dict IndexPath:indexPath];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark- UITableViewDelegate

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSLog(@"我的评论");
    }else if (indexPath.row ==1){
        NSLog(@"我的收藏");
    }else{
        NSLog(@"消息中心");
    }
}






@end
NS_ASSUME_NONNULL_END
