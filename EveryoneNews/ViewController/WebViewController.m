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
    
    screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat topViewH = 44;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, topViewH)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [self drawDetailsInTopView:topView];

    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, topViewH, screenW, [UIScreen mainScreen].bounds.size.height - topViewH)];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];

    NSLog(@"webUrl:%@", _webUrl);
    
    //加载URL需要进行encode，否则有些URL中的转义字符会不识别
    NSString *encodedString=[_webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
    CGFloat bottonH = 40;
    CGFloat bottonY = [UIScreen mainScreen].bounds.size.height - bottonH;
    UIView *bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, bottonY, screenW, bottonH)];
    bottonView.backgroundColor = [UIColor colorFromHexString:@"#fafafa"];
    [self drawDetailsInBottonView:bottonView];
    [self.view addSubview:bottonView];

}

- (void)drawDetailsInTopView:(UIView *)topView
{
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23 + 20, 27 + 20)];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"webBack.png"] forState:UIControlStateNormal];
    [topView addSubview:backBtn];
    
    CGFloat titleX = CGRectGetMaxX(backBtn.frame) + 10;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(titleX, 17, screenW - 36 - titleX, 13)];
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.textColor = [UIColor colorFromHexString:kGreen];
    titleLab.text = _webUrl;
    [topView addSubview:titleLab];
    
    CGFloat cutlineY = CGRectGetMaxY(topView.frame) - 1;
    UIView *cutline = [[UIView alloc] initWithFrame:CGRectMake(0, cutlineY, screenW, 1)];
    cutline.backgroundColor = [UIColor colorFromHexString:@"#d6d6d6"];
    [topView addSubview:cutline];
}

- (void)drawDetailsInBottonView:(UIView *)bottonView
{
    CGFloat oneThird = screenW / 3;
    CGFloat height = 10;
    UIButton *likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(oneThird / 4, height, 21, 20)];
    likeBtn.backgroundColor = [UIColor clearColor];
    [likeBtn setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    [bottonView addSubview:likeBtn];
    
    CGFloat likeTitleX = CGRectGetMaxX(likeBtn.frame) + 5;
    UILabel *likeTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(likeTitleX, height + 2, oneThird / 2, 20)];
    likeTitleLab.text = @"9527";
    likeTitleLab.textColor = [UIColor colorFromHexString:kGreen];
    likeTitleLab.font = [UIFont systemFontOfSize:16];
    [bottonView addSubview:likeTitleLab];
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
