//
//  LPSearchTool.h
//  EveryoneNews
//
//  Created by dongdan on 16/8/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPSearchTool : NSObject

/**
 *  拆分汉字
 *
 *  @param word 初始汉字
 *
 *  @return 拆分后数组
 */
+ (NSArray *)stringTokenizerWithWord:(NSString *)word;

/**
 *  给关键字设置颜色
 *
 *  @param content  原文
 *  @param keyWords 关键字数组
 *  @param color    颜色
 *
 *  @return 属性字符串
 */
+ (NSAttributedString *)attributeStringWithContent:(NSString *)content keyWords:(NSArray *)keyWords color:(UIColor *)color fontSize:(CGFloat)fontSize;

/**
 *  过滤html标签
 *
 *  @param html html字符串
 *
 *  @return 过滤后字符串
 */
+ (NSString *)filterHTML:(NSString *)html;

/**
 *  字符串转换为数组
 *
 *  @param word 字符串
 *
 *  @return 数组
 */
+ (NSArray *)stringWithWord:(NSString *)word;
@end
