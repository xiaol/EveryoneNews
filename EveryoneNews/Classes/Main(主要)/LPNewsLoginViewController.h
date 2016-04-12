//
//  LPNewsLoginViewController.h
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsBaseViewController.h"
@class LPNewsLoginViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol  LPNewsLoginViewControllerDelegate <NSObject>
@optional
- (void)didCloseLoginView:(LPNewsLoginViewController *)loginView;
- (void)didWeixinLoginWithLoginView:(LPNewsLoginViewController *)loginView;
- (void)didSinaLoginWithLoginView:(LPNewsLoginViewController *)loginView;
@end


@interface LPNewsLoginViewController : LPNewsBaseViewController

@property (nonatomic, strong)id<LPNewsLoginViewControllerDelegate> delegate;

@end
NS_ASSUME_NONNULL_END