//
//  LPNewsPrivacyItemsController.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsPrivacyItemsController.h"
#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPNewsPrivacyItemsController()<UIWebViewDelegate>
@end

@implementation LPNewsPrivacyItemsController

#pragma mark-  ViewLife Cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithDesignIndex:9];
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text = @"隐私政策";
    titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
    titleLabel.font = [UIFont  boldSystemFontOfSize:LPFont8];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerX = topView.centerX;
    titleLabel.centerY = backButton.centerY;
    [topView addSubview:titleLabel];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) , ScreenWidth , 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor10];
    [self.view addSubview:seperatorView];
 
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Privacy" ofType:@"html"];
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path relativeToURL:baseURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.f];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) + 0.5, ScreenWidth, ScreenHeight - topViewHeight)];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

- (void)topViewBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}


//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//}
//
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//}
//
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//
//}
//
//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//}
//
//- (void)didReceiveMemoryWarning{
//    [super didReceiveMemoryWarning];
//    if ([self.view window] == nil && [self isViewLoaded]) {
//    }
//}

//#pragma mark- private methods
//-(void)addAboutWebView{
//    if (webView == nil) {
//        webView = [[UIWebView alloc] init];
//    }
//    [self.view addSubview:webView];
//    webView.delegate = self;
//    __weak __typeof(self)weakSelf = self;
//    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        make.top.left.equalTo(strongSelf.view);
//        make.size.equalTo(strongSelf.view);
//    }];
//    [self loadWebViewPage];
//}
//
//- (void)loadWebViewPage{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Privacy" ofType:@"html"];
//    NSString *basePath = [[NSBundle mainBundle] bundlePath];
//    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path relativeToURL:baseURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.f];
//    [webView loadRequest:request];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//}
//
#pragma mark- UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}
//
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//}

@end

NS_ASSUME_NONNULL_END