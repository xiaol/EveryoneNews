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

NS_ASSUME_NONNULL_BEGIN

CGSize static const kAvatarImageViewSize = {70,70};
static NSString * const kCellIdentify = @"LPNewsMyCommCell";
@interface LPNewsMyCommViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong, nullable) NSArray *dataSource;
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
    
}

- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
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
        userNameLabel.font = [UIFont boldSystemFontOfSize:36.f/2.2639];
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
//        [_tableView registerClass:[JoyHeaderView class] forHeaderFooterViewReuseIdentifier:kHeaderViewIdentify];
    }
    return _tableView;
}

@end

NS_ASSUME_NONNULL_END
