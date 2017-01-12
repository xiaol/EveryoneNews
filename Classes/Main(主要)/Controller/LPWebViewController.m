//
//  LPWebViewController.m
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPWebViewController.h"
#import "MBProgressHUD+MJ.h"

@interface LPWebViewController () <UIWebViewDelegate, UIScrollViewDelegate> {
     UIWebView *webView;
}


@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation LPWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor whiteColor];
    
    //加载URL需要进行encode，否则有些URL中的转义字符会不识别
    NSString *encodedString=[_webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 34, 34)];
    backBtn.alpha = 0.8;
    [backBtn setImage:[UIImage oddityImage:@"back.png"] forState:UIControlStateNormal];
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


- (void)viewWillDisappear:(BOOL)animated {
    [webView stopLoading];
    [super viewWillDisappear:animated];
}

- (void)backBtnPress {
    [self.indicator stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Web view delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //    [MBProgressHUD showMessage:@"正在加载..."];
    //    self.loadingView = [CustomLoaddingView showMessage:@"正在加载..." toView:webView];
    [self.indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    [MBProgressHUD hideHUD];
    //    [self.loadingView dismissMessage];
    [self.indicator stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //    [MBProgressHUD hideHUD];
    //    [self.loadingView dismissMessage];
    [self.indicator stopAnimating];
    //    [MBProgressHUD showError:@"加载失败：("];
}

@end
