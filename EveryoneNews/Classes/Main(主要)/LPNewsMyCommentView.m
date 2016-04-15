//
//  LPNewsMyCommentView.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsMyCommentView.h"
#import "Account.h"
#import "AccountTool.h"
#import "SDWebImageManager.h"

CGSize const kAvatarImageViewSize1 = {70,70};

@interface LPNewsMyCommentView ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *userNameLabel;

@end

@implementation LPNewsMyCommentView

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
    [self setNavTitleView:@"评论"];
    [self backImageItem];
    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor colorWithDesignIndex:9];
    [self addContentView];
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
-(void)addContentView{
    
    
    
    UIImageView *comBGImg = [[UIImageView alloc] init];
    [comBGImg setImage:[UIImage imageNamed:@"LP_commBG"]];
    [self.view addSubview:comBGImg];
    __weak __typeof(self)weakSelf = self;
    [comBGImg mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.view);
        make.top.equalTo(strongSelf.view).with.offset(-64);
        
    }];
    [self.view addSubview:self.avatarImageView];
    [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.top.equalTo(comBGImg.mas_top).with.offset(85);
        make.centerX.equalTo(strongSelf.view);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.view addSubview:self.userNameLabel];
    [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:strongSelf.userNameLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.f]}];
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr.size.width), ceilf(attStr.size.height)));
        make.centerX.mas_equalTo(strongSelf.view);
        make.top.mas_equalTo(strongSelf.avatarImageView.mas_bottom).with.offset(10);
    }];

    
    UIImageView *noticeImg = [[UIImageView alloc] init];
    [noticeImg setImage:[UIImage imageNamed:@"LP_construction"]];
    [self.view addSubview:noticeImg];
    [noticeImg mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.view);
        make.top.equalTo(comBGImg.mas_bottom).with.offset(55);
        
    }];
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"正在建设中，请移步";
    noticeLabel.font = [UIFont systemFontOfSize:20.f];
    noticeLabel.textColor = [UIColor colorWithDesignIndex:5];
    [self.view addSubview:noticeLabel];
    [noticeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.view);
        make.top.equalTo(noticeImg.mas_bottom).with.offset(20);
        
    }];
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
        avatarImageView.layer.cornerRadius = kAvatarImageViewSize1.width/2;
        avatarImageView.layer.borderWidth = 0.5f;
        avatarImageView.layer.borderColor = [[UIColor colorWithDesignIndex:5] CGColor];
        _avatarImageView = avatarImageView;
        
        if (account == nil) {
            avatarImageView.image = [LPNewsAssistant imageWithContentsOfFile:@"LP_icon"];
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
        userNameLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _userNameLabel = userNameLabel;
    }
    return _userNameLabel;
}


@end
