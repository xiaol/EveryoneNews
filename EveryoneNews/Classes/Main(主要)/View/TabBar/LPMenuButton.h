//
//  LPMenuButton.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPChannelItem;
@interface LPMenuButton : UILabel

// 默认字体颜色
@property (nonatomic, strong) UIColor *normalColor;
// 选中时字体颜色
@property (nonatomic, strong) UIColor *selectedColor;
// 字体缩放比例
@property (nonatomic, assign) CGFloat rate;
// 字体颜色和大小渐变
- (void)titleSizeAndColorDidChangedWithRate:(CGFloat)rate;

@end
