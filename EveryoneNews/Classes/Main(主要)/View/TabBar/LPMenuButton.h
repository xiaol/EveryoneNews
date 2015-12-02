//
//  LPMenuButton.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPMenuButton : UIButton
// 默认字体颜色
@property (nonatomic, strong) UIColor *normalColor;
// 选中时字体颜色
@property (nonatomic, strong) UIColor *selectedColor;
// 字体缩放比例
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, copy) NSString *fontName;

// 选中按钮时添加动画
- (void)selectedItemAnimation;
// 取消选中时添加动画
- (void)unSelectedItemAnimation;
// 根据索引初始化标题
- (instancetype)initTitlesWithIndex:(NSArray *)titles index:(int)index;
// 根据缩放系数改变字体颜色和大小
- (void)changeSelectedColorWithRate:(CGFloat)rate;

@end
