//
//  LPPressTool.h
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPCategory;

@interface LPPressTool : NSObject

+ (void)homePressesWithCategory:(LPCategory *)category success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (void)loadWebViewWithURL:(NSString *)url viewController:(UIViewController *)vc;
@end
