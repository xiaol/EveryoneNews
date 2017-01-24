//
//  LPAdsDetailViewController.m
//  EveryoneNews
//
//  Created by dongdan on 2016/11/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPAdsDetailViewController.h"
#import <WebKit/WebKit.h>
#import "LPLoadingView.h"

@interface LPAdsDetailViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) LPLoadingView *loadingView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation LPAdsDetailViewController


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}


#pragma mark - setupSubviews
- (void)setupSubviews {
    
    self.view.backgroundColor = [UIColor colorFromHexString:LPColor9];
    // 导航栏
    double topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
    double padding = 15;
    
    double returnButtonWidth = 13;
    double returnButtonHeight = 22;
    
    if (iPhone6Plus) {
        returnButtonWidth = 12;
        returnButtonHeight = 21;
    }
    if (iPhone6) {
        topViewHeight = 72;
    }
    double returnButtonPaddingTop = (topViewHeight - returnButtonHeight + StatusBarHeight) / 2;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topViewHeight)];
    topView.backgroundColor = [UIColor colorFromHexString:@"#ffffff" alpha:0.0f];
    [self.view addSubview:topView];
    
    // 返回button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, returnButtonPaddingTop, returnButtonWidth, returnButtonHeight)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"消息中心返回"] forState:UIControlStateNormal];
    backButton.enlargedEdge = 15;
    [backButton addTarget:self action:@selector(topViewBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenWidth , 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor10];
    [self.view addSubview:seperatorView];
    
    
    CGFloat webViewY = CGRectGetMaxY(seperatorView.frame);
    CGFloat webViewH = ScreenHeight - webViewY;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, webViewY, ScreenWidth, webViewH)];
    webView.hidden = YES;
    webView.navigationDelegate = self;
    self.webView = webView;
    
    NSString *urlStr = [self.publishURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];    
    [self.view addSubview:webView];
    
    LPLoadingView *loadingView = [[LPLoadingView alloc] initWithFrame:CGRectMake(0, webViewY, ScreenWidth, webViewH /2.0f)];
    [self.view addSubview:loadingView];
  
    self.loadingView = loadingView;
}

#pragma mark - 返回上一级
- (void)topViewBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - NavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
     [self.loadingView startAnimating];
}

// 页面加载完成
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
 
    [self.loadingView stopAnimating];
    self.webView.hidden = NO;

}
//  页面加载失败
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.loadingView stopAnimating];
    NSURL *url = [NSURL URLWithString:(NSString *)error.userInfo[@"NSErrorFailingURLStringKey"]];
    if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication]openURL:url];
    }

}
 

@end
