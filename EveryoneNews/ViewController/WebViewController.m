//
//  WebViewController.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
    UIWebView *webView;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
