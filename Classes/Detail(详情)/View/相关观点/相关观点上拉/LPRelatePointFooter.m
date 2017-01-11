//
//  LPRelatePointFooter.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPRelatePointFooter.h"

@interface LPRelatePointFooter()

@end

@implementation LPRelatePointFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare {
    [super prepare];
    // 设置控件的高度
    self.mj_h = 48;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            break;
        case MJRefreshStateRefreshing:
            break;
        case MJRefreshStateNoMoreData:
            break;
        default:
            break;
    }
}

@end
