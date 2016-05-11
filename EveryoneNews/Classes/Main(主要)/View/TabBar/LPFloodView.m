//
//  LPFloodView.m
//  EveryoneNews
//
//  Created by dongdan on 16/3/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPFloodView.h"

@implementation LPFloodView


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat radius = 13;
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.5);
    
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat midY = CGRectGetMidY(rect);
    
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    CGContextMoveToPoint(context, minX, midY);
    CGContextAddArcToPoint(context, minX, minY, midX, minY, radius);
    CGContextAddArcToPoint(context, maxX, minY, maxX, midY, radius);
    CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius);
    CGContextAddArcToPoint(context, minX, maxY, minX, midY, radius);
    CGContextClosePath(context);

    // 背景填充色
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextDrawPath(context,kCGPathFill);
 
}

@end
