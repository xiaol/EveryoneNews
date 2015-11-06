//
//  SectionColorLayoutAttributes.m
//  EveryoneNews
//
//  Created by apple on 15/10/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SectionColorLayoutAttributes.h"

@implementation SectionColorLayoutAttributes
+ (instancetype)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind withIndexPath:(NSIndexPath *)indexPath {
    SectionColorLayoutAttributes *attributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    attributes.color = [UIColor whiteColor]; // 设置装饰视图的布局属性的颜色属性
    return attributes;
}
@end
