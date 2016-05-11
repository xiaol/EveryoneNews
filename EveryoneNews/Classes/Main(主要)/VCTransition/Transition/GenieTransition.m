//
//  GenieTransition.m
//  EveryoneNews
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GenieTransition.h"
#import "GenieAnimation.h"

@interface GenieTransition ()
@property (nonatomic, weak) UIViewController *vc;
//@property (nonatomic, strong) GenieAnimation *animator;
@end

@implementation GenieTransition
//- (instancetype)initWithToViewController:(UIViewController *)toVc {
//    self = [super init];
//    if (self) {
//        toVc.transitioningDelegate = self;
//        toVc.modalPresentationStyle = UIModalPresentationCustom;
//        _animator = [[GenieAnimation alloc] init];
//    }
//    return self;
//}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
//    self.animator.type = ModalTypePresent;
//    return self.animator;
    return [GenieAnimation new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    self.animator.type = ModalTypeDismiss;
//    return self.animator;
    return [GenieAnimation new];
}

- (void)dealloc {
    NSLog(@"transition dealloc!");
}

@end
