//
//  LPSpringLayout.m
//  EveryoneNews
//
//  Created by apple on 15/8/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPSpringLayout.h"
@interface LPSpringLayout ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation LPSpringLayout
- (id)init {
    if ([super init]) {
        _springDamping = 1.0;
        _springFrequency = 1.0;
        _resistanceFactor = 3200;
    }
    return self;
}

- (void)setSpringDamping:(CGFloat)springDamping {
    if (springDamping >= 0 && _springDamping != springDamping) {
        _springDamping = springDamping;
        for (UIAttachmentBehavior *spring in _animator.behaviors) {
            spring.damping = _springDamping;
        }
    }
}

- (void)setSpringFrequency:(CGFloat)springFrequency {
    if (springFrequency >= 0 && _springFrequency != springFrequency) {
        _springFrequency = springFrequency;
        for (UIAttachmentBehavior *spring in _animator.behaviors) {
            spring.frequency = _springFrequency;
        }
    }
}

- (void)prepareLayout {
    [super prepareLayout];
    
    if (self.springinessEnabled) {
        if (!_animator) {
            _animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
            CGSize contentSize = [self collectionViewContentSize];
            NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
            
            for (UICollectionViewLayoutAttributes *item in items) {
                UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];
                
                spring.length = 0;
                spring.damping = self.springDamping;
                spring.frequency = self.springFrequency;
                
                [_animator addBehavior:spring];
            }
        }
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (self.springinessEnabled) {
        return [_animator itemsInRect:rect];
    } else {
        return [super layoutAttributesForElementsInRect:rect];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.springinessEnabled) {
        return [_animator layoutAttributesForCellAtIndexPath:indexPath];
    } else {
        return [super layoutAttributesForItemAtIndexPath:indexPath];
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (self.springinessEnabled) {
        UIScrollView *scrollView = self.collectionView;
        CGFloat scrollDelta = newBounds.origin.y - scrollView.bounds.origin.y;
        CGPoint touchLocation = [scrollView.panGestureRecognizer locationInView:scrollView];
        for (UIAttachmentBehavior *spring in _animator.behaviors) {
            CGPoint anchorPoint = spring.anchorPoint;
            CGFloat distanceFromTouch = fabs(touchLocation.y - anchorPoint.y);
            CGFloat scrollResistance = distanceFromTouch / self.resistanceFactor;
            
            UICollectionViewLayoutAttributes *item = [spring.items firstObject];
            CGPoint center = item.center;
            center.y += scrollDelta > 0 ? MIN(scrollDelta, scrollDelta * scrollResistance) : MAX(scrollDelta, scrollDelta * scrollResistance);
            item.center = center;
            
            [_animator updateItemUsingCurrentState:item];
        }
    }
    return NO;
}

- (void)reset {
    [self.animator removeAllBehaviors];
    self.animator = nil;
}
@end
