//
//  NavigationPopAnimation.m
//  EveryoneNews
//
//  Created by apple on 15/10/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NavigationPopAnimation.h"

@implementation NavigationPopAnimation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toVc.view belowSubview:fromVc.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVc.view.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
@end
