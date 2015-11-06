//
//  SectionColorLayoutAttributes.h
//  EveryoneNews
//
//  Created by apple on 15/10/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

//  一 :
//  1. 布局属性类用以捕捉collectionView中每个成分(item, header, footer, sectionHeader, sectionFooter)的属性
//  2. 每个将要被布局的item都有相应的布局属性对象
//  3. 默认地, 一个UICollectionViewLayoutAttributes对象有诸如frame, size, hidden, transform3D, zIndex, representedElementCategory等属性, 而没有color, 于是自定义一个布局属性类, 使其在原有基础上加上颜色属性, 并将其布置在装饰视图上

#import <UIKit/UIKit.h>

@interface SectionColorLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, strong) UIColor *color;
@end
