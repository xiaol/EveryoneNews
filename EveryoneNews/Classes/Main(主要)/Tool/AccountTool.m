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

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubViews];

    
    
    
    
//    if (self.footerBackgroundImage != nil) {
//        UIImageView *footerBackgroundView = [[UIImageView alloc] initWithImage:self.footerBackgroundImage];
//        footerBackgroundView.frame = CGRectMake(0, 0, self.footerBackgroundImage.size.width, self.footerBackgroundImage.size.height);
//        [self.view addSubview:footerBackgroundView];
//    }
//    UIImageView *headerBackgroundView = [[UIImageView alloc] initWithImage:self.headerBackgroundImage];
//    [self.view addSubview:headerBackgroundView];
//    UIView *mask = [[UIView alloc] initWithFrame:self.view.bounds];
//    mask.backgroundColor = [UIColor blackColor];
//    mask.alpha = 0.75;
//    [self.view addSubview:mask];
//    self.maskView = mask;
//    [self setupSubviews];
}

- (void)setupSubViews {
    CGFloat labelPaddingTop = 150;
    if (iPhone6Plus) {
        labelPaddingTop = 171;
    }
    CGFloat firstLabelHeight = [@"您好" heightForLineWithFont:[UIFont systemFontOfSize:20]];
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelPaddingTop, ScreenWidth, firstLabelHeight)];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.font = [UIFont systemFontOfSize:20];
    firstLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
    firstLabel.text = @"智能推荐您喜欢的文章";
    [self.view addSubview: firstLabel];
    
    
    CGFloat secondLabelHeight = [@"您好" heightForLineWithFont:[UIFont systemFontOfSize:16]];
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstLabel.frame) + 16, ScreenWidth, secondLabelHeight)];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.font = [UIFont systemFontOfSize:16];
    secondLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
    secondLabel.text = @"只需一键登录";
    [self.view addSubview: secondLabel];
    
    CGFloat casualLookButtonHeight = [@"您好" heightForLineWithFont:[UIFont systemFontOfSize:18]];
    UIButton *casualLookButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(secondLabel.frame) + 32, ScreenWidth, casualLookButtonHeight)];
    [casualLookButton setEnlargedEdgeWithTop:20 left:0 bottom:20 right:0];
    [casualLookButton setTitle:@"先随便看看 >" forState:UIControlStateNormal];
    [casualLookButton setTitleColor:[UIColor colorFromHexString:@"#999999"] forState:UIControlStateNormal];
    [casualLookButton addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: casualLookButton];
    
    
    CGFloat weixingPaddingLeft = 60;
    if (iPhone6Plus) {
        weixingPaddingLeft = 74;
    }
    
    UIButton *weixinBtn = [[UIButton alloc] init];
    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"微信登录"] forState:UIControlStateNormal];
    weixinBtn.frame = CGRectMake(weixingPaddingLeft, CGRectGetMaxY(casualLookButton.frame) + 113, 75, 75);
    [weixinBtn addTarget:self action:@selector(weixinLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinBtn];
    
    CGFloat weixinLabelHeight = [@"您好" heightForLineWithFont:[UIFont systemFontOfSize:14]];
    UILabel *weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(weixingPaddingLeft, CGRectGetMaxY(weixinBtn.frame) + 12 , 75, weixinLabelHeight)];
    weixinLabel.textAlignment = NSTextAlignmentCenter;
    weixinLabel.text = @"微信登录";
    weixinLabel.font = [UIFont systemFontOfSize:14];
    weixinLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
    [self.view addSubview:weixinLabel];
    
    
    UIButton *weiboBtn = [[UIButton alloc] init];
    [weiboBtn setBackgroundImage:[UIImage imageNamed:@"微博登录"] forState:UIControlStateNormal];
    weiboBtn.frame = CGRectMake(ScreenWidth - weixingPaddingLeft - 75,CGRectGetMaxY(casualLookButton.frame) + 113, 75, 75);
    [weiboBtn addTarget:self action:@selector(weiboLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboBtn];
    
    UILabel *weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - weixingPaddingLeft - 75, CGRectGetMaxY(weixinBtn.frame) + 12 , 75, weixinLabelHeight)];
    weiboLabel.text = @"微博登录";
    weiboLabel.font = [UIFont systemFontOfSize:14];
    weiboLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
    weiboLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:weiboLabel];
}

#pragma mark - 显示状态栏
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - 随便看看
- (void)closeBtnClick {
    [self closeSelf];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}


- (void)closeSelf {
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - 微信登录
- (void)weixinLogin:(UIButton *)weixinBtn {
    [self loginWithPlatformName:UMShareToWechatSession];
}


#pragma mark - 微博登录
- (void)weiboLogin:(UIButton *)weiboBtn {
    [self loginWithPlatformName:UMShareToSina];
}

#pragma mark - 登录微信微博平台
- (void)loginWithPlatformName:(NSString *)type {
    
    UMSocialSnsPlatform *platform = [UMSocialSnsPlatformManager getSocialPlatformWithName:type];
    __weak typeof(self) wself = self;
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


#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"loginVC dealloc !");
}

//#pragma mark - UMSocialUIDelegate
////- (BOOL)closeOauthWebViewController:(UINavigationController *)navigationCtroller socialControllerService:(UMSocialControllerService *)socialControllerService {
////    return YES;
////}
//
//- (void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType {
//    [self closeSelf];
//}

@end

@implementation AccountTool
singleton_m(AccountTool);

+ (void)accountLoginWithViewController:(UIViewController *)viewVc success:(LoginSuccessHandler)success failure:(LoginFailureHandler)failure cancel:(LoginCancelHandler)cancel {
    Account *account = [self account];
    if (account) {
        return;
    }
    LPLoginViewController *loginVc = [[LPLoginViewController alloc] init];
    loginVc.successBlock = success;
    loginVc.failureBlock = failure;
    loginVc.cancelBlock = cancel;
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
