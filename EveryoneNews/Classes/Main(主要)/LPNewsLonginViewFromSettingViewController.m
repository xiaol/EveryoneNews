//
//  LPNewsLonginViewFromSettingViewController.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsLonginViewFromSettingViewController.h"
#import "Account.h"
#import "AccountTool.h"
#import "UIImageView+WebCache.h"
#import "UMSocialAccountManager.h"
#import "WXApi.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "LPHttpTool.h"
#import "NSDate+Extension.h"
#import "UMSocialDataService.h"
#import "LPNewsMineViewController.h"
#import "MainNavigationController.h"
#import "LPNewsNavigationController.h"
#import "LPNewsMineViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface LPNewsLonginViewFromSettingViewController()<UMSocialUIDelegate>{
    UIButton *weixinBtn;
    UIButton *weiboBtn;
    UIButton *settingBtn;
    
    UILabel *weixinLabel;
    UILabel *weiboLabel;
    UILabel *settingLabel;
}

@end

@implementation LPNewsLonginViewFromSettingViewController

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
    [self backItem:@"取消"];
    
    CGRect lineLayerRect = CGRectMake(0.f, (self.navigationController.navigationBar.size.height-1.f), kApplecationScreenWidth, 0.5f);
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = lineLayerRect;
    lineLayer.backgroundColor = [[UIColor colorWithDesignIndex:5] CGColor];
    [self.navigationController.navigationBar.layer addSublayer:lineLayer];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithDesignIndex:9];
    self.navigationController.navigationBar.translucent = NO;
    
    [self setNavTitleView:@"奇点资讯"];
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
    
    weixinBtn = [[UIButton alloc] init];
    [weixinBtn setImage:[UIImage imageNamed:@"微信登录"] forState:UIControlStateNormal];
    //btn阴影
//    weixinBtn.layer.cornerRadius = weixinBtn.imageView.image.size.width/2;
//    weixinBtn.layer.shadowOffset =  CGSizeMake(1, 1);
//    weixinBtn.layer.shadowOpacity = 0.8;
//    weixinBtn.layer.shadowColor =  [UIColor blackColor].CGColor;
    [weixinBtn addTarget:self action:@selector(doWeixinLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinBtn];
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(weixinBtn)weakWinxinBtn = weixinBtn;
    [weixinBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        __strong __typeof(weakWinxinBtn)strongWenxinBtn = weakWinxinBtn;
        make.top.equalTo(strongSelf.view.mas_top).with.offset(7+75);
        make.right.equalTo(strongSelf.view.mas_left).with.offset((kApplecationScreenWidth-76)/2);
        make.size.mas_equalTo(strongWenxinBtn.imageView.image.size);
    }];
    
    weiboBtn = [[UIButton alloc] init];
    [weiboBtn setImage:[UIImage imageNamed:@"微博登录"] forState:UIControlStateNormal];
    //btn阴影
//    weiboBtn.layer.cornerRadius = weixinBtn.imageView.image.size.width/2;
//    weiboBtn.layer.shadowOffset =  CGSizeMake(1, 1);
//    weiboBtn.layer.shadowOpacity = 0.8;
//    weiboBtn.layer.shadowColor =  [UIColor blackColor].CGColor;
    [weiboBtn addTarget:self action:@selector(doWeiboLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboBtn];
    __weak __typeof(weiboBtn)weakWeiboBtn = weiboBtn;
    [weiboBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakWeiboBtn)strongWeiboBtn = weakWeiboBtn;
        __strong __typeof(weakWinxinBtn)strongWenxinBtn = weakWinxinBtn;
        make.centerY.equalTo(strongWenxinBtn.mas_centerY);
        make.left.equalTo(strongWenxinBtn.mas_right).with.offset(76);
        make.size.mas_equalTo(strongWeiboBtn.imageView.image.size);
    }];
    
    weixinLabel = [[UILabel alloc] init];
    weixinLabel.text = @"微信登录";
    weixinLabel.textAlignment = NSTextAlignmentCenter;
    weixinLabel.textColor = [UIColor colorWithDesignIndex:1];
    weixinLabel.font = [UIFont boldSystemFontOfSize:32.f/fontSizePxToSystemMultiple];
    [self.view addSubview:weixinLabel];
    [weixinLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakWinxinBtn)strongWenxinBtn = weakWinxinBtn;
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:weixinLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:32.f/fontSizePxToSystemMultiple]}];
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr.size.width), ceilf(attStr.size.height)));
        make.centerX.equalTo(strongWenxinBtn.mas_centerX);
        make.top.mas_equalTo(strongWenxinBtn.mas_bottom).with.offset(14);
        
    }];
    
    weiboLabel = [[UILabel alloc] init];
    weiboLabel.text = @"微博登录";
    weiboLabel.textAlignment = NSTextAlignmentCenter;
    weiboLabel.textColor = [UIColor colorWithDesignIndex:1];
    weiboLabel.font = [UIFont boldSystemFontOfSize:32.f/fontSizePxToSystemMultiple];
    [self.view addSubview:weiboLabel];
    [weiboLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakWeiboBtn)strongWeiboBtn = weakWeiboBtn;
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:weixinLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:32.f/fontSizePxToSystemMultiple]}];
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr.size.width), ceilf(attStr.size.height)));
        make.centerX.equalTo(strongWeiboBtn.mas_centerX);
        make.top.mas_equalTo(strongWeiboBtn.mas_bottom).with.offset(14);
        
    }];
}

#pragma mark- BackItemMethod

- (void)doBackAction:(nullable id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doWeixinLogin{
    NSLog(@"微信登录");
    [self loginWithPlatformName:UMShareToWechatSession];
}

- (void)doWeiboLogin{
    NSLog(@"微博登录");
    [self loginWithPlatformName:UMShareToSina];
}

#pragma mark- Getters and Setters

#pragma mark - 登录微信微博平台
- (void)loginWithPlatformName:(NSString *)type {
    
    UMSocialSnsPlatform *platform = [UMSocialSnsPlatformManager getSocialPlatformWithName:type];
    UMSocialControllerService *service = [UMSocialControllerService defaultControllerService];
    service.socialUIDelegate = self;
    platform.loginClickHandler(self, service , YES ,^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *accountEntity = [[UMSocialAccountManager socialAccountDictionary] valueForKey:type];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"userId"] = accountEntity.usid;
            dict[@"userGender"] = @(0);
            dict[@"userName"] = accountEntity.userName;
            dict[@"userIcon"] = accountEntity.iconURL;
            dict[@"platformType"] = accountEntity.platformName;
            dict[@"deviceType"] = @"ios";
            dict[@"token"] = accountEntity.accessToken;
            dict[@"expiresTime"] = @([NSDate dateToMilliSeconds:accountEntity.expirationDate]);
            Account *account = [Account objectWithKeyValues:dict];
            [AccountTool saveAccount:account];
            //将用户授权信息上传到服务器
            NSDictionary *params = [NSDictionary dictionary];
            params = account.keyValues;
            [LPHttpTool getWithURL:AccountLoginUrl params:params success:^(id json) {
                [AccountTool saveAccount:account];
                [self dismissViewControllerAnimated:YES completion:nil];
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"登录失败"];
            }];
        } else {
            [MBProgressHUD showError:@"登录失败"];
        }
    });
}




@end

NS_ASSUME_NONNULL_END