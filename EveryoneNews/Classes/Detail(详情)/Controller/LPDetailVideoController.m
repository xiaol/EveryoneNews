//
//  LPDetailVideoController.m
//  EveryoneNews
//
//  Created by dongdan on 16/6/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPDetailVideoController.h"
#import "NSString+LP.h"
#import <WebKit/WebKit.h>

@implementation LPDetailVideoController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupSubView];
}
- (void)setupSubView {
    
    NSString *videoURL = [self.videoURL stringByTrimmingWhitespaceAndNewline];
    CGFloat w = ScreenWidth;
    CGFloat h = (3.0f * w) / 4;
    CGFloat x = 0;
    CGFloat y = (ScreenHeight - h) / 2;

    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.scrollView.scrollEnabled = NO;
    // 处理视频宽高
    NSArray *array = [videoURL componentsSeparatedByString:@";"];
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    for (NSString *str in array) {
        NSString *tempStr = [str copy];
        if ([tempStr containsString:@"width"]) {
            tempStr = [NSString stringWithFormat:@"width=%f&amp", w];
        } else if ([tempStr containsString:@"height"]) {
            tempStr = [NSString stringWithFormat:@"height=%f&amp", h];
        }
        if (tempStr.length > 0) {
            [mutableString appendString:[NSString stringWithFormat:@"%@;",tempStr]];
        }
    }
    
    NSURL *url =[NSURL URLWithString:mutableString];

    NSURLRequest *request =[NSURLRequest requestWithURL:url];

    
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}

@end
