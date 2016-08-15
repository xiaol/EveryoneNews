//
//  LPNewsLoginViewController.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsSettingViewController.h"
#import "LPNewsLoginViewController.h"
#import "LPHomeViewController+LaunchLoginManager.h"
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
#import "LPNewsMineViewController.h"
#import "LPLoginTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPNewsLoginViewController()<UMSocialUIDelegate>{
    UIButton *weixinBtn;
    UIButton *weiboBtn;
    UIButton *settingBtn;
    
    UILabel *weixinLabel;
    UILabel *weiboLabel;
    UILabel *settingLabel;
}

@end

@implementation LPNewsLoginViewController



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
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [backBtn setTitleColor:[UIColor colorFromHexString:LPColor1] forState:UIControlStateNormal];
    backBtn.enlargedEdge = 15;
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    // 分割线
    UILabel *seperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topViewHeight - 0.5, ScreenWidth, 0.5)];
    seperatorLabel.backgroundColor = [UIColor colorFromHexString:@"#dddddd"];
    [self.view addSubview:seperatorLabel];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text = @"奇点资讯";
    titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
    titleLabel.font = [UIFont  boldSystemFontOfSize:LPFont8];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerX = self.view.centerX;
    titleLabel.centerY = backBtn.centerY;
    [self.view addSubview:titleLabel];
 
    [self addContent];
}

- (void)backBtnClick {
   [self dismissViewControllerAnimated:YES completion:^{
       self.statusWindow.hidden = NO;
   }];
}


#pragma mark- private methods

- (void)addContent{
    
    weixinBtn = [[UIButton alloc] init];
    [weixinBtn setImage:[UIImage imageNamed:@"微信登录"] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(doWeixinLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinBtn];
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(weixinBtn)weakWinxinBtn = weixinBtn;
    [weixinBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        __strong __typeof(weakWinxinBtn)strongWenxinBtn = weakWinxinBtn;
        make.top.equalTo(strongSelf.view.mas_top).with.offset(kCustomNavigationBarHeight+75);
        make.right.equalTo(strongSelf.view.mas_left).with.offset((kApplecationScreenWidth-76)/2);
        make.size.mas_equalTo(strongWenxinBtn.imageView.image.size);
    }];
    
    weiboBtn = [[UIButton alloc] init];
    [weiboBtn setImage:[UIImage imageNamed:@"微博登录"] forState:UIControlStateNormal];
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
    
    settingLabel = [[UILabel alloc] init];
    settingLabel.text = @"设置";
    settingLabel.textAlignment = NSTextAlignmentCenter;
    settingLabel.textColor = [UIColor colorWithDesignIndex:1];
    settingLabel.font = [UIFont boldSystemFontOfSize:28.f/fontSizePxToSystemMultiple];
    [self.view addSubview:settingLabel];
    [settingLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:settingLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:28.f/fontSizePxToSystemMultiple]}];
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr.size.width), ceilf(attStr.size.height)));
        make.centerX.equalTo(strongSelf.view);
        make.bottom.mas_equalTo(strongSelf.view.mas_bottom).with.offset(-24);
    }];
    
    settingBtn = [[UIButton alloc] init];
    [settingBtn setImage:[UIImage imageNamed:@"User_setting"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(gotoSettingView) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.enlargedEdge = 10;
    [self.view addSubview:settingBtn];
    __weak __typeof (settingBtn)weakSettingBtn = settingBtn;
    __weak __typeof (settingLabel)weakSettingLabel = settingLabel;
    [settingBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSettingBtn)strongSetingBtn = weakSettingBtn;
        __strong __typeof(weakSettingLabel)strongSettingLabel = weakSettingLabel;
        make.centerX.equalTo(strongSettingLabel.mas_centerX);
        make.bottom.equalTo(strongSettingLabel.mas_top).with.offset(-14);
        make.size.mas_equalTo(strongSetingBtn.imageView.image.size);
    }];
}


#pragma mark - 设置
- (void)gotoSettingView{
    
    LPNewsSettingViewController *settingVC = [[LPNewsSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}


- (void)doWeixinLogin{
    
    [self loginWithPlatformName:UMShareToWechatSession];
}

- (void)doWeiboLogin{
    
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
            // 保存友盟信息到本地
            [LPLoginTool saveAccountWithAccountEntity:accountEntity];
        
            NSMutableDictionary *params = [LPLoginTool registeredUserParamsWithAccountEntity:accountEntity];
            // 第三方注册
            NSString *url = @"http://bdp.deeporiginalx.com/v2/au/sin/s";
            [LPHttpTool postJSONResponseAuthorizationWithURL:url params:params success:^(id json, NSString *authorization) {
       
                [LPLoginTool saveRegisteredUserInfoAndSendConcernNotification:json authorization:authorization];
                if ([json[@"code"] integerValue] == 2000) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }  failure:^(NSError *error) {
                [MBProgressHUD showError:@"登录失败"];
            }];
            
        } else {
            [MBProgressHUD showError:@"登录失败"];
        }
    });
}

@end
NS_ASSUME_NONNULL_END