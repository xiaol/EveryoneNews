//
//  AppDelegate.h
//  EveryoneNews
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoreDataHelper;

extern NSString * const NetworkReachabilityDidChangeToReachableNotification;

extern NSString * const AppDidReceiveReviewUserDefaultKey;

extern NSString * const AppDidReceiveReviewNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) CoreDataHelper *coreDataHelper;

- (CoreDataHelper *)cdh;

// 加载仿网易新闻新版本，运行旧版本需要注释相应的方法

- (void)LoadHomeViewController;

@end

