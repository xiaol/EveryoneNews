//
//  Configured.h
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#ifndef Configured_h
#define Configured_h

#import "UIColor+Additions.h"
#import "UIImage+Additions.h"
#import "LPNewsAssistant.h"
#import "AppDelegate.h"
#import <Masonry.h>

#define Screeen_3_5_INCH ([[UIScreen mainScreen] bounds].size.height == 480)

#define kMainScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kMainScreenHeight   [[UIScreen mainScreen] bounds].size.height

#define kApplecationScreenWidth [[UIScreen mainScreen] applicationFrame].size.width
#define kApplecationScreenHeight [[UIScreen mainScreen] applicationFrame].size.height

#define kNavTextColor   [UIColor blackColor]

static const CGFloat kNavigationBarHEIGHT = 44.f;

typedef NS_ENUM(NSUInteger, NavItemPosition) {
    NavLeftItem = 0,
    NavRightItem,
    NavTitleView,
};


#pragma mark - CG_INLINE

CG_INLINE CGRect

CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)

{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    CGRect rect;
    rect.origin.x = x * myDelegate.autoSizeScaleX; rect.origin.y = y * myDelegate.autoSizeScaleY;
    rect.size.width = width * myDelegate.autoSizeScaleX; rect.size.height = height * myDelegate.autoSizeScaleY;
    
    return rect;
}

CG_INLINE CGSize

CGSizeMake1(CGFloat width, CGFloat height)
{
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    CGSize size;
    size.width = width * myDelegate.autoSizeScaleX; size.height = height * myDelegate.autoSizeScaleY;
    
    return size;
}







#endif /* Configured_h */
