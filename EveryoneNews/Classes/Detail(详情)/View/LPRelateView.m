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

const static CGFloat padding = 13;
const static CGFloat headerViewHeight = 50;
const static CGFloat contentPadding = 10;

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
    _relateArray = relateArray;
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(Padding, 0, ScreenWidth - Padding * 2 , HeaderViewHeight)];
//    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - padding * 2, headerViewHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.layer.borderWidth = 0.5;
    headerView.layer.borderColor = [UIColor colorFromHexString:@"#dddddd"].CGColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentPadding, 0, 200, headerViewHeight)];
    titleLabel.textColor = [UIColor colorFromHexString:@"#0086d1"];
    titleLabel.text = @"相关观点";
    titleLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:titleLabel];
    
    [self addSubview:headerView];
    
//    // 设置标题左边长条
//    CGFloat rectangleX = 13;
//    CGFloat rectangleW = 4;
//    CGFloat rectangleH = 16;
//    CGFloat rectangleY = (HeaderViewHeight - rectangleH) / 2;
//    
//    // 标题矩形框
//    CAShapeLayer *headerLayer = [CAShapeLayer layer];
//    UIBezierPath *headerPath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(rectangleX, rectangleY, rectangleW, rectangleH) cornerRadius:0.0f];
//    headerLayer.path = headerPath.CGPath;
//    headerLayer.fillColor = [UIColor colorFromHexString:@"#a1a1a1"].CGColor;
//    [headerView.layer addSublayer:headerLayer];
//    
//    // 标题
//    CGFloat titleLabelX = rectangleX + rectangleW + 10;
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, 0, ScreenWidth - titleLabelX, HeaderViewHeight)];
//    titleLabel.text = @"相关观点";
//    titleLabel.textColor = [UIColor colorFromHexString:@"#a1a1a1"];
//    titleLabel.textAlignment = NSTextAlignmentLeft;
//    titleLabel.font = [UIFont boldSystemFontOfSize:17];
//    [headerView addSubview:titleLabel];
//    [self addSubview:headerView];
    
    CGFloat marginY = CGRectGetMaxY(headerView.frame);
    CGFloat cellHeight = 79;
    
    for (int i = 0; i < relateArray.count; i++) {
        LPRelatePoint *point = self.relateArray[i];
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(padding, marginY + cellHeight * i, ScreenWidth - 2 * padding, cellHeight)];
        
        CGFloat dateLayerX = 0;
        CGFloat dateLayerW = 32;
        CGFloat dateLayerH = 12;
        CGFloat dateLayerY = (cellHeight - dateLayerH - padding) / 2 + padding;
        
        // 日期
        CAShapeLayer *dateLayer = [CAShapeLayer layer];
        UIBezierPath *datePath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(dateLayerX , dateLayerY, dateLayerW, dateLayerH) cornerRadius:3];
        dateLayer.lineWidth = 1.0;
        dateLayer.path = datePath.CGPath;
        dateLayer.fillColor = nil;
        dateLayer.strokeColor = [UIColor colorFromHexString:@"#cbcbcb"].CGColor;
        [cellView.layer addSublayer:dateLayer];
        
        NSString *currentDate = point.ptime;
        //  如果日期有问题则设置为当前日期
        if(currentDate.length < 10)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            currentDate = [dateFormatter stringFromDate:[NSDate date]];
        }
        currentDate = [[currentDate substringWithRange:NSMakeRange(5, 5)] stringByReplacingOccurrencesOfString:@"-"withString:@"."];
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.text = currentDate;
        timeLabel.frame = CGRectMake(dateLayerX, dateLayerY, dateLayerW, dateLayerH);
        [cellView addSubview:timeLabel];
        
        CGFloat circleRadius = 3.0f;
        CGFloat circlePathX = dateLayerW + circleRadius * 2;
        CGFloat circlePathY = (cellHeight + padding)/ 2;
        
        
        // 贝塞尔曲线(创建一个圆)
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(circlePathX, circlePathY)
                                                                  radius:circleRadius
                                                              startAngle:0
                                                                endAngle:M_PI * 2
                                                               clockwise:YES];
        circleLayer.lineWidth = 1.0;
        circleLayer.path = circlePath.CGPath;
        circleLayer.fillColor = nil;
        circleLayer.strokeColor = [UIColor colorFromHexString:@"#b5b5b5"].CGColor;
        [cellView.layer addSublayer:circleLayer];
        
        
        // 上方时间轴线
        if (i > 0) {
            CGFloat dashUpX = circlePathX;
            CGFloat dashUpY = circlePathY - circleRadius;
            CAShapeLayer *dashUp = [CAShapeLayer layer];
            UIBezierPath *linePathUp = [UIBezierPath bezierPath];
            [linePathUp moveToPoint:CGPointMake(dashUpX, 0)];
            [linePathUp addLineToPoint:CGPointMake(dashUpX, dashUpY)];
            dashUp.lineWidth = 1.0;
            dashUp.lineDashPattern = @[@1, @1];
            dashUp.path=linePathUp.CGPath;
            dashUp.fillColor = nil;
            dashUp.strokeColor = [UIColor colorFromHexString:@"#b5b5b5"].CGColor;
            [cellView.layer addSublayer:dashUp];
        }
        
        
        
        // 下方时间轴线
        if (i < (relateArray.count - 1)) {
            CGFloat dashDownX = circlePathX;
            CGFloat dashDownY = circlePathY + circleRadius;
            CAShapeLayer *dashDown = [CAShapeLayer layer];
            UIBezierPath *linePathDown = [UIBezierPath bezierPath];
            [linePathDown moveToPoint:CGPointMake(dashDownX, dashDownY)];
            [linePathDown addLineToPoint:CGPointMake(dashDownX, cellHeight)];
            dashDown.lineWidth = 1.0;
            dashDown.lineDashPattern = @[@1, @1];
            dashDown.path=linePathDown.CGPath;
            dashDown.fillColor = nil;
            dashDown.strokeColor = [UIColor colorFromHexString:@"#b5b5b5"].CGColor;
            [cellView.layer addSublayer:dashDown];
        }
        
        // 内容
        CGFloat contentPathX = dateLayerW + circleRadius * 4;
        CGFloat contentPathH = cellHeight - padding;
        CGFloat contentPathW = ScreenWidth - contentPathX - padding * 2 - contentPadding * 2;
        CAShapeLayer *contentLayer = [CAShapeLayer layer];
        UIBezierPath *contentPath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(contentPathX, padding, contentPathW, contentPathH) cornerRadius:3];
        contentLayer.lineWidth = 1.0;
        contentLayer.path = contentPath.CGPath;
        contentLayer.fillColor = nil;
        contentLayer.strokeColor = [UIColor colorFromHexString:@"#cbcbcb"].CGColor;
        [cellView.layer addSublayer:contentLayer];
        
        
        UIImageView *contentImageView = [[UIImageView alloc] init];
        contentImageView.frame = CGRectMake(contentPathX, padding, contentPathW, contentPathH);
        //        contentImageView.userInteractionEnabled =YES;
        [cellView addSubview:contentImageView];
        
        UILabel *contentLabel= [[UILabel alloc] init];
        CGFloat contentLabelPaddingH = 10;
        CGFloat contentLabelPaddingV = 5;
        contentLabel.frame = CGRectMake(contentLabelPaddingH , contentLabelPaddingV, contentPathW - 2 * contentLabelPaddingH, contentPathH - contentLabelPaddingV * 2);
        contentLabel.text = point.title;
        contentLabel.attributedText = [contentLabel.text attributedStringWithFont:[UIFont systemFontOfSize:14] color:[UIColor blackColor] lineSpacing:3];
        contentLabel.numberOfLines = 0;
        contentLabel.contentMode = UIViewContentModeTop;
        [contentImageView addSubview:contentLabel];
        
        if (point.img.length > 0 && [point.img rangeOfString:@","].location == NSNotFound) {
            
            CGFloat imageW = 50;
            CGFloat imageY = 10;
            CGFloat imageH = contentPathH - 2 * imageY;
            // 有图片时，重新设置文字宽度
            contentLabel.frame = CGRectMake(contentLabelPaddingH , contentLabelPaddingV, contentPathW - 2 * contentLabelPaddingH - imageW - 10, contentPathH - contentLabelPaddingV * 2);
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentLabel.frame) + 10, imageY, imageW, imageH)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:point.img] placeholderImage:[UIImage imageNamed:@"dig详情页占位小图"]];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [contentImageView addSubview:imageView];
            
        }
        
        [cellView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
        cellView.userInteractionEnabled = YES;
        cellView.tag = i;
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
