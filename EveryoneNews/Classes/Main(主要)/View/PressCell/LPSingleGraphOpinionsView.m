//
//  LPSingleGraphOpinionsView.m
//  EveryoneNews
//
//  Created by apple on 15/6/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPSingleGraphOpinionsView.h"
#import "LPPressFrame.h"
#import "LPPointview.h"

#define OpinionLineSpacing 4
#define OpinionLabelSpacing 8
#define OpinionDividerHeight 1.0
#define LeftPartW 43
#define RightPartW CellWidth - 43
#define OpinionLabelX 47
#define OpinionLabelW RightPartW - 25
#define VerticalLineX 31.5
#define VerticalLineW 1
#define CircleViewW 7.5
#define CircleViewH CircleViewW
#define CircleViewX 32 - CircleViewW / 2

@interface LPSingleGraphOpinionsView ()
@property (nonatomic, strong) NSMutableArray *opinionLabels;
@property (nonatomic, strong) NSMutableArray *circleViews;
@property (nonatomic, strong) NSMutableArray *verticalLines;
@property (nonatomic, strong) NSMutableArray *dashLayers;
@end

@implementation LPSingleGraphOpinionsView

- (NSMutableArray *)opinionLabels
{
    if (_opinionLabels == nil) {
        _opinionLabels = [NSMutableArray array];
    }
    return _opinionLabels;
}

- (NSMutableArray *)circleViews
{
    if (_circleViews == nil) {
        _circleViews = [NSMutableArray array];
    }
    return _circleViews;
}

- (NSMutableArray *)verticalLines
{
    if (_verticalLines == nil) {
        _verticalLines = [NSMutableArray array];
    }
    return _verticalLines;
}

- (NSMutableArray *)dashLayers
{
    if(_dashLayers == nil) {
        _dashLayers = [NSMutableArray array];
    }
    return _dashLayers;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        for (int i = 0; i < 3; i++) {
            UILabel *opinionLabel = [[UILabel alloc] init];
            opinionLabel.numberOfLines = 2;
            opinionLabel.lineBreakMode = NSLineBreakByClipping;
            opinionLabel.userInteractionEnabled = YES;
            opinionLabel.tag = i;
            [opinionLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];
            [self addSubview:opinionLabel];
            [self.opinionLabels addObject:opinionLabel];
            
            UIImageView *circleView = [[UIImageView alloc] init];
            circleView.image = [UIImage resizedImageWithName:@"蓝点"];
            circleView.contentMode = UIViewContentModeScaleAspectFill;
            // circleView.backgroundColor = [UIColor colorFromHexString:@"#50b5eb"];
            [self addSubview:circleView];
            [self.circleViews addObject:circleView];
            
            UIView *verticalLine = [[UIView alloc] init];
            verticalLine.backgroundColor = [UIColor colorFromHexString:@"#50b5eb"];
            [self addSubview:verticalLine];
            [self.verticalLines addObject:verticalLine];
        }
        [self setupDashLine];
        [self setupDashLine];
    }
    return self;
}

- (void)setupDashLine
{
    CAShapeLayer *dashLayer = [CAShapeLayer layer];
    dashLayer.strokeColor = [UIColor colorFromHexString:@"9c9c9c"].CGColor;
    dashLayer.fillColor = [UIColor clearColor].CGColor;
    dashLayer.opacity = 0.4;
    [self.dashLayers addObject:dashLayer];
}

- (void)setSublist:(NSArray *)sublist
{
    _sublist = sublist;

    if (!sublist || !sublist.count) {
        for (UILabel *label in self.opinionLabels) {
            label.hidden = YES;
        }
        for (UIView *line in self.verticalLines) {
            line.hidden = YES;
        }
        for (CAShapeLayer *layer in self.dashLayers) {
            layer.hidden = YES;
        }
        for (UIImageView *circle in self.circleViews) {
            circle.hidden = YES;
        }
        return;
    }
    int i = 0;
    for (i = 0; i < MIN(3, sublist.count); i++) {
        CGFloat opinionLabelY = 0;
        CGFloat verticalLineY = 0;
        CGFloat circleViewY = OpinionLabelSpacing + 2;
        LPPointview *pointview = sublist[i];
        NSMutableAttributedString *pointItem = pointview.pointItem;
        CGFloat lineH = pointItem.lineHeight;

        if (i > 0) {
            UILabel *preLabel = self.opinionLabels[i-1];
            UIView *preLine = self.verticalLines[i-1];
            CGFloat dashY = CGRectGetMaxY(preLabel.frame);
            CAShapeLayer *dashLayer = self.dashLayers[i-1];
            dashLayer.hidden = NO;
            dashLayer.frame = self.bounds;
            dashLayer.lineWidth = 0.5;
            dashLayer.lineDashPattern = @[@(2.7), @(1.9)];
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, LeftPartW, dashY);
            CGPathAddLineToPoint(path, NULL, CellWidth, dashY);
            dashLayer.path = path;
            CGPathRelease(path);
            [self.layer addSublayer:dashLayer];
            
            opinionLabelY = CGRectGetMaxY(preLabel.frame) + OpinionDividerHeight;
            verticalLineY = CGRectGetMaxY(preLine.frame);
            circleViewY = CGRectGetMaxY(preLabel.frame) + OpinionDividerHeight + OpinionLabelSpacing + 2;
        }
            
        UILabel *opinionLabel = self.opinionLabels[i];
        opinionLabel.hidden = NO;
        CGFloat opinionLabelH = 0;
        if (![pointItem isMoreThanOneLineConstraintToWidth:OpinionLabelW]) {
                opinionLabel.attributedText = pointItem;
                opinionLabelH = lineH + 2 * OpinionLabelSpacing;
                opinionLabel.frame = CGRectMake(OpinionLabelX, opinionLabelY, OpinionLabelW, opinionLabelH);
        } else {
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.lineSpacing = OpinionLineSpacing;
                [pointItem addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, pointItem.length)];
                opinionLabel.attributedText = pointItem;
                opinionLabelH = 2 * lineH + 2 * OpinionLabelSpacing + OpinionLineSpacing;
                opinionLabel.frame = CGRectMake(OpinionLabelX, opinionLabelY, OpinionLabelW, opinionLabelH);
        }
        
        UIView *verticalLine = self.verticalLines[i];
        verticalLine.hidden = NO;
        CGFloat verticalLineH = opinionLabelH;
        verticalLine.frame = CGRectMake(VerticalLineX, verticalLineY, VerticalLineW, verticalLineH);
        
        UIImageView *circleView = self.circleViews[i];
        circleView.hidden = NO;
        circleView.frame = CGRectMake(CircleViewX, circleViewY, CircleViewW, CircleViewH);
    }
    for (int j = 2; j >= i; j--) {
        UILabel *label = self.opinionLabels[j];
        label.hidden = YES;
        UIView *line = self.verticalLines[j];
        line.hidden = YES;
        UIImageView *circle = self.circleViews[j];
        circle.hidden = YES;
        CAShapeLayer *layer = self.dashLayers[j-1];
        layer.hidden = YES;
    }
}

+ (CGFloat)opinionsViewHeightWithOpinions:(NSArray *)sublist
{
    CGFloat h = OpinionsBottomBlankHeight;
    if (!sublist || !sublist.count) {
        return h;
    } else {
        LPPointview *pointview = sublist[0];
        NSMutableAttributedString *item = pointview.pointItem;
        CGFloat lineH = item.lineHeight;
        if (sublist.count == 1) {
            h += [self opinionHeightWithPointItem:item lineHeight:lineH];
        } else if (sublist.count == 2) {
            h += [self opinionHeightWithPointItem:item lineHeight:lineH] + OpinionDividerHeight;
            LPPointview *pointview = sublist[1];
            h += [self opinionHeightWithPointItem:pointview.pointItem lineHeight:lineH];
        } else {
            LPPointview *pointview0 = sublist[0];
            h += [self opinionHeightWithPointItem:pointview0.pointItem lineHeight:lineH] + OpinionDividerHeight;
            LPPointview *pointview1 = sublist[1];
            h += [self opinionHeightWithPointItem:pointview1.pointItem lineHeight:lineH] + OpinionDividerHeight;
            LPPointview *pointview2 = sublist[2];
            h += [self opinionHeightWithPointItem:pointview2.pointItem lineHeight:lineH];
        }
        return h;
    }
}

+ (CGFloat)opinionHeightWithPointItem:(NSMutableAttributedString *)item lineHeight:(CGFloat)lineHeight
{
    if ([item isMoreThanOneLineConstraintToWidth:OpinionLabelW]) {
        return 2 * OpinionLabelSpacing + 2 * lineHeight + OpinionLineSpacing;
    } else {
        return 2 * OpinionLabelSpacing + lineHeight;
    }
}

- (void)labelTap:(UITapGestureRecognizer *)tap
{
    LPPointview *pointview = self.sublist[tap.view.tag];
    NSDictionary *info = @{LPWebURL: pointview.url};
    [noteCenter postNotificationName:LPWebViewWillLoadNotification object:self userInfo:info];
}
@end
