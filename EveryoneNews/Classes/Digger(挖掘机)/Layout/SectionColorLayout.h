//
//  SectionColorLayout.h
//  EveryoneNews
//
//  Created by apple on 15/10/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//
//  三 :
//     自定义布局类以添加自定义的装饰视图, 需要实现两个方法
//  1. + layoutAttributesClass 告诉布局类用什么布局属性
//  2. - layoutAttributesForElementsInRect 该方法返回视界里面的所有布局属性对象. 重写该方法以添加自定义的装饰视图

#import <UIKit/UIKit.h>

@interface SectionColorLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGFloat albumH;
@property (nonatomic, assign) CGFloat albumW;
@property (nonatomic, assign) CGFloat exposureH;
@end
