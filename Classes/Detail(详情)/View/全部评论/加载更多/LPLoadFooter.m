//
//  LPLoadFooter.m
//  EveryoneNews
//
//  Created by dongdan on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPLoadFooter.h"

static NSString * const loadMoreAnimationKey = @"loadMoreRotation";

static const CGFloat fontSize = 16;
static const CGFloat loadMoreHeight = 40;

@interface LPLoadFooter()
//@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CABasicAnimation *animation;

@end

@implementation LPLoadFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = loadMoreHeight;

    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor colorFromHexString:@"#969696"];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage oddityImage:@"加载更多"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    self.imageView = imageView;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.repeatCount = FLT_MAX;
    animation.duration = 0.5;
    animation.cumulative = YES;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.14 , 0, 0, 1)];
    self.animation = animation;
   
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    NSString *loadStr = @"正在载入";
    CGSize labelSize = [loadStr sizeWithFont:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat imageViewW = 14;
    CGFloat imageViewH = 14;
    CGFloat padding =  10;
    CGFloat imageViewX = (ScreenWidth - imageViewW - padding - labelSize.width) / 2;
    CGFloat imageViewY = (self.mj_h - imageViewH) / 2;
    
    if (self.state == MJRefreshStateRefreshing) {
        self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
        self.label.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + padding, 0, labelSize.width, loadMoreHeight);
    } else if (self.state == MJRefreshStateNoMoreData) {
        NSString *loadFinishStr = @"加载已完成";
        CGSize loadFinishLabelSize = [loadFinishStr sizeWithFont:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        
        CGFloat labelW = loadFinishLabelSize.width;
        CGFloat labelX = (ScreenWidth - labelW) / 2;
      
        self.label.frame = CGRectMake(labelX, 0, labelW, loadMoreHeight);
    }
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
            [self.imageView.layer addAnimation:self.animation forKey:loadMoreAnimationKey];
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"加载已完成";
            self.imageView.hidden = YES;
            break;
        default:
            break;
    }
}

@end
