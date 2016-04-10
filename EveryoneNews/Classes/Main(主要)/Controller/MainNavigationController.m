//
//  HomeNavigationController.m
//  EveryoneNews
//
//  Created by Feng on 15/7/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MainNavigationController.h"
#import "NavigationInteractiveTransition.h"
#import <objc/runtime.h>

@interface MainNavigationController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NavigationInteractiveTransition *navTransition;
@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    
    // built-in pop recognizer
    UIGestureRecognizer *recognizer = self.interactivePopGestureRecognizer;
    recognizer.enabled = NO;
    UIView *gestureView = recognizer.view;
    
    // pop recognizer
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:popRecognizer];
    self.popRecognizer = popRecognizer;
    
    // taget-action reflect
    NSMutableArray *actionTargets = [recognizer valueForKey:@"_targets"];
    id actionTarget = [actionTargets firstObject];
    id target = [actionTarget valueForKey:@"_target"];
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    [popRecognizer addTarget:target action:action];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    return self.viewControllers.count > 1 && ![[self valueForKey:@"_isTransitioning"] boolValue] && [gestureRecognizer translationInView:gestureRecognizer.view].x > 0;
}


@end
