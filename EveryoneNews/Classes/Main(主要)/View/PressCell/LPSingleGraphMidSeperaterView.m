//
//  LPSingleGraphMidSeperaterView.m
//  EveryoneNews
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPSingleGraphMidSeperaterView.h"
#define DividerHeight 0.5

@interface LPSingleGraphMidSeperaterView ()
{
    CAShapeLayer *maskLayer;
}

@property (nonatomic, strong) UIView *dividerView;
@property (nonatomic, strong) UILabel *pointLabel;


@end

@implementation LPSingleGraphMidSeperaterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
       // self.backgroundColor = [UIColor colorFromHexString:CellBackColor];
       // self.backgroundColor = [UIColor redColor];
        
        UIView *dividerView = [[UIView alloc] init];
        dividerView.backgroundColor = [UIColor colorFromHexString:@"#dadada"];
//        dividerView.alpha = 0.8;
        [self addSubview:dividerView];
        self.dividerView = dividerView;
        
        UILabel *pointLabel = [[UILabel alloc] init];
//        pointLabel.backgroundColor = [UIColor colorFromHexString:@"#50b5eb"];
        pointLabel.text = @"观点";
        pointLabel.font = [UIFont systemFontOfSize:10];
        pointLabel.textColor = [UIColor whiteColor];
        pointLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:pointLabel];
        self.pointLabel = pointLabel;
        
        maskLayer = [CAShapeLayer layer];
    }
    return self;
}

- (void)setCategory:(NSString *)category
{
    _category = category;
    self.pointLabel.backgroundColor = [UIColor colorFromCategory:self.category];
}

- (void)layoutSubviews
{
    CGFloat dividerX = 0;
    CGFloat dividerY = self.height / 2 - DividerHeight / 2;
    CGFloat dividerW = self.width;
    CGFloat dividerH = DividerHeight;
    self.dividerView.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    
    CGFloat pointX = 20;
    CGFloat pointY = 0;
    CGFloat pointW = 24;
    CGFloat pointH = pointW;
    self.pointLabel.frame = CGRectMake(pointX, pointY, pointW, pointH);

    maskLayer.frame = self.pointLabel.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithOvalInRect:maskLayer.bounds];
    maskLayer.path = maskPath.CGPath;
    self.pointLabel.layer.mask = maskLayer;
}
@end
