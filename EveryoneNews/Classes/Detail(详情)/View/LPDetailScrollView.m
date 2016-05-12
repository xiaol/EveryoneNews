//
//  LPDetailScrollView.m
//  EveryoneNews
//
//  Created by dongdan on 16/5/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPDetailScrollView.h"

@interface LPDetailScrollView () <UIGestureRecognizerDelegate>

@end

@implementation LPDetailScrollView


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 首先判断otherGestureRecognizer是不是系统pop手势
    
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            
            return YES;
        }
    }
    return NO;
}


@end
