//
//  UITextField+LP.m
//  EveryoneNews
//
//  Created by dongdan on 16/1/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UITextField+LP.h"

@implementation UITextField (LP)

- (void)setLayerCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

-(void)setLayerBorderColor:(UIColor *)color
{
    self.layer.borderColor = color.CGColor;
}

-(void)setLayerBorderWidth:(CGFloat)width
{
    self.layer.borderWidth = width;
}
@end
