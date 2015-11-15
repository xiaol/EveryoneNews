//
//  ZhihuView.m
//  EveryoneNews
//
//  Created by dongdan on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ZhihuView.h"
#import "Zhihu.h"

static const CGFloat RightPadding = 13;
static const CGFloat LeftPadding = 13;
static const CGFloat HeaderViewHeight = 50;
static const CGFloat HeaderViewMarginTop = 20;
static const CGFloat HeaderViewMaginBottom = 10;

@interface ZhihuView ()
// 观点UILabel集合
@property (nonatomic, strong) NSMutableArray *zhihuLabels;
@end

@implementation ZhihuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray *)zhihuLabels
{
    if (_zhihuLabels == nil) {
        _zhihuLabels = [NSMutableArray array];
    }
    return _zhihuLabels;
}

#pragma mark 设置知乎链接
-(void)setZhihuArray:(NSArray *)zhihuArray
{
    _zhihuArray = zhihuArray;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, HeaderViewMarginTop, ScreenWidth, HeaderViewHeight)];
    headerView.backgroundColor = [UIColor colorFromHexString:@"#f4f4f4"];
    
    // 标题矩形框
    CAShapeLayer *headerLayer = [CAShapeLayer layer];
    UIBezierPath *headerPath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(LeftPadding, 15, 4, 20) cornerRadius:0.0f];
    //headerLayer.lineWidth = 1.0;
    headerLayer.path = headerPath.CGPath;
    headerLayer.fillColor = [UIColor colorFromHexString:@"#a1a1a1"].CGColor;
    [headerView.layer addSublayer:headerLayer];
    
    // 标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, HeaderViewHeight)];
    label.text = @"知乎延伸";
    label.textColor = [UIColor colorFromHexString:@"#a1a1a1"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [headerView addSubview:label];
    [self addSubview:headerView];
    
    CGFloat pointY = HeaderViewMarginTop + HeaderViewHeight + HeaderViewMaginBottom;
    CGFloat pointX = 30;
    CGFloat pointW = ScreenWidth - pointX - RightPadding;
    for (int i = 0; i < zhihuArray.count; i++) {
        Zhihu *point = zhihuArray[i];
        NSString *text = point.title;
        NSMutableAttributedString *pointString = [text attributedStringWithFont:[UIFont systemFontOfSize:14] color:[UIColor blackColor] lineSpacing:5];
        CGFloat pointH = [pointString heightWithConstraintWidth:pointW];
        if (i > 0) {
            UILabel *lastLabel = self.zhihuLabels[i-1];
            pointY = CGRectGetMaxY(lastLabel.frame) + 10;
        }
        UILabel *zhihuLabel = [[UILabel alloc] init];
        zhihuLabel.tag = i;
        [zhihuLabel setUserInteractionEnabled:YES];
        zhihuLabel.frame = CGRectMake(pointX, pointY, pointW, pointH);
        zhihuLabel.numberOfLines = 0;
        zhihuLabel.attributedText = pointString;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhihuLabelTap:)];
        [zhihuLabel addGestureRecognizer:tap];
        // 设置圆点
//        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        CGFloat lineH = [pointString lineHeight] - 5.0f;
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(LeftPadding, pointY + lineH / 2.0f - 2.0f, 4.0f, 4.0f)];
        dotView.layer.backgroundColor = [UIColor blackColor].CGColor;
        dotView.layer.cornerRadius = 2.0f;

        [self addSubview:dotView];
        [self addSubview:zhihuLabel];
        [self.zhihuLabels addObject:zhihuLabel];
    }
    
}

#pragma mark 设置知乎视图高度值
- (CGFloat)heightWithPointsArray:(NSArray *)points
{
    CGFloat h = HeaderViewMarginTop + HeaderViewHeight;
    NSUInteger count = points.count;
    CGFloat array[count];
    for (int k = 0; k < count; k++) {
        array[k] = 0.0;
    }
    CGFloat pointW = ScreenWidth - 30 - RightPadding;
    for (int i = 0; i < count; i++) {
        Zhihu *point = points[i];
        NSString *text = point.title;
        NSMutableAttributedString *pointString = [text attributedStringWithFont:[UIFont systemFontOfSize:14] color:[UIColor blackColor] lineSpacing:5];
        CGFloat pointH = [pointString heightWithConstraintWidth:pointW];
        array[i] = pointH;
    }
    CGFloat sumH = 0.0;
    for (int j = 0; j < count; j++) {
        sumH += array[j];
    }
    if (count == 1) {
        h += sumH;
    } else {
        h += sumH + (count - 1) * 10;
    }
    return h + HeaderViewMaginBottom;
}

#pragma mark 知乎链接
- (void)zhihuLabelTap:(UITapGestureRecognizer*)tap
{
    UILabel *label = (UILabel *)tap.view;
    Zhihu *point = self.zhihuArray[label.tag];
    if ([self.delegate respondsToSelector:@selector(zhihuView:didClickURL:)]) {
        [self.delegate zhihuView:self didClickURL:point.url];
    }
}
-(void)dealloc
{
    //NSLog(@"zhihu dealloc");
}
@end
