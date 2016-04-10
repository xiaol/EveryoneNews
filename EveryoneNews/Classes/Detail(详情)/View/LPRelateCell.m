//
//  LPRelateCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/3/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPRelateCell.h"
#import "LPRelateFrame.h"
#import "LPRelatePoint.h"
#import "UIImageView+WebCache.h"
#import "LPFontSizeManager.h"

@interface LPRelateCell ()

@property (nonatomic, strong) CAShapeLayer *dateLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *contentLayer;
@property (nonatomic, strong) CAShapeLayer *lineLayer;


@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIImageView *pointImageView;
@property (nonatomic, strong) NSString *relatePointURL;


@end

@implementation LPRelateCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"relatePointID";
    LPRelateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LPRelateCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        // 日期
        CAShapeLayer *dateLayer = [CAShapeLayer layer];
        [self.layer addSublayer:dateLayer];
        self.dateLayer = dateLayer;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        // 贝塞尔曲线(创建一个圆)
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        [self.layer addSublayer:circleLayer];
        self.circleLayer = circleLayer;
        
        // 内容
        CAShapeLayer *contentLayer = [CAShapeLayer layer];
        [self.layer addSublayer:contentLayer];
        self.contentLayer = contentLayer;
        
        UIImageView *contentImageView = [[UIImageView alloc] init];
        contentImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)];
        [contentImageView addGestureRecognizer:gesture];
        
        [self addSubview:contentImageView];

        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont systemFontOfSize:[LPFontSizeManager sharedManager].currentDetailRelatePointFontSize];
        contentLabel.numberOfLines = 0;
        [contentImageView addSubview:contentLabel];
        self.contentLabel= contentLabel;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [contentImageView addSubview:imageView];
        self.pointImageView = imageView;
        
        self.contentImageView = contentImageView;
        
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        [self.layer addSublayer:lineLayer];
        self.lineLayer = lineLayer;
        
   
       
    }
    return self;
}

- (void)setRelateFrame:(LPRelateFrame *)relateFrame {
    _relateFrame = relateFrame;
    LPRelatePoint *point = _relateFrame.relatePoint;
    self.relatePointURL = point.url;
    
    UIBezierPath *datePath = [UIBezierPath  bezierPathWithRoundedRect:_relateFrame.datelayerF cornerRadius:3];
    self.dateLayer.lineWidth = 1.0;
    self.dateLayer.path = datePath.CGPath;
    self.dateLayer.fillColor = nil;
    self.dateLayer.strokeColor = [UIColor colorFromHexString:@"#cbcbcb"].CGColor;
    
    self.timeLabel.frame = _relateFrame.dateF;
    NSString *currentDate = point.updateTime;
    //  如果日期有问题则设置为当前日期
    if(currentDate.length < 10)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        currentDate = [dateFormatter stringFromDate:[NSDate date]];
    }
    currentDate = [[currentDate substringWithRange:NSMakeRange(5, 5)] stringByReplacingOccurrencesOfString:@"-"withString:@"."];
    self.timeLabel.text = currentDate;
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_relateFrame.circlePoint
                                                              radius:_relateFrame.circleRadius
                                                          startAngle:0
                                                            endAngle:M_PI * 2
                                                           clockwise:YES];
    self.circleLayer.lineWidth = 1.0;
    self.circleLayer.path = circlePath.CGPath;
    self.circleLayer.fillColor = nil;
    self.circleLayer.strokeColor = [UIColor colorFromHexString:@"#b5b5b5"].CGColor;
    
    UIBezierPath *contentPath = [UIBezierPath  bezierPathWithRoundedRect:_relateFrame.contentLayerF cornerRadius:3];
    self.contentLayer.lineWidth = 1.0;
    self.contentLayer.path = contentPath.CGPath;
    self.contentLayer.fillColor = nil;
    self.contentLayer.strokeColor = [UIColor colorFromHexString:@"#cbcbcb"].CGColor;
    
    self.contentImageView.frame = _relateFrame.contentImageViewF;
    self.imageView.frame = _relateFrame.imageViewF;
    
    self.contentLabel.frame = _relateFrame.contentF;
    self.contentLabel.text = point.title;
    

   if (point.imgUrl.length > 0 && [point.imgUrl rangeOfString:@","].location == NSNotFound) {
        [self.pointImageView sd_setImageWithURL:[NSURL URLWithString:point.imgUrl] placeholderImage:[UIImage imageNamed:@"dig详情页占位小图"]];
        self.pointImageView.hidden = NO;
        self.pointImageView.frame = _relateFrame.imageViewF;
   } else {
       self.pointImageView.hidden = YES;
   }
    
    CGFloat cellWidth = ScreenWidth - BodyPadding * 2;
    // 绘制边框
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointZero];
    [linePath addLineToPoint:CGPointMake(0, 79)];
    
    [linePath moveToPoint:CGPointMake(cellWidth, 0)];
    [linePath addLineToPoint:CGPointMake(cellWidth, 79)];
    self.lineLayer.path = linePath.CGPath;
    self.lineLayer.fillColor = nil;
    self.lineLayer.strokeColor = [UIColor colorFromHexString:@"#e9e9e9"].CGColor;

}

- (void)tapImageView{
    if ([self.delegate respondsToSelector:@selector(relateCell:didClickURL:)]) {
        [self.delegate relateCell:self didClickURL:self.relatePointURL];
    }
}


@end
