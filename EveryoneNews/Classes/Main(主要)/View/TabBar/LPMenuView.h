//
//  LPMenuView.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMenuButton.h"

@class LPMenuView;
@protocol LPMenuViewDelegate <UIScrollViewDelegate>

@optional
- (void)menuView:(LPMenuView *)menuView didSelectedButtonAtIndex:(int)index;

@end

@interface LPMenuView : UIScrollView

@property (nonatomic, weak) id<LPMenuViewDelegate> menuViewDelegate;
@property (nonatomic, strong) LPMenuButton *selectedButton;
/**
 *  当自定义PagingView滚动时候菜单栏缩放
 *
 *  @param index 当前页
 *  @param rate  按钮缩放比例
 */
- (void)selectedButtonScaleWithRate:(int)index rate:(CGFloat)rate;

/**
 *  加载菜单栏
 *
 *  @param titles 菜单栏标题
 */
- (void)loadMenuViewTitles:(NSArray *)titles;

/**
 *  标题自动移动到正中央
 *
 *  @param index 选中标题索引
 */
- (void)selectedButtonMoveToCenterWithIndex:(int)index;

/**
 *  菜单栏标题选中状态改变
 *
 *  @param index 选中标题索引值
 */
- (void)buttonSelectedStatusChangedWithIndex:(int)index;
/**
 *  改变频道栏后重新加载菜单
 *
 *  @param titles        重新选择的所有频道
 *  @param selectedTitle 历史选中的频道名称
 */
- (void)reloadMenuViewTitles:(NSArray *)titles selectedTitle:(NSString *)selectedTitle;
@end
