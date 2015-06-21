//
//  TransitioningObject.h
//  EveryoneNews
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 apple. All rights reserved.
// TransitioningObject 自定义的一个“Animator”

#import <Foundation/Foundation.h>

@class LPTabBarController;
@interface TransitioningObject : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) LPTabBarController *tabBarController;
@end
