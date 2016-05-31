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
#import "LPUITextView.h"

@interface LPRelateCell ()

@property (nonatomic, strong) CAShapeLayer *yearLayer;
@property (nonatomic, strong) CAShapeLayer *monthDayLayer;
@property (nonatomic, strong) CAShapeLayer *dashMonthLayerUp;
@property (nonatomic, strong) CAShapeLayer *dashYearLayerUp;
@property (nonatomic, strong) CAShapeLayer *dashMonthLayerDown;
@property (nonatomic, strong) CAShapeLayer *dashYearLayerDown;



@property (nonatomic, strong) UIImageView *pointImageView;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) LPUITextView *titleLabel;
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
        
        CAShapeLayer *dashMonthLayerUp = [CAShapeLayer layer];
        [self.layer addSublayer:dashMonthLayerUp];
        self.dashMonthLayerUp = dashMonthLayerUp;
        
        CAShapeLayer *dashYearLayerUp = [CAShapeLayer layer];
        [self.layer addSublayer:dashYearLayerUp];
        self.dashYearLayerUp = dashYearLayerUp;
        
        CAShapeLayer *dashMonthLayerDown = [CAShapeLayer layer];
        [self.layer addSublayer:dashMonthLayerDown];
        self.dashMonthLayerDown = dashMonthLayerDown;
        
        CAShapeLayer *dashYearLayerDown = [CAShapeLayer layer];
        [self.layer addSublayer:dashYearLayerDown];
        self.dashYearLayerDown = dashYearLayerDown;
        
        
        UIView *cellView = [[UIView alloc] init];
        cellView.userInteractionEnabled = YES;
        [self addSubview:cellView];
        self.cellView = cellView;
        
        // 年
        UILabel *yearLabel = [[UILabel alloc] init];
        yearLabel.textColor = [UIColor colorFromHexString:LPColor2];
        yearLabel.font = [UIFont systemFontOfSize:14];
        [self.cellView addSubview:yearLabel];
        self.yearLabel = yearLabel;
        
        // 月日
        UILabel *monthDayLabel = [[UILabel alloc] init];
        monthDayLabel.backgroundColor = [UIColor colorFromHexString:LPColor2];
        monthDayLabel.textColor = [UIColor whiteColor];
        monthDayLabel.textAlignment = NSTextAlignmentCenter;
        monthDayLabel.font = [UIFont systemFontOfSize:13];
        monthDayLabel.layer.cornerRadius = 2.0f;
        monthDayLabel.layer.borderWidth = 0.f;
        
        monthDayLabel.clipsToBounds = YES;
        [self.cellView addSubview:monthDayLabel];
        self.monthDayLabel = monthDayLabel;
        
        
        // 标题
        LPUITextView *titelLabel = [[LPUITextView alloc] init];
        titelLabel.textColor = [UIColor colorFromHexString:LPColor3];
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
        pointImageView.contentMode = UIViewContentModeScaleAspectFill;
        pointImageView.clipsToBounds = YES;
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
    
    // 搜索来源是google google背景高亮
    if (relateFrame.googleSourceExistsInRelatePoint) {
        if ([point.from isEqualToString:@"Google"]) {
            self.monthDayLabel.backgroundColor = [UIColor colorFromHexString:LPColor2];
        } else {
            self.monthDayLabel.backgroundColor = [UIColor colorFromHexString:LPColor12];
        }
        
        
    } else {
        if ([point.from isEqualToString:@"Baidu"]) {
            self.monthDayLabel.backgroundColor = [UIColor colorFromHexString:LPColor2];
        } else {
            self.monthDayLabel.backgroundColor = [UIColor colorFromHexString:LPColor12];
        }
    }
    
    UIBezierPath *linePathMonthUp = [UIBezierPath bezierPath];
    UIBezierPath *linePathMonthDown = [UIBezierPath bezierPath];
    UIBezierPath *linePathYearUp = [UIBezierPath bezierPath];
    UIBezierPath *linePathYearDown = [UIBezierPath bezierPath];
    
    // 包含年份
    if (point.ptime.length > 5) {
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
        self.yearLabel.text = [point.ptime substringToIndex:4];
        
        
        self.yearLabel.hidden = NO;
        self.yearLayer.hidden = NO;
        self.monthDayLabel.text = [point.ptime substringFromIndex:5];
        
        // 非0行
        if (_relateFrame.currentRowIndex != 0) {
     
            self.dashYearLayerUp.hidden = NO;
            [linePathYearUp moveToPoint:CGPointMake(_relateFrame.yearPoint.x,0)];
            [linePathYearUp addLineToPoint:CGPointMake(_relateFrame.yearPoint.x, _relateFrame.yearPoint.y - 2)];
            
            
        } else {
            self.dashYearLayerUp.hidden = YES;
        }
        self.dashMonthLayerUp.hidden = NO;
        
        
        
        [linePathMonthUp moveToPoint:CGPointMake(_relateFrame.yearPoint.x,_relateFrame.yearPoint.y + 2)];
        [linePathMonthUp addLineToPoint:CGPointMake(_relateFrame.yearPoint.x, _relateFrame.monthDayPoint.y - 2)];
    
        [linePathYearDown moveToPoint:CGPointMake(_relateFrame.yearPoint.x,_relateFrame.yearPoint.y + 2)];
        [linePathYearDown addLineToPoint:CGPointMake(_relateFrame.yearPoint.x, _relateFrame.monthDayPoint.y - 2)];
        
        
    } else {
        // 不包含年份
        self.yearLabel.hidden = YES;
        self.yearLayer.hidden = YES;
        self.monthDayLabel.text = point.ptime;
        self.dashYearLayerUp.hidden = YES;
        self.dashYearLayerDown.hidden = YES;
        
        
        if (_relateFrame.currentRowIndex != 0) {
           self.dashMonthLayerUp.hidden = NO;
            [linePathMonthUp moveToPoint:CGPointMake(_relateFrame.monthDayPoint.x, 0)];
            [linePathMonthUp addLineToPoint:CGPointMake(_relateFrame.monthDayPoint.x, _relateFrame.monthDayPoint.y - 2)];
        } else {
            self.dashMonthLayerUp.hidden = YES;
        }
    }
 
    
    if (_relateFrame.currentRowIndex == _relateFrame.totalCount - 1) {
        [linePathMonthDown moveToPoint:CGPointMake(_relateFrame.monthDayPoint.x, _relateFrame.monthDayPoint.y + 2)];
        [linePathMonthDown addLineToPoint:CGPointMake(_relateFrame.monthDayPoint.x, CGRectGetMaxY(_relateFrame.sourceSiteF))];
    } else {
        [linePathMonthDown moveToPoint:CGPointMake(_relateFrame.monthDayPoint.x, _relateFrame.monthDayPoint.y + 2)];
        [linePathMonthDown addLineToPoint:CGPointMake(_relateFrame.monthDayPoint.x, _relateFrame.cellHeight)];
    }
    
    
    
    self.dashMonthLayerUp.lineWidth = 1.0;
    self.dashMonthLayerUp.lineDashPattern = @[@1, @1];
    self.dashMonthLayerUp.path = linePathMonthUp.CGPath;
    self.dashMonthLayerUp.fillColor = nil;
    self.dashMonthLayerUp.strokeColor = [UIColor colorFromHexString:@"#b3b3b3"].CGColor;
    
    
    self.dashYearLayerUp.lineWidth = 1.0;
    self.dashYearLayerUp.lineDashPattern = @[@1, @1];
    self.dashYearLayerUp.path = linePathYearUp.CGPath;
    self.dashYearLayerUp.fillColor = nil;
    self.dashYearLayerUp.strokeColor = [UIColor colorFromHexString:@"#b3b3b3"].CGColor;
    
    
    self.dashMonthLayerDown.lineWidth = 1.0;
    self.dashMonthLayerDown.lineDashPattern = @[@1, @1];
    self.dashMonthLayerDown.path = linePathMonthDown.CGPath;
    self.dashMonthLayerDown.fillColor = nil;
    self.dashMonthLayerDown.strokeColor = [UIColor colorFromHexString:@"#b3b3b3"].CGColor;
    
    self.dashYearLayerDown.lineWidth = 1.0;
    self.dashYearLayerDown.lineDashPattern = @[@1, @1];
    self.dashYearLayerDown.path = linePathYearDown.CGPath;
    self.dashYearLayerDown.fillColor = nil;
    self.dashYearLayerDown.strokeColor = [UIColor colorFromHexString:@"#b3b3b3"].CGColor;

    
    // 月份
    UIBezierPath *monthDayPath = [UIBezierPath bezierPathWithArcCenter:_relateFrame.monthDayPoint
                                                            radius:_relateFrame.circleRadius
                                                        startAngle:0
                                                          endAngle:M_PI * 2
                                                         clockwise:YES];
    self.monthDayLayer.path = monthDayPath.CGPath;
    self.monthDayLayer.fillColor = nil;
    self.monthDayLayer.strokeColor = [UIColor colorFromHexString:@"#b3b3b3"].CGColor;
    
    self.cellView.frame = _relateFrame.cellViewF;
    
    self.titleLabel.frame = _relateFrame.titleF;
    self.titleLabel.attributedText = point.titleHtmlString;
    
    self.sourceLabel.frame = _relateFrame.sourceSiteF;
    self.sourceLabel.text = point.pname;
    
    self.seperatorView.frame = _relateFrame.seperatorViewF;
 
    self.monthDayLabel.frame = _relateFrame.monthDayF;
 
    
   if (point.img.length > 0 && [point.img rangeOfString:@","].location == NSNotFound) {
        [self.pointImageView sd_setImageWithURL:[NSURL URLWithString:point.img] placeholderImage:[UIImage imageNamed:@"dig详情页占位小图"]];
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
