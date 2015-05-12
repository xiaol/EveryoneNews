//
//  CountdownView.m
//  EveryoneNews
//
//  Created by apple on 15/5/6.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "CountdownView.h"
#import "CircleProgressView.h"
#import "DateScrollView.h"

@interface CountdownView ()
@property (nonatomic, weak) UIImageView *bgImage;

@end

@implementation CountdownView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImage.image = [UIImage imageNamed:@"背景"];
        [self addSubview:bgImage];
        self.bgImage = bgImage;
        
        CircleProgressView *circleView = [[CircleProgressView alloc] init];
        circleView.backgroundColor = [UIColor clearColor];
        [self addSubview:circleView];
        self.circleView = circleView;

        DateScrollView *dateView = [[DateScrollView alloc] init];
        dateView.backgroundColor = [UIColor clearColor];
        [self addSubview:dateView];
        self.dateView = dateView;
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        self.cancelBtn = cancelBtn;
    }
    return self;
}

-(void)setUpdateTime:(int)updateTime
{
    _updateTime = updateTime;
    self.circleView.updateTime = updateTime;
}

-(void)setType:(BOOL)type
{
    _type = type;
    self.dateView.type = type;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgImage.frame = self.bounds;
    
    CGFloat border = 50;
    
    CGFloat dateW = self.bounds.size.width;
    CGFloat dateH = self.bounds.size.height / 5;
    CGFloat dateX = 0;
    CGFloat dateY = self.bounds.size.height - dateH - self.bounds.size.height * 0.08;
    self.dateView.frame  = CGRectMake(dateX, dateY, dateW, dateH);
    self.dateView.contentSize = CGSizeMake(15.0 * self.bounds.size.width / 8, 0);
    self.dateView.showsHorizontalScrollIndicator = NO;
    self.dateView.bounces = NO;
    
    CGFloat circleW = self.bounds.size.width - border * 2;
    CGFloat circleH = circleW;
    CGFloat circleX = border;
    CGFloat circleY = (dateY - circleH) / 2;
    self.circleView.frame = CGRectMake(circleX, circleY, circleW, circleH);
    
    CGFloat cancelW = 15;
    CGFloat cancelH = cancelW;
    CGFloat cancelX = self.bounds.size.width - 20 - cancelW;
    CGFloat cancelY = 36;
    
//        CGFloat cancelW = 15;
//        CGFloat cancelH = cancelW;
//        CGFloat cancelX = self.bounds.size.width/2;
//        CGFloat cancelY = 400;
    self.cancelBtn.frame = CGRectMake(cancelX, cancelY, cancelW, cancelH);
}

- (void)cancelClick
{
//    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(countdownViewDidCancel)]) {
        [self.delegate countdownViewDidCancel];
    }
}

@end
