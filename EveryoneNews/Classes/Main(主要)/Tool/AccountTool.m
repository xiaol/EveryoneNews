//
//  AccountTool.m
//  EveryoneNews
//
//  Created by Feng on 15/6/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//  友盟登录

#import "AccountTool.h"
#import "MBProgressHUD.h"
#import "Account.h"
#import "MJExtension.h"
#import "LPHttpTool.h"
#import "UIImage+LP.h"
#import "AppDelegate.h"
#import "NSDate+Extension.h"
#import "UMSocialAccountManager.h"
#import "UMSocialDataService.h"
#import "MainNavigationController.h"
#import "UMSocialSnsPlatformManager.h"
#import "WXApi.h"


@interface LPLoginViewController : LPBaseViewController <UMSocialUIDelegate>

//tabbar的背景图
@property (nonatomic,strong) UIImage *headerBackgroundImage;
//非tabbar的背景图
@property (nonatomic,strong) UIImage *footerBackgroundImage;

@property (nonatomic,strong) UIView *wrapperView;

@property (nonatomic,strong) UIView *maskView;

@property (nonatomic, copy) LoginSuccessHandler successBlock;

@property (nonatomic, copy) LoginFailureHandler failureBlock;

@property (nonatomic, copy) LoginCancelHandler cancelBlock;

@end

@implementation LPLoginViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    MainNavigationController *nav = (MainNavigationController *)self.navigationController;
//    nav.popRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.footerBackgroundImage != nil) {
        UIImageView *footerBackgroundView = [[UIImageView alloc] initWithImage:self.footerBackgroundImage];
        footerBackgroundView.frame = CGRectMake(0, 0, self.footerBackgroundImage.size.width, self.footerBackgroundImage.size.height);
        [self.view addSubview:footerBackgroundView];
    }
    UIImageView *headerBackgroundView = [[UIImageView alloc] initWithImage:self.headerBackgroundImage];
    [self.view addSubview:headerBackgroundView];
    UIView *mask = [[UIView alloc] initWithFrame:self.view.bounds];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.75;
    [self.view addSubview:mask];
    self.maskView = mask;
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.6 animations:^{
        self.maskView.alpha = 0.85;
        self.wrapperView.alpha = 1.0;
    } completion:nil];
}
/**
 *  初始化和添加子views
 */
- (void)setupSubviews{
    UIView *viewWrapper = [[UIView alloc] init];
    [self.view addSubview:viewWrapper];
    self.wrapperView = viewWrapper;
    viewWrapper.frame = self.view.bounds;
    viewWrapper.backgroundColor = [UIColor clearColor];
    
    UILabel *firstLabel = [[UILabel alloc] init];
    firstLabel.text = @"加入百家";
    firstLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    firstLabel.frame = CGRectMake((ScreenWidth-230.0 / 375 * ScreenWidth) * 0.5 , ScreenHeight * 0.3, 100, 20);
    firstLabel.textColor = [UIColor whiteColor];
    [viewWrapper addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc] init];
    secondLabel.text = @"与世界分享你的真知灼见";
    secondLabel.font = [UIFont systemFontOfSize:15.0];
    secondLabel.frame = CGRectMake((ScreenWidth-230.0 / 375 * ScreenWidth) * 0.5 , CGRectGetMaxY(firstLabel.frame) + 14, 200, 15);
    secondLabel.textColor = [UIColor whiteColor];
    [viewWrapper addSubview:secondLabel];
    
    //微博登录按钮
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 10, 15);
    weiboBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    weiboBtn.imageView.contentMode = UIViewContentModeCenter;
    weiboBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    weiboBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    weiboBtn.frame = CGRectMake((ScreenWidth-230.0 / 375 * ScreenWidth) *0.5,CGRectGetMaxY(secondLabel.frame) + 30, 230.0 / 375 * ScreenWidth, 55.0 / 667 * ScreenHeight);
    weiboBtn.backgroundColor = [UIColor colorFromHexString:@"ff5d5d"];
    [weiboBtn setImage:[UIImage imageNamed:@"ic_login_weibo"] forState:UIControlStateNormal];
    [weiboBtn setImage:[UIImage imageNamed:@"ic_login_weibo"] forState:UIControlStateHighlighted];
    [weiboBtn setTitle:@"使用微博账号" forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(weiboLogin:) forControlEvents:UIControlEventTouchUpInside];
    [viewWrapper addSubview:weiboBtn];
    
    //微信登录按钮
    
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame=CGRectMake((ScreenWidth-230.0 / 375 * ScreenWidth) / 2, CGRectGetMaxY(weiboBtn.frame)+13, 230.0/375*ScreenWidth, 55.0/667*ScreenHeight);
    weixinBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 10, 15);
    weixinBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    weixinBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    weixinBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    weixinBtn.titleLabel.font=[UIFont systemFontOfSize:16.0];
    weixinBtn.backgroundColor = [UIColor colorFromHexString:@"00e17f"];
    [weixinBtn setImage:[UIImage imageNamed:@"ic_login_weixin"] forState:UIControlStateNormal];
    [weixinBtn setImage:[UIImage imageNamed:@"ic_login_weixin"] forState:UIControlStateHighlighted];
    [weixinBtn setTitle:@"使用微信账号" forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(weixinLogin:) forControlEvents:UIControlEventTouchUpInside];
    [viewWrapper addSubview:weixinBtn];
//    NSLog(@"is wechat installed %d, support %d", [WXApi isWXAppInstalled], [WXApi isWXAppSupportApi]);
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]) {
        weixinBtn.hidden = YES;
    } else {
        weixinBtn.hidden = NO;
    }
    
    //添加关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(ScreenWidth * 0.5 - 13, CGRectGetMaxY(weixinBtn.frame) + 24, 25, 25);
    if(weixinBtn.hidden == YES) {
        closeBtn.y = CGRectGetMaxY(weiboBtn.frame)+ 30;
    }
    closeBtn.enlargedEdge = 10;
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"ic_login_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [viewWrapper addSubview:closeBtn];
    viewWrapper.alpha = 0.5;
}

- (void)closeBtnClick {
    [self closeSelf];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

/**
 *  pop当前的viewcontroller
 */
- (void)closeSelf
{
//    [self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)loginWithPlatformName:(NSString *)type {
    UMSocialSnsPlatform *platform = [UMSocialSnsPlatformManager getSocialPlatformWithName:type];
    __weak typeof(self) wself = self;
    [self.wrapperView removeFromSuperview];
    [self.maskView removeFromSuperview];
    UMSocialControllerService *service = [UMSocialControllerService defaultControllerService];
    service.socialUIDelegate = self;
//    NSLog(@"service %@", service.socialUIDelegate)
    platform.loginClickHandler(self, service , YES ,^(UMSocialResponseEntity *response) {
//        NSLog(@"%@", [UMSocialControllerService defaultControllerService]);
        NSLog(@"responseCode is %d, type is %@", response.responseCode, type);
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
                [noteCenter postNotificationName:AccountLoginNotification object:wself];
                if (wself.successBlock) {
                    wself.successBlock(account);
                }
                [wself closeSelf];
            } failure:^(NSError *error) {
                if (wself.failureBlock) {
                    wself.failureBlock();
                }
                [wself closeSelf];
            }];
        } else {
            if (wself.failureBlock) {
                wself.failureBlock();
            }
            [wself closeSelf];
        }
    });
}

- (void)weiboLogin:(UIButton *)weiboBtn {
    [self loginWithPlatformName:UMShareToSina];
}

- (void)weixinLogin:(UIButton *)weixinBtn{
    [self loginWithPlatformName:UMShareToWechatSession];
}

- (void)dealloc {
    NSLog(@"loginVC dealloc !");
}

#pragma mark - UMSocialUIDelegate
//- (BOOL)closeOauthWebViewController:(UINavigationController *)navigationCtroller socialControllerService:(UMSocialControllerService *)socialControllerService {
//    return YES;
//}

- (void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType {
    [self closeSelf];
}

@end

@implementation AccountTool
singleton_m(AccountTool);

+ (void)accountLoginWithViewController:(UIViewController *)viewVc success:(LoginSuccessHandler)success failure:(LoginFailureHandler)failure cancel:(LoginCancelHandler)cancel {
    Account *account = [self account];
    if (account) {
        return;
    }
    LPLoginViewController *loginVc = [[LPLoginViewController alloc] init];
    loginVc.headerBackgroundImage = [UIImage captureWithView:viewVc.view];
    loginVc.successBlock = success;
    loginVc.failureBlock = failure;
    loginVc.cancelBlock = cancel;
    //    [viewVc.navigationController pushViewController:loginVc animated:NO];
    [viewVc presentViewController:loginVc animated:NO completion:nil];
}

+ (Account *)account{
    
    Account *account = [NSKeyedUnarchiver unarchiveObjectWithFile:kAccountSavePath];
//    if (account) {
//        //如果已经授权登录，则判断是否过期
//        if ([NSDate dateToMilliSeconds:[NSDate date]] > account.expiresTime.unsignedIntegerValue) {
//            return nil;
//        }
//    }
    return account;
}

+ (void)saveAccount:(Account *)account{
    [NSKeyedArchiver archiveRootObject:account toFile:kAccountSavePath];
}

+ (void)deleteAccount{
    //1.删除授权信息
//    Account *account=[self account];
    
//    [ShareSDK cancelAuthWithType:account.platformType.intValue];

    //2.删除本地信息文件
    NSFileManager *fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:kAccountSavePath error:nil];
}

@end
