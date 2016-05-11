//
//  DiggerFooter.m
//  EveryoneNews
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//


#import "LPDiggerFooter.h"

static NSString * const loadMoreAnimationKey = @"loadMoreRotation";
static const CGFloat labelWidth = 100;
static const CGFloat imageViewWidth = 14;
static const CGFloat imageViewHeitht = 14;
static const CGFloat loadMoreHeight = 40;

@interface LPDiggerFooter()
@property (nonatomic, weak) UIView *view;
@property (weak, nonatomic) UILabel *label;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) CABasicAnimation *animation;

@end

@implementation LPDiggerFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    UIView *view = [[UIView alloc] init];

    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorFromHexString:@"#8e8e93"];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    self.label = label;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"加载更多"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageView];
    self.imageView = imageView;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.repeatCount = FLT_MAX;
    animation.duration = 0.5;
    animation.cumulative = YES;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.14 , 0, 0, 1)];
    self.animation = animation;
    
    [self addSubview:view];
    self.view = view;
 
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.view.frame = CGRectMake(0, 0, labelWidth + imageViewWidth, loadMoreHeight);
    self.view.centerX = self.centerX;
 
    self.imageView.frame = CGRectMake(0, 0, imageViewWidth, imageViewHeitht);
    self.imageView.centerY = self.view.centerY;
    
    self.label.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, 0, labelWidth, loadMoreHeight);
    self.label.centerY = self.view.centerY;
    
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
            self.label.text = @"";
            self.imageView.hidden = YES;
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"正在载入";
            self.imageView.hidden = NO;
            self.label.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, 0, labelWidth, loadMoreHeight);
            [self.imageView.layer addAnimation:self.animation forKey:loadMoreAnimationKey];
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"加载已完成";
            self.imageView.hidden = YES;
            self.label.frame = CGRectMake(CGRectGetMinX(self.imageView.frame), 0, labelWidth, loadMoreHeight);
            [self.imageView.layer removeAnimationForKey:loadMoreAnimationKey];
            break;
        default:
            break;
    }
}

@end