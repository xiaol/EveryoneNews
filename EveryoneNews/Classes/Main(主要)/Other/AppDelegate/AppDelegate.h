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

@property (nonatomic, assign) BOOL isLaunchedByNotification;

- (CoreDataHelper *)cdh;

@end

