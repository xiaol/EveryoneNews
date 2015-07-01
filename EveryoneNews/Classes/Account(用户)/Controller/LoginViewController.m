//
//  LoginViewController.m
//  EveryoneNews
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "UIImage+LP.h"


@interface LoginViewController ()
@property (nonatomic,strong) UIView *wrapperView;
@end

@implementation LoginViewController
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.footerBackgroundImage != nil) {
        UIImageView *footerBackgroundView=[[UIImageView alloc] initWithImage:self.footerBackgroundImage];
        footerBackgroundView.frame=CGRectMake(0, 0, self.footerBackgroundImage.size.width, self.footerBackgroundImage.size.height);
        [self.view addSubview:footerBackgroundView];

    }
    UIImageView *headerBackgroundView = [[UIImageView alloc] initWithImage:self.headerBackgroundImage];
    [self.view addSubview:headerBackgroundView];
    UIView *mask=[[UIView alloc] initWithFrame:self.view.bounds];
    mask.backgroundColor=[UIColor colorFromHexString:@"0000000" alpha:0.85];
    [self.view addSubview:mask];
    [self setupSubviews];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.8 animations:^{
        self.wrapperView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
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
    firstLabel.frame=CGRectMake((ScreenWidth-230.0 / 375 * ScreenWidth) * 0.5 , ScreenHeight * 0.3, 100, 20);
    firstLabel.textColor=[UIColor whiteColor];
    [viewWrapper addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc] init];
    secondLabel.text = @"与世界分享你的真知灼见";
    secondLabel.font = [UIFont systemFontOfSize:15.0];
    secondLabel.frame=CGRectMake((ScreenWidth-230.0 / 375 * ScreenWidth) * 0.5 , CGRectGetMaxY(firstLabel.frame) + 14, 200, 15);
    secondLabel.textColor=[UIColor whiteColor];
    [viewWrapper addSubview:secondLabel];
    
    //微博登录按钮
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 10, 15);
    weiboBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    weiboBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    weiboBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    weiboBtn.titleLabel.font=[UIFont systemFontOfSize:16.0];
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
    
    //添加关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(ScreenWidth * 0.5 - 13, CGRectGetMaxY(weixinBtn.frame)+ 24, 25, 25);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"ic_login_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
    [viewWrapper addSubview:closeBtn];
    viewWrapper.alpha = 0.5;

    
    
}
/**
 *  关闭当前的viewcontroller
 */
- (void)closeSelf
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)weiboLogin:(UIButton *)weiboBtn{
    [self closeSelf];
    [[[AccountTool alloc] init] accountLoginWithType:AccountTypeSinaWeibo completion:^(BOOL result) {
        if (result) {
             [[NSNotificationCenter defaultCenter] postNotificationName:AccountLoginNotification object:self userInfo:[NSDictionary dictionaryWithObject:@(result) forKey:AccountLoginCallbackDictKey]];
            [MBProgressHUD showSuccess:@"登录成功"];
        }else {
            [MBProgressHUD showError:@"登录失败"];
        }

    }];
     
}
- (void)weixinLogin:(UIButton *)weixinBtn{
    [self closeSelf];
    [[[AccountTool alloc] init] accountLoginWithType:AccountTypeWeiXin completion:^(BOOL result) {
        if (result) {
         [[NSNotificationCenter defaultCenter] postNotificationName:AccountLoginNotification object:self userInfo:[NSDictionary dictionaryWithObject:@(result) forKey:AccountLoginCallbackDictKey]];
            [MBProgressHUD showSuccess:@"登录成功"];
        }else {
            [MBProgressHUD showError:@"登录失败"];
        }
    }];
  
}

@end

