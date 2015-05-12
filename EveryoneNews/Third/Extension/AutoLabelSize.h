//
//  AutoLabelSize.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/7.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AutoLabelSize : NSObject

/**
 *  根据字符串长度计算size
 *
 *  @param str   待输入字符串
 *  @param size  字体大小
 *  @param sizeW 限制宽度
 *  @param sizeH 现在高度
 *
 *  @return 返回size
 */
+ (CGSize)autoLabSizeWithStr:(NSString *)str Fontsize:(CGFloat)size SizeW:(CGFloat)sizeW SizeH:(CGFloat)sizeH;

@end
