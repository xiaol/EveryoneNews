//
//  LPNewsNavigationController.h
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPNewsNavigationController : UINavigationController

@property (readonly, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *popRecognizer;

- (instancetype)initWithRootViewControllerInOtherPopStyle:(UIViewController *)rootViewController;

@end


@protocol JoyPanBackProtocol <NSObject>
- (BOOL)enablePanBack:(LPNewsNavigationController *)panNavigationController;
- (void)startPanBack:(LPNewsNavigationController *)panNavigationController;
- (void)finshPanBack:(LPNewsNavigationController *)panNavigationController;
- (void)resetPanBack:(LPNewsNavigationController *)panNavigationController;
@end

NS_ASSUME_NONNULL_END