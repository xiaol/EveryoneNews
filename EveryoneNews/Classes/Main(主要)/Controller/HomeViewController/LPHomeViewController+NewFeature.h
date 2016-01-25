//
//  LPHomeViewController+NewFeature.h
//  EveryoneNews
//
//  Created by dongdan on 16/1/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPHomeViewController.h"

@interface LPHomeViewController (NewFeature)<UIGestureRecognizerDelegate, UIScrollViewDelegate>

/**
 *  应用首次安装时候新特性
 */
- (void)setupNewFeatureView;

@end
