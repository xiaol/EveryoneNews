//
//  CircleProgressView.m
//  EveryoneNews
//
//  Created by apple on 15/5/6.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "CircleProgressView.h"
#import "UIColor+HexToRGB.h"
#import "NSDate+LP.h"
#import "Common.h"

@interface CircleProgressView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, assign) CGFloat lineW;
@property (nonatomic, weak) UIImageView *timeImage;

@property (nonatomic, weak) UILabel *hourLabel;
@property (nonatomic, weak) UILabel *minLabel;
@property (nonatomic, weak) UILabel *secLabel;
@property (nonatomic, assign) int countTime;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CircleProgressView




- (void)layoutSubviews
{
    [super layoutSubviews];
 //   NSLog(@"circle-layoutSubviews");
    
    // 背景圆环
    CGFloat lineW = self.bounds.size.width / 32;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.frame = self.bounds;
    shapeLayer.strokeColor = [UIColor colorFromHexString:@"#3C9DFB" alpha:0.2].CGColor;
    shapeLayer.lineWidth = lineW;
    UIBezierPath *backCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(shapeLayer.frame.size.width / 2, shapeLayer.frame.size.height / 2)
                                                                  radius:(CGRectGetWidth(self.bounds)) / 2
                                                              startAngle:(CGFloat) - M_PI_2
                                                                endAngle:(CGFloat)(1.5 * M_PI)
                                                               clockwise:YES];
    shapeLayer.path = backCircle.CGPath;
    [self.layer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
    
    // 进度条
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.frame = self.bounds;
    progressLayer.strokeColor = [UIColor colorFromHexString:@"#66DBFB" alpha:0.8].CGColor;
    progressLayer.lineWidth = lineW;
    progressLayer.path = backCircle.CGPath;
    [self.layer addSublayer:progressLayer];
    self.progressLayer = progressLayer;
    
    // 图标
    UIImageView *timeImage = [[UIImageView alloc] init];
//    NSDate *now = [NSDate localeDate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
//    NSLog(@"hour:%ld",components.hour);
    if (components.hour >= 6 && components.hour <= 17) {
        timeImage.image = [UIImage imageNamed:@"太阳"];
    } else {
        timeImage.image = [UIImage imageNamed:@"月亮"];
    }
    timeImage.contentMode = UIViewContentModeScaleAspectFill;
    // timeImage.clipsToBounds = YES;
    [self addSubview:timeImage];
    self.timeImage = timeImage;

    CGFloat timeImgY = self.bounds.size.height / 6;
# pragma mark - 应该自适应大小
    CGFloat timeImgW = self.bounds.size.height / 7;
    CGFloat timeImgH = timeImgW;
    CGFloat timeImgX = (self.bounds.size.width - timeImgW) / 2;
    self.timeImage.frame = CGRectMake(timeImgX, timeImgY, timeImgW, timeImgH);
    
    
    
    UILabel *hourLabel = [[UILabel alloc] init];
    hourLabel.backgroundColor = [UIColor clearColor];
    hourLabel.textColor = [UIColor whiteColor];
    CGFloat hourW = self.bounds.size.width / 8;
    CGFloat hourH = hourW;
    CGFloat hourX = (self.bounds.size.width) / 8;
    CGFloat hourY = CGRectGetMaxY(self.timeImage.frame) + timeImgH;
    hourLabel.frame = CGRectMake(hourX, hourY, hourW, hourH);
    hourLabel.textAlignment = NSTextAlignmentJustified;
    hourLabel.font = [UIFont systemFontOfSize:hourH - 4];
    hourLabel.text = @"12";
    [self addSubview:hourLabel];
    self.hourLabel = hourLabel;
    
    UILabel *hourTip = [[UILabel alloc] init];
    hourTip.backgroundColor = [UIColor clearColor];
    hourTip.textColor = [UIColor whiteColor];
    CGFloat hourTipW = hourW;
    CGFloat hourTipH = hourH * 0.6;
    CGFloat hourTipX = CGRectGetMaxX(hourLabel.frame);
    CGFloat hourTipY = CGRectGetMaxY(hourLabel.frame) - hourTipH;
    hourTip.frame = CGRectMake(hourTipX, hourTipY, hourTipW, hourTipH);
    hourTip.textAlignment = NSTextAlignmentJustified;
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        hourTip.font = [UIFont systemFontOfSize:11];
    } else {
        hourTip.font = [UIFont systemFontOfSize:14];
    }
    
    hourTip.text = @"小时";
    [self addSubview:hourTip];
    
    UILabel *minLabel = [[UILabel alloc] init];
    minLabel.backgroundColor = [UIColor clearColor];
    minLabel.textColor = [UIColor whiteColor];
    CGFloat minW = hourLabel.frame.size.width;
    CGFloat minH = hourLabel.frame.size.height;
    CGFloat minX = CGRectGetMaxX(hourTip.frame) + 2;
    CGFloat minY = CGRectGetMaxY(self.timeImage.frame) + timeImgH;
    minLabel.frame = CGRectMake(minX, minY, minW, minH);
    minLabel.textAlignment = NSTextAlignmentJustified;
    minLabel.font = [UIFont systemFontOfSize:hourH - 4];
    minLabel.text = @"00";
    [self addSubview:minLabel];
    self.minLabel = minLabel;
    
    UILabel *minTip = [[UILabel alloc] init];
    minTip.backgroundColor = [UIColor clearColor];
    minTip.textColor = [UIColor whiteColor];
    CGFloat minTipW = minW;
    CGFloat minTipH = minH * 0.6;
    CGFloat minTipX = CGRectGetMaxX(minLabel.frame);
    CGFloat minTipY = CGRectGetMaxY(minLabel.frame) - minTipH;
    minTip.frame = CGRectMake(minTipX, minTipY, minTipW, minTipH);
    minTip.textAlignment = NSTextAlignmentJustified;
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        minTip.font = [UIFont systemFontOfSize:11];
    } else {
        minTip.font = [UIFont systemFontOfSize:14];
    }

    minTip.text = @"分钟";
    [self addSubview:minTip];


    
 
    UILabel *secLabel = [[UILabel alloc] init];
    secLabel.backgroundColor = [UIColor clearColor];
    secLabel.textColor = [UIColor whiteColor];
    CGFloat secW = hourLabel.frame.size.width;
    CGFloat secH = hourLabel.frame.size.height;
    CGFloat secX = CGRectGetMaxX(minTip.frame) + 2;
    CGFloat secY = CGRectGetMaxY(self.timeImage.frame) + timeImgH;
    secLabel.frame = CGRectMake(secX, secY, secW, secH);
    secLabel.textAlignment = NSTextAlignmentJustified;
    secLabel.font = [UIFont systemFontOfSize:secH - 4];
    secLabel.text = @"00";
    [self addSubview:secLabel];
    self.secLabel = secLabel;
    
    UILabel *secTip = [[UILabel alloc] init];
    secTip.backgroundColor = [UIColor clearColor];
    secTip.textColor = [UIColor whiteColor];
    CGFloat secTipW = secW;
    CGFloat secTipH = secH * 0.6;
    CGFloat secTipX = CGRectGetMaxX(secLabel.frame);
    CGFloat secTipY = CGRectGetMaxY(secLabel.frame) - secTipH;
    secTip.frame = CGRectMake(secTipX, secTipY, secTipW, secTipH);
    secTip.textAlignment = NSTextAlignmentJustified;
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        secTip.font = [UIFont systemFontOfSize:11];
    } else {
        secTip.font = [UIFont systemFontOfSize:14];
    }

    secTip.text = @"秒";
    [self addSubview:secTip];

    
   // [self setAnimation:self.updateTime];
    [self setAnimation:self.updateTime];

}

- (void)setAnimation:(int)updateTime
{
    CGFloat duration = 0.7f;
    
    // updateTime = 3690;
    CGFloat percent = 1.0 - (CGFloat)updateTime / (12 * 3600);
    int hour = (int) (updateTime / 3600);
    if (hour < 10) {
        self.hourLabel.text = [NSString stringWithFormat:@"0%d", hour];
    } else {
        self.hourLabel.text = [NSString stringWithFormat:@"%d", hour];
    }
    int minute = (int) (updateTime - hour * 3600) / 60;
    if (minute < 10) {
        self.minLabel.text = [NSString stringWithFormat:@"0%d", minute];
    } else {
        self.minLabel.text = [NSString stringWithFormat:@"%d", minute];
    }
    int second = (int) (updateTime - hour * 3600 - minute * 60);
    if (second < 10) {
        self.secLabel.text = [NSString stringWithFormat:@"0%d", second];
    } else {
        self.secLabel.text = [NSString stringWithFormat:@"%d", second];
    }
    
    CABasicAnimation *progressAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    progressAnimation.delegate = self;
    progressAnimation.duration = duration;
    progressAnimation.fromValue = @(0.0f);
    progressAnimation.toValue = @(percent);
    progressAnimation.fillMode = kCAFillModeForwards;
    progressAnimation.removedOnCompletion = NO;
    progressAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.progressLayer addAnimation:progressAnimation forKey:nil];
    
    
    _countTime = (int)(updateTime - duration);
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFire) userInfo:nil repeats:YES];
}

- (void)timeFire
{
    if (_countTime == 0) {
        [_timer invalidate];
        if ([self.delegate respondsToSelector:@selector(circleProgressDidFinish)]) {
            [self.delegate circleProgressDidFinish];
        }
    }
    int hour = (int) (_countTime / 3600);
    int minute = (int) (_countTime - hour * 3600) / 60;
    int second = (int) (_countTime - hour * 3600 - minute * 60);
    
    if (hour < 10) {
        self.hourLabel.text = [NSString stringWithFormat:@"0%d", hour];
    } else {
        self.hourLabel.text = [NSString stringWithFormat:@"%d", hour];
    }
    if (minute < 10) {
        self.minLabel.text = [NSString stringWithFormat:@"0%d", minute];
    } else {
        self.minLabel.text = [NSString stringWithFormat:@"%d", minute];
    }
    if (second < 10) {
        self.secLabel.text = [NSString stringWithFormat:@"0%d", second];
    } else {
        self.secLabel.text = [NSString stringWithFormat:@"%d", second];
    }

    _countTime --;
}

@end
