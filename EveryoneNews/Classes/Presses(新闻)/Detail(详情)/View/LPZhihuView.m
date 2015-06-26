//
//  LPZhihuView.m
//  EveryoneNews
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPZhihuView.h"
#import "LPZhihuPoint.h"

#define RightPadding 10
#define ZhihuPointLineSpacing 3
#define ZhihuFontSize 14
#define ArrowW 3

#define ZhihuPointSpacing 12
#define ArrowExcess 3
#define ZhihuTopPadding 30
#define ZhihuBottomPadding 35

@interface LPZhihuView ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) NSMutableArray *pointLabels;
@end

@implementation LPZhihuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"延伸阅读"]];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:iconView];
        self.iconView = iconView;
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

- (void)setZhihuPoints:(NSArray *)zhihuPoints
{
    _zhihuPoints = zhihuPoints;
    
    self.iconView.frame = CGRectMake(10, -3, 22, 57);
    
    CGFloat pointY = ZhihuTopPadding;
    CGFloat pointX = CGRectGetMaxX(self.iconView.frame) + 15.5 + ArrowW + 7.5;
    CGFloat pointW = DetailCellWidth - pointX - RightPadding;
    
    CGFloat arrowX = CGRectGetMaxX(self.iconView.frame) + 15.5;

    for (int i = 0; i < zhihuPoints.count; i++) {
        LPZhihuPoint *point = self.zhihuPoints[i];
        NSString *text = point.title;
        NSMutableAttributedString *pointString = [text attributedStringWithFont:[UIFont systemFontOfSize:ZhihuFontSize] color:[UIColor blackColor] lineSpacing:ZhihuPointLineSpacing];
        CGFloat pointH = [pointString heightWithConstraintWidth:pointW];
        if (i > 0) {
            UILabel *lastLabel = self.pointLabels[i-1];
            pointY = CGRectGetMaxY(lastLabel.frame) + ZhihuPointSpacing + 2 * ArrowExcess;
        }
        UILabel *pointLabel = [[UILabel alloc] init];
        pointLabel.tag = i;
        pointLabel.userInteractionEnabled = YES;
        pointLabel.frame = CGRectMake(pointX, pointY, pointW, pointH);
        pointLabel.numberOfLines = 0;
        pointLabel.attributedText = pointString;
        [pointLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)]];
        [self addSubview:pointLabel];
        [self.pointLabels addObject:pointLabel];
        
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头"]];
        arrowView.clipsToBounds = YES;
        arrowView.contentMode = UIViewContentModeRight;
        CGFloat arrowY = pointY - ArrowExcess;
        CGFloat arrowH = pointH + 2 * ArrowExcess;
        arrowView.frame = CGRectMake(arrowX, arrowY, ArrowW, arrowH);
        [self addSubview:arrowView];
        
        CGFloat arrowLineY = pointY - ArrowExcess;
        CGFloat arrowLineH = pointH + 2 * ArrowExcess;
        UIView *arrowLine = [[UIView alloc] initWithFrame:CGRectMake(arrowX, arrowLineY, 1, arrowLineH)];
        arrowLine.backgroundColor = [UIColor lightGrayColor];
        arrowLine.alpha = 0.3;
        [self addSubview:arrowLine];
    }
}

- (CGFloat)heightWithPointsArray:(NSArray *)points
{
    CGFloat h = ZhihuTopPadding;
    NSUInteger count = points.count;
    CGFloat array[count];
    for (int k = 0; k < count; k++) {
        array[k] = 0.0;
    }
    CGFloat pointW = DetailCellWidth - 10 - 22 - 15.5 - ArrowW - 7.5 - RightPadding;
    for (int i = 0; i < count; i++) {
        LPZhihuPoint *point = points[i];
        NSString *text = point.title;
        NSMutableAttributedString *pointString = [text attributedStringWithFont:[UIFont systemFontOfSize:ZhihuFontSize] color:[UIColor blackColor] lineSpacing:ZhihuPointLineSpacing];
        CGFloat pointH = [pointString heightWithConstraintWidth:pointW] + 2 * ArrowExcess;
        array[i] = pointH;
    }
    CGFloat sumH = 0.0;
    for (int j = 0; j < count; j++) {
        sumH += array[j];
    }
    if (count == 1) {
        h += sumH;
    } else {
        h += sumH + (count - 1) * ZhihuPointSpacing;
    }
    return h + ZhihuBottomPadding;
}

- (void)tapLabel:(UITapGestureRecognizer *)tap
{
    NSLog(@"labelTap");
    UILabel *label = (UILabel *)tap.view;
    LPZhihuPoint *point = self.zhihuPoints[label.tag];
    if ([self.delegate respondsToSelector:@selector(zhihuView:didClickURL:)]) {
        [self.delegate zhihuView:self didClickURL:point.url];
    }
}
@end
