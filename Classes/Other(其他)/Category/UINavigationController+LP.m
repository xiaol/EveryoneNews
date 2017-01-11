//
//  UINavigationController+LP.m
//  EveryoneNews
//
//  Created by dongdan on 16/1/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UINavigationController+LP.h"

@implementation UINavigationController (LP)

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
    
}

@end
