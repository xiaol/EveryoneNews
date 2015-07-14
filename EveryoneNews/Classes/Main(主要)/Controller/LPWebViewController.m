//
//  LPWebViewController.m
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPWebViewController.h"
#import "MBProgressHUD+MJ.h"
//#import "CustomLoaddingView.h"

@interface LPWebViewController () <UIWebViewDelegate>
{
    UIWebView *webView;
}
//@property (nonatomic, strong) CustomLoaddingView *loadingView;
@end

@implementation LPWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor whiteColor];
        
    //加载URL需要进行encode，否则有些URL中的转义字符会不识别
    NSString *encodedString=[_webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
    
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(22, 44, 35, 35)];
    backBtn.alpha = 0.8;
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    // 菊花
    sharedIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    sharedIndicator.center = self.view.center;
    sharedIndicator.color = [UIColor lightGrayColor];
    [self.view addSubview:sharedIndicator];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)backBtnPress
{
    [sharedIndicator stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Web view delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    [MBProgressHUD showMessage:@"正在加载..."];
//    self.loadingView = [CustomLoaddingView showMessage:@"正在加载..." toView:webView];
    [sharedIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [MBProgressHUD hideHUD];
//    [self.loadingView dismissMessage];
    [sharedIndicator stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [MBProgressHUD hideHUD];
//    [self.loadingView dismissMessage];
    [sharedIndicator stopAnimating];
    [MBProgressHUD showError:@"加载失败：("];
}
@end
