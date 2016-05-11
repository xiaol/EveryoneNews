//
//  LPFeatureView.m
//  EveryoneNews
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPFeatureView.h"
#import "LPZhihuView.h"
#import "LPZhihuPoint.h"
#import "LPFeature.h"
#import "LPFeatureFrame.h"
#import "LPZhihuPoint.h"
#import "LPItemView.h"
#import "UIImageView+WebCache.h"

@interface LPFeatureView ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *hud;
@property (nonatomic, strong) UILabel *titleLabel;
// 中间的itemViews
@property (nonatomic, strong) NSMutableArray *itemViews;
@end

@implementation LPFeatureView

- (NSMutableArray *)itemViews {
    if (_itemViews == nil) {
        _itemViews = [NSMutableArray array];
    }
    return _itemViews;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *headerView = [[UIView alloc] init];
        self.headerView = headerView;
        [self addSubview:headerView];
        
        UIImageView *headerImageView = [[UIImageView alloc] init];
        headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        headerImageView.clipsToBounds = YES;
        [headerView addSubview:headerImageView];
        self.headerImageView = headerImageView;
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        self.maskLayer = maskLayer;
        
        UIView *filterView = [[UIView alloc] init];
        filterView.alpha = 0.1;
        [headerImageView addSubview:filterView];
        self.filterView = filterView;
        
        UIImageView *hud = [[UIImageView alloc] init];
        hud.image = [UIImage imageNamed:@"渐变"];
        hud.alpha = 0.6;
        [headerView addSubview:hud];
        self.hud = hud;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor whiteColor];
        [headerView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        LPZhihuView *zhihuView = [[LPZhihuView alloc] init];
        [self addSubview:zhihuView];
        self.zhihuView = zhihuView;
        zhihuView.layer.shadowOpacity = 0.24f;
        zhihuView.layer.shadowRadius = 3.0;
        zhihuView.layer.shadowOffset = CGSizeMake(0, 0);
        zhihuView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        zhihuView.layer.zPosition = 999.0;
    }
    return self;
}

- (void)setFeatureFrame:(LPFeatureFrame *)featureFrame {
    _featureFrame = featureFrame;
    LPFeature *feature = featureFrame.feature;
    
    self.headerView.frame = featureFrame.headerF;
    self.headerImageView.frame = featureFrame.headerImageViewF;
    if (!feature.isFromFront) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:feature.headerImg]];
    }
    self.maskLayer.frame = featureFrame.maskLayerF;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.maskLayer.bounds];
    self.maskLayer.path = path.CGPath;
    self.headerImageView.layer.mask = self.maskLayer;
    self.filterView.frame = featureFrame.filterViewF;
    self.filterView.backgroundColor = feature.color;
    self.hud.frame = featureFrame.hudF;
    self.titleLabel.frame = featureFrame.titleLabelF;
    self.titleLabel.attributedText = feature.titleString;
    
    for (int i = 0; i < featureFrame.contentFrames.count; i++) {
        LPItemView *itemView = [[LPItemView alloc] init];
        [self addSubview:itemView];
        itemView.contentFrame = featureFrame.contentFrames[i];
        itemView.frame = [featureFrame.itemFrames[i] CGRectValue];
    }
    
    if(feature.zhihuPoints.count) {
        self.zhihuView.hidden = NO;
        self.zhihuView.frame = featureFrame.zhihuViewF;
        self.zhihuView.zhihuPoints = feature.zhihuPoints;
    } else {
        self.zhihuView.hidden = YES;
    }
    [self sendSubviewToBack:self.headerView];
}

@end
