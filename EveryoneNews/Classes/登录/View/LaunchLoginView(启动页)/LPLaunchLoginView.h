//
//  LPFirstInstallationView.h
//  EveryoneNews
//
//  Created by dongdan on 16/4/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPLaunchLoginView;
@protocol  LPLaunchLoginViewDelegate<NSObject>

@optional

- (void)didCloseLoginView:(LPLaunchLoginView *)loginView;

- (void)didWeixinLoginWithLoginView:(LPLaunchLoginView *)loginView;

- (void)didSinaLoginWithLoginView:(LPLaunchLoginView *)loginView;


@end

@interface LPLaunchLoginView : UIView

 
@property (nonatomic, weak) id<LPLaunchLoginViewDelegate> delegate;

@end
