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
- (void)menuViewDelegate:(LPMenuView *)menuView index:(int)index;

@end

@interface LPMenuView : UIView

@property (nonatomic, weak) id<LPMenuViewDelegate> delegate;

/**
 *  指定回调函数，当菜单下面的scrollview滚动时候调用
 *
 *  @param index 当前页
 *  @param rate  按钮缩放比例
 */
- (void)changeSelectedButtonRateWithIndex:(int)index rate:(CGFloat) rate;

/**
 *  加载菜单栏
 *
 *  @param titles 菜单栏标题
 */
- (void)loadMenuViewTitles:(NSArray *)titles;

/**
 *  回调函数，当菜单栏下面自定义PagingView滚动时候，按钮颜色发生变化
 *
 *  @param index      选中按钮
 *  @param otherIndex 非选中按钮
 */
- (void)selectedButtonWithIndex:(int)index otherIndex:(int)otherIndex;

/**
 *  标题自动移动到正中央
 *
 *  @param index 标题索引
 */
- (void)selectedButtonMoveToCenterWithIndex:(int)index;

@end
