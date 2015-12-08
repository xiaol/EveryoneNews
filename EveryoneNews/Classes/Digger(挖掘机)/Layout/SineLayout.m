//
//  SineLayout.m
//  EveryoneNews
//
//  Created by apple on 15/10/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SineLayout.h"

@implementation SineLayout
{
    CGSize boundsSize;
    CGFloat midX;
}

- (void)prepareLayout {
    [super prepareLayout];
    boundsSize = self.collectionView.bounds.size;
    midX = boundsSize.width / 2;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSArray *attributes = [super layoutAttributesForElementsInRect:rect].copy;
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect].copy];

    for (UICollectionViewLayoutAttributes *attribute in attributes) { // 这里只有cell类型的布局属性
        attribute.transform3D = CATransform3DIdentity;
        if (!CGRectIntersectsRect(attribute.frame, rect)) {
            continue;
        }
        CGPoint contentOffset = self.collectionView.contentOffset;
        // item中心点
        CGPoint itemCenter = CGPointMake(attribute.center.x - contentOffset.x, attribute.center.y - contentOffset.y);
        // 当前item中心距屏幕中心的距离
        CGFloat distance = ABS(midX - itemCenter.x);
        CGFloat normalized = distance / midX;
        normalized = MIN(1.0, normalized);
        CGFloat zoom = cos(normalized * M_PI / 5);
        
        attribute.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
    }
    return attributes;
}

// contentOffset校正, 使中间的cell居中显示
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat offsetAdjustment = CGFLOAT_MAX;
//    NSLog(@"proposedContentOffset : %@", NSStringFromCGPoint(proposedContentOffset));
    // 屏幕部分在整个collectionView的frame, 并取出屏幕上的item属性
    CGRect screenRect = CGRectMake(proposedContentOffset.x, 0, boundsSize.width, boundsSize.height);
    NSArray *attributes = [super layoutAttributesForElementsInRect:screenRect].copy;
    
    CGFloat screenCenterX = proposedContentOffset.x + midX;
    
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        CGFloat distance = attribute.center.x - screenCenterX;
        if (ABS(distance) < ABS(offsetAdjustment)) {
            offsetAdjustment = distance;
        }
    }
    
    CGPoint desiredPoint = CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    return desiredPoint;
}
@end
