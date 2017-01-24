//
//  LPWebViewController.m
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPWebViewController.h"
#import "MBProgressHUD+MJ.h"
#import <WebKit/WebKit.h>

@interface LPWebViewController () <WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation LPWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    if (iOS9) {
        webView.allowsLinkPreview = YES; 
    }
    webView.allowsBackForwardNavigationGestures = YES;
    webView.navigationDelegate = self;
    webView.backgroundColor = [UIColor whiteColor];
 

    NSString *encodedString = _webUrl;
    //加载URL需要进行encode，否则有些URL中的转义字符会不识别
  //   NSString *encodedString=[_webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]];
    [webView loadRequest:request];
    [self.view addSubview: webView];
    self.webView = webView;
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 34, 34)];
    backBtn.alpha = 0.8;
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    self.backBtn = backBtn;
    
    // 菊花
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = self.view.center;
    indicator.color = [UIColor lightGrayColor];
    [self.view addSubview:indicator];
    self.indicator = indicator;
}


#pragma mark - viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated {
    [self.webView stopLoading];
    [super viewWillDisappear:animated];
}

#pragma mark - Delegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
     [self.indicator startAnimating];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
     [self.indicator startAnimating];
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.indicator stopAnimating];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [self.indicator stopAnimating];
}

- (void)backBtnPress {
    [self.indicator stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
