//
//  LPFeatureView.h
//  EveryoneNews
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPZhihuView;
@class LPFeatureFrame;

@interface LPFeatureView : UIScrollView
@property (nonatomic, strong) LPFeatureFrame *featureFrame;
// 头图
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;

// 知乎尾部
@property (nonatomic, strong) LPZhihuView *zhihuView;
@end
