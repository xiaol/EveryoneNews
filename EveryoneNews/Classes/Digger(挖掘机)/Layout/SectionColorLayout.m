//
//  SectionColorLayout.m
//  EveryoneNews
//
//  Created by apple on 15/10/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SectionColorLayout.h"
#import "SectionColorLayoutAttributes.h"
#import "SectionColorDecorationReusableView.h"

static NSString *DecorationReuseID = @"sectionBackgroundColor";

@implementation SectionColorLayout
{
    int i;
}

// 自定义的布局属性
+ (Class)layoutAttributesClass {
    return [SectionColorLayoutAttributes class];
}
// prepare
- (void)prepareLayout {
    [super prepareLayout];
    
    self.minimumLineSpacing = 10.0f;
    self.minimumInteritemSpacing = 8.0f;
    self.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    self.itemSize = CGSizeMake(self.albumW, self.albumH);
    // 注册装饰视图
    [self registerClass:[SectionColorDecorationReusableView class] forDecorationViewOfKind:DecorationReuseID];
    i = 0;
}

- (CGFloat)albumW {
    return (ScreenWidth - 36) / 3.0f;
}

- (CGFloat)albumH {
    return self.albumW * 1.3f;
}

- (CGFloat)exposureH {
    return self.albumH + 20.0f;
}

- (CGSize)collectionViewContentSize {
    CGSize size = [super collectionViewContentSize];
    if (size.height < ScreenHeight * 2 - self.exposureH - 44) {
        return CGSizeMake(size.width, ScreenHeight * 2 - self.exposureH - 44);
    } else {
        return size;
    }
}

// 为布局属性添加装饰属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray *attrs = [attributes mutableCopy];
    
    NSLog(@"attributes rect : %@", NSStringFromCGRect(rect));
    
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        if (attr.representedElementCategory == UICollectionElementCategoryCell
            && attr.frame.origin.x == self.sectionInset.left && i == 0) { // 加装饰属性
            SectionColorLayoutAttributes *decorationAttr = [SectionColorLayoutAttributes layoutAttributesForDecorationViewOfKind:DecorationReuseID withIndexPath:attr.indexPath];
//            decorationAttr.frame = CGRectMake(0, attr.frame.origin.y - self.sectionInset.top, self.collectionViewContentSize.width, self.itemSize.height + self.minimumLineSpacing + self.sectionInset.top + self.sectionInset.bottom);
            decorationAttr.frame = CGRectMake(0, attr.frame.origin.y - self.sectionInset.top, self.collectionViewContentSize.width, self.collectionViewContentSize.height - 44);
            decorationAttr.zIndex = attr.zIndex - 1;
            [attrs addObject:decorationAttr];
            i ++;
            break;
        }
    }
    return attrs;
}
@end
