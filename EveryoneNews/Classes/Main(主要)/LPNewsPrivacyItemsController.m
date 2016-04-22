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

@interface LPNewsPrivacyItemsController()<UIWebViewDelegate>{
    UIWebView *webView;
}

@end

@implementation LPNewsPrivacyItemsController



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
    [self setNavTitleView:@"隐私政策"];
    
    [self backImageItem];
    [self addAboutWebView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationItem.hidesBackButton = YES;
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
-(void)addAboutWebView{
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
}

- (void)loadWebViewPage{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Privacy" ofType:@"html"];
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path relativeToURL:baseURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.f];
    [webView loadRequest:request];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark- UIWebViewDelegate

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

NS_ASSUME_NONNULL_END