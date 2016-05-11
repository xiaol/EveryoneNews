//
//  NavigationInteractiveTransition.h
//  EveryoneNews
//
//  Created by apple on 15/10/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController, UIPercentDrivenInteractiveTransition;
@interface NavigationInteractiveTransition : NSObject <UINavigationControllerDelegate>
- (instancetype)initWithVc:(UIViewController *)vc;
- (void)handlePop:(UIPanGestureRecognizer *)recognizer;
- (UIPercentDrivenInteractiveTransition *)interactivePopTransition;
@end
