//
//  LPTabBar.h
//  EveryoneNews
//
//  Created by apple on 15/5/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPTabBarButton.h"
@class LPTabBar;

typedef void (^tabBarDidClick)(int from,int to);

@protocol LPTabBarDelegate <NSObject>

@optional
- (void)tabBar:(LPTabBar *)tabBar didSelectButtonFrom:(int)from to:(int)to;

@end


@interface LPTabBar : UIView

- (void)addTabBarButtonWithItem:(UITabBarItem *)tabBarItem tag:(int)tag;
- (void)setBabBarDidClickBlock:(tabBarDidClick)block;
@property (nonatomic, weak) id<LPTabBarDelegate> delegate;
@property (nonatomic, weak) LPTabBarButton *selectedButton;
@property (nonatomic, strong) NSMutableArray *tabBarButtons;
@property (nonatomic, weak) UIView *sliderView;


@end
