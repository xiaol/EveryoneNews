//
//  UIButton+LP.h
//  EveryoneNews
//
//  Created by apple on 15/7/31.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LP)
// 扩张的边界大小
@property (nonatomic, assign) CGFloat enlargedEdge;
// 设置四个边界扩充的大小
- (void)setEnlargedEdgeWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;
@end
