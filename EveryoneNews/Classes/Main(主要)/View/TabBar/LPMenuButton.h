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
// 标题颜色
@property (nonatomic, strong) UIColor *titleColor;
// 字体大小
@property (nonatomic, assign) CGFloat fontSize;
// 字体名称
@property (nonatomic, copy) NSString *fontName;

// 选中按钮时添加动画
- (void)buttonDidSelectedWithAnimation;

// 取消选中时添加动画
- (void)buttonDidDeSelectedWithAnimation;

// 初始化标题
- (instancetype)initWithTitle:(NSString *)title;

// 根据缩放系数改变字体颜色和大小
- (void)titleSizeAndColorDidChangedWithRate:(CGFloat)rate;

@end
