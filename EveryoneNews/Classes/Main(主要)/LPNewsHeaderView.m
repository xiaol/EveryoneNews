//
//  LPNewsHeaderView.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LPNewsHeaderView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier headerViewHeight:(CGFloat)headerViewHeight lineColor:(nullable UIColor *)lineColor lineFrame:(CGRect)lineFrame{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        if (lineColor) {
            CALayer *lineLayer = [CALayer layer];
            lineLayer.frame =lineFrame;
            lineLayer.backgroundColor = [lineColor CGColor];
            [self.contentView.layer addSublayer:lineLayer];
        }
        
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
