//
//  LPSearchTopView.h
//  EveryoneNews
//
//  Created by dongdan on 16/6/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPSearchTopView;

@protocol LPSearchTopViewDelegate <NSObject>

@optional
- (void)backButtonDidClick:(LPSearchTopView *)searchTopView;
- (void)topView:(LPSearchTopView *)topView searchBarSearchButtonClicked:(UISearchBar *)searchBar;


@end

@interface LPSearchTopView : UIView

@property (nonatomic, weak) id<LPSearchTopViewDelegate> delegate;

@property (nonatomic, strong) UISearchBar *searchBar;

@end
