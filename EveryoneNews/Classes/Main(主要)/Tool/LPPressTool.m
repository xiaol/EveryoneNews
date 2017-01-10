//
//  LPPressTool.m
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPPressTool.h"
#import "LPWebViewController.h"
#import "LPHttpTool.h"


@implementation LPPressTool

+ (void)loadWebViewWithURL:(NSString *)url viewController:(UIViewController *)vc
{
    LPWebViewController *webVc = [[LPWebViewController alloc] init];
    webVc.webUrl = url;
    [vc.navigationController pushViewController:webVc animated:YES];
}

@end
