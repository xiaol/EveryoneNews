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

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.navigationBar.hidden = YES;
//    
//    UIGestureRecognizer *recognizer = self.interactivePopGestureRecognizer;
//    recognizer.enabled = NO;
//    UIView *view = recognizer.view;
//    
//    _popRecognizer = [[UIPanGestureRecognizer alloc] init];
//    _popRecognizer.delegate = self;
//    _popRecognizer.minimumNumberOfTouches = 1;
//    [view addGestureRecognizer:_popRecognizer];
//    
//    _navTransition = [[NavigationInteractiveTransition alloc] initWithVc:self];
//    [_popRecognizer addTarget:_navTransition action:@selector(handlePop:)];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    
    // built-in pop recognizer
    UIGestureRecognizer *recognizer = self.interactivePopGestureRecognizer;
//    Class recognizerClass = [recognizer class];
//    NSLog(@"interactivePopGestureRecognizer class: %@", NSStringFromClass(recognizerClass));
//    NSLog(@"interactivePopGestureRecognizer super class: %@", NSStringFromClass([recognizer superclass]));
//    unsigned int propertyCount;
//    objc_property_t *properties = class_copyPropertyList(recognizerClass, &propertyCount);
//    for (int i = 0; i < propertyCount; i++) {
//        objc_property_t property = properties[i];
//        NSLog(@"property[%d] name: %@", i, [[NSString alloc] initWithCString:property_getName(property)encoding:NSUTF8StringEncoding]);
//    }
    recognizer.enabled = NO;
    UIView *gestureView = recognizer.view;
    
//    unsigned int count;
//    Ivar *ivars = class_copyIvarList([UIGestureRecognizer class], &count);
//    for (int i = 0; i < count; i++) {
//        Ivar ivar = *(ivars + i);
//        NSLog(@"ivar type --- %s", ivar_getTypeEncoding(ivar));
//        NSLog(@"ivar name --- %s", ivar_getName(ivar));
//    }
//
//    NSMutableArray *action_targets = [self.interactivePopGestureRecognizer valueForKey:@"_targets"];
//    for (int i = 0; i < action_targets.count; i++) {
//        NSLog(@"%@", action_targets[i]);
//    }
//
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
