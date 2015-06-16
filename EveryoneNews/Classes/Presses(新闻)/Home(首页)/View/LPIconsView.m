//
//  LPIconsView.m
//  EveryoneNews
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPIconsView.h"

//@interface LPIconsView ()
//@property (nonatomic, strong) NSMutableArray *icons;
//@end

@implementation LPIconsView

//- (NSMutableArray *)icons
//{
//    if (_icons == nil) {
//        _icons = [NSMutableArray array];
//    }
//    return _icons;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i < Icons.count; i++) {
            UIImage *icon = [UIImage imageNamed:[Icons objectAtIndex:i]];
            UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
//            [self.icons addObject:iconView];
            [self addSubview:iconView];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat iconW = IconW;
    CGFloat iconH = iconW;
    CGFloat iconY = 0;
    for (int i = 0; i < self.subviews.count; i++) {
        CGFloat iconX = i * (iconW + IconBorder);
        UIImageView *iconView = self.subviews[i];
        iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    }
}
@end
