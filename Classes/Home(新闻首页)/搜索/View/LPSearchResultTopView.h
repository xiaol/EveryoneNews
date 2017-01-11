//
//  LPSearchResultTopView.h
//  EveryoneNews
//
//  Created by dongdan on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPSearchResultTopView;
@protocol LPSearchResultTopViewDelegate <NSObject>

@optional
- (void)backButtonDidClick:(LPSearchResultTopView *)searchResultTopView;

- (void)topView:(LPSearchResultTopView *)topView searchBarSearchButtonClicked:(UISearchBar *)searchBar;

@end

@interface LPSearchResultTopView : UIView

@property (nonatomic, weak) id<LPSearchResultTopViewDelegate> delegate;

@property (nonatomic, strong) UISearchBar *searchBar;


@end
