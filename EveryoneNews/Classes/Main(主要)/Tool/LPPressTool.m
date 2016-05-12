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
#import "LPCategory.h"

@implementation LPPressTool

+ (void)homePressesWithCategory:(LPCategory *)category success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [LPHttpTool getWithURL:category.url params:nil success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)loadWebViewWithURL:(NSString *)url viewController:(UIViewController *)vc
{
    LPWebViewController *webVc = [[LPWebViewController alloc] init];
    webVc.webUrl = url;
    [vc.navigationController pushViewController:webVc animated:YES];
}

@end
