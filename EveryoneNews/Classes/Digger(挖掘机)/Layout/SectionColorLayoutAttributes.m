//
//  SectionColorLayoutAttributes.m
//  EveryoneNews
//
//  Created by apple on 15/10/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SectionColorLayoutAttributes.h"

@implementation SectionColorLayoutAttributes
// 重写方法, 设置相应装饰视图上的attributes
+ (instancetype)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind withIndexPath:(NSIndexPath *)indexPath {
    SectionColorLayoutAttributes *attributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    attributes.color = [UIColor whiteColor]; // 设置装饰视图的布局属性的颜色属性
    return attributes;
}
@end
