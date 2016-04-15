//
//  LPNewsAppStoreCommentView.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsAppStoreCommentView.h"
#import "MBProgressHUD.h"

@interface LPNewsAppStoreCommentView(){

    UIWebView *webView;
}

@end


@implementation LPNewsAppStoreCommentView

#pragma mark- Initialize

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc{
    
}

#pragma mark-  ViewLife Cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setNavTitleView:@"App Store 评分"];
    [self backImageItem];
    [self addContentView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    if ([self.view window] == nil && [self isViewLoaded]) {
    }
}

#pragma mark- private methods
-(void)addContentView{
    if (webView == nil) {
        webView = [[UIWebView alloc] init];
    }
    [self.view addSubview:webView];
    webView.delegate = self;
    __weak __typeof(self)weakSelf = self;
    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.top.left.equalTo(strongSelf.view);
        make.size.equalTo(strongSelf.view);
    }];
    [self loadWebViewPage];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)loadWebViewPage{
    
    NSString *path = @"https://appsto.re/cn/Jiy26.i";
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

   return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
