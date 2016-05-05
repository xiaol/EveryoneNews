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

@property (nonatomic, strong) CAShapeLayer *yearLayer;
@property (nonatomic, strong) CAShapeLayer *monthDayLayer;
@property (nonatomic, strong) CAShapeLayer *dashMonthLayer;
@property (nonatomic, strong) CAShapeLayer *dashYearLayer;

@property (nonatomic, strong) UIImageView *pointImageView;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) NSString *relatePointURL;
@property (nonatomic, strong) UIView *cellView;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UILabel *monthDayLabel;

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
        self.backgroundColor = [UIColor colorFromHexString:LPColor9];
        // 年份
        CAShapeLayer *yearLayer = [CAShapeLayer layer];
        [self.layer addSublayer:yearLayer];
        self.yearLayer = yearLayer;
    
        // 月份
        CAShapeLayer *monthDayLayer = [CAShapeLayer layer];
        [self.layer addSublayer:monthDayLayer];
        self.monthDayLayer = monthDayLayer;
        
        CAShapeLayer *dashMonthLayer = [CAShapeLayer layer];
        [self.layer addSublayer:dashMonthLayer];
        self.dashMonthLayer = dashMonthLayer;
        
        CAShapeLayer *dashYearLayer = [CAShapeLayer layer];
        [self.layer addSublayer:dashYearLayer];
        self.dashYearLayer = dashYearLayer;
        
        UIView *cellView = [[UIView alloc] init];
        cellView.userInteractionEnabled = YES;
        [self addSubview:cellView];
        self.cellView = cellView;
        
        // 年
        UILabel *yearLabel = [[UILabel alloc] init];
        yearLabel.textColor = [UIColor colorFromHexString:LPColor2];
        yearLabel.font = [UIFont systemFontOfSize:13];
        [self.cellView addSubview:yearLabel];
        self.yearLabel = yearLabel;
        
        // 月日
        UILabel *monthDayLabel = [[UILabel alloc] init];
        monthDayLabel.backgroundColor = [UIColor colorFromHexString:@"#0091fa"];
        monthDayLabel.textColor = [UIColor whiteColor];
        monthDayLabel.textAlignment = NSTextAlignmentCenter;
        monthDayLabel.font = [UIFont systemFontOfSize:LPFont7];
        [self.cellView addSubview:monthDayLabel];
        self.monthDayLabel = monthDayLabel;
        
        
        // 标题
        UILabel *titelLabel = [[UILabel alloc] init];
        titelLabel.font = [UIFont systemFontOfSize:LPFont4];
        titelLabel.textColor = [UIColor colorFromHexString:LPColor3];
        titelLabel.numberOfLines = 0;
        [self.cellView addSubview:titelLabel];
        self.titleLabel = titelLabel;
        
        // 来源
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.numberOfLines = 0;
        sourceLabel.font = [UIFont systemFontOfSize:LPFont7];
        sourceLabel.textColor = [UIColor colorFromHexString:LPColor4];
        [self.cellView addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        // 图片
        UIImageView *pointImageView = [[UIImageView alloc] init];
        [self.cellView addSubview:pointImageView];
        self.pointImageView = pointImageView;
        
        // 分割线
        UIView *seperatorView = [[UIView alloc] init];
        seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
        [self.cellView addSubview:seperatorView];
        self.seperatorView = seperatorView;
       
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellView)];
        [self.cellView addGestureRecognizer:gesture];

    }
    return self;
}

- (void)setRelateFrame:(LPRelateFrame *)relateFrame {
    _relateFrame = relateFrame;
    LPRelatePoint *point = _relateFrame.relatePoint;
    self.relatePointURL = point.url;
    
    UIBezierPath *linePathMonth = [UIBezierPath bezierPath];
    // 包含年份
    if (point.updateTime.length > 5) {
        // 年份
        UIBezierPath *yearPath = [UIBezierPath bezierPathWithArcCenter:_relateFrame.yearPoint
                                                                radius:_relateFrame.circleRadius
                                                            startAngle:0
                                                              endAngle:M_PI * 2
                                                             clockwise:YES];
        self.yearLayer.lineWidth = 1.0;
        self.yearLayer.path = yearPath.CGPath;
        self.yearLayer.fillColor = nil;
        self.yearLayer.strokeColor = [UIColor colorFromHexString:@"#b3b3b3"].CGColor;
        
        self.yearLabel.frame = _relateFrame.yearF;
        self.yearLabel.text = [point.updateTime substringToIndex:4];
        
        
        self.yearLabel.hidden = NO;
        self.monthDayLabel.text = [point.updateTime substringFromIndex:5];
        
        
        UIBezierPath *linePathYear = [UIBezierPath bezierPath];
        
     
            [linePathYear moveToPoint:CGPointMake(_relateFrame.yearPoint.x,0)];
            [linePathYear addLineToPoint:CGPointMake(_relateFrame.yearPoint.x, _relateFrame.yearPoint.y - 2)];
            
            [linePathYear moveToPoint:CGPointMake(_relateFrame.yearPoint.x,_relateFrame.yearPoint.y + 2)];
            [linePathYear addLineToPoint:CGPointMake(_relateFrame.yearPoint.x, _relateFrame.monthDayPoint.y - 2)];
        
        
        self.dashYearLayer.lineWidth = 1.0;
        self.dashYearLayer.lineDashPattern = @[@1, @1];
        self.dashYearLayer.path = linePathYear.CGPath;
        self.dashYearLayer.fillColor = nil;
        self.dashYearLayer.strokeColor = [UIColor colorFromHexString:@"#b3b3b3"].CGColor;
        
        
    } else {
        // 不包含年份
        self.yearLabel.hidden = YES;
        self.monthDayLabel.text = point.updateTime;
        
        if (_relateFrame.currentRowIndex != 0) {
            [linePathMonth moveToPoint:CGPointMake(_relateFrame.monthDayPoint.x, 0)];
            [linePathMonth addLineToPoint:CGPointMake(_relateFrame.monthDayPoint.x, _relateFrame.monthDayPoint.y - 2)];
        }
    }
    
    [linePathMonth moveToPoint:CGPointMake(_relateFrame.monthDayPoint.x, _relateFrame.monthDayPoint.y + 2)];
    [linePathMonth addLineToPoint:CGPointMake(_relateFrame.monthDayPoint.x, _relateFrame.cellHeight)];
    
    self.dashMonthLayer.lineWidth = 1.0;
    self.dashMonthLayer.lineDashPattern = @[@1, @1];
    self.dashMonthLayer.path = linePathMonth.CGPath;
    self.dashMonthLayer.fillColor = nil;
    self.dashMonthLayer.strokeColor = [UIColor colorFromHexString:@"#b3b3b3"].CGColor;
    
    // 月份
    UIBezierPath *monthDayPath = [UIBezierPath bezierPathWithArcCenter:_relateFrame.monthDayPoint
                                                            radius:_relateFrame.circleRadius
                                                        startAngle:0
                                                          endAngle:M_PI * 2
                                                         clockwise:YES];
    self.monthDayLayer.lineWidth = 1.0;
    self.monthDayLayer.path = monthDayPath.CGPath;
    self.monthDayLayer.fillColor = nil;
    self.monthDayLayer.strokeColor = [UIColor colorFromHexString:@"#b3b3b3"].CGColor;
    
    self.cellView.frame = _relateFrame.cellViewF;
    
    self.titleLabel.frame = _relateFrame.titleF;
    self.titleLabel.text = point.title;
    
    self.sourceLabel.frame = _relateFrame.sourceSiteF;
    self.sourceLabel.text = point.sourceSite;
    
    self.seperatorView.frame = _relateFrame.seperatorViewF;
 
    self.monthDayLabel.frame = _relateFrame.monthDayF;
 
    
   if (point.imgUrl.length > 0 && [point.imgUrl rangeOfString:@","].location == NSNotFound) {
        [self.pointImageView sd_setImageWithURL:[NSURL URLWithString:point.imgUrl] placeholderImage:[UIImage imageNamed:@"dig详情页占位小图"]];
        self.pointImageView.hidden = NO;
        self.pointImageView.frame = _relateFrame.imageViewF;
   } else {
        self.pointImageView.hidden = YES;
   }
}

- (void)tapCellView{
    if ([self.delegate respondsToSelector:@selector(relateCell:didClickURL:)]) {
        [self.delegate relateCell:self didClickURL:self.relatePointURL];
    }
}


@end
