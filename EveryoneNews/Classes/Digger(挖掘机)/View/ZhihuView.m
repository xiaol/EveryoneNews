//
//  ZhihuView.m
//  EveryoneNews
//
//  Created by dongdan on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ZhihuView.h"
#import "Zhihu.h"

static const CGFloat ZhihuTopPadding=30;
static const CGFloat RightPadding=13;
static const CGFloat HeaderViewHeight=50;
static const CGFloat HeaderViewMarginTop=20;
static const CGFloat HeaderViewMaginBotton=10;

@interface ZhihuView ()
// 观点UILabel集合
@property (nonatomic, strong) NSMutableArray *zhihuLabels;

@end
@implementation ZhihuView

- (id)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        
        
    }
    
    return self;
}
- (NSMutableArray *)pointLabels
{
    if (_zhihuLabels == nil) {
        _zhihuLabels = [NSMutableArray array];
    }
    return _zhihuLabels;
}

-(void)setZhihuSet:(NSSet *)zhihuSet
{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, HeaderViewMarginTop, ScreenWidth, HeaderViewHeight)];
    headerView.backgroundColor=[UIColor colorFromHexString:@"#f4f4f4"];
    // 标题矩形框
    CAShapeLayer *headerLayer = [CAShapeLayer layer];
    UIBezierPath *headerPath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(10, 10, 4, 30) cornerRadius:0.0f];
    headerLayer.lineWidth=1.0;
    headerLayer.path=headerPath.CGPath;
    headerLayer.fillColor = [UIColor colorFromHexString:@"#a1a1a1"].CGColor;
    [headerView.layer addSublayer:headerLayer];
    // 标题
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 50)];
    label.text=@"知乎延伸";
    label.textColor=[UIColor colorFromHexString:@"#a1a1a1"];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:17];
    [headerView addSubview:label];
    [self addSubview:headerView];
    
    CGFloat pointY =HeaderViewMarginTop+ HeaderViewHeight+HeaderViewMaginBotton;
    CGFloat pointX = 30;
    CGFloat pointW = ScreenWidth - pointX - RightPadding;
    
    NSArray *zhihuArray =[zhihuSet allObjects];
    for (int i=0; i<zhihuArray.count; i++) {
        Zhihu *point=zhihuArray[i];
        NSString *text = point.title;
        NSMutableAttributedString *pointString = [text attributedStringWithFont:[UIFont systemFontOfSize:14] color:[UIColor blackColor] lineSpacing:3];
        CGFloat pointH = [pointString heightWithConstraintWidth:pointW];
        if (i > 0) {
            UILabel *lastLabel = self.pointLabels[i-1];
            pointY = CGRectGetMaxY(lastLabel.frame) + 10;
        }
        UILabel *zhihuLabel = [[UILabel alloc] init];
        zhihuLabel.tag = i;
        
        [zhihuLabel setUserInteractionEnabled:YES];
        zhihuLabel.frame = CGRectMake(pointX, pointY, pointW, pointH);
        zhihuLabel.numberOfLines = 0;
        zhihuLabel.attributedText = pointString;
        [zhihuLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UITapGestureRecognizer:)]];
 
        // 圆点
        UIView *dotView=[[UIView alloc] initWithFrame:CGRectMake(10, pointY, 10, pointH)];
        CAShapeLayer *dotLayer = [CAShapeLayer layer];
        UIBezierPath *dotPath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(0, 5, 5, 5) cornerRadius:2];
        dotLayer.lineWidth=1.0;
        dotLayer.path=dotPath.CGPath;
        dotLayer.fillColor = [UIColor blackColor].CGColor;
        [dotView.layer addSublayer:dotLayer];
        
        [self addSubview:dotView];
        [self addSubview:zhihuLabel];
        [self.pointLabels addObject:zhihuLabel];
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
    CGFloat pointW = DetailCellWidth - - RightPadding;
    for (int i = 0; i < count; i++) {
        Zhihu *point = points[i];
        NSString *text = point.title;
        NSMutableAttributedString *pointString = [text attributedStringWithFont:[UIFont systemFontOfSize:14] color:[UIColor blackColor] lineSpacing:3];
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
    return h + 80;
}

- (void)pointLabelTap:(UITapGestureRecognizer*)tap
{
    NSLog(@"sds");
    //    UILabel *label = (UILabel *)tap.view;
    //    Zhihu *point = [self.zhihuSet allObjects][label.tag];
    //    if ([self.delegate respondsToSelector:@selector(zhihuView:didClickURL:)]) {
    //        [self.delegate zhihuView:self didClickURL:point.url];
    //    }
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    return YES;
//  //  return ([[touch.view class] isSubclassOfClass:[UILabel class]]) ? NO : YES;
//}


@end
