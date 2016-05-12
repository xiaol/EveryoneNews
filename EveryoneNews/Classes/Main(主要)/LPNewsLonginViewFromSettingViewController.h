//
//  LPNewsLonginViewFromSettingViewController.h
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsBaseViewController.h"

@class LPNewsLonginViewFromSettingViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol  LPNewsLonginViewFromSettingViewController <NSObject>
@optional
- (void)didCloseLoginView:(LPNewsLonginViewFromSettingViewController *)loginView;
- (void)didWeixinLoginWithLoginView:(LPNewsLonginViewFromSettingViewController *)loginView;
- (void)didSinaLoginWithLoginView:(LPNewsLonginViewFromSettingViewController *)loginView;
@end


@interface LPNewsLonginViewFromSettingViewController : LPNewsBaseViewController

@property (nonatomic, strong)id<LPNewsLonginViewFromSettingViewController> delegate;

@end
NS_ASSUME_NONNULL_END