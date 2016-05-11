//
//  TransitioningObject.m
//  EveryoneNews
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TransitioningObject.h"

@implementation TransitioningObject

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
}
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.7;
}
@end
