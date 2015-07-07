//
//  UICustomLoadding.m
//  自定义加载view
//
//  Created by Feng on 15/7/7.
//  Copyright (c) 2015年 Feng. All rights reserved.
//

#import "UICustomLoadding.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define ProgressWidth 120

@interface UICustomLoadding()
@property (nonatomic,strong) UIActivityIndicatorView *loaddingView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,copy) UILabel *messageLabel;
@property (nonatomic,strong) UIView *mask;
@end
@implementation UICustomLoadding
-(UIActivityIndicatorView *)loaddingView{
    
    if (_loaddingView == nil) {
        _loaddingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _loaddingView.hidden = NO;
        _loaddingView.hidesWhenStopped = YES;
        [_loaddingView startAnimating];
        _loaddingView.frame = CGRectMake((ProgressWidth - 60) * 0.5, 15, 60, 60);
    }
    return _loaddingView;
}
- (UILabel *)messageLabel{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.loaddingView.frame), ProgressWidth, 16)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor whiteColor];
    }
    return _messageLabel;
}
- (UIView *)mask{
    if (_mask == nil) {
        _mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _mask.backgroundColor = [UIColor clearColor];
    }
    return _mask;
}
- (UIView *)containerView{
    if (_containerView == nil) {
        CGFloat containerX = (SCREEN_WIDTH - ProgressWidth) * 0.5;
        CGFloat containerY = (SCREEN_HEIGHT - ProgressWidth) * 0.5 - ProgressWidth * 0.5;
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(containerX , containerY, ProgressWidth, 120)];
        _containerView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
        _containerView.layer.cornerRadius = 15;
        _containerView.layer.masksToBounds = YES;
        [_containerView addSubview:self.loaddingView];
        [_containerView addSubview:self.messageLabel];
    }
    return _containerView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.mask];
        [self addSubview:self.containerView];
    }
    return self;
}

+ (instancetype)showMessage:(NSString *)message toView:(UIView *)rootView{
    UICustomLoadding *view = [[self alloc] initWithFrame:rootView.bounds];
    UIView *container = view.subviews[1];
    UILabel *messageView = container.subviews[1];
    messageView.text = message;
    [rootView addSubview:view];
    return view;
}
- (void)dismissMessage{
    [super removeFromSuperview];
    [self removeFromSuperview];
    self.loaddingView.hidden = YES;
    self.containerView = nil;
    self.loaddingView = nil;
    self.messageLabel = nil;
    NSLog(@"---%d",_containerView.subviews.count);
    NSLog(@"%d",    _loaddingView.isAnimating);
}
@end
