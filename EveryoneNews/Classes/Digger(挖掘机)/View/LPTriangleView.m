//
//  LPTriangleView.m
//  EveryoneNews
//
//  Created by dongdan on 16/1/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPTriangleView.h"

@implementation LPTriangleView

- (void)drawRect:(CGRect)rect {
    // 三角形
    CGFloat triangleHeight = 30;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextMoveToPoint(ctx, 0, triangleHeight);
    CGContextAddLineToPoint(ctx, triangleHeight,triangleHeight);
    CGContextAddLineToPoint(ctx, triangleHeight, 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    CGContextStrokePath(ctx);

}
@end
