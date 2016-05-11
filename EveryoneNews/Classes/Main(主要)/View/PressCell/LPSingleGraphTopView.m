//
//  LPSingleGraphTopView.m
//  EveryoneNews
//
//  Created by apple on 15/6/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPSingleGraphTopView.h"
#import "LPIconsView.h"
#import "UIImageView+WebCache.h"
#import "LPPress.h"
#import "LPPressFrame.h"

#define CategoryLabelRadius 5.0
#define PointsNumLineWidth 1.0

@interface LPSingleGraphTopView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) LPIconsView *smallIconsView;

@property (nonatomic, strong) UILabel *categoryLabel;

//@property (nonatomic, strong) UIButton *pointsBtn;

@end

@implementation LPSingleGraphTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 1.5;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        self.smallIconsView = [[LPIconsView alloc] init];
        [self addSubview:self.smallIconsView];
        
        UILabel *categoryLabel = [[UILabel alloc] init];
        categoryLabel.font = [UIFont systemFontOfSize:14];
        categoryLabel.textAlignment = NSTextAlignmentCenter;
        categoryLabel.textColor = [UIColor whiteColor];
        [self addSubview:categoryLabel];
        self.categoryLabel = categoryLabel;
        
//        UIButton *pointsBtn = [[UIButton alloc] init];
//        pointsBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [pointsBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        pointsBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [pointsBtn setBackgroundImage:[UIImage imageNamed:@"观点数量"] forState:UIControlStateNormal];
//        pointsBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
//        pointsBtn.backgroundColor = [UIColor clearColor];
//        [self addSubview:pointsBtn];
//        self.pointsBtn = pointsBtn;
    }
    return self;
}

- (void)setPressFrame:(LPPressFrame *)pressFrame
{
    _pressFrame = pressFrame;
    LPPress *press = pressFrame.press;
    
    //设置小图标
    self.smallIconsView.pressFrame=_pressFrame;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:press.imgUrl] placeholderImage:[UIImage imageNamed:@"占位图"]];
    self.imageView.frame = self.pressFrame.thumbnailViewF;
    
    self.titleLabel.attributedText = press.titleString;
    self.titleLabel.frame = self.pressFrame.titleLabelF;
    
    self.categoryLabel.text = press.category;
    self.categoryLabel.frame = self.pressFrame.categoryLabelF;
    self.categoryLabel.backgroundColor = [UIColor colorFromCategory:press.category];
//    if ([press.category isBlank]) {
//        self.categoryLabel.hidden = YES;
//    } else {
//        self.categoryLabel.hidden = NO;
//    }
    // 左边显示为半圆
    CAShapeLayer *maskShapeLayer = [CAShapeLayer layer];
    maskShapeLayer.frame = self.categoryLabel.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskShapeLayer.frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(CategoryLabelRadius, CategoryLabelRadius)];
    maskShapeLayer.path = maskPath.CGPath;
    self.categoryLabel.layer.mask = maskShapeLayer;
    
    self.smallIconsView.frame = pressFrame.smallIconsViewF;
    
//    if (press.otherNum.intValue > 0 && press.otherNum) {
////        self.pointsLabel.hidden = NO;
////        self.pointsLabel.frame = pressFrame.pointsLabelF;
////        self.pointsLabel.text = press.otherNum;
//        self.pointsBtn.hidden = NO;
//        self.pointsBtn.frame = pressFrame.pointsLabelF;
//        [self.pointsBtn setTitle:press.otherNum forState:UIControlStateNormal];
//        
//        
//    } else {
////        self.pointsLabel.hidden = YES;
//          self.pointsBtn.hidden = YES;
//    }
}

@end
