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
#import "LPNewsMyInfoView.h"
#import "LPSpringLayout.h"
#import "LPDigViewController.h"
#import "GenieTransition.h"
#import "LPNewsMyCommViewController.h"


#import "EveryoneNews-Swift.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const kCellIdentify = @"JoyMineViewCell";
//CGSize static const kAvatarImageViewSize = {70,70};

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
@property (nonatomic, strong) GenieTransition *genieTransition;

@end

@implementation LPNewsMineViewController

#pragma mark- Initialize


- (void)dealloc{
    NSLog(@"dealloc");
}

#pragma mark-  ViewLife Cycle

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithDesignIndex:9];
    
    // 分享，评论，添加按钮边距设置
    double topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
    
    if (iPhone6) {
        topViewHeight = 72;
    }
    
    double padding = 11;
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
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(returnButtonX, returnButtonY, returnButtonW, returnButtonH)];
    [backBtn setTitle:@"关闭" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [backBtn setTitleColor:[UIColor colorFromHexString:LPColor1] forState:UIControlStateNormal];
    backBtn.enlargedEdge = 15;
    [backBtn addTarget:self action:@selector(doBackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    // 分割线
    UILabel *seperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topViewHeight - 0.5, ScreenWidth, 0.5)];
    seperatorLabel.backgroundColor = [UIColor colorFromHexString:@"#dddddd"];
    [self.view addSubview:seperatorLabel];
    
    [self addContent];
}



#pragma mark- private methods

- (void)addContent{
    
    [self.view addSubview:self.avatarImageView];
    __weak __typeof(self)weakSelf = self;
    [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.top.equalTo(strongSelf.view).with.offset(71+75);
        
        if (iPhone5) {
            make.top.equalTo(strongSelf.view).with.offset(71+75-17);
        }
        
        make.centerX.equalTo(strongSelf.view);
       
        if (iPhone5) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }else{
             make.size.mas_equalTo(CGSizeMake(70, 70));
        }
        
        
    }];
    
    // 用户名
    [self.view addSubview:self.userNameLabel];
    [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:strongSelf.userNameLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:36.f/fontSizePxToSystemMultiple]}];
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr.size.width)+10, ceilf(attStr.size.height)));
        make.centerX.mas_equalTo(strongSelf.view);
        make.top.mas_equalTo(strongSelf.avatarImageView.mas_bottom).with.offset(12);
        if (iPhone5) {
            make.top.mas_equalTo(strongSelf.avatarImageView.mas_bottom).with.offset(8);
        }
        
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.top.mas_equalTo(strongSelf.userNameLabel.mas_bottom).with.offset(47);
        make.left.equalTo(strongSelf.view);
        make.width.mas_equalTo(kApplecationScreenWidth);
        make.height.mas_equalTo(kMineViewCellHeight*3);
    }];
    
    UIImageView *separatorLineUp = [[UIImageView alloc] init];
    separatorLineUp.backgroundColor = [UIColor colorWithDesignIndex:5];
    [self.view addSubview:separatorLineUp];
    [separatorLineUp mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.top.equalTo(strongSelf.tableView);
        make.width.mas_equalTo(kApplecationScreenWidth);
        make.height.mas_equalTo(0.5);
    }];

    userBookLabel = [[UILabel alloc] init];
    userBookLabel.text = @"一订";
    userBookLabel.textAlignment = NSTextAlignmentCenter;
    userBookLabel.textColor = [UIColor colorWithDesignIndex:1];
    userBookLabel.font = [UIFont boldSystemFontOfSize:28.f/fontSizePxToSystemMultiple];
    [self.view addSubview:userBookLabel];
    [userBookLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:userBookLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:28.f/fontSizePxToSystemMultiple]}];
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr.size.width), ceilf(attStr.size.height)));
        make.right.equalTo(strongSelf.view.mas_left).with.offset((kApplecationScreenWidth-73)/2);
        make.bottom.mas_equalTo(strongSelf.view.mas_bottom).with.offset(-24);
        
    }];
    
    userSetLabel = [[UILabel alloc] init];
    userSetLabel.text = @"设置";
    userSetLabel.textAlignment = NSTextAlignmentCenter;
    userSetLabel.textColor = [UIColor colorWithDesignIndex:1];
    userSetLabel.font = [UIFont boldSystemFontOfSize:28.f/fontSizePxToSystemMultiple];
    [self.view addSubview:userSetLabel];
    [userSetLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:userBookLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:28.f/fontSizePxToSystemMultiple]}];
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr.size.width), ceilf(attStr.size.height)));
        make.left.equalTo(userBookLabel.mas_right).with.offset(73);
        make.bottom.mas_equalTo(strongSelf.view.mas_bottom).with.offset(-24);
        
    }];
    
    userBookBtn = [[UIButton alloc] init];
    [userBookBtn setImage:[UIImage imageNamed:@"User_book"] forState:UIControlStateNormal];
    [userBookBtn addTarget:self action:@selector(doBookingAction) forControlEvents:UIControlEventTouchUpInside];
    userBookBtn.enlargedEdge = 15;
    [self.view addSubview:userBookBtn];
    [userBookBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(userBookLabel.mas_centerX);
        make.bottom.mas_equalTo(userBookLabel.mas_top).with.offset(-14);
    }];
    
    
    userSetBtn = [[UIButton alloc] init];
    [userSetBtn setImage:[UIImage imageNamed:@"User_setting"] forState:UIControlStateNormal];
    [userSetBtn addTarget:self action:@selector(gotoSettingView) forControlEvents:UIControlEventTouchUpInside];
    userSetBtn.enlargedEdge = 15;
    [self.view addSubview:userSetBtn];
    [userSetBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userSetLabel.mas_centerX);
        make.centerY.mas_equalTo(userBookBtn.mas_centerY);
    }];

    
}


#pragma mark -  一订
- (void)doBookingAction{
    LPDigViewController *diggerVc = [[LPDigViewController alloc] init];
    //    diggerVc.hotwords = self.digTags;
    diggerVc.presented = YES;
    //    diggerVc.pasteURL = self.pasteURL;
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:diggerVc];
    //    _genieTransition = [[GenieTransition alloc] initWithToViewController:nav];
    self.genieTransition = [[GenieTransition alloc] init];
    nav.transitioningDelegate = self.genieTransition;
    nav.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)gotoSettingView{
    
    LPNewsSettingViewController *settingVC = [[LPNewsSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
    
}

#pragma mark- BackItemMethod

- (void)doBackAction {
    [self dismissViewControllerAnimated:YES completion:^{
        self.statusWindow.hidden = NO;
    }];
}

#pragma mark- Getters and Setters

- (UIImageView *__nonnull)avatarImageView{
    if (!_avatarImageView) {
        Account *account = [AccountTool account];
        UIImageView *avatarImageView = [[UIImageView alloc] init];
        
        CGSize  kAvatarImageViewSize = CGSizeMake(70, 70);
        
        if (iPhone5) {
            kAvatarImageViewSize =  CGSizeMake(60, 60);
        }
        
        avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.shouldRasterize = YES;
        avatarImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        avatarImageView.layer.cornerRadius = kAvatarImageViewSize.width / 2;
        avatarImageView.layer.borderWidth = 0.5f;
        avatarImageView.layer.borderColor = [[UIColor colorWithDesignIndex:5] CGColor];
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
        Account *account = [AccountTool account];
        UILabel *userNameLabel = [[UILabel alloc] init];
        userNameLabel.text = @"奇点资讯";
        if (account != nil) {
            userNameLabel.text = account.userName;
        }
        userNameLabel.textAlignment = NSTextAlignmentCenter;
        userNameLabel.textColor = [UIColor colorWithDesignIndex:1];
        userNameLabel.font = [UIFont systemFontOfSize:36.f/fontSizePxToSystemMultiple];
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
        
        LPNewsMyCommViewController *commView = [[LPNewsMyCommViewController alloc] init];
        [self.navigationController pushViewController:commView animated:YES];

    }else if (indexPath.row ==1){
        
        UIViewController *colView = [[UIStoryboard shareCollectionBoard] getCollectionViewController];
        [self.navigationController pushViewController:colView animated:YES];
        
        
    }else{
        
        LPNewsMyInfoView *infoView = [[LPNewsMyInfoView alloc] init];
        [self.navigationController pushViewController:infoView animated:YES];
        
    }
}






@end
NS_ASSUME_NONNULL_END
