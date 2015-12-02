//
//  LPMenuView.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LPMenuView;

@protocol LPMenuViewDelegate <NSObject>

@optional
- (void) MenuViewDelegate:(LPMenuView *)menuView index:(int)index;

@end

@interface LPMenuView : UIView
@property (nonatomic, weak) id<LPMenuViewDelegate> delegate;
- (void)selectedButtonMoveToCenterWithRateAndIndex:(int)index rate:(CGFloat) rate;
// 加载标题栏
- (void)loadMenuViewTitles:(NSArray *)titles;
// 选中菜单中按钮
- (void)selectedButtonWithIndex:(int)index otherIndex:(int)otherIndex;

@end
