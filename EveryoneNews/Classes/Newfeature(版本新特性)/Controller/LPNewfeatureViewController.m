//
//  LPNewfeatureViewController.m
//  EveryoneNews
//
//  Created by apple on 15/6/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <ImageIO/ImageIO.h>

#import "LPNewfeatureViewController.h"
#import "MainNavigationController.h"
#import "MainViewController.h"
#import "AccountTool.h"
#import "LPTagCloudView.h"
//#import <ShareSDK/ShareSDK.h>
#import "LPHttpTool.h"
#import "Account.h"
#import "NSDate+Extension.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "LPTagCloudView.h"

//#import "LaunchViewController.h"

#define GIFHeight 337
#define GIFWidth 222
#define PageCount 3

@interface LPNewfeatureViewController () <UIScrollViewDelegate, LPTagCloudViewDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MainViewController *mainVc;
@property (nonatomic, strong) MainNavigationController *nav;
@property (nonatomic, strong) LPTagCloudView *tagCloudView;
@end

@implementation LPNewfeatureViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupGif];
//    [self setupScrollView];
//    [self setupPageControl];
//    [self setupCancelBtn];
    
    // 1. bgview & logo
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    NSString *bgImgName = @"";
    if (iPhone4) {
        bgImgName = @"引导页背景图iphone4";
    } else if (iPhone5) {
        bgImgName = @"引导页背景图iphone5";
    } else {
        bgImgName = @"引导页背景";
    }
    bgView.image = [UIImage imageNamed:bgImgName];
    [self.view addSubview:bgView];
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.y = 30;
    if (iPhone6Plus) {
        logoView.y = 32;
    }
    NSString *logoName = @"";
    if (iPhone4 || iPhone5) {
        logoName = @"引导页上logo_iphone4";
    } else {
        logoName = @"引导页上logo";
    }
    UIImage *logoImg = [UIImage imageNamed:logoName];
    logoView.image = logoImg;
    CGSize logoSize = logoImg.size;
    logoView.width = logoSize.width;
    logoView.height = logoSize.height;
    logoView.x = (ScreenWidth - logoView.width) / 2;
    [self.view addSubview:logoView];
    
    // 2. scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.contentSize = CGSizeMake(ScreenWidth * PageCount, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    for (int i = 0; i < PageCount; i++) {
        UIImageView *contentImageView = [[UIImageView alloc] init];
        contentImageView.width = ScreenWidth;
        contentImageView.height = ScreenHeight;
        contentImageView.x = i * ScreenWidth;
        contentImageView.y = 0;
        NSString *name = nil;
        if (iPhone4) {
            name = [NSString stringWithFormat:@"4_%d", i + 1];
        }
        if (iPhone5) {
            name = [NSString stringWithFormat:@"5_%d", i + 1];
        }
        if (iPhone6) {
            name = [NSString stringWithFormat:@"6_%d", i + 1];
        }
        if (iPhone6Plus) {
            name = [NSString stringWithFormat:@"6plus_%d", i + 1];
        }
        contentImageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:contentImageView];
    }
    
    // 3. buttons
    UIButton *loginBtn = [[UIButton alloc] init];
    UIButton *startBtn = [[UIButton alloc] init];
    CGFloat pageControlPadding = 0;
    [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startBtn setTitle:@"随便看看" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"微博登录" forState:UIControlStateNormal];
    [scrollView addSubview:loginBtn];
    [scrollView addSubview:startBtn];
    if (iPhone6 || iPhone6Plus) {
        [loginBtn setBackgroundImage:[UIImage resizableImage:@"引导页背景框"] forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[UIImage resizableImage:@"引导页背景框"] forState:UIControlStateNormal];
        loginBtn.height = 44;
        startBtn.height = 44;
    } else {
        [loginBtn setBackgroundImage:[UIImage resizableImage:@"引导页背景框5"] forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[UIImage resizableImage:@"引导页背景框5"] forState:UIControlStateNormal];
        loginBtn.height = 36;
        startBtn.height = 36;
    }
    if (iPhone6Plus) {
        loginBtn.y = ScreenHeight - loginBtn.height - 80;
        loginBtn.x = 34 + ScreenWidth * (PageCount - 1);
        loginBtn.width = (ScreenWidth - 3 * 34) / 2;
        startBtn.x = CGRectGetMaxX(loginBtn.frame) + 34;
        pageControlPadding = 50;
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    } else if (iPhone6) {
        pageControlPadding = 46;
        loginBtn.y = ScreenHeight - loginBtn.height - 70;
        loginBtn.x = 30 + ScreenWidth * (PageCount - 1);
        loginBtn.width = (ScreenWidth - 3 * 30) / 2;
        startBtn.x = CGRectGetMaxX(loginBtn.frame) + 30;
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    } else {
        pageControlPadding = 25;
        loginBtn.y = ScreenHeight - loginBtn.height - 40;
        loginBtn.x = 30 + ScreenWidth * (PageCount - 1);
        loginBtn.width = (ScreenWidth - 3 * 30) / 2;
        startBtn.x = CGRectGetMaxX(loginBtn.frame) + 30;
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        if (iPhone5) {
            loginBtn.y = ScreenHeight - loginBtn.height - 45;
            pageControlPadding = 45;
        }
    }
    startBtn.width = loginBtn.width;
    startBtn.y = loginBtn.y;
    
    
    // 4. page control
    CGFloat pageControlY = CGRectGetMinY(loginBtn.frame) - pageControlPadding;
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = PageCount;
    pageControl.centerX = ScreenWidth * 0.5;
    pageControl.centerY = pageControlY;
    [self.view addSubview:pageControl];
    
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = LPColor(150, 150, 150);
    self.pageControl = pageControl;
    
    MainViewController *mainVc = [[MainViewController alloc] init];
    MainNavigationController *mainNavVc = [[MainNavigationController alloc] initWithRootViewController:mainVc];
    self.mainVc = mainVc;
    self.nav = mainNavVc;
}

//- (void)setupCancelBtn
//{
//    CGFloat padding = 20;
//    UIButton *cancelBtn = [[UIButton alloc] init];
//    [self.view insertSubview:cancelBtn aboveSubview:self.scrollView];
//    cancelBtn.width = 25;
//    cancelBtn.height = 25;
//    if (iPhone6Plus) {
//        cancelBtn.width = 40;
//        cancelBtn.height = 40;
//    }
//    cancelBtn.x = ScreenWidth - padding - cancelBtn.width;
//    cancelBtn.y =  padding;
//    [cancelBtn setImage:[UIImage imageNamed:@"跳过"] forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
//}

- (void)startBtnClick
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    LaunchViewController *launchVc = [[LaunchViewController alloc] init];
    window.rootViewController = self.nav;
}

//- (void)loginBtnClick {
//    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//        if(result){
//            //0. 登录成功,存储用户信息到本地
//            id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];//平台类型
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            dict[@"userId"] = userInfo.uid;
//            dict[@"userGender"] = @(userInfo.gender);
//            dict[@"userName"] = userInfo.nickname;
//            dict[@"userIcon"] = userInfo.profileImage;
//            dict[@"platformType"] = @(userInfo.type);
//            dict[@"deviceType"] = @"ios";
//            dict[@"token"] = credential.token;
//            dict[@"expiresTime"] = @([NSDate dateToMilliSeconds:credential.expired]);
//            Account *account = [Account objectWithKeyValues:dict];
//            
//            // 1. 获取标签云
//            NSMutableDictionary *params = [NSMutableDictionary dictionary];
//            params[@"userId"] = account.userId;
//            params[@"token"] = account.token;
//            params[@"platformType"] = @(AccountTypeSinaWeibo);
//            NSString *url = [NSString stringWithFormat:@"%@/news/baijia/fetchTags", ServerUrl];
//            [LPHttpTool getWithURL:url params:params success:^(id json) {
//                NSArray *tags = json[@"tags"];
//                if (tags && tags.count) {
//                    LPTagCloudView *tagCloudView = [[LPTagCloudView alloc] init];
//                    tagCloudView.delegate = self;
//                    tagCloudView.alpha = 0;
//                    [self.view addSubview:tagCloudView];
//                    [self.view bringSubviewToFront:tagCloudView];
//                    tagCloudView.frame = self.view.bounds;
//                    tagCloudView.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:1.0];
//                    tagCloudView.pageCapacity = 8;
//                    tagCloudView.tags = tags;
//                    
//                    [UIView animateWithDuration:0.5 animations:^{
//                        tagCloudView.alpha = 1.0;
//                    } completion:^(BOOL finished) {
//                    }];
//                } else {
//                    [MBProgressHUD showSuccess:@"登录成功, 您没有标签~"];
//                    [self startBtnClick];
//                }
//            } failure:^(NSError *error) {
//                [MBProgressHUD showError:@"获取标签失败"];
//            }];
//            
//            // 2. 用户头像
//            UIImageView *imageView = [[UIImageView alloc] init];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:[AccountTool account].userIcon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                UIImage *icon = [UIImage circleImageWithImage:imageView.image];
//                self.mainVc.userIcon = icon;
//            }];
//
//            //3. 将用户信息传到服务器
//            NSDictionary *param = [NSDictionary dictionary];
//            param = account.keyValues;
//            [LPHttpTool getWithURL:AccountLoginUrl params:param success:^(id json) {
//                [AccountTool saveAccount:account];
//            } failure:^(NSError *error) {
//            }];
//            
//        }else{
//            [MBProgressHUD showError:@"登录失败"];
//        }
//    }];
//}

#pragma mark - scroll view delegate
- (void)tagCloudViewDidClickStartButton:(LPTagCloudView *)tagCloudView {
    [self startBtnClick];
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.width + 0.5;
    self.pageControl.currentPage = page;
}
@end
