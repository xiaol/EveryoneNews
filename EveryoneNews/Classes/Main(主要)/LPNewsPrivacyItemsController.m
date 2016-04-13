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

@interface LPNewsPrivacyItemsController(){
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
    [self setNavTitleView:@"使用政策"];
    [self backImageItem];
    [self addAboutWebView];
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
-(void)addAboutWebView{
    [self.view addSubview:webView];
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
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Privacy" ofType:@"html"];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    NSString *basePath = [[NSBundle mainBundle] bundlePath];
//    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path relativeToURL:baseURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.f];
    [webView loadRequest:request];
}

#pragma mark- UIWebViewDelegate

- (void)webViewDidStartLoad:(nonnull UIWebView *)webView{
//    [super webViewDidStartLoad:webView];
}

- (void)webViewDidFinishLoad:(nonnull UIWebView *)webView{
//    [super webViewDidFinishLoad:webView];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webView:(nonnull UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
//    [super webView:webView didFailLoadWithError:error];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


@end

NS_ASSUME_NONNULL_END