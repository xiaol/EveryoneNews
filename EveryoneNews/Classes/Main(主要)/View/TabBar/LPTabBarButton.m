//
//  LPTabBarButton.m
//  EveryoneNews
//
//  Created by apple on 15/5/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPTabBarButton.h"

@implementation LPTabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self setTitleColor:[UIColor colorFromHexString:TabBarButtonNormalColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorFromHexString:TabBarButtonSelectedColor] forState:UIControlStateSelected];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.height);
}

- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    [self setTitle:self.item.title forState:UIControlStateNormal];
//    [self setImage:self.item.image forState:UIControlStateNormal];
//    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
