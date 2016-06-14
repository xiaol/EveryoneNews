//
//  DiggerHeader.m
//  EveryoneNews
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPDiggerHeader.h"

@interface LPDiggerHeader ()

@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIActivityIndicatorView *loading;

@end

@implementation LPDiggerHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare {
    
    [super prepare];
    
    // 设置控件高度
    self.mj_h = 54.0f;
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
    
    // 添加loading
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorFromHexString:@"#969696"];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
}


#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    
    self.loading.frame = CGRectMake((ScreenWidth - 22) / 2, 2, 22, 22);
    CGFloat loadLabelY = CGRectGetMaxY(self.loading.frame) + 8;
    CGFloat loadLabelX = (ScreenWidth - 100) / 2;
    
    self.label.frame =  CGRectMake(loadLabelX, loadLabelY, 100, 12);
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
            [self.loading stopAnimating];
            self.label.text = @"正在推荐";
            break;
        case MJRefreshStatePulling:
            [self.loading startAnimating];
            self.label.text = @"松开立即刷新";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"正在推荐";
            [self.loading startAnimating];
            break;
        default:
            break;
    }
}


@end
