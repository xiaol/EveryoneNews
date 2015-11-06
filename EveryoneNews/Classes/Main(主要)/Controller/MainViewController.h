//
//  HomeViewController.h
//  EveryoneNews
//
//  Created by Feng on 15/7/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPTabBar.h"
@class GenieTransition;

@interface MainViewController : LPBaseViewController
@property (nonatomic, strong) UIImageView *frontImageView;
@property (nonatomic, assign) BOOL shouldPush;
@property (nonatomic, strong) UIImage *userIcon;
@property (nonatomic, strong) GenieTransition *genieTransition;
@end


