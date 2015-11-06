//
//  LPFeaturedCell.m
//  EveryoneNews
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPFeaturedCell.h"
#import "LPFeatureFrame.h"
#import "LPFeatureView.h"

@interface LPFeaturedCell ()

@end

@implementation LPFeaturedCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {        
        LPFeatureView *featureView = [[LPFeatureView alloc] init];
        featureView.showsVerticalScrollIndicator = NO;
        featureView.backgroundColor = [UIColor colorFromHexString:TableViewBackColor];
        [self.contentView addSubview:featureView];
        self.featureView = featureView;
    }
    return self;
}

- (void)setFeatureFrame:(LPFeatureFrame *)featureFrame {

    _featureFrame = featureFrame;
    
    self.featureView.frame = self.bounds;
    self.featureView.contentSize = featureFrame.viewSize;
    self.featureView.featureFrame = self.featureFrame;
}



@end
