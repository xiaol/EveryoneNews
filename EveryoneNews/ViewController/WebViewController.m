//
//  WebViewController.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "WebViewController.h"
#import "UIColor+HexToRGB.h"

@interface WebViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
    CGFloat screenW;
}

@end

@implementation WebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];

    NSLog(@"webUrl:%@", _webUrl);
    
    //加载URL需要进行encode，否则有些URL中的转义字符会不识别
    NSString *encodedString=[_webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    

    CGFloat btnY = [UIScreen mainScreen].bounds.size.height - 64;
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(22, btnY, 42, 42)];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];


}

#pragma mark backBtn
- (void)backBtnPress
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark webDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidFinishLoad");
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError   \n%@", error);
}



@end
