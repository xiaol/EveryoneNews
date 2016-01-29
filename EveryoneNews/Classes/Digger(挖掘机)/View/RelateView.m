//
//  RelateView.m
//  EveryoneNews
//
//  Created by dongdan on 16/1/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RelateView.h"
#import "Relate.h"
#import "NSString+LP.h"
#import "UIImageView+WebCache.h"
#import "LPPressTool.h"

static const CGFloat Padding = 13;
static const CGFloat HeaderViewHeight = 50;

@interface RelateView () 

@end

@implementation RelateView

-(void)setRelateArray:(NSArray *)relateArray
{
    _relateArray=relateArray;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HeaderViewHeight)];
    headerView.backgroundColor = [UIColor colorFromHexString:@"#f4f4f4"];
    
    // 标题矩形框
    CAShapeLayer *headerLayer = [CAShapeLayer layer];
    UIBezierPath *headerPath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(Padding, 17, 4, 16) cornerRadius:0.0f];
    //headerLayer.lineWidth = 1.0;
    headerLayer.path = headerPath.CGPath;
    headerLayer.fillColor = [UIColor colorFromHexString:@"#a1a1a1"].CGColor;
    [headerView.layer addSublayer:headerLayer];
    
    // 标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, HeaderViewHeight)];
    label.text = @"相关观点";
    label.textColor = [UIColor colorFromHexString:@"#a1a1a1"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [headerView addSubview:label];
    [self addSubview:headerView];
    
    CGFloat marginY = CGRectGetMaxY(label.frame);
    
    for (int i=0; i<relateArray.count; i++) {
        Relate *point = self.relateArray[i];
        UIView *cellView=[[UIView alloc] initWithFrame:CGRectMake(Padding,marginY + 79 * i, ScreenWidth - 2 * Padding, 79)];
//        cellView.backgroundColor = [UIColor redColor];
        // 日期
        CAShapeLayer *dateLayer = [CAShapeLayer layer];
        UIBezierPath *datePath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(0, 40, 32, 12) cornerRadius:3];
        dateLayer.lineWidth = 1.0;
        dateLayer.path = datePath.CGPath;
        dateLayer.fillColor = nil;
        dateLayer.strokeColor = [UIColor colorFromHexString:@"#cbcbcb"].CGColor;
        [cellView.layer addSublayer:dateLayer];
        
        NSString *currentDate=point.updateTime;
        //  如果日期有问题则设置为当前日期
        if(currentDate.length < 10)
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
        timeLabel.frame = CGRectMake(0,40, 32, 12);
        [cellView addSubview:timeLabel];
        
        // 上方时间轴线
        if (i > 0) {
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
        }

        // 贝塞尔曲线(创建一个圆)
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(38,46)
                                                                  radius:3.0f
                                                              startAngle:0
                                                                endAngle:M_PI * 2
                                                               clockwise:YES];
        circleLayer.lineWidth = 1.0;
        circleLayer.path = circlePath.CGPath;
        circleLayer.fillColor = nil;
        circleLayer.strokeColor = [UIColor colorFromHexString:@"#b5b5b5"].CGColor;
        [cellView.layer addSublayer:circleLayer];
        
        // 下方时间轴线
        if (i < (relateArray.count - 1)) {
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
        UIBezierPath *contentPath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(44, 14, ScreenWidth - 70, 65) cornerRadius:3];
        contentLayer.lineWidth=1.0;
        contentLayer.path=contentPath.CGPath;
        contentLayer.fillColor = nil;
        contentLayer.strokeColor = [UIColor colorFromHexString:@"#cbcbcb"].CGColor;
        [cellView.layer addSublayer:contentLayer];
        
        
        UIImageView *contentImageView=[[UIImageView alloc] init];
        contentImageView.frame=CGRectMake(44, 14, ScreenWidth - 75, 65);
    
        contentImageView.userInteractionEnabled=YES;
     
        [cellView addSubview:contentImageView];
        
        
        UILabel *contentLabel= [[UILabel alloc] init];
        contentLabel.frame=CGRectMake(10, 5, ScreenWidth - 145, 55);
        contentLabel.text=point.title;
        contentLabel.attributedText=[contentLabel.text attributedStringWithFont:[UIFont systemFontOfSize:14] color:[UIColor blackColor] lineSpacing:3];
        contentLabel.numberOfLines=0;
        contentLabel.contentMode=UIViewContentModeTop;
        [contentImageView addSubview:contentLabel];
        
       //   有图片就加上图片，否则只显示文字
        if (point.photoURL.length > 0) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentLabel.frame) + 10, 12.5f, 50, 40)];
            imageView.layer.masksToBounds = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:point.photoURL] placeholderImage:[UIImage imageNamed:@"dig详情页占位小图"]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [contentImageView addSubview:imageView];
        } else {
            
            contentLabel.frame=CGRectMake(10, 5, ScreenWidth - 85, 55);
        }

        [cellView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidTapCellView:)]];
        cellView.userInteractionEnabled = YES;
        cellView.tag = i;
        [self addSubview:cellView];
        
    }
}

- (void)DidTapCellView:(UITapGestureRecognizer *)tap
{
    UIView *view = (UIView *)tap.view;
    Relate *point = self.relateArray[view.tag];
    if(point.url)
    {
        if([self.delegate respondsToSelector:@selector(relateView:didClickURL:)])
        {
           [self.delegate relateView:self didClickURL:point.url];
        }
    }
}

@end
