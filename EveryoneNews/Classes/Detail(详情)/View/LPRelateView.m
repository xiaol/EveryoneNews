//
//  LPRelateView.m
//  EveryoneNews
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPRelateView.h"
#import "LPRelatePoint.h"
#import "NSString+LP.h"
#import "UIImageView+WebCache.h"
#import "LPPressTool.h"

#define RelateTopPadding 30;
#define RightPadding 13
#define RelateFontSize 14
#define RelatePointLineSpacing 3
#define RelatePointSpacing 12

@interface LPRelateView ()
@property (nonatomic, strong) NSMutableArray *pointLabels;
@end

@implementation LPRelateView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (NSMutableArray *)pointLabels
{
    if (_pointLabels == nil) {
        _pointLabels = [NSMutableArray array];
    }
    return _pointLabels;
}


-(void)setRelateArray:(NSArray *)relateArray
{
    _relateArray=relateArray;
    // 添加相关观点标题
    NSString *relate = @"相关观点";
    UILabel *relateLabel = [[UILabel alloc] init];
    relateLabel.font = [UIFont systemFontOfSize:15];
    relateLabel.textColor = [UIColor colorFromHexString:@"#b5b5b5"];
    relateLabel.text = relate;
    relateLabel.frame=CGRectMake(12, 10, 70, 20);
    relateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:relateLabel];
    
    CAShapeLayer *titleLayer = [CAShapeLayer layer];
    UIBezierPath *titlePath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(12, 10, 70, 20) cornerRadius:6.5f];
    titleLayer.lineWidth=1.0;
    titleLayer.path=titlePath.CGPath;
    titleLayer.fillColor = nil;
    titleLayer.strokeColor = [UIColor colorFromHexString:@"#b5b5b5"].CGColor;
    [self.layer addSublayer:titleLayer];
    
    for (int i=0; i<relateArray.count; i++) {
        LPRelatePoint *point = self.relateArray[i];
        UIView *cellView=[[UIView alloc] initWithFrame:CGRectMake(10,30+79*i,ScreenWidth-40, 79)];
        
        // 日期
        CAShapeLayer *dateLayer = [CAShapeLayer layer];
        UIBezierPath *datePath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(0, 40, 32, 12) cornerRadius:3];
        dateLayer.lineWidth=1.0;
        dateLayer.path=datePath.CGPath;
        dateLayer.fillColor = nil;
        dateLayer.strokeColor = [UIColor colorFromHexString:@"#cbcbcb"].CGColor;
        [cellView.layer addSublayer:dateLayer];
        
        NSString *currentDate=point.updateTime;
        //  如果日期有问题则设置为当前日期
        if(currentDate.length<10)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            currentDate=[dateFormatter stringFromDate:[NSDate date]];
        }
        currentDate=[[currentDate substringWithRange:NSMakeRange(5, 5)] stringByReplacingOccurrencesOfString:@"-"withString:@"."];
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.text = currentDate;
        timeLabel.frame=CGRectMake(0,40, 32, 12);
        [cellView addSubview:timeLabel];

        // 上方时间轴线
            CAShapeLayer *dashUp = [CAShapeLayer layer];
            UIBezierPath *linePathUp = [UIBezierPath bezierPath];
            [linePathUp moveToPoint:CGPointMake(38, 0)];
            [linePathUp addLineToPoint:CGPointMake(38, 43)];
            dashUp.lineWidth = 1.0;
            dashUp.lineDashPattern = @[@1, @1];
            dashUp.path=linePathUp.CGPath;
            dashUp.fillColor = nil;
            dashUp.strokeColor = [UIColor colorFromHexString:@"#b5b5b5"].CGColor;
            [cellView.layer addSublayer:dashUp];
        // 贝塞尔曲线(创建一个圆)
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(38,46)
                                                            radius:3.0f
                                                        startAngle:0
                                                          endAngle:M_PI * 2
                                                         clockwise:YES];
        circleLayer.lineWidth=1.0;
        circleLayer.path=circlePath.CGPath;
        circleLayer.fillColor = nil;
        circleLayer.strokeColor = [UIColor colorFromHexString:@"#b5b5b5"].CGColor;
        [cellView.layer addSublayer:circleLayer];
        
        // 下方时间轴线
        if (i<(relateArray.count-1)) {
            CAShapeLayer *dashDown = [CAShapeLayer layer];
            UIBezierPath *linePathDown = [UIBezierPath bezierPath];
            [linePathDown moveToPoint:CGPointMake(38, 49)];
            [linePathDown addLineToPoint:CGPointMake(38, 78)];
            dashDown.lineWidth = 1.0;
            dashDown.lineDashPattern = @[@1, @1];
            dashDown.path=linePathDown.CGPath;
            dashDown.fillColor = nil;
            dashDown.strokeColor = [UIColor colorFromHexString:@"#b5b5b5"].CGColor;
            [cellView.layer addSublayer:dashDown];
        }
        
        // 内容
        CAShapeLayer *contentLayer = [CAShapeLayer layer];
        UIBezierPath *contentPath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(44, 14, ScreenWidth-88, 65) cornerRadius:3];
        contentLayer.lineWidth=1.0;
        contentLayer.path=contentPath.CGPath;
        contentLayer.fillColor = nil;
        contentLayer.strokeColor = [UIColor colorFromHexString:@"#cbcbcb"].CGColor;
        [cellView.layer addSublayer:contentLayer];
        
        UIImageView *contentImageView=[[UIImageView alloc] init];
        contentImageView.frame=CGRectMake(44, 14, ScreenWidth-85, 65);
        contentImageView.tag=i;
        contentImageView.userInteractionEnabled=YES;
        [contentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
        [cellView addSubview:contentImageView];
        
        
        UILabel *contentLabel= [[UILabel alloc] init];
        contentLabel.frame=CGRectMake(10, 5, ScreenWidth-168, 55);
        contentLabel.text=point.title;
        contentLabel.attributedText=[contentLabel.text attributedStringWithFont:[UIFont systemFontOfSize:14] color:[UIColor blackColor] lineSpacing:3];
        contentLabel.numberOfLines=0;
        contentLabel.contentMode=UIViewContentModeTop;
        [contentImageView addSubview:contentLabel];
        
        //  图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-152, 12.5f, 50, 40)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:point.img] placeholderImage:[UIImage imageNamed:@"imgWallPlaceholder"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [contentImageView addSubview:imageView];
        [self addSubview:cellView];
        
    }
}

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIImageView *view=(UIImageView *)tap.view;
    LPRelatePoint *point=self.relateArray[view.tag];
    if(point.url)
    {
        if([self.delegate respondsToSelector:@selector(relateView:didCliclURL:)])
        {
            [self.delegate relateView:self didCliclURL:point.url];
        }
    }
}




@end
