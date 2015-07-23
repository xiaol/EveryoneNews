//
//  DiggerHeader.m
//  EveryoneNews
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "DiggerHeader.h"

@implementation DiggerHeader

- (void)prepare {
    [super prepare];
    
//    // 设置普通状态的动画图片
//    NSMutableArray *idleImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i<=..; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd", i]];
//        [idleImages addObject:image];
//    }
//    [self setImages:idleImages forState:MJRefreshStateIdle];
  
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 7; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"动画3000%zd", i]];
        [refreshingImages addObject:image];
    }
        [self setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}
@end
